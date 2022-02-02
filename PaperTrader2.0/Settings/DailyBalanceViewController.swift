//
//  DailyBalanceViewController.swift
//  PaperTrader2.0
//
//  Created by Jimmy  on 1/23/22.
//


import UIKit
import CoreData

class DailyBalanceViewController: UITableViewController {
    @IBOutlet var testButton: UIButton!
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var dailyBalances = [DailyBalance]()
    
    // MARK: Table View Delegates
    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        
        return dailyBalances.count
    }
    
    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
      ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
          withIdentifier: "DailyBalanceCell",
          for: indexPath) as! DailyBalanceCell
        
        let dailyBalance = dailyBalances[indexPath.row]
        
        cell.configure(for: dailyBalance)
        return cell
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let fetchRequest = NSFetchRequest<DailyBalance>()
        
        let entity = DailyBalance.entity()
        fetchRequest.entity = entity
        let sortDescriptor = NSSortDescriptor(
            key: "date",
            ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            dailyBalances = try context.fetch(fetchRequest)
            
        } catch {
            //fatalCoreDataError(error)
        }
        print(dailyBalances.count)
    }
    
    @IBAction func testAddBalance() {
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .medium
        formatter.timeZone = TimeZone.current
        let dateTimeString = formatter.string(from: currentDateTime)
        addDailyBalanceItem(date: currentDateTime, balanceAmount: "140000", dateString: "Feb 2, 2022")
       
        
    }
    
    // MARK: Core Data
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
    
   
}
