//
//  ButtonTableViewCell.swift
//  FirebaseApp
//
//  Created by Funke Sowole on 06/03/2018.
//  Copyright © 2018 Funke Sowole. All rights reserved.
//

import UIKit

class ButtonTableViewCell: UITableViewCell {
    
    var action: (()->()) = {}

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        self.action()
    }
}
