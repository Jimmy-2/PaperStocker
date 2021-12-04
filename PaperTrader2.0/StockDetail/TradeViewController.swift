//
//  TradeViewController.swift
//  PaperTrader2.0
//
//  Created by Jimmy  on 11/22/21.
//

import UIKit
import CoreData


class TradeViewController: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet var symbolLabel: UILabel!
    @IBOutlet var currentPriceLabel: UILabel!
    @IBOutlet var availableBalanceLabel: UILabel!
    @IBOutlet var quantityTextField: UITextField!
    
    @IBOutlet var tradeButton: UIButton!
    
    var symbol: String?
    var stockName: String?
    var currentPrice: String?
    var tradeButtonText: String?
    var availableBalance: String?
    
    var balancePortfolioTrade: Balance?
    
    private var models = [Balance]()
    
    var isPortfolio: Bool!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        availableBalance = defaults.string(forKey: "balanceAmount")
        availableBalanceLabel.text = defaults.string(forKey: "balanceAmount")
        
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
        if tradeButtonText == "Buy" {
            if isPortfolio == true {
                let quantityToBuy: Double = Double(quantityTextField.text!)!
                let currentQuantity: Double = Double((balancePortfolioTrade?.quantity)!)!
                let newQuantity = quantityToBuy+currentQuantity
                let newValue = newQuantity*Double(currentPrice!)!
                updateQuantity(item: balancePortfolioTrade!, newQuantity: String(newQuantity))
                updateValue(item: balancePortfolioTrade!, newValue: String(newValue))
                //deleteItem(item: balancePortfolioTrade!)
                
            }else {
                var stockValue:Double = Double(currentPrice!)! * Double(quantityTextField.text!)!
                createItem(stock: symbol!, stockName: stockName!, price: currentPrice!, quantity: quantityTextField.text!, value: String(stockValue))
                
            }
            
            
        }else if tradeButtonText == "Sell" {
            if isPortfolio == true {
                let quantityToSell: Double = Double(quantityTextField.text!)!
                let currentQuantity: Double = Double((balancePortfolioTrade?.quantity)!)!
                var newQuantity: Double
                if quantityToSell >= currentQuantity {
                    newQuantity = 0
                }else {
                    newQuantity = currentQuantity-quantityToSell
                }
                let newValue = newQuantity*Double(currentPrice!)!
                updateQuantity(item: balancePortfolioTrade!, newQuantity: String(newQuantity))
                updateValue(item: balancePortfolioTrade!, newValue: String(newValue))
                //deleteItem(item: balancePortfolioTrade!)
                
            }else {
                
            }
            
        }
        
        //deleteItem(item: balancePortfolioTrade!)
        dismiss(animated: true, completion: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newDataNotif"), object: nil)

    }
    
    
    // MARK: Core Data

    func getAllItems() {
        do {
            models = try context.fetch(Balance.fetchRequest())
        
            DispatchQueue.main.async {
                
            }
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
    
    func updateQuantity(item: Balance, newQuantity: String) {
        item.quantity = newQuantity
        do {
            try context.save()
        }catch {
            
        }
    }
    
    func updateValue(item: Balance, newValue: String) {
        item.value = newValue
        do {
            try context.save()
        }catch {
            
        }
    }
    
    func updatePrice(item: Balance, newPrice: String, newValue: String) {
        
    }

}
