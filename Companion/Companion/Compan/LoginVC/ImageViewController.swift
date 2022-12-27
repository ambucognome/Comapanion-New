//
//  ImageViewController.swift
//  Compan
//
//  Created by Ambu Sangoli on 16/12/22.
//

import UIKit
import Kingfisher

class ImageViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var imageURL = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: imageURL)
        imageView.contentMode = .scaleAspectFit
        imageView.kf.setImage(with: url)
    }

}
