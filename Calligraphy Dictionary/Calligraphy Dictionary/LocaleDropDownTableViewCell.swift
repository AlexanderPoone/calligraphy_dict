//
//  LocaleDropDownTableViewCell.swift
//  Tempus E Spatium
//
//  Created by Victor Poon on 18/10/2019.
//  Copyright © 2019 SoftFeta. All rights reserved.
//

import UIKit
import DropDown

class LocaleDropDownTableViewCell: DropDownCell {

    @IBOutlet weak var mFlag: UIImageView!
    @IBOutlet weak var mSubtitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
