//
//  PersonTableViewCell.swift
//  Doorbell
//
//  Created by Giacobbi, Alexander T on 12/6/20.
//

import UIKit

class PersonTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func update(_ name: String, withStatus status: Bool, email: String) {
        nameLabel.text = name
        emailLabel.text = email
        if status {
            statusLabel.text = "Available"
        } else {
            statusLabel.text = "Busy"
        }
    }

}
