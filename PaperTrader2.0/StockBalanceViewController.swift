//
//  StockBalanceViewController.swift
//  PaperTrader2.0
//
//  Created by Jimmy  on 11/26/21.
//

import UIKit

class StockPortfolioViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private var models = [Balance]()
    
    override func viewDidLoad() {
        super.viewDidLoad();
        title = "Paper Trader Portfolio"
        createItem(stock: "saa", stockName: "sdas", price: "adassad", quantity: "asdsad", value: "dasaas")
    }
    
    func getAllItems() {
        do {
             models = try context.fetch(Balance.fetchRequest())
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
}
