//
//  StockDetailViewController.swift
//  PaperTrader2.0
//
//  Created by Jimmy  on 11/21/21.
//

import UIKit

class StockDetailViewController: UIViewController {

    @IBOutlet var symbolLabel: UILabel!
    @IBOutlet var stockNameLabel: UILabel!

    
    var searchResult: SearchResult!
    var dataTask: URLSessionDataTask?
    var isLoading = false
    
    var open = "loading"
    var high = "loading"
    var low = "loading"
    var close = "loading"
    var volume = "loading"
    var previous_close = "loading"
    var change = "loading"
    var percent_change = "loading"
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if searchResult != nil {
            dataTask?.cancel()
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
                        
                        }
                        return
                    }
                } else {
                    print("Failure! \(response!)")
                }
                DispatchQueue.main.async {
                
                    self.isLoading = false
                   
                    self.showNetworkError()
                }
            }
            dataTask?.resume()
            
         
            
            
            updateUI()
        }

        // Do any additional setup after loading the view.
    }
    // MARK: - Helper Methods
    func stocksURL() -> URL {
        let urlString = String(format: "https://api.twelvedata.com/quote?symbol=%@"+"&interval=1day&apikey=313fd5808dc2469abf9380853265bca3", searchResult.symbol!)
        let url = URL(string: urlString)
        return url!
    }
    
    func performStoreRequest(with url: URL) -> Data? {
        do {
            return try Data(contentsOf:url)
        } catch {
            print("Download Error: \(error.localizedDescription)")
            showNetworkError()
            return nil
        }
    }
    
    func parse(data: Data) {
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(StockDetail.self, from: data)
            let symbol = result.symbol
            let name = result.name
            open = result.open!
            high = result.high!
            low = result.low!
            close = result.close!
            volume = result.volume!
            previous_close = result.previous_close!
            change = result.change!
            percent_change = result.percent_change!
            
            print(percent_change)
            
        } catch {
            print("JSON Error: \(error)")
            
        }
    }
    
    func showNetworkError() {
      let alert = UIAlertController(title: "Whoops...", message: "There was an error accessing the search results. Please try again.", preferredStyle: .alert)

      let action = UIAlertAction(title: "OK", style: .default, handler: nil)
      alert.addAction(action)
      present(alert, animated: true, completion: nil)
    }
    
    func updateUI() {
        stockNameLabel.text = searchResult.name
      
      
        symbolLabel.text = searchResult.symbol
      
      

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
