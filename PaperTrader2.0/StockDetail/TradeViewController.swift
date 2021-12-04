//
//  TradeViewController.swift
//  PaperTrader2.0
//
//  Created by Jimmy  on 11/22/21.
//

import UIKit
import CoreData


class TradeViewController: UIViewController, UITextFieldDelegate  {
    
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
    
    var portfolioSymbols: [String] = []
    var portfolioStock: [String] = []
    var portfolioValue: [String] = []


    override func viewDidLoad() {
        super.viewDidLoad()
        getAllPortfolioItems()
        print(self.portfolioSymbols)
        
        quantityTextField.delegate = self
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
        if(quantityTextField.text == "") {
            
        }else {
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
                    if let index = portfolioSymbols.index(of: symbol!) {
                        print(models[index].quantity)
                        let quantityToBuy: Double = Double(quantityTextField.text!)!
                        let currentQuantity: Double = Double((models[index].quantity)!)!
                        let newQuantity = quantityToBuy+currentQuantity
                        let newValue = newQuantity*Double(currentPrice!)!
                        updateQuantity(item: models[index], newQuantity: String(newQuantity))
                        updateValue(item: models[index], newValue: String(newValue))
                        
                    }else {
                        var stockValue:Double = Double(currentPrice!)! * Double(quantityTextField.text!)!
                        createItem(stock: symbol!, stockName: stockName!, price: currentPrice!, quantity: quantityTextField.text!, value: String(stockValue))
                    }
                    
                    
                }
                
                
            }else if tradeButtonText == "Sell" {
                if isPortfolio == true {
                    let quantityToSell: Double = Double(quantityTextField.text!)!
                    let currentQuantity: Double = Double((balancePortfolioTrade?.quantity)!)!
                    
                    if quantityToSell >= currentQuantity {
                        deleteItem(item: balancePortfolioTrade!)
                        
                    }else {
                        let newQuantity:Double = currentQuantity-quantityToSell
                        let newValue = newQuantity*Double(currentPrice!)!
                        updateQuantity(item: balancePortfolioTrade!, newQuantity: String(newQuantity))
                        updateValue(item: balancePortfolioTrade!, newValue: String(newValue))
                    }
                    
                    
                }else {
                    if let index = portfolioSymbols.index(of: symbol!) {
                        print(models[index].quantity)
                        let quantityToSell: Double = Double(quantityTextField.text!)!
                        let currentQuantity: Double = Double((models[index].quantity)!)!
                        
                        if quantityToSell >= currentQuantity {
                            deleteItem(item: models[index])
                        }else {
                            let newQuantity:Double = currentQuantity-quantityToSell
                            let newValue = newQuantity*Double(currentPrice!)!
                            updateQuantity(item: models[index], newQuantity: String(newQuantity))
                            updateValue(item: models[index], newValue: String(newValue))
                        }
                        
                        
                    }else {
                       
                    }
                }
                
            }
            
        }
        
        
        
        //deleteItem(item: balancePortfolioTrade!)
        dismiss(animated: true, completion: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newDataNotif"), object: nil)

    }
    //MARK: - Text Field Delegates
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let allowedChars = "1234567890"
        let allowedCharSet = CharacterSet(charactersIn: allowedChars)
        let typedCharSet = CharacterSet(charactersIn: string)
        
        return allowedCharSet.isSuperset(of: typedCharSet)
        return true
    }
    
    // MARK: Core Data

    func getAllPortfolioItems() {
        do {
            models = try context.fetch(Balance.fetchRequest())
            for index in 0...self.models.count-1 {
                self.portfolioSymbols.append(self.models[index].stock!)
            }
            
            
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
