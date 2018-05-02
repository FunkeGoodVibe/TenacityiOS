//
//  WeekTableViewCell.swift
//  FirebaseApp
//
//  Created by Funke Sowole on 17/02/2018.
//  Copyright © 2018 Funke Sowole. All rights reserved.
//

import UIKit

class WeekTableViewCell: UITableViewCell {

    @IBOutlet weak var weekLabel: UILabel!
    @IBOutlet weak var handoutsLabel: UILabel!
    @IBOutlet weak var exerciseLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
