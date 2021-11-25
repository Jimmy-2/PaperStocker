//
//  TradeViewController.swift
//  PaperTrader2.0
//
//  Created by Jimmy  on 11/22/21.
//

import UIKit

class TradeViewController: UIViewController {
    
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
