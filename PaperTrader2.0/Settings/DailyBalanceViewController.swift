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
            ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            dailyBalances = try context.fetch(fetchRequest)
            
        } catch {
            //fatalCoreDataError(error)
        }
    }
    
    @IBAction func testAddBalance() {
        addDailyBalanceItem(date: "HELLO1", balanceAmount: "balanceAmount: HEHE")
        
    }
    func addDailyBalanceItem(date: String, balanceAmount: String) {
        let newItem = DailyBalance(context: context)
        newItem.balanceAmount = balanceAmount
        newItem.date = date
       
        
        do {
            try context.save()
            
        }catch {
            
        }
    }
}
