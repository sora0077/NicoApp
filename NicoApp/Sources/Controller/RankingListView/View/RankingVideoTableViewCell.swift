//
//  RankingVideoTableViewCell.swift
//  NicoApp
//
//  Created by 林達也 on 2016/03/27.
//  Copyright © 2016年 jp.sora0077. All rights reserved.
//

import UIKit

class RankingVideoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var thumbnailImageView: UIImageView! {
        didSet {
            thumbnailImageView.backgroundColor = UIColor(red:0.14, green:0.14, blue:0.14, alpha:1.00)
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension RankingVideoTableViewCell: RankingVideoRowRenderer {
    
}
