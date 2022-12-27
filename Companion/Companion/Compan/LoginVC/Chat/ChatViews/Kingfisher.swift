//
//  Kingfisher.swift
//  iOS Example
//
//  Created by Ambu Sangoli on 6/13/18.
//

import Kingfisher

extension UIImageView {

    func setImage(with resource: URL?, placeholder: UIImage? = nil) {
        let optionInfo: KingfisherOptionsInfo = [
            .transition(.fade(0.25)),
            .cacheOriginalImage
        ]

        kf.setImage(with: resource, placeholder: placeholder, options: optionInfo)
    }
}


