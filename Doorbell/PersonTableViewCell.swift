//
//  PersonTableViewCell.swift
//  Doorbell
//  This program model the cell for displaying a users status to thier friends. The cell will show the name, email and status of the person
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
    
    /**
     Updates a cell with the provided information
     - Parameters:
        - name: name to be displayed in the cell
        - status: status of the user
        - email: user's email addrss
     */
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
