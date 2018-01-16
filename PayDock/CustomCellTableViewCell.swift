//
//  CustomCellTableViewCell.swift
//  PayDock
//
//  Created by Oleksandr Omelchenko on 12.11.17.
//  Copyright © 2017 PayDock. All rights reserved.
//

import UIKit

class CustomCellTableViewCell: UITableViewCell {

    @IBOutlet weak var primaryImg: UIImageView!
    
    @IBOutlet weak var typeImg: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var numberLabel: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
