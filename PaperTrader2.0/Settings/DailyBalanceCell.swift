//
//  DailyBalanceCell.swift
//  PaperTrader2.0
//
//  Created by Jimmy  on 1/23/22.
//

import UIKit

class DailyBalanceCell: UITableViewCell {
    @IBOutlet var balanceAmountLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var availableLabel: UILabel!
    @IBOutlet var totalStockValueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }
    
}


