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
    
    var rssImage: UIImage? {
        didSet {
            rssImageView.image = self.rssImage
        }
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
