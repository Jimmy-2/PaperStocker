//
//  SummaryViewController.swift
//  PaperTrader2.0
//
//  Created by Jimmy  on 2/5/22.
//

import UIKit
import CoreData
import Charts

class SummaryViewController: UITableViewController,ChartViewDelegate  {
    var pieChart = PieChartView()
    
    @IBOutlet var allTimeProfitLabel: UILabel!
    //store avg cost of each stock in database and set the label to the one with the highest gain
    @IBOutlet var mostProfitableStockSymbolLabel: UILabel!
    @IBOutlet var leastProfitableStockSymbolLabel: UILabel!
    @IBOutlet var mostProfitableStockProfitLabel: UILabel!
    @IBOutlet var leastProfitableStockProfitLabel: UILabel!
    
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var balances = [Balance]()
    var stockRecords = [StockRecords]()
    var allTimeProfit: Double = 0.0
    
    var leastProfitableStock: String = ""
    var leastProfitableStockAmount: Double = Double.infinity
    
    var mostProfitableStock: String = ""
    var mostProfitableStockAmount: Double = -Double.infinity
    
    
    var gainsDictionary = Dictionary<String, Double>()
    
    // MARK: Table View Delegates
    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        
        return stockRecords.count
    }
    
    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
      ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
          withIdentifier: "StockRecordsCell",
          for: indexPath) as! StockRecordsCell
        
        let stockRecord = stockRecords[indexPath.row]
        
        cell.configure(for: stockRecord)
        return cell
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        //fatching portfolio items
        let fetchRequest = NSFetchRequest<StockRecords>()
        
        let entity = StockRecords.entity()
        fetchRequest.entity = entity
          
        let sortDescriptor = NSSortDescriptor(
            key: "totalProfits",
            ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            stockRecords = try context.fetch(fetchRequest)
            
            
        } catch {
            //fatalCoreDataError(error)
        }
        
        
        
        print(mostProfitableStockAmount)
        
        // put everything under here in a refresh function that can be called to reload table view from portfolio screen
        for i in 0..<stockRecords.count {
            allTimeProfit += stockRecords[i].totalProfits
            if (stockRecords[i].totalProfits > mostProfitableStockAmount) {
                self.mostProfitableStockAmount = stockRecords[i].totalProfits
                self.mostProfitableStock = stockRecords[i].stockSymbol!
            }
            if (stockRecords[i].totalProfits < leastProfitableStockAmount) {
                self.leastProfitableStockAmount = stockRecords[i].totalProfits
                self.leastProfitableStock = stockRecords[i].stockSymbol!
            }
        }
        if(stockRecords.count > 0) {
            mostProfitableStockSymbolLabel.text = mostProfitableStock
            mostProfitableStockProfitLabel.text = String(format: "%.2f",mostProfitableStockAmount)
            leastProfitableStockSymbolLabel.text = leastProfitableStock
            leastProfitableStockProfitLabel.text = String(format: "%.2f",leastProfitableStockAmount)
            
            if (mostProfitableStockAmount > 0) {
                self.mostProfitableStockProfitLabel.textColor = UIColor(red: 35/255, green: 200/255, blue: 35/255, alpha: 1.0)
            }else if(mostProfitableStockAmount < 0) {
                self.mostProfitableStockProfitLabel.textColor = UIColor(red: 255/255, green: 20/255, blue: 25/255, alpha: 1.0)
            }
            
            if (leastProfitableStockAmount > 0) {
                self.leastProfitableStockProfitLabel.textColor = UIColor(red: 35/255, green: 200/255, blue: 35/255, alpha: 1.0)
            }else if (leastProfitableStockAmount < 0) {
                self.mostProfitableStockProfitLabel.textColor = UIColor(red: 255/255, green: 20/255, blue: 25/255, alpha: 1.0)
            }
            
            allTimeProfitLabel.text = String(format: "%.2f",allTimeProfit)
            if (allTimeProfit > 0) {
                self.allTimeProfitLabel.textColor = UIColor(red: 35/255, green: 200/255, blue: 35/255, alpha: 1.0)
            }else if(allTimeProfit < 0) {
                self.allTimeProfitLabel.textColor = UIColor(red: 255/255, green: 20/255, blue: 25/255, alpha: 1.0)
            }
        }
        
        print(allTimeProfit)
        print(mostProfitableStock)
        print(leastProfitableStock)
        /*
        for (index, _) in self.balances.enumerated(){
            var avgPrice: Double = Double(self.balances[index].avgPrice!)!
            var currQuanitity: Double = Double(self.balances[index].quantity!)!
            var currVal:Double = Double(self.balances[index].value!)!
            
            var totalGains: Double = currVal - (avgPrice*currQuanitity)
            gainsDictionary[self.balances[index].stock!] = totalGains
  
        }
        
        print(gainsDictionary)
        */
        
        pieChart.delegate = self
        pieChart.frame = CGRect(x:0,y:20, width: self.view.frame.size.width, height:300)

        view.addSubview(pieChart)
        var entriesPie = [ChartDataEntry]()
        for x in 0..<10 {
            entriesPie.append(ChartDataEntry(x:Double(x),y:Double(x)))
        }
        let setPie = PieChartDataSet(entries:entriesPie)
        setPie.colors = ChartColorTemplates.material()
        let dataPie = PieChartData(dataSet:setPie)
        pieChart.data = dataPie
        
        
        
    }
    
}
