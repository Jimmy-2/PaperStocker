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
        totalProfitsLabel.text = String(stockRecords.totalProfits)
    }

    
}
