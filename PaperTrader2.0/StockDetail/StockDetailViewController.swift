//
//  StockDetailViewController.swift
//  PaperTrader2.0
//
//  Created by Jimmy  on 11/21/21.
//

import UIKit

class StockDetailViewController: UITableViewController {

    @IBOutlet var symbolLabel: UILabel!
    @IBOutlet var stockNameLabel: UILabel!
    
    @IBOutlet var currentPriceLabel: UILabel!
    @IBOutlet var changeLabel: UILabel!
    @IBOutlet var changePercentLabel: UILabel!
    @IBOutlet var volumeLabel: UILabel!
    
    @IBOutlet var openLabel: UILabel!
    @IBOutlet var previousCloseLabel: UILabel!
    @IBOutlet var highLabel: UILabel!
    @IBOutlet var lowLabel: UILabel!
    
  
    @IBOutlet var buyButton: UIButton!
    @IBOutlet var sellButton: UIButton!
    
    let refreshControll = UIRefreshControl()
    
   

    
    var searchResult: SearchResult!
    var balancePortfolio: Balance?
    
    var dataTask: URLSessionDataTask?
    var isLoading = false
    
    var open: String? = "loading"
    var high: String? = "loading"
    var low: String? = "loading"
    var close: String? = "loading"
    var volume: String?  = "loading"
    var previous_close: String?  = "loading"
    var change: String?  = "loading"
    var percent_change: String?  = "loading"
    
    var trade: String?
    
    var stockSymbol: String!
    var stockName: String!
    
    var isPortfolio: Bool!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(isPortfolio)
        if let balance = balancePortfolio {
            stockNameLabel.text = balance.stockName
            symbolLabel.text = balance.stock
            stockName = balance.stockName
            stockSymbol = balance.stock
        }else {
            stockNameLabel.text = searchResult.name
            symbolLabel.text = searchResult.symbol
            stockName = searchResult.name
            stockSymbol = searchResult.symbol
            
        }
        getStockData()
        
    
        refreshControll.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControll.addTarget(self, action: #selector(didPullToRefresh(sender:)), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControll)
        
    }
    
    
    
    
   
    
    // MARK: - Action Methods
    @IBAction func buyStock() {
        trade = "Buy"
        let balance: Balance
        performSegue(withIdentifier: "ShowTrade", sender: nil)
        
        
    }
    
    @IBAction func sellStock() {
        trade = "Sell"
        performSegue(withIdentifier: "ShowTrade", sender: nil)
        
    }
    

    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowTrade" {
            let tradeViewController = segue.destination as! TradeViewController
            tradeViewController.symbol = stockSymbol
            tradeViewController.stockName = stockName
            tradeViewController.currentPrice = close
            tradeViewController.tradeButtonText = trade
            tradeViewController.balancePortfolioTrade = balancePortfolio
            tradeViewController.isPortfolio = isPortfolio
            
        }
    }
    
    // MARK: - Helper Methods
    
    //refresh stock data
    @objc func didPullToRefresh(sender: AnyObject) {
        DispatchQueue.main.async {
            self.getStockData()
            self.refreshControll.endRefreshing()
        }
    }
    
    func getStockData() {
        if searchResult != nil || balancePortfolio != nil{
            dataTask?.cancel()
            isLoading = true
   
            
            self.updateUI()
            let apiURL = stocksURL()
            let session = URLSession.shared
            dataTask = session.dataTask(with: apiURL) {data, response, error in
          
                if let error = error as NSError?, error.code == -999 {
                    return
                } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    if let data = data {
                        self.parse(data: data)
              
                        DispatchQueue.main.async {
                            self.isLoading = false
                            self.updateUI()
                            if(self.open != nil) {
                             
                                self.buyButton.isHidden = false
                                self.sellButton.isHidden = false
                            }else {
                                self.showToastMessage2(message: "The API has exceeded the amount. Please try again in 1 minute")
                                self.buyButton.isHidden = true
                                self.sellButton.isHidden = true
                            }
                            
                        
                        }
                        return
                    }
                } else {
                    print("Failure!")
                    
                }
                DispatchQueue.main.async {
                
                    self.isLoading = false
                   
                    self.showNetworkError()
                }
            }
            dataTask?.resume()
            
         
            
            
            
        }
    }
    
    
    
    
    func stocksURL() -> URL {
        let urlString = String(format: "https://api.twelvedata.com/quote?symbol=%@"+"&interval=1day&apikey=313fd5808dc2469abf9380853265bca3", stockSymbol!)
        let url = URL(string: urlString)
        return url!
    }
    
 
    func parse(data: Data) {
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(StockDetail.self, from: data)
            var symbol: String?  = result.symbol
            var name: String?  = result.name
            
            
            open = result.open
            high = result.high
            low = result.low
            close = result.close
            volume = result.volume
            previous_close = result.previous_close
            change = result.change
            percent_change = result.percent_change
            
            print(result.open)
            
            
            
            
        } catch {
            print("JSON Error: \(error)")
            //tell user to wait go back and wait a bit before continuing
            
        }
    }
    
    func showNetworkError() {
      let alert = UIAlertController(title: "Whoops...", message: "There was an error accessing the stock details results. Please try again.", preferredStyle: .alert)

      let action = UIAlertAction(title: "OK", style: .default, handler: nil)
      alert.addAction(action)
      present(alert, animated: true, completion: nil)
    }
    
    func updateUI() {
        
        
        currentPriceLabel.text = close
        changeLabel.text = change
        changePercentLabel.text = percent_change
        volumeLabel.text = volume
        openLabel.text = open
        previousCloseLabel.text = previous_close
        highLabel.text = high
        lowLabel.text = low
      
      

    }
    

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UIViewController {
    func showToastMessage2(message: String) {
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        let toastLabel = UILabel()
        toastLabel.text = message
        toastLabel.textAlignment = .center
        toastLabel.numberOfLines = 0
        toastLabel.lineBreakMode = .byWordWrapping
        toastLabel.sizeToFit()
        toastLabel.adjustsFontSizeToFitWidth = true
        toastLabel.minimumScaleFactor = 0.5
        toastLabel.font = UIFont.systemFont(ofSize: 18)
        toastLabel.textColor = UIColor.white
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
    
        
        
        toastLabel.frame = CGRect(x: 20, y: 100, width: window.frame.width, height: 75 )
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
