//
//  DailyBalanceViewController.swift
//  PaperTrader2.0
//
//  Created by Jimmy  on 1/23/22.
//

import DropDown
import UIKit
import CoreData

class DailyBalanceViewController: UITableViewController {
    @IBOutlet var dropdownButton: UIButton!
    
    let dropDown = DropDown()
    
    var sortingOrder: Bool = false
    
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
        dropDown.anchorView = dropdownButton
        dropDown.dataSource = ["DESC\u{2193}","ASC\u{2191}"]
        refreshTable() 
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshTable), name: NSNotification.Name(rawValue: "newDailyBalanceDataNotif"), object: nil)
    }
    @objc func refreshTable()  {
        let fetchRequest = NSFetchRequest<DailyBalance>()
        
        let entity = DailyBalance.entity()
        fetchRequest.entity = entity
        let sortDescriptor = NSSortDescriptor(
            key: "date",
            ascending: sortingOrder)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            dailyBalances = try context.fetch(fetchRequest)
            
        } catch {
            //fatalCoreDataError(error)
        }
        self.tableView.reloadData()
    }
    
    @IBAction func dropdownClicked() {
        dropDown.show()
        dropDown.layer.zPosition = 1;
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            //self.dropDownButton.setTitle(item,for: .normal)
            if item == "\u{2793}" {
                sortingOrder = false
            }
                
            else {
                sortingOrder = true
            }
            
            self.refreshTable()
        }
       
        
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
    
    //for testing
    func deleteItem(item: DailyBalance) {
        context.delete(item)
        
        do {
            try context.save()
        }catch {
            
        }
    }
   
}
