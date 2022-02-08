//
//  StockBalanceViewController.swift
//  PaperTrader2.0
//
//  Created by Jimmy  on 11/26/21.
//

import Charts
import UIKit
import CoreData

class StockPortfolioViewController: UITableViewController,ChartViewDelegate {
    
    var lineChart = LineChartView()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var balances = [Balance]()
    
    var dailyBalances = [DailyBalance]()
    
    var searchResults = [SearchResult]()
    
    let refreshControll = UIRefreshControl()
    
    var totalValueDouble: Double = 0.0

    var batchRequestString: String = ""
    var dailyBalanceCount: Int = 0
    
    @IBOutlet var balanceLabel: UILabel!
    @IBOutlet var totalValueLabel: UILabel!
    @IBOutlet var noStockLabel: UILabel!
    
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
        print(UserDefaults.standard.dictionaryRepresentation())
        
        

        let defaults = UserDefaults.standard
        let availableBalance: String? = defaults.string(forKey: "balanceAmount")
        let availableBalanceDoub: Double = Double(availableBalance ?? "100000")!
        self.balanceLabel.text = String(format: "%.2f", availableBalanceDoub)

        //fatching portfolio items
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
        if balances.count == 0 {
            noStockLabel.isHidden = false
            
        }else {
            noStockLabel.isHidden = true
        }
        
        for (index, stock) in balances.enumerated(){
            var stockValue: Double = Double(balances[index].value!)!
            totalValueDouble = totalValueDouble + stockValue
        }
 
        var balanceDoub: Double? = Double(defaults.string(forKey: "balanceAmount") ?? "0.0")
        totalValueDouble = totalValueDouble + balanceDoub!
        totalValueLabel.text = String(format: "%.2f", totalValueDouble)
       
