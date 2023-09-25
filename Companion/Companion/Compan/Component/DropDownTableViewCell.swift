//
//  DropDownTableViewCell.swift
//  Compan
//
//  Created by Ambu Sangoli on 13/05/22.
//

import UIKit
import SwiftyMenu

class DropDownTableViewCell: UITableViewCell {
    


    @IBOutlet private weak var dropDownMenu: SwiftyMenu!
    @IBOutlet weak var mainDropDown: DropDown!
    @IBOutlet weak var uriLbl: UILabel!
    @IBOutlet weak var resetBtn: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var errorLabelHeight: NSLayoutConstraint!
    
    var ddcModel: DDCFormModell?


    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    var data : DDCFormModell?
    var indexPath : IndexPath?
    var entity : Entity?
    var entityGroupId: String = ""
    var parentEntityGroupId = ""
    var groupOrder = 0

    
    func setUpDropDownCell(data: DDCFormModell,entity: Entity, indexPath: IndexPath) {
        let dataa : Entity? = entity
        self.isUserInteractionEnabled = true
        self.mainDropDown.text = ""

        if isReadOnly {
            self.isUserInteractionEnabled = false
        }


        
        var fieldValueArray = [String]()
        var fieldIDArray = [String]()

        var dropDownSet : ValueSet?
        
        for valueSet in data.valueSets ?? [] {
            if valueSet.id == entity.valueSetID {
                dropDownSet = valueSet
            }
        }
        
        var valueData = ""
        if let instrumentsData = instruments?.entities {
            for instrument in instrumentsData {
                if instrument.entityTemplateID == entity.id  ?? "" {
                    if let value = instrument.value {
                        valueData = value
                    }
                }
            }
        }
        
        for dic in dropDownSet?.valueSetData ?? [] {
            fieldValueArray.append(dic.value!)
            fieldIDArray.append(dic.uri!)

            if dic.uri == valueData {
                self.mainDropDown.text = dic.value
            }
            
        }
        
       // uriLbl.text = dataa!.uri
        uriLbl.text = dataa?.label
        
          mainDropDown.optionArray = fieldValueArray
          mainDropDown.optionIds = fieldIDArray
          mainDropDown.checkMarkEnabled = true
          mainDropDown.placeholder = "Select your " + (dataa!.label)!
          mainDropDown.didSelect{(selectedText , index , id) in
            print("Selected String: \(selectedText) \n index: \(index) \n Id: \(id)")
              NewRequestHelper.shared.updateEntityValue(entity: self.entity!, value: id)
          }
          mainDropDown.arrowSize = 10


        self.entity = entity
        self.data = data
        self.indexPath = indexPath

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
//        RequestHelper.shared.createRequestForEntity(entity: self.entity!, newValue: "", entityGroupId: self.entityGroupId,parentEntityGroupId: self.parentEntityGroupId,groupOrder: self.groupOrder, dataModel: self.ddcModel)
    }
}
