//
//  BackgroundTableViewCell.swift
//  Calligraphy Dictionary
//
//  Created by Victor Poon on 7/11/2019.
//  Copyright © 2019 SoftFeta. All rights reserved.
//

import UIKit
import DropDown

class BackgroundTableViewCell: DropDownCell {

    @IBOutlet weak var mBackgroundImg: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
