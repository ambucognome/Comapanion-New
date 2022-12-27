//
//  SelectionStyleCell.swift
//  iOS Example
//
//  Created by Ambu Sangoli on 6/13/18.
//

import UIKit

class SelectionStyleCell: UITableViewCell {

    var chatBarStyleTitle: UILabel!
    var useImagePickerDefaultSwitch: UISwitch!
    var showConversationButton: UIButton!
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
        contentView.backgroundColor = .white
    }
}
