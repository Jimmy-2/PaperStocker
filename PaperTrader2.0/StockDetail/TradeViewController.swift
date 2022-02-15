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
    
    @IBOutlet var popupView: UIView!
    
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
    
    //calculate profits even time we sell a stock and put that record into the stockrecords database
    var stockRecords = [StockRecords]()
    
    
    var balancePortfolioTrade: Balance?

    
    private var models = [Balance]()
    private var stockRecordsModels = [StockRecords]()
    
    
    var isPortfolio: Bool!
    
    var portfolioSymbols: [String] = []
    var stockRecordsSymbols: [String] = []
    
    @IBOutlet var availableToBuyLabel: UILabel!
    @IBOutlet var shareAmountLabel: UILabel!

    var ableToPurchase: Double?
    var balanceDouble: Double?

    override func viewDidLoad() {
        super.viewDidLoad()
        popupView.layer.cornerRadius = 10
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        gestureRecognizer.cancelsTouchesInView = false
        gestureRecognizer.delegate = self
        view.addGestureRecognizer(gestureRecognizer)
      
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let defaults = UserDefaults.standard
    
        getAllPortfolioItems()
        getAllStockRecordsItems()
        
        quantityTextField.delegate = self

        availableBalance = defaults.string(forKey: "balanceAmount")
        let availableBalanceDoub: Double = Double(availableBalance!)!
        availableBalanceLabel.text = String(format: "%.2f", availableBalanceDoub)
        
        symbolLabel.text = symbol
        currentPriceLabel.text = currentPrice
        
        balanceDouble = Double(availableBalance!)
        ableToPurchase = balanceDouble!/Double(currentPrice!)!
        
        availableToBuyLabel.text = String(format: "%.0f", floor(ableToPurchase!))
        tradeButton.setTitle(tradeButtonText, for: .normal)
        
        if let index = portfolioSymbols.index(of: symbol!) {
            shareAmountLabel.text = models[index].quantity
        }else {
            shareAmountLabel.text = "0"
           
        }
    }
   
    
    // MARK: Actions
    @IBAction func closeTrade() {
        dismiss(animated: true, completion: nil)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
          
            let spaceAtBottom = self.view.frame.height
            self.view.frame.origin.y = keyboardHeight - keyboardHeight - keyboardHeight/2
        }
    }
    @objc private func keyboardWillHide() {
        self.view.frame.origin.y = 0
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @IBAction func doTrade() {
        if(quantityTextField.text == "") {
            
        }else {
            if tradeButtonText == "Buy" {
                //coming from portflio screen
                if isPortfolio == true {
                    let quantityToBuy: Double = Double(quantityTextField.text!)!
                    if(quantityToBuy > ableToPurchase!) {
                        showToastMessage(message: "You cannot afford this many shares!")
                    }else if (quantityToBuy == 0) {
                        showToastMessage(message: "Please enter a number greater than 0!")
                        
                    }else {
                        let currentQuantity: Double = Double((balancePortfolioTrade?.quantity ?? "0"))!
                        let newQuantity = quantityToBuy+currentQuantity
                        let newValue = newQuantity*Double(currentPrice!)!
                        
                        //update quantity of stock in coredata
                        updateQuantity(item: balancePortfolioTrade!, newQuantity: String(newQuantity))
                        
                        //update total value of stock in coredata
                        updateValue(item: balancePortfolioTrade!, newValue: String(newValue))
                        updatePrice(item: balancePortfolioTrade!, newPrice: String(currentPrice!))
                        
                        let oldAvgPrice: String = balancePortfolioTrade!.avgPrice!
                        let newPositionVal:Double = quantityToBuy*Double(currentPrice!)!
                        let oldPositionVal:Double = currentQuantity*Double(oldAvgPrice)!
                        let newAvgPrice: Double = (newPositionVal + oldPositionVal)/newQuantity
                            
                        updateAvgPrice(item: balancePortfolioTrade!, newAvgprice: String(format: "%.2f",newAvgPrice))
                        
                        var spentAmount: Double? = quantityToBuy*Double(currentPrice!)!
                        balanceDouble = balanceDouble! - spentAmount!
                        var newBalance:String? = String(format: "%f", balanceDouble!)
                        let defaults = UserDefaults.standard
                        defaults.set(newBalance, forKey: "balanceAmount")
                        showToastMessage2(message: "You have successfully purchased " + quantityTextField.text! + " shares!")
                        //deleteItem(item: balancePortfolioTrade!)
                    }
                    
                    
                //coming from search stock screen
                }else {
                    let quantityToBuy: Double = Double(quantityTextField.text!)!
                    if(quantityToBuy > ableToPurchase!) {
                        showToastMessage(message: "You cannot afford this many shares!")
                    }else {
                        //check if stock exists in database and if it does, get the index of it from database
                        if let index = portfolioSymbols.index(of: symbol!) {
                        
                            let currentQuantity: Double = Double((models[index].quantity)!)!
                            let newQuantity = quantityToBuy+currentQuantity
                            let newValue = newQuantity*Double(currentPrice!)!
                            
                            //update quantity of stock in coredata
                            updateQuantity(item: models[index], newQuantity: String(newQuantity))
                            
                            //update total value of stock in coredata
                            updateValue(item: models[index], newValue: String(newValue))
                            updatePrice(item: balancePortfolioTrade!, newPrice: String(currentPrice!))
                            
                            let oldAvgPrice: String = balancePortfolioTrade!.avgPrice!
                            let newPositionVal:Double = quantityToBuy*Double(currentPrice!)!
                            let oldPositionVal:Double = currentQuantity*Double(oldAvgPrice)!
                            let newAvgPrice: Double = (newPositionVal + oldPositionVal)/newQuantity
                                
                            updateAvgPrice(item: balancePortfolioTrade!, newAvgprice: String(newAvgPrice))
                            
                            var spentAmount: Double? = quantityToBuy*Double(currentPrice!)!
                            balanceDouble = balanceDouble! - spentAmount!
                            var newBalance:String? = String(format: "%f", balanceDouble!)
                            let defaults = UserDefaults.standard
                            defaults.set(newBalance, forKey: "balanceAmount")
                            showToastMessage2(message: "You have successfully purchased " + quantityTextField.text! + " shares!")
                            
                        }else {
                            //if stock does not exist in portfolio then we will create a new entry for it in coredata
                            var stockValue:Double = Double(currentPrice!)! * Double(quantityTextField.text!)!
                            createItem(stock: symbol!, stockName: stockName!, price: currentPrice!, quantity: quantityTextField.text!, value: String(stockValue), avgPrice: currentPrice!)
                            
                            var spentAmount: Double? = quantityToBuy*Double(currentPrice!)!
                            balanceDouble = balanceDouble! - spentAmount!
                            var newBalance:String? = String(format: "%f", balanceDouble!)
                            let defaults = UserDefaults.standard
                            defaults.set(newBalance, forKey: "balanceAmount")
                            showToastMessage2(message: "You have successfully purchased " + quantityTextField.text! + " shares!")
                            
                        }
                    }
                    
                    
                    
                }
                
                
            }else if tradeButtonText == "Sell" {
                if isPortfolio == true {
                    let quantityToSell: Double = Double(quantityTextField.text!)!
                    let currentQuantity: Double = Double((balancePortfolioTrade?.quantity)!)!
                    
                    if quantityToSell >= currentQuantity {
                        
                        
                        
                        //addAmount = total value gained from selling stock
                        var addAmount: Double? = currentQuantity*Double(currentPrice!)!
                        var avgPriceDoub = Double((balancePortfolioTrade?.avgPrice)!)
                        var ifSoldAtAvg = avgPriceDoub! * currentQuantity
                        
                        var gainsLosses = addAmount! - ifSoldAtAvg
                        
                        //get index of stock from stockrecords database if it exists
                        if let stockRecordsIndex = stockRecordsSymbols.index(of: symbol!) {
                           var oldTotalProfits = stockRecordsModels[stockRecordsIndex].totalProfits
                            var newTotalProfits = oldTotalProfits + gainsLosses
                        
                            updateStockRecordsTotalProfits(item: stockRecordsModels[stockRecordsIndex], newTotalProfit: newTotalProfits)
                            
                        }else { //otherwise we create an entry for this stock in the stockrecords database
                            createStockRecordsItem(stockSymbol: symbol!, totalProfit: gainsLosses)
                        }
                        
                        balanceDouble = balanceDouble! + addAmount!
                        var newBalance:String? = String(format: "%f", balanceDouble!)
                        let defaults = UserDefaults.standard
                        defaults.set(newBalance, forKey: "balanceAmount")
                        deleteItem(item: balancePortfolioTrade!)
                        showToastMessage2(message: "You have successfully sold all your shares of " + symbol!)
                        
                    }else {
                        let newQuantity:Double = currentQuantity-quantityToSell
                        let newValue = newQuantity*Double(currentPrice!)!
                        updateQuantity(item: balancePortfolioTrade!, newQuantity: String(newQuantity))
                        updateValue(item: balancePortfolioTrade!, newValue: String(newValue))
                        updatePrice(item: balancePortfolioTrade!, newPrice: String(currentPrice!))
                        var addAmount: Double? = quantityToSell*Double(currentPrice!)!
                        var avgPriceDoub = Double((balancePortfolioTrade?.avgPrice)!)
                        var ifSoldAtAvg = avgPriceDoub! * quantityToSell
                        
                        var gainsLosses = addAmount! - ifSoldAtAvg
               
                        
                        //get index of stock from stockrecords database if it exists
                        if let stockRecordsIndex = stockRecordsSymbols.index(of: symbol!) {
                           var oldTotalProfits = stockRecordsModels[stockRecordsIndex].totalProfits
                            var newTotalProfits = oldTotalProfits + gainsLosses
                        
                            updateStockRecordsTotalProfits(item: stockRecordsModels[stockRecordsIndex], newTotalProfit: newTotalProfits)
                            
                        }else { //otherwise we create an entry for this stock in the stockrecords database
                            createStockRecordsItem(stockSymbol: symbol!, totalProfit: gainsLosses)
                        }
                        
                        
                        
                        balanceDouble = balanceDouble! + addAmount!
                        var newBalance:String? = String(format: "%f", balanceDouble!)
                        let defaults = UserDefaults.standard
                        defaults.set(newBalance, forKey: "balanceAmount")
                        showToastMessage(message: "You have successfully sold " + quantityTextField.text! + " shares!")
                    }
                    
                    
                }else {
                    if let index = portfolioSymbols.index(of: symbol!) {
                        
                        let quantityToSell: Double = Double(quantityTextField.text!)!
                        let currentQuantity: Double = Double((models[index].quantity)!)!
                        
                        if quantityToSell >= currentQuantity {
                            
                            var addAmount: Double? = currentQuantity*Double(currentPrice!)!
                            var avgPriceDoub = Double(models[index].avgPrice!)
                            var ifSoldAtAvg = avgPriceDoub! * currentQuantity
                            
                            var gainsLosses = addAmount! - ifSoldAtAvg
                   
                            //get index of stock from stockrecords database if it exists
                            if let stockRecordsIndex = stockRecordsSymbols.index(of: symbol!) {
                               var oldTotalProfits = stockRecordsModels[stockRecordsIndex].totalProfits
                                var newTotalProfits = oldTotalProfits + gainsLosses
                            
                                updateStockRecordsTotalProfits(item: stockRecordsModels[stockRecordsIndex], newTotalProfit: newTotalProfits)
                                
                            }else { //otherwise we create an entry for this stock in the stockrecords database
                                createStockRecordsItem(stockSymbol: symbol!, totalProfit: gainsLosses)
                            }
                            
                            balanceDouble = balanceDouble! + addAmount!
                            var newBalance:String? = String(format: "%f", balanceDouble!)
                            let defaults = UserDefaults.standard
                            defaults.set(newBalance, forKey: "balanceAmount")
                            deleteItem(item: models[index])
                            showToastMessage2(message: "You have successfully sold all your shares of " + symbol!)
                        }else {
                            let newQuantity:Double = currentQuantity-quantityToSell
                            let newValue = newQuantity*Double(currentPrice!)!
                            updateQuantity(item: models[index], newQuantity: String(newQuantity))
                            updateValue(item: models[index], newValue: String(newValue))
                            updatePrice(item: models[index], newPrice: String(currentPrice!))
                            var addAmount: Double? = quantityToSell*Double(currentPrice!)!
                            var avgPriceDoub = Double((models[index].avgPrice)!)
                            var ifSoldAtAvg = avgPriceDoub! * quantityToSell
                            
                            var gainsLosses = addAmount! - ifSoldAtAvg
                   
                            //get index of stock from stockrecords database if it exists
                            if let stockRecordsIndex = stockRecordsSymbols.index(of: symbol!) {
                               var oldTotalProfits = stockRecordsModels[stockRecordsIndex].totalProfits
                                var newTotalProfits = oldTotalProfits + gainsLosses
                            
                                updateStockRecordsTotalProfits(item: stockRecordsModels[stockRecordsIndex], newTotalProfit: newTotalProfits)
                                
                            }else { //otherwise we create an entry for this stock in the stockrecords database
                                createStockRecordsItem(stockSymbol: symbol!, totalProfit: gainsLosses)
                            }
                            
                            balanceDouble = balanceDouble! + addAmount!
                            var newBalance:String? = String(format: "%f", balanceDouble!)
                            let defaults = UserDefaults.standard
                            defaults.set(newBalance, forKey: "balanceAmount")
                            showToastMessage(message: "You have successfully sold " + quantityTextField.text! + " shares!")
                        }
                        
                        
                    }else {
                        showToastMessage(message: "You cannot sell a stock you do not own!")
                       
                    }
                }
                
            }
            //deleteItem(item: balancePortfolioTrade!)
            dismiss(animated: true, completion: nil)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newDataNotif"), object: nil)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newSummaryDataNotif"), object: nil)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "changeBalanceDataNotif"), object: nil)

            
        }
        

        

    }
    
    
    
    
    //MARK: - Text Field Delegates
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let allowedChars = "1234567890"
        let allowedCharSet = CharacterSet(charactersIn: allowedChars)
        let typedCharSet = CharacterSet(charactersIn: string)
        
        return allowedCharSet.isSuperset(of: typedCharSet)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    // MARK: Core Data

    func getAllPortfolioItems() {
        do {
            models = try context.fetch(Balance.fetchRequest())
            for (index, stock) in models.enumerated(){
                self.portfolioSymbols.append(self.models[index].stock!)
            }
            
            
            DispatchQueue.main.async {
                
                
                
            }
        }catch {
            // error
        }
        
    }
    func getAllStockRecordsItems() {
        do {
            stockRecordsModels = try context.fetch(StockRecords.fetchRequest())
            for (index, stockSymbol) in stockRecordsModels.enumerated(){
                self.stockRecordsSymbols.append(self.stockRecordsModels[index].stockSymbol!)
            }
            
            
            DispatchQueue.main.async {
                
                
                
            }
        }catch {
            // error
        }
        
    }
    
    func createItem(stock: String, stockName: String, price: String, quantity: String, value: String, avgPrice:String) {
        let newItem = Balance(context: context)
        newItem.stock = stock
        newItem.stockName = stockName
        
   
        newItem.price = price
  
        newItem.quantity = quantity
        newItem.value = value
        newItem.avgPrice = avgPrice
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
    func updateAvgPrice(item: Balance, newAvgprice: String) {
        item.avgPrice = newAvgprice
        do {
            try context.save()
        }catch {
            
        }
    }
    
    func updatePrice(item: Balance, newPrice: String) {
        item.price = newPrice
        do {
            try context.save()
        }catch {
            
        }
    }
    
    func createStockRecordsItem(stockSymbol: String, totalProfit: Double) {
        let newItem = StockRecords(context: context)
        newItem.stockSymbol = stockSymbol
        newItem.totalProfits = totalProfit
        
        do {
            try context.save()
            
        }catch {
            
        }
    }
    
    func updateStockRecordsTotalProfits(item: StockRecords, newTotalProfit: Double) {
        item.totalProfits = newTotalProfit
        do {
            try context.save()
        }catch {
            
        }
    }

}


extension TradeViewController: UIGestureRecognizerDelegate {
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
    return (touch.view === self.view)
  }
}

extension UIViewController {
    func showToastMessage(message: String) {
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        let toastLabel = UILabel()
        toastLabel.text = message
        toastLabel.textAlignment = .center
        toastLabel.font = UIFont.systemFont(ofSize: 18)
        toastLabel.textColor = UIColor.white
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.numberOfLines = 0
        
        let textSize = toastLabel.intrinsicContentSize
        let labelHeight = (textSize.width / window.frame.width) * 30
        let adjustedHeight = max(labelHeight, textSize.height + 20)
        
        toastLabel.frame = CGRect(x: 20, y: 100, width: window.frame.width, height: adjustedHeight)
        toastLabel.center.x = window.center.x
        toastLabel.layer.cornerRadius = 10
        toastLabel.layer.masksToBounds = true
        window.addSubview(toastLabel)
        
        UIView.animate(withDuration: 3.0, animations: {toastLabel.alpha = 0}) {
            (_) in
            toastLabel.removeFromSuperview()
        }
    }
}
