//
//  GuestCell.swift
//  Companion
//
//  Created by Ambu Sangoli on 19/05/23.
//

import UIKit

class GuestCell: UITableViewCell {
    
    @IBOutlet weak var guestNameLabel: UILabel!
    @IBOutlet weak var guestEmailLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
