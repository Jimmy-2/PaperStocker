//
//  StockRecordsCell.swift
//  PaperTrader2.0
//
//  Created by Jimmy  on 2/11/22.
//

import UIKit

class StockRecordsCell: UITableViewCell {
    @IBOutlet var stockSymbolLabel: UILabel!
    @IBOutlet var totalProfitsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }
    
    // MARK: - Helper Method
    func configure(for stockRecords: StockRecords) {
        stockSymbolLabel.text = stockRecords.stockSymbol
        totalProfitsLabel.text = String(format: "%.2f",stockRecords.totalProfits)
        if (stockRecords.totalProfits < 0) {
            self.totalProfitsLabel.textColor = UIColor(red: 255/255, green: 20/255, blue: 25/255, alpha: 1.0)
        }else if (stockRecords.totalProfits > 0) {
            self.totalProfitsLabel.textColor = UIColor(red: 35/255, green: 200/255, blue: 35/255, alpha: 1.0)
            
        }
    }

    
}
