//
//  DoctorProfileViewController.swift
//  Companion
//
//  Created by Ambu Sangoli on 13/03/23.
//

import UIKit

class DoctorProfileViewController: UIViewController {
    
    @IBOutlet weak var imgView : UIImageView!
    @IBOutlet weak var nameLabel : UILabel!
    @IBOutlet weak var specialityLabel : UILabel!
    @IBOutlet weak var patientsLabel : UILabel!
    @IBOutlet weak var experienceLabel : UILabel!
    @IBOutlet weak var reviewLabel : UILabel!
    @IBOutlet weak var bioTextView : UITextView!
    @IBOutlet weak var videoCallImage : UIImageView!


    
    var data : CareTeam?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let data = data {
            self.nameLabel.text = data.name
            self.specialityLabel.text = data.specality
            self.patientsLabel.text = data.patients
            self.experienceLabel.text = data.experience
            self.reviewLabel.text = data.review
            self.bioTextView.text = data.bio
            self.imgView.image = UIImage(named: data.image)
            self.videoCallImage.layer.borderColor = DARK_BLUE_COLOR.cgColor
            self.videoCallImage.layer.borderWidth = 2

        }
    }
    


}
