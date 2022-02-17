//
//  SummaryViewController.swift
//  PaperTrader2.0
//
//  Created by Jimmy  on 2/5/22.
//

import UIKit
import DropDown
import CoreData
import Charts

class SummaryViewController: UITableViewController,ChartViewDelegate  {
    var pieChart = PieChartView()
    let dropDown = DropDown()
    @IBOutlet var dropDownButton: UIButton!
    
    var ascendingOrder: Bool = false
    var ascendedBy: String = "totalProfits"
    
    @IBOutlet var allTimeProfitLabel: UILabel!
    
    //store avg cost of each stock in database and set the label to the one with the highest gain
    @IBOutlet var mostProfitableStockSymbolLabel: UILabel!
    @IBOutlet var leastProfitableStockSymbolLabel: UILabel!
    @IBOutlet var mostProfitableStockProfitLabel: UILabel!
    @IBOutlet var leastProfitableStockProfitLabel: UILabel!
    
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var balanceItems = [Balance]()
    var portfolioSymbols: [String] = []
    
    
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

        dropDown.anchorView = dropDownButton
        dropDown.dataSource = ["Profit","Ticker"]
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.summaryRefresh), name: NSNotification.Name(rawValue: "newSummaryDataNotif"), object: nil)
        summaryRefresh()

    }
    
    @IBAction func dropDownClicked() {
        //if same button clicked, change ascending order else change which to sort by
        dropDown.show()
        dropDown.layer.zPosition = 1;
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            //self.dropDownButton.setTitle(item,for: .normal)
            if (item == "Profit" && ascendedBy == "totalProfits") || (item == "Ticker" && ascendedBy == "stockSymbol"){
                ascendingOrder = !ascendingOrder
            }else {
                if item == "Profit" {
                    ascendedBy = "totalProfits"
                }else {
                    ascendedBy = "stockSymbol"
                }
                
            }
            
            self.summaryRefresh()
           
        }
    }
    @objc func summaryRefresh()  {
        //fatching portfolio items
        let fetchRequest = NSFetchRequest<StockRecords>()
        
        let entity = StockRecords.entity()
        fetchRequest.entity = entity
          
        let sortDescriptor = NSSortDescriptor(
            key: ascendedBy,
            ascending: ascendingOrder)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            stockRecords = try context.fetch(fetchRequest)
            
            
        } catch {
            //fatalCoreDataError(error)
        }
       
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
            
            
            labelColorChange(labelName: mostProfitableStockProfitLabel, amount: mostProfitableStockAmount)
            
            labelColorChange(labelName: leastProfitableStockProfitLabel, amount: leastProfitableStockAmount)

            allTimeProfitLabel.text = String(format: "%.2f",allTimeProfit)
            labelColorChange(labelName: allTimeProfitLabel, amount: allTimeProfit)
        }
        
        self.createPieChart()
        
       
        self.tableView.reloadData()
    }
    
    func labelColorChange(labelName: UILabel, amount: Double) {
        if (amount > 0) {
            labelName.textColor = UIColor(red: 35/255, green: 200/255, blue: 35/255, alpha: 1.0)
        }else if(amount < 0) {
            labelName.textColor = UIColor(red: 255/255, green: 20/255, blue: 25/255, alpha: 1.0)
        }
    }
    
    func createPieChart() {
        let defaults = UserDefaults.standard
        
        //put all portfolio items into list
        getAllPortfolioItems()
        
        pieChart.delegate = self
        pieChart.frame = CGRect(x:0,y:20, width: self.view.frame.size.width, height:300)
        
        view.addSubview(pieChart)
        
        pieChart.drawHoleEnabled = false
        pieChart.legend.enabled = false
        var entries: [PieChartDataEntry] = Array()
        
        for x in 0..<balanceItems.count {
            let pieVals: String = balanceItems[x].value!
            entries.append(PieChartDataEntry(value: Double(pieVals)!, label: balanceItems[x].stockName))
        }
   
        let availableBalance: String? = defaults.string(forKey: "balanceAmount")
        let availableBalanceDoub: Double = Double(availableBalance!)!
        entries.append(PieChartDataEntry(value: availableBalanceDoub, label: "Cash"))
        let dataSet = PieChartDataSet(entries: entries, label: "")
        dataSet.colors = ChartColorTemplates.material()
        dataSet.drawValuesEnabled = false
        pieChart.data = PieChartData(dataSet: dataSet)
    }
    
    func getAllPortfolioItems() {
        do {
            balanceItems = try context.fetch(Balance.fetchRequest())
            for (index, stock) in balanceItems.enumerated(){
                self.portfolioSymbols.append(self.balanceItems[index].stock!)
            }
            
            DispatchQueue.main.async {
                
            }
        }catch {
            // error
        }
    }
    
}
