//
//  AppCollectionViewCell.swift
//  Companion
//
//  Created by Ambu Sangoli on 22/12/22.
//

import UIKit

class AppCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel : UILabel!
    @IBOutlet weak var imgView : UIImageView!
    @IBOutlet weak var mainView : UIView!
    @IBOutlet weak var badgeLabel : UILabel!


    override func layoutSubviews() {
        super.layoutSubviews()
//        self.contentView.layer.cornerRadius = self.contentView.frame.size.height / 2
//        self.contentView.layer.masksToBounds = true
    }
    
}
