//
//  BuildingTableViewCell.swift
//  Idle Game Maker
//
//  Created by Albert Wu on 9/3/17.
//  Copyright © 2017 Old Friend. All rights reserved.
//

import UIKit

class BuildingTableViewCell: UITableViewCell{
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView?
    @IBOutlet weak var initialCostLabel: UILabel!
    @IBOutlet weak var cpsLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }
}
