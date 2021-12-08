//
//  StockBalanceViewController.swift
//  PaperTrader2.0
//
//  Created by Jimmy  on 11/26/21.
//

import UIKit
import CoreData

class StockPortfolioViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var balances = [Balance]()
    
  
    
    var searchResults = [SearchResult]()
    
    let refreshControll = UIRefreshControl()
    
    var totalValueDouble: Double = 0.0

    var batchRequestString: String = ""
    
    @IBOutlet var balanceLabel: UILabel!
    @IBOutlet var totalValueLabel: UILabel!
    
    var newPrices: [String:String] = [:]
    
    
    private let isPortfolio = true
    
    
    var stockPortfolio = [StockPortfolio]()
    var dataTask: URLSessionDataTask?
    var isLoading = false
    
    
    
    // MARK: Table View Delegates
    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        
        return balances.count
    }
    
    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
      ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
          withIdentifier: "PortfolioCell",
          for: indexPath) as! PortfolioCell
        
        let balance = balances[indexPath.row]
        
        cell.configure(for: balance)
        return cell
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        
        let defaults = UserDefaults.standard
        balanceLabel.text = defaults.string(forKey: "balanceAmount")
        print(defaults.string(forKey: "balanceAmount"))
        let fetchRequest = NSFetchRequest<Balance>()
        
        let entity = Balance.entity()
        fetchRequest.entity = entity
          
        let sortDescriptor = NSSortDescriptor(
            key: "stock",
            ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            balances = try context.fetch(fetchRequest)
            
        } catch {
            fatalCoreDataError(error)
        }
        
        for (index, stock) in balances.enumerated(){
            var stockValue: Double = Double(balances[index].value!)!
            totalValueDouble = totalValueDouble + stockValue
            
            print(balances[index].value)
            print("Hello")
        }
 
        var balanceDoub: Double? = Double(defaults.string(forKey: "balanceAmount") ?? "0.0")
        totalValueDouble = totalValueDouble + balanceDoub!
        totalValueLabel.text = String(format: "%f", totalValueDouble)
       
        refreshControll.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControll.addTarget(self, action: #selector(didPullToRefresh(sender:)), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControll)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refresh), name: NSNotification.Name(rawValue: "newDataNotif"), object: nil)

        print("HELLLLLLO")
        print(balances.count)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if userDefaults.defaults.isNew() {
            let view = storyboard?.instantiateViewController(identifier: "firstTime") as! FirstTimeViewController
            view.modalPresentationStyle = .fullScreen
            present(view, animated: true)
        }
    }
    
    //MARK: - Refresh Methods
    
    @objc func didPullToRefresh(sender: AnyObject) {
       DispatchQueue.main.async {
        self.getNewPrices()
        self.refresh()
        self.refreshControll.endRefreshing()
        
       }
    }
    
    @objc func refresh() {
        
        DispatchQueue.main.async { [self] in
            let defaults = UserDefaults.standard
            self.balanceLabel.text = defaults.string(forKey: "balanceAmount")
            
            let fetchRequest = NSFetchRequest<Balance>()
            
            let entity = Balance.entity()
              fetchRequest.entity = entity
              let sortDescriptor = NSSortDescriptor(
                key: "stock",
                ascending: true)
              fetchRequest.sortDescriptors = [sortDescriptor]
              do {
                self.balances = try self.context.fetch(fetchRequest)
              } catch {
                self.fatalCoreDataError(error)
              }
            
            
            
            
            totalValueDouble = 0.0
            for (index, stock) in self.balances.enumerated(){
                var stockValue: Double = Double(self.balances[index].value!)!
                totalValueDouble = totalValueDouble + stockValue
                
                print(self.balances[index].value)
                print("Hello")
            }
            var balanceDoub = Double(defaults.string(forKey: "balanceAmount")!)
            totalValueDouble = totalValueDouble + balanceDoub!
            totalValueLabel.text = String(format: "%f", totalValueDouble)
            
            self.tableView.reloadData()
        }
        
    }
    
    
    // MARK: - Helper Methods
    func getNewPrices() {
        batchRequestString = ""
        for (index, stock) in balances.enumerated(){
            batchRequestString = batchRequestString+balances[index].stock!+","
            
            
        }
        dataTask?.cancel()
        isLoading = true
        
        stockPortfolio = []

        let url = stocksURL()
        let session = URLSession.shared
        dataTask = session.dataTask(with: url) {data, response, error in
      
            if let error = error as NSError?, error.code == -999 {
                return
            } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                if let data = data {
                    self.stockPortfolio = self.parse(data: data)
                   
                    
                    for (index, stock) in self.stockPortfolio.enumerated(){
                        self.newPrices[self.stockPortfolio[index].symbol!] = String(self.stockPortfolio[index].price!)
                        
                        
                        //self.updatePrice(item: self.balances[index], newValue: newPriceString)
                        
                    }
                    for (index, stock) in self.balances.enumerated(){
                        var stockToUpdate: String = self.balances[index].stock!
                        if(self.newPrices[stockToUpdate] == nil) {
                           
                        }else {
                            self.updatePrice(item: self.balances[index], newValue: self.newPrices[stockToUpdate]!)
                            
                            var newPriceStr: String = self.balances[index].price!
                            var newPriceDoub: Double = Double(newPriceStr)!
                            var quantityStr: String = self.balances[index].quantity!
                            var quantityDoub: Double = Double(quantityStr)!
                            
                            var newTotalVal: Double? = quantityDoub*newPriceDoub
                            self.updateValue(item: self.balances[index], newValue: String(newTotalVal!))
                        }
                        
                        print(stockToUpdate)
                        print(self.newPrices[stockToUpdate])
                    }
                    
                    
                    
                    
                    DispatchQueue.main.async {
                        self.isLoading = false
                    }
                    return
                }
            } else {
                print("Failure! \(response!)")
            }
            DispatchQueue.main.async {
                self.isLoading = false
                self.showNetworkError()
            }
        }
        dataTask?.resume()
        self.tableView.reloadData()
    }
    
    func stocksURL() -> URL {
        let urlString = String(format: "https://financialmodelingprep.com/api/v3/quote/"+batchRequestString+"?apikey=d6d32343ce4ed4d79945c94ca7c9c383")
        let url = URL(string: urlString)
        return url!
    }
    
    func parse(data: Data) -> [StockPortfolio] {
        do {
            print("HEYHEYHELLO")
            let decoder = JSONDecoder()
            let result = try decoder.decode([StockPortfolio].self, from: data)
            return result
        } catch {
            print("JSON Error: \(error)")
            return []
        }
    }
    
    func showNetworkError() {
        let alert = UIAlertController(title: "Whoops...", message: "There was an error refreshing the stock information. Please try again.", preferredStyle: .alert)
        if(balances.count == 0) {
            
        }else {
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("HELLLO")
      if segue.identifier == "ShowDetailPortfolio" {
        print("HELLLO")
        let controller = segue.destination as! StockDetailViewController

        if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
            let balance = balances[indexPath.row]
            
            controller.balancePortfolio = balance
            controller.isPortfolio = isPortfolio
        }
        
      }
    }
    
    
    
    // MARK: - Core Data
    

    
    func updateValue(item: Balance, newValue: String) {
        item.value = newValue
        do {
            try context.save()
        }catch {
            
        }
    }
    
    func updatePrice(item: Balance, newValue: String) {
        item.price = newValue
        do {
            try context.save()
        }catch {
            
        }
    }
    
    func fatalCoreDataError(_ error: Error) {
      print("*** Fatal error: \(error)")
      NotificationCenter.default.post(name: dataSaveFailedNotification, object: nil)
        
    }
    let dataSaveFailedNotification = Notification.Name(rawValue: "DataSaveFailedNotification")
    
    
    
    
    

}

