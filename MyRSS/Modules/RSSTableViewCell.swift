//
//  RSSTableViewCell.swift
//  MyRSS
//
//  Created by 서재훈 on 2020/03/19.
//  Copyright © 2020 서재훈. All rights reserved.
//

import UIKit

class RSSTableViewCell: UITableViewCell {
    
    @IBOutlet weak var rssTitleLabel: UILabel!
    @IBOutlet weak var rssDescriptionLabel: UILabel!
    @IBOutlet weak var rssImageView: UIImageView!
    @IBOutlet weak var keywordLabel1: UILabel!
    @IBOutlet weak var keywordLabel2: UILabel!
    @IBOutlet weak var keywordLabel3: UILabel!
    
    var link: URL?
    var rssImage: UIImage? {
        didSet {
            rssImageView.image = self.rssImage
        }
    }

    var keywords: [String]? {
        didSet {
            let keywordLabels = [keywordLabel1, keywordLabel2, keywordLabel3]
            if let keywords = self.keywords {
                for i in 0 ..< keywords.count {
                    keywordLabels[i]?.text = " " + keywords[i] + " "
                    keywordLabels[i]?.layer.borderWidth = 1
                    keywordLabels[i]?.layer.cornerRadius = 5
                }
            }
        }
    }
    
    
    override func prepareForReuse() {
        rssTitleLabel.text = "Title"
        rssDescriptionLabel.text = "Description"
        rssImageView.image = UIImage(named: "placeholder_img")
        link = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
