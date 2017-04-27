//
//  NavigationTableViewCell.swift
//  Lucas Robert
//
//  Created by Connor Meehan on 1/13/17.
//  Copyright © 2017 CBM Web Development. All rights reserved.
//

import UIKit

class NavigationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var navigationItemLabel: UILabel!
    @IBOutlet weak var navigationIconImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

