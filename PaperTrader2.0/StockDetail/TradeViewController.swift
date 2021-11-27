//
//  TradeViewController.swift
//  PaperTrader2.0
//
//  Created by Jimmy  on 11/22/21.
//

import UIKit


class TradeViewController: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet var symbolLabel: UILabel!
    @IBOutlet var currentPriceLabel: UILabel!
    @IBOutlet var availableBalanceLabel: UILabel!
    
    @IBOutlet var tradeButton: UIButton!
    
    var symbol: String?
    var currentPrice: String?
    var tradeButtonText: String?


    override func viewDidLoad() {
        super.viewDidLoad()
        
        symbolLabel.text = symbol
        currentPriceLabel.text = currentPrice
        tradeButton.setTitle(tradeButtonText, for: .normal) 

        // Do any additional setup after loading the view.
    }
    
    // MARK: Actions
    @IBAction func closeTrade() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doTrade() {
        createItem(stock: symbol!, stockName: "gamestop", price: currentPrice!, quantity: "13212", value: "211231331231")
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: Core Data

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

}
