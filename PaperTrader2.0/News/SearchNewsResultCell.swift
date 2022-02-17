//
//  SearchNewsResultCell.swift
//  PaperTrader2.0
//
//  Created by Jimmy  on 11/25/21.
//

import UIKit

class SearchNewsResultCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var newsTextLabel: UILabel!
    @IBOutlet var sourceLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var stockSymbolLabel: UILabel!
    
    
    @IBOutlet var newsImageView: UIImageView!
    
    var downloadTask: URLSessionDownloadTask?

    override func awakeFromNib() {
      super.awakeFromNib()
      let selectedView = UIView(frame: CGRect.zero)
      selectedView.backgroundColor = UIColor(named: "SearchBar")?.withAlphaComponent(0.5)
      selectedBackgroundView = selectedView
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        downloadTask?.cancel()
        downloadTask = nil
      }
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    // MARK: - Helper Methods
    func configure(for result: SearchNewsResult) {
        newsTextLabel.sizeToFit()
        newsTextLabel.numberOfLines = 0
        titleLabel.text = result.titleText
        newsTextLabel.text = result.newsBodyText
        sourceLabel.text = result.sourceText
        dateLabel.text = result.dateText
        stockSymbolLabel.text = result.symbol
       
        //sentimentLabel.text = result.sentimentText

        
        newsImageView.image = UIImage(systemName: "square")
        if let imageURL = URL(string: result.imageSmall) {
          downloadTask = newsImageView.loadImage(url: imageURL)
        }
        
    
      
     
    }
}
