//
//  QuestionTableViewCell.swift
//  FirebaseApp
//
//  Created by Funke Sowole on 21/02/2018.
//  Copyright © 2018 Funke Sowole. All rights reserved.
//

import UIKit

class QuestionTableViewCell: UITableViewCell {

    @IBOutlet weak var questionLabel: UILabel!

    @IBOutlet weak var answerTextView: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.answerTextView.layer.borderColor = UIColor.black.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
