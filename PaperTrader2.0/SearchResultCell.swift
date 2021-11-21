//
//  SearchResultCell.swift
//  PaperTrader2.0
//
//  Created by Jimmy  on 11/19/21.
//

import UIKit

class SearchResultCell: UITableViewCell {
  @IBOutlet var nameLabel: UILabel!
  @IBOutlet var stockNameLabel: UILabel!


  override func awakeFromNib() {
    super.awakeFromNib()
    let selectedView = UIView(frame: CGRect.zero)
    selectedView.backgroundColor = UIColor(named: "SearchBar")?.withAlphaComponent(0.5)
    selectedBackgroundView = selectedView
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    // Configure the view for the selected state
  }
}
