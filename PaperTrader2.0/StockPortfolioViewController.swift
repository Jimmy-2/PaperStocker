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
          for: indexPath)
        
        let balance = balances[indexPath.row]

        let symbolLabel = cell.viewWithTag(1001) as! UILabel
        symbolLabel.text = balance.stock

        let stockNameLabel = cell.viewWithTag(1002) as! UILabel
        stockNameLabel.text = balance.stockName
        
        let priceLabel = cell.viewWithTag(1003) as! UILabel
        priceLabel.text = balance.price
        
        let quantityLabel = cell.viewWithTag(1004) as! UILabel
        quantityLabel.text = balance.quantity
        
        let valueLabel = cell.viewWithTag(1005) as! UILabel
        valueLabel.text = balance.value

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
        
    }
    
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
