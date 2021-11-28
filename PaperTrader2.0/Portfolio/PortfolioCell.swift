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

        stockNameLabel.text = balance.stockName
    
        priceLabel.text = balance.price
    
        quantityLabel.text = balance.quantity
        
        valueLabel.text = balance.value
    }

}
