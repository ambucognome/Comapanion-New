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
    
    var ddcModel: DDCFormModel?

    
    var data : DDCFormModel?
    var indexPath : IndexPath?
    var entity : Entity?
    var entityGroupId: String = ""
    var parentEntityGroupId = ""
    var groupOrder = 0

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupSliderCell(data: DDCFormModel,entity: Entity, indexPath: IndexPath ,entityGroupId: String,parentEntityGroupId:String = "99",groupOrder: Int = 0) {
        self.isUserInteractionEnabled = true
        if isReadOnly {
            self.isUserInteractionEnabled = false
        }
        self.entityGroupId = entityGroupId
        self.entity = entity
        self.data = data
        self.indexPath = indexPath
        self.parentEntityGroupId = parentEntityGroupId
        self.groupOrder = groupOrder

        let dataa : Entity? = entity
        if let entity = dataa {
            let valueString = entity.value?.value as? Bool
            if valueString == false || valueString == nil {
                self.toggleSwitch.isOn = false
            } else {
                self.toggleSwitch.isOn = true
            }
        }
        self.resetBtn.isHidden = true
        if isResetAvailable {
            self.resetBtn.isHidden = false
    }
        self.errorLabel.isHidden = true
        self.errorLabelHeight.constant = 0
        if ComponentUtils.showErrorMessage(entity: entity) {
            self.errorLabel.text = entity.errorMessage
            self.errorLabel.isHidden = false
            self.errorLabelHeight.constant = 12
        }
    }
    
    @IBAction func switched(_ sender: UISwitch) {
        RequestHelper.shared.createRequestForEntity(entity: self.entity!, newValue: sender.isOn, entityGroupId: entityGroupId,parentEntityGroupId: parentEntityGroupId,groupOrder: groupOrder,dataModel: self.ddcModel)
    }
 
    
    
    @IBAction func resetBtn(_ sender: Any) {
        RequestHelper.shared.createRequestForEntity(entity: self.entity!, newValue: "", entityGroupId: entityGroupId,parentEntityGroupId: parentEntityGroupId,groupOrder: groupOrder, dataModel: self.ddcModel)
    }
    
}
