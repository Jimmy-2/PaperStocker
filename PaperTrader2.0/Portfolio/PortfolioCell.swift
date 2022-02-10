//
//  PortfolioCell.swift
//  PaperTrader2.0
//
//  Created by Jimmy  on 11/27/21.
//

import UIKit

class PortfolioCell: UITableViewCell {
    
    @IBOutlet var symbolLabel: UILabel!
    @IBOutlet var stockNameLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var quantityLabel: UILabel!
    @IBOutlet var valueLabel: UILabel!
    @IBOutlet var avgPriceLabel: UILabel!
    @IBOutlet var gainsLossLabel: UILabel!
    @IBOutlet var gainsLossPercentLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }
    
    
    // MARK: - Helper Method
    func configure(for balance: Balance) {
        symbolLabel.text = balance.stock

        stockNameLabel.sizeToFit()
        stockNameLabel.text = balance.stockName
    
        var priceDoub: Double = Double(balance.price!)!
        priceLabel.text = String(format: "%.2f", priceDoub)
    
        var quantityDoub: Double = Double(balance.quantity!)!
        quantityLabel.text = String(format: "%.0f", quantityDoub)
        
        var valueDoub: Double = Double(balance.value!)!
        valueLabel.text = String(format: "%.2f", valueDoub)
        
        avgPriceLabel.text = balance.avgPrice
        
        if (balance.gainsLosses != nil) {
            if(Double(balance.gainsLosses!)! > 0) {
                self.gainsLossLabel.textColor = UIColor(red: 35/255, green: 200/255, blue: 35/255, alpha: 1.0)
                self.gainsLossPercentLabel.textColor = UIColor(red: 35/255, green: 200/255, blue: 35/255, alpha: 1.0)
                self.avgPriceLabel.textColor = UIColor(red: 35/255, green: 200/255, blue: 35/255, alpha: 1.0)
            }else if ((Double(balance.gainsLosses!)! < 0)){ //if == 0, color will be white
                self.gainsLossLabel.textColor = UIColor(red: 255/255, green: 20/255, blue: 25/255, alpha: 1.0)
                self.gainsLossPercentLabel.textColor = UIColor(red: 255/255, green: 20/255, blue: 25/255, alpha: 1.0)
                self.avgPriceLabel.textColor = UIColor(red: 255/255, green: 20/255, blue: 25/255, alpha: 1.0)
        }
        
            
        }
        gainsLossLabel.text = balance.gainsLosses
        gainsLossPercentLabel.text = balance.gainsLossesPercent
        
    }

}
