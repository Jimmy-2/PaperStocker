//
//  StockDetailViewController.swift
//  PaperTrader2.0
//
//  Created by Jimmy  on 11/21/21.
//

import UIKit

class StockDetailViewController: UITableViewController {
    
    var delegate: stockDelegate?

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
    
    var stockDetail = [StockDetail]()
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
        refreshControll.tintColor = .white
        
    }
    
    
    
    
   
    
    // MARK: - Action Methods
    @IBAction func buyStock() {
        trade = "Buy"
        
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
                        
                        self.stockDetail = self.parse(data: data)
                        if(self.stockDetail.isEmpty) {
                            print("HELLLLLLLLLLO123123")
                            DispatchQueue.main.async {
                                self.isLoading = false
                                self.updateUI()
                                self.showToastMessage2(message: "The API has exceeded the daily usage. Please try again in 1 day.")
                                self.buyButton.isHidden = true
                                self.sellButton.isHidden = true
                               
                            }
                            
                        }else if (self.stockDetail[0].open == nil) {
                            DispatchQueue.main.async {
                                self.isLoading = false
                                self.updateUI()
                                self.showToastMessage2(message: "The API has exceeded the daily usage. Please try again in 1 day.")
                                self.buyButton.isHidden = true
                                self.sellButton.isHidden = true
                               
                            }
                        }else {
                            
                            self.open = String(self.stockDetail[0].open!)
                            self.close = String(self.stockDetail[0].price!)
                            self.change = String(self.stockDetail[0].change!)
                            self.percent_change = String(self.stockDetail[0].changesPercentage!)+"%"
                            self.low = String(self.stockDetail[0].dayLow!)
                            self.high = String(self.stockDetail[0].dayHigh!)
                            self.volume = String(self.stockDetail[0].volume!)
                            self.previous_close = String(self.stockDetail[0].previousClose!)
                            
                            
                            if (self.stockDetail[0].change! >= 0) {
                                self.changeLabel.textColor = UIColor(red: 35/255, green: 200/255, blue: 35/255, alpha: 1.0)
                                self.changePercentLabel.textColor = UIColor(red: 35/255, green: 200/255, blue: 35/255, alpha: 1.0)
                                self.currentPriceLabel.textColor = UIColor(red: 35/255, green: 200/255, blue: 35/255, alpha: 1.0)
                                self.openLabel.textColor = UIColor(red: 35/255, green: 200/255, blue: 35/255, alpha: 1.0)
                                self.previousCloseLabel.textColor = UIColor(red: 35/255, green: 200/255, blue: 35/255, alpha: 1.0)
                                self.volumeLabel.textColor = UIColor(red: 35/255, green: 200/255, blue: 35/255, alpha: 1.0)
                                self.highLabel.textColor = UIColor(red: 35/255, green: 200/255, blue: 35/255, alpha: 1.0)
                                self.lowLabel.textColor = UIColor(red: 35/255, green: 200/255, blue: 35/255, alpha: 1.0)
                                
                            }else {
                                self.changeLabel.textColor = UIColor(red: 255/255, green: 20/255, blue: 25/255, alpha: 1.0)
                                self.changePercentLabel.textColor = UIColor(red: 255/255, green: 20/255, blue: 25/255, alpha: 1.0)
                                self.currentPriceLabel.textColor = UIColor(red: 255/255, green: 20/255, blue: 25/255, alpha: 1.0)
                                self.openLabel.textColor = UIColor(red: 255/255, green: 20/255, blue: 25/255, alpha: 1.0)
                                self.previousCloseLabel.textColor = UIColor(red: 255/255, green: 20/255, blue: 25/255, alpha: 1.0)
                                self.volumeLabel.textColor = UIColor(red: 255/255, green: 20/255, blue: 25/255, alpha: 1.0)
                                self.highLabel.textColor = UIColor(red: 255/255, green: 20/255, blue: 25/255, alpha: 1.0)
                                self.lowLabel.textColor = UIColor(red: 255/255, green: 20/255, blue: 25/255, alpha: 1.0)
                            }
                            DispatchQueue.main.async {
                                self.isLoading = false
                                self.updateUI()
                                
                                self.buyButton.isHidden = false
                                self.sellButton.isHidden = false
                               
                            }
                        }
                        
                        
                        
        
                        /*
                        
                        self.parse(data: data)
              
                        DispatchQueue.main.async {
                            self.isLoading = false
                            self.updateUI()
                            if(self.open != nil) {
                             
                                self.buyButton.isHidden = false
                                self.sellButton.isHidden = false
                            }else {
                                self.showToastMessage2(message: "The API has exceeded the daily usage. Please try again in 1 day.")
                                self.buyButton.isHidden = true
                                self.sellButton.isHidden = true
                            }
                            
                        
                        }
 
                        */
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
    
    
    /*
    
    func stocksURL() -> URL {
        let urlString = String(format: "https://api.twelvedata.com/quote?symbol=%@"+"&interval=1day&apikey=313fd5808dc2469abf9380853265bca3", stockSymbol!)
        let url = URL(string: urlString)
        return url!
        //"https://api.twelvedata.com/quote?symbol=%@"+"&interval=1day&apikey=313fd5808dc2469abf9380853265bca3"
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
 
    */
    
    func stocksURL() -> URL {
        let urlString = String(format: "https://financialmodelingprep.com/api/v3/quote/%@"+"?apikey=d1980c7326fed76a84ab12644fa786f9",stockSymbol!)
        let url = URL(string: urlString)
        return url!
        
        //let urlString = String(format: "https://financialmodelingprep.com/api/v3/quote/%@"+"?apikey=d1980c7326fed76a84ab12644fa786f9",stockSymbol!)
    }
    
    func parse(data: Data) -> [StockDetail] {
        do {
            print("HEYHEYHELLO")
            let decoder = JSONDecoder()
            let result = try decoder.decode([StockDetail].self, from: data)
            return result
        } catch {
            print("JSON Error: \(error)")
            return []
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
        
        
        UIView.animate(withDuration: 4.0, animations: {toastLabel.alpha = 0}) {
            (_) in
            toastLabel.removeFromSuperview()
        }
    }
}
