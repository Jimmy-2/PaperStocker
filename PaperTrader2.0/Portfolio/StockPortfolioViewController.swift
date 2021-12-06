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
            batchRequestString = batchRequestString+balances[index].stock!
            
            
        }
        print("HELLLLLLLLLLO")
        print(batchRequestString)
        
        
        
        
        
        
        
        
        for (index, stock) in balances.enumerated(){
            var stockValue: Double = Double(balances[index].value!)!
            totalValueDouble = totalValueDouble + stockValue
            
            print(balances[index].value)
            print("Hello")
        }
        
        
        
        
        var balanceDoub = Double(defaults.string(forKey: "balanceAmount")!)
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
    
    
    @objc func didPullToRefresh(sender: AnyObject) {
        DispatchQueue.main.async {
            let defaults = UserDefaults.standard
            self.balanceLabel.text = defaults.string(forKey: "balanceAmount")
            
            self.refresh()
            self.newPrices["aapl"] = "123HELLLO"
            print(self.newPrices["aapl"])
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
    
    func getAllItems() {
        do {
             let item = try context.fetch(Balance.fetchRequest())
        }catch {
            // error
        }
        
    }
    
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

