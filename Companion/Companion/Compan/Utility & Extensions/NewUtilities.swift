//
//  Utilities.swift
//  Cognome
//
//  Created by Ambu Sangoli
//  Copyright © 2022 Cognome. All rights reserved.
//

import UIKit

class NewUtilities: NSObject {

    static let shared = NewUtilities()

    // Validation for entered email address
    func validateEmail(enteredEmail:String) -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: enteredEmail)
    }
    
    //CHeck empty textfield
    func checkEmptyTextFIeld(txtStr:String) -> Bool {
        if (txtStr == "") {
            return false
        } else {
            return true
        }
    }
    
//    func calculateGroupHeightCell(tableView: UITableView, entityGroup: Entity,data: DDCFormModel) -> CGFloat {
//        var totalHeight : CGFloat = 0
//        totalHeight += self.getEntityHeigh(entityGroup: entityGroup, data: data)
//        for entity in entityGroup.entities ?? [] {
//
//            if entity.type == .entityGroupRepeatable {
//                for group in entity.entityGroups ?? [] {
//                    totalHeight += self.getEntityHeigh(entityGroup: group, data: data)
//
//                }
//            }
//        }
//        return totalHeight + 50
//    }
    
    
    func calculateGroupHeight(tableView: UITableView, entityGroup: Entity,data: DDCFormModell) -> CGFloat {
        var totalHeight : CGFloat = 0
        totalHeight += self.getEntityHeigh(entityGroup: entityGroup, data: data)
        for entity in entityGroup.entities ?? [] {

            if entity.entityType == .entityGroupRepeatable {
                totalHeight += self.getEntityHeigh(entityGroup: entity.entityGroup!, data: data)
            }
        }
        return totalHeight
    }
    
    
    func getEntityHeigh(entityGroup: Entity,data: DDCFormModell) -> CGFloat {
        var totalHeight : CGFloat = 0
        for entity in entityGroup.entities ?? [] {
        let enumerationEntityfieldTypeIs = ComponentUtils.getEnumerationEntityFieldType(fieldData:entity)
        let textEntityFieldType = ComponentUtils.getTextEntryEntityFieldType(fieldData:entity)
        let messageEntityFieldType = ComponentUtils.getMeesageEntityFieldType(fieldData:entity)

        print(textEntityFieldType)
        if enumerationEntityfieldTypeIs == .radioButton {

            var dropDownSet : ValueSet?
            for valueSet in ddcModel!.valueSets ?? [] {
                if valueSet.id == entityGroup.valueSetID {
                    dropDownSet = valueSet
                }
            }
            let dynamicHeightforRadioCell = dropDownSet!.valueSetData!.count * 50 + 50

            totalHeight += CGFloat(dynamicHeightforRadioCell) + ComponentUtils.getErrorMessageHeight(entity: entity)
            //return 700

      } else  if enumerationEntityfieldTypeIs == .checkBox {

          var dropDownSet : ValueSet?
          for valueSet in ddcModel!.valueSets ?? [] {
              if valueSet.id == entityGroup.valueSetID {
                  dropDownSet = valueSet
              }
          }
          let dynamicHeightforRadioCell = dropDownSet!.valueSetData!.count * 50 + 80

          totalHeight += CGFloat(dynamicHeightforRadioCell) + ComponentUtils.getErrorMessageHeight(entity: entity)
            //return 700

      } else if enumerationEntityfieldTypeIs == .dropDownField {
          
          totalHeight += 100 + ComponentUtils.getErrorMessageHeight(entity: entity)//UITableView.automaticDimension

       } else if textEntityFieldType == .textareaField {
        
           totalHeight += 200 + ComponentUtils.getErrorMessageHeight(entity: entity)//UITableView.automaticDimension
       } else if textEntityFieldType == .datePicker {
           
           totalHeight += 100 + ComponentUtils.getErrorMessageHeight(entity: entity)//UITableView.automaticDimension
       } else if messageEntityFieldType == .messageField {
           totalHeight += 100 + ComponentUtils.getErrorMessageHeight(entity: entity)//UITableView.automaticDimension
       } else if textEntityFieldType == .timePicker {
           totalHeight += 100 + ComponentUtils.getErrorMessageHeight(entity: entity)//UITableView.automaticDimension
       } else if textEntityFieldType == .picker {
           totalHeight += 100 + ComponentUtils.getErrorMessageHeight(entity: entity)//UITableView.automaticDimension
       } else if textEntityFieldType == .slider {
           totalHeight += 100 + ComponentUtils.getErrorMessageHeight(entity: entity)//UITableView.automaticDimension
       } else {
           totalHeight += 100 + ComponentUtils.getErrorMessageHeight(entity: entity)
       }
        }
        return totalHeight
        
    }
}
