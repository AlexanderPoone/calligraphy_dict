//
//  BlockListTableViewCell.swift
//  Calligraphy Dictionary
//
//  Created by Victor Poon on 5/11/2019.
//  Copyright © 2019 SoftFeta. All rights reserved.
//

import UIKit
import SwiftIcons

class BlockListTableViewCell: UITableViewCell {

    @IBOutlet weak var mImg: UIImageView!
    @IBOutlet weak var mCaption: UILabel!
    @IBOutlet weak var mDelete: UIButton!
    @IBOutlet weak var mShare: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        mDelete.setIcon(icon: .fontAwesomeSolid(.broom), iconSize: nil, color: .white, backgroundColor: UIColor(named: "danger")!, forState: .normal)
        mShare.setIcon(icon: .fontAwesomeSolid(.share), iconSize: nil, color: .white, backgroundColor: UIColor(named: "info")!, forState: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
