//
//  SettingTableViewCell.swift
//  SettingsScreen
//
//  Created by Ambu Sangoli on 31/01/23.
//

import UIKit

struct SettingsOption {
    let title : String
    let icon : UIImage?
    let iconBackgroundColor : UIColor
    let handler : (() -> Void)
    var disclosureRequired: Bool = true
}

class SettingTableViewCell: UITableViewCell {
    static let identifier = "SettingTableViewCell"
    
    private let iconContainer : UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        return view
    }()
    
    private let iconImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let label : UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(label)
        contentView.addSubview(iconContainer)
        iconContainer.addSubview(iconImageView)
        contentView.clipsToBounds = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let size : CGFloat = contentView.frame.size.height - 12
        iconContainer.frame = CGRect(x: 15, y: 6, width: size, height: size)
        
        let imageSize : CGFloat = size / 1.5
        iconImageView.frame = CGRect(x: (size - imageSize)/2, y: (size - imageSize)/2, width: imageSize, height: imageSize)
        
        label.frame = CGRect(x: 25 + iconContainer.frame.size.width,
                             y: 0,
                             width: contentView.frame.size.width - 20 - iconContainer.frame.size.width,
                             height: contentView.frame.size.height)
        if self.iconImageView.image == nil {
            self.iconContainer.frame.size.width = 0
            self.label.frame.origin.x = 25
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
        label.text = nil
        iconContainer.backgroundColor = nil
    }
    
    public func configure(with model : SettingsOption) {
        label.text = model.title
        iconImageView.image = model.icon
        iconContainer.backgroundColor = model.iconBackgroundColor
        if model.disclosureRequired {
            self.accessoryType = .disclosureIndicator
        }
    }

}
