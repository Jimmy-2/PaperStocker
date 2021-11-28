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
        let fetchRequest = NSFetchRequest<Balance>()
        
        let entity = Balance.entity()
          fetchRequest.entity = entity
          // 3
          let sortDescriptor = NSSortDescriptor(
            key: "stock",
            ascending: true)
          fetchRequest.sortDescriptors = [sortDescriptor]
          do {
            // 4
            balances = try context.fetch(fetchRequest)
          } catch {
            fatalCoreDataError(error)
          }
        
        refreshControll.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControll.addTarget(self, action: #selector(didPullToRefresh(sender:)), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControll)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refresh), name: NSNotification.Name(rawValue: "newDataNotif"), object: nil)

        
    }
    
    @objc func didPullToRefresh(sender: AnyObject) {
        DispatchQueue.main.async {
            
            self.refresh()
            self.refreshControll.endRefreshing()
        }
    }
    
    @objc func refresh() {
        DispatchQueue.main.async {
            let fetchRequest = NSFetchRequest<Balance>()
            
            let entity = Balance.entity()
              fetchRequest.entity = entity
              // 3
              let sortDescriptor = NSSortDescriptor(
                key: "stock",
                ascending: true)
              fetchRequest.sortDescriptors = [sortDescriptor]
              do {
                // 4
                self.balances = try self.context.fetch(fetchRequest)
              } catch {
                self.fatalCoreDataError(error)
              }
            
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
    
    func createItem(stock: String, stockName: String, price: String, quantity: String, value: String) {
        let newItem = Balance(context: context)
        newItem.stock = stock
        newItem.stockName = stockName
        newItem.price = price
        newItem.quantity = quantity
        newItem.value = value
        
        do {
            try context.save()
            
        }catch {
            
        }
    }
    
    func deleteItem(item: Balance) {
        context.delete(item)
        
        do {
            try context.save()
        }catch {
            
        }
    }
    
    func updateItem(item: Balance, newQuantity: String) {
        item.quantity = newQuantity
        do {
            try context.save()
        }catch {
            
        }
    }
    
    func updatePrice(item: Balance, newPrice: String, newValue: String) {
        
    }
    
    func fatalCoreDataError(_ error: Error) {
      print("*** Fatal error: \(error)")
      NotificationCenter.default.post(name: dataSaveFailedNotification, object: nil)
        
    }
    let dataSaveFailedNotification = Notification.Name(rawValue: "DataSaveFailedNotification")

}
