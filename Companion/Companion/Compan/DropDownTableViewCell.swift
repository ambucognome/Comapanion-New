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


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var data : DDCFormModel?
    var indexPath : IndexPath?
    var entity : Entity?
    var entityGroupId: String = ""
    var parentEntityGroupId = ""
    var groupOrder = 0

    
    
    func setUpDropDownCell(data: DDCFormModel,entity: Entity, indexPath: IndexPath,entityGroupId: String,parentEntityGroupId:String = "99",groupOrder: Int = 0) {
        let dataa : Entity? = entity
        self.isUserInteractionEnabled = true
        if isReadOnly {
            self.isUserInteractionEnabled = false
        }
//        if data.template?.entities![indexPath.section].type == .entityGroupRepeatable {
//            dataa = data.template?.entities![indexPath.section].entityGroups![0].entities![indexPath.row]
//        } else {
//            dataa = data.template?.entities![indexPath.section]
//        }
        self.mainDropDown.text = dataa?.value?.value as? String

        
        var fieldValueArray = [String]()
        var fieldIDArray = [String]()

        let dropDownSet = data.valueSet?[(dataa?.valueSetRef!)!]
        for dic in dropDownSet ?? [] {
            fieldValueArray.append(dic.values.first!)
            fieldIDArray.append(dic.keys.first!)
            if dic.keys.first == (dataa?.value?.value as? String ?? "") {
                self.mainDropDown.text = dic.values.first

            }
        }
        
       // uriLbl.text = dataa!.uri
        uriLbl.attributedText = dataa?.title?.htmlToAttributedString

       // print(dropDownValue.map { ( $0.value) })
        
          mainDropDown.optionArray = fieldValueArray
          mainDropDown.optionIds = fieldIDArray
          mainDropDown.checkMarkEnabled = true
          mainDropDown.placeholder = "Select your " + (dataa!.uri)!
          mainDropDown.didSelect{(selectedText , index , id) in
            //  self.valueLabel.text = "Selected String: \(selectedText) \n index: \(index) \n Id: \(id)"
//              RequestHelper.shared.createRequestForEntity(data: data, index: indexPath, newValue: selectedText)
              RequestHelper.shared.createRequestForEntity(entity: entity, newValue: id, entityGroupId: entityGroupId,parentEntityGroupId: parentEntityGroupId,groupOrder: groupOrder)
          }
          mainDropDown.arrowSize = 10


        self.entityGroupId = entityGroupId
        self.entity = entity
        self.data = data
        self.indexPath = indexPath
        self.parentEntityGroupId = parentEntityGroupId

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
        RequestHelper.shared.createRequestForEntity(entity: self.entity!, newValue: "", entityGroupId: self.entityGroupId,parentEntityGroupId: self.parentEntityGroupId,groupOrder: self.groupOrder)
    }
}
