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
    
    @IBOutlet var totalProfitMade: UILabel!
    //store avg cost of each stock in database and set the label to the one with the highest gain
    @IBOutlet var biggestWin: UILabel!
    @IBOutlet var biggestLoss: UILabel!
    
    
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var balances = [Balance]()
    var stockRecords = [StockRecords]()
    
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
        pieChart.frame = CGRect(x:0,y:0, width: self.view.frame.size.width, height:300)

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
