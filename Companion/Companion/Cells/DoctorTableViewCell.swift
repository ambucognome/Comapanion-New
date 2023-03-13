//
//  DoctorTableViewCell.swift
//  Companion
//
//  Created by Santosh Naidu on 13/03/23.
//

import UIKit

class DoctorTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var specialityLabel: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var patientsLabel: UILabel!
    @IBOutlet weak var expLabel: UILabel!
    
    @IBOutlet weak var shadowView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        //Added shadow
        self.reloadLayers()
    }

    private func reloadLayers() {
        self.layer.cornerRadius = 4
        self.shadowView.dropShadoww()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
