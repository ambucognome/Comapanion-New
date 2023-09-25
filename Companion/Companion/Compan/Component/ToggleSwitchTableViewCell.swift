//
//  ToggleSwitchTableViewCell.swift
//  Compan
//
//  Created by Ambu Sangoli on 29/08/22.
//

import UIKit

class ToggleSwitchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var toggleSwitch: UISwitch!
    @IBOutlet weak var uriLbl: UILabel!
    @IBOutlet weak var resetBtn: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var errorLabelHeight: NSLayoutConstraint!
    
    var ddcModel: DDCFormModell?

    
    var data : DDCFormModell?
    var indexPath : IndexPath?
    var entity : Entity?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupSliderCell(data: DDCFormModell,entity: Entity, indexPath: IndexPath) {
        self.isUserInteractionEnabled = true
        if isReadOnly {
            self.isUserInteractionEnabled = false
        }
        self.entity = entity
        self.data = data
        self.indexPath = indexPath

        if let instrumentsData = instruments?.entities {
            for instrument in instrumentsData {
                if instrument.entityTemplateID == entity.id  ?? "" {
                    if let value = instrument.value {
                        self.toggleSwitch.isOn = value.boolValue
                    }
                }
            }
        }
        
//        self.resetBtn.isHidden = true
//        if isResetAvailable {
//            self.resetBtn.isHidden = false
//    }
        self.errorLabel.isHidden = true
        self.errorLabelHeight.constant = 0
        if ComponentUtils.showErrorMessage(entity: entity) {
            self.errorLabel.text = entity.errorMessage
            self.errorLabel.isHidden = false
            self.errorLabelHeight.constant = 12
        }
    }
    
    @IBAction func switched(_ sender: UISwitch) {
        NewRequestHelper.shared.updateEntityValue(entity: self.entity!, value: sender.isOn)
    }
 
    
    
    @IBAction func resetBtn(_ sender: Any) {
//        RequestHelper.shared.createRequestForEntity(entity: self.entity!, newValue: "", entityGroupId: entityGroupId,parentEntityGroupId: parentEntityGroupId,groupOrder: groupOrder, dataModel: self.ddcModel)
    }
    
}
