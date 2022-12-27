//
//  TextfieldComponent.swift.swift
//  Cognome
//
//  Created by ambu sangoli.
//

import UIKit

protocol TextfieldComponentDelegate {

}

class TextfieldComponent: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var uriLbl: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var floatingTextField: FloatingLabelTextField!
    @IBOutlet weak var resetBtn: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var errorLabelHeight: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    var data : DDCFormModel?
    var indexPath : IndexPath?
    var entity : Entity?
    var entityGroupId: String = ""
    var parentEntityGroupId = ""
    var groupOrder = 0

    
    func setUpTextFieldCell(data: DDCFormModel,entity: Entity, indexPath: IndexPath,entityGroupId: String,parentEntityGroupId:String = "99",groupOrder: Int = 0) {
        self.isUserInteractionEnabled = true
        if isReadOnly {
            self.isUserInteractionEnabled = false
        }
        self.entityGroupId = entityGroupId
        self.entity = entity
        self.textField.delegate = self
        self.data = data
        self.indexPath = indexPath
        let dataa : Entity? = entity
        self.parentEntityGroupId = parentEntityGroupId

        self.textField.text = dataa?.value?.value as? String ?? ""
        self.groupOrder = groupOrder
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
    
    @IBAction func resetBtn(_ sender: Any) {
        RequestHelper.shared.createRequestForEntity(entity: self.entity!, newValue: "", entityGroupId: entityGroupId,parentEntityGroupId: parentEntityGroupId,groupOrder: groupOrder)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
//        print(RequestHelper.shared.createRequestForEntity(data: self.data!, index: self.indexPath!, newValue: textField.text!))
        RequestHelper.shared.createRequestForEntity(entity: self.entity!, newValue: textField.text!, entityGroupId: entityGroupId,parentEntityGroupId: parentEntityGroupId,groupOrder: groupOrder)
    }
    
    

    
}

