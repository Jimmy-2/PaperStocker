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
    
    @IBOutlet var balanceLabel: UILabel!
    
    private let isPortfolio = true
    
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
        
        
        let defaults = UserDefaults.standard
        balanceLabel.text = defaults.string(forKey: "balanceAmount")
        print(defaults.string(forKey: "balanceAmount"))
        let fetchRequest = NSFetchRequest<Balance>()
        
        let entity = Balance.entity()
          fetchRequest.entity = entity
          
          let sortDescriptor = NSSortDescriptor(
            key: "stock",
            ascending: true)
          fetchRequest.sortDescriptors = [sortDescriptor]
          do {
            balances = try context.fetch(fetchRequest)
            
          } catch {
            fatalCoreDataError(error)
          }
        
        refreshControll.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControll.addTarget(self, action: #selector(didPullToRefresh(sender:)), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControll)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refresh), name: NSNotification.Name(rawValue: "newDataNotif"), object: nil)

        print("HELLLLLLO")
        print(balances.count)
        for index in 0...balances.count-1 {
            print(balances[index].price)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if userDefaults.defaults.isNew() {
            let view = storyboard?.instantiateViewController(identifier: "firstTime") as! FirstTimeViewController
            view.modalPresentationStyle = .fullScreen
            present(view, animated: true)
        }
    }
    
    
    @objc func didPullToRefresh(sender: AnyObject) {
        DispatchQueue.main.async {
            let defaults = UserDefaults.standard
            self.balanceLabel.text = defaults.string(forKey: "balanceAmount")
            
            self.refresh()
            self.refreshControll.endRefreshing()
        }
    }
    
    @objc func refresh() {
        DispatchQueue.main.async {
            let defaults = UserDefaults.standard
            self.balanceLabel.text = defaults.string(forKey: "balanceAmount")
            
            let fetchRequest = NSFetchRequest<Balance>()
            
            let entity = Balance.entity()
              fetchRequest.entity = entity
              let sortDescriptor = NSSortDescriptor(
                key: "stock",
                ascending: true)
              fetchRequest.sortDescriptors = [sortDescriptor]
              do {
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
            for index in 0...balances.count-1 {
                print(balances[index])
            }
            controller.balancePortfolio = balance
            controller.isPortfolio = isPortfolio
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

