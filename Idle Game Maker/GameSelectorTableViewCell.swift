//
//  GameSelectorTableViewCell.swift
//  Idle Game Maker
//
//  Created by Albert Wu on 9/4/17.
//  Copyright © 2017 Old Friend. All rights reserved.
//

import UIKit

class GameSelectorTableViewCell: UITableViewCell {

    @IBOutlet weak var gameName: UILabel!
    @IBOutlet weak var gameImage: UIImageView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