        refreshControll.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControll.addTarget(self, action: #selector(didPullToRefresh(sender:)), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControll)
        refreshControll.tintColor = .white
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refresh), name: NSNotification.Name(rawValue: "newDataNotif"), object: nil)
       
    
        self.refresh()
            
        
       
        
        
        
        
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
        self.refreshControll.endRefreshing()
        DispatchQueue.main.async {
            self.refresh()
        
        
        }
        
    }
    
    @objc func refresh() {
        
        
        DispatchQueue.main.async { [self] in
            
            let defaults = UserDefaults.standard
            let availableBalance: String? = defaults.string(forKey: "balanceAmount")
            if availableBalance != nil {
                let availableBalanceDoub: Double = Double(availableBalance!)!
                self.balanceLabel.text = String(format: "%.2f", availableBalanceDoub)
            }
            
            
            
            
            
            
            
            
            
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
      
            }
            if balances.count == 0 {
                noStockLabel.isHidden = false
                
            }else {
                noStockLabel.isHidden = true
            }
            getNewPrices()
            var balanceDoub = Double(defaults.string(forKey: "balanceAmount") ?? "100000")
            totalValueDouble = totalValueDouble + balanceDoub!
            totalValueLabel.text = String(format: "%.2f", totalValueDouble)
            
            
            // datetime graph entry
            let currentDateTime = Date()
            let formatter = DateFormatter()
            formatter.timeStyle = .none
            formatter.dateStyle = .medium
            formatter.timeZone = TimeZone.current
            let dateTimeString = formatter.string(from: currentDateTime)
       
            
            let fetchRequestDailyBalance = NSFetchRequest<DailyBalance>()
            let entityDailyBalance = DailyBalance.entity()
            fetchRequestDailyBalance.entity = entityDailyBalance
            let sortDescriptorDailyBalance = NSSortDescriptor(
                key: "date",
                ascending: true)
            fetchRequestDailyBalance.sortDescriptors = [sortDescriptorDailyBalance]
            do {
                dailyBalances = try context.fetch(fetchRequestDailyBalance)
                
            } catch {
                //fatalCoreDataError(error
            }
            
            if dailyBalances.count == 0 {
                addDailyBalanceItem(date: currentDateTime, balanceAmount: availableBalance ?? "0", dateString: "Start")
            }else if dailyBalances.count > 0 && dateTimeString == dailyBalances[dailyBalances.count-1].dateString {
                updateDailyBalanceItem(item: self.dailyBalances[dailyBalances.count-1], newBalance: String(format: "%.2f", totalValueDouble))
            }else {
                addDailyBalanceItem(date: currentDateTime, balanceAmount: String(format: "%.2f", totalValueDouble), dateString: dateTimeString)
            }
            //line chart
       
            lineChart.delegate = self
            lineChart.frame = CGRect(x:0,y:0, width: self.view.frame.size.width, height:240)
            
            view.addSubview(lineChart)
            var entries = [ChartDataEntry]()
            for x in 0..<dailyBalances.count {
                entries.append(ChartDataEntry(x:Double(x),y:Double(dailyBalances[x].balanceAmount!)!))
            }
            let set = LineChartDataSet(entries:entries)
            let data = LineChartData(dataSet:set)
            set.drawCirclesEnabled = false
            lineChart.leftAxis.axisMinimum = 0
            lineChart.rightAxis.axisMinimum = 0
            lineChart.xAxis.axisMinimum = 0
            lineChart.xAxis.axisMaximum = Double(dailyBalances.count-1)
            lineChart.xAxis.labelTextColor = UIColor.white
            lineChart.leftAxis.labelTextColor = UIColor.white
            lineChart.rightAxis.labelTextColor = UIColor.white
            data.setValueTextColor(UIColor.white)
            set.drawFilledEnabled = true
            lineChart.legend.enabled = false
            lineChart.data = data
            if (dailyBalances.count > 0) {
                lineChart.xAxis.valueFormatter = self
            }
            if (dailyBalances.count > 4) {
        
                lineChart.xAxis.labelCount = 4
                lineChart.setVisibleXRangeMaximum(4)
            }
            lineChart.leftAxis.drawGridLinesEnabled = false
            lineChart.xAxis.drawGridLinesEnabled = false
            lineChart.leftAxis.drawAxisLineEnabled = false
            lineChart.xAxis.drawAxisLineEnabled = false
            lineChart.moveViewToX(Double(dailyBalances.count))
            
            
            lineChart.notifyDataSetChanged()
            
            lineChart.animate(xAxisDuration: 0.05)
                
                
                
                
            
            
            
            self.tableView.reloadData()
            

        }
        
    }
    
    
    // MARK: - Helper Methods
    func getNewPrices() {
        batchRequestString = ""
        for (index, stock) in balances.enumerated(){
            batchRequestString = batchRequestString+balances[index].stock!+","
        }
        
        //remove last comma from string for batch endpoint testing since I do not have premium 
        if batchRequestString.count > 0 {
            batchRequestString.remove(at: batchRequestString.index(before: batchRequestString.endIndex))
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
        let urlString = String(format: "https://financialmodelingprep.com/api/v3/quote/"+batchRequestString+"?apikey=a648ba199bfe8c139430db2f19fb782f")
        let url = URL(string: urlString)
        return url!
    }
    
    func parse(data: Data) -> [StockPortfolio] {
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode([StockPortfolio].self, from: data)
            return result
        } catch {
            //print("JSON Error: \(error)")
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
      if segue.identifier == "ShowDetailPortfolio" {
        let controller = segue.destination as! StockDetailViewController

        if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
            let balance = balances[indexPath.row]
            print(indexPath.row)
            
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
    
    func addDailyBalanceItem(date: Date, balanceAmount: String, dateString: String) {
        let newItem = DailyBalance(context: context)
        newItem.balanceAmount = balanceAmount
        newItem.date = date
        newItem.dateString = dateString
        do {
            try context.save()
        }catch {
            
        }
    }
    
    func updateDailyBalanceItem(item: DailyBalance, newBalance: String) {
        item.balanceAmount = newBalance
        do {
            try context.save()
        }catch {
            
        }
    }
    
    
    
    func fatalCoreDataError(_ error: Error) {
      //print("*** Fatal error: \(error)")
      NotificationCenter.default.post(name: dataSaveFailedNotification, object: nil)
        
    }
    let dataSaveFailedNotification = Notification.Name(rawValue: "DataSaveFailedNotification")
    
    
    
    
    


}

extension StockPortfolioViewController: IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        var xDate: [String] = []
        for x in 0..<dailyBalances.count {
            xDate.append(dailyBalances[x].dateString!)
        }
        
        return xDate[Int(value)]
    }
}

