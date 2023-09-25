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
    
    var data : DDCFormModell?
    var indexPath : IndexPath?
    var entity : Entity?
    var entityGroupId: String = ""
    var parentEntityGroupId = ""
    var groupOrder = 0
    var ddcModel: DDCFormModell?

    
    
    func setUpTextFieldCell(data: DDCFormModell,entity: Entity, indexPath: IndexPath) {
        self.isUserInteractionEnabled = true
        if isReadOnly {
            self.isUserInteractionEnabled = false
        }
        self.entity = entity
        self.textField.delegate = self
        self.data = data
        self.indexPath = indexPath
        self.textField.text = ""
        
        if let instrumentsData = instruments?.entities {
            for instrument in instrumentsData {
                if instrument.entityTemplateID == entity.id  ?? "" {
                    if let value = instrument.value {
                        self.textField.text! = value
                    }
                }
            }
        }

//        self.textField.text = dataa?.value?.value as? String ?? ""
//        self.resetBtn.isHidden = true
//        if isResetAvailable {
//            self.resetBtn.isHidden = false
//        }
        self.errorLabel.isHidden = true
        self.errorLabelHeight.constant = 0
        if ComponentUtils.showErrorMessage(entity: entity) {
            self.errorLabel.text = entity.errorMessage
            self.errorLabel.isHidden = false
            self.errorLabelHeight.constant = 12
        }
    }
    
    @IBAction func resetBtn(_ sender: Any) {
//        RequestHelper.shared.createRequestForEntity(entity: self.entity!, newValue: "", entityGroupId: entityGroupId,parentEntityGroupId: parentEntityGroupId,groupOrder: groupOrder,dataModel: self.ddcModel)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //TODO: Update
        print(textField.text!)
        NewRequestHelper.shared.updateEntityValue(entity: self.entity!,value: textField.text!)
    }
    
    

    
}

