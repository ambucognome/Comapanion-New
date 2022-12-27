//
//  Utilities.swift
//  Cognome
//
//  Created by Ambu Sangoli
//  Copyright © 2022 Cognome. All rights reserved.
//

import UIKit

class Utilities: NSObject {

    static let shared = Utilities()

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
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    class func convertDateToTimestamp(date : String) -> String {
        let myFormatter = DateFormatter()
        myFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        let newDate = myFormatter.date(from: date)
        let timestamp = newDate!.millisecondsSince1970
        return String(timestamp)
    }
    

    class func getDayFromTimeStamp(date: Date,timezone:TimeZone = .current) -> String {
        //Date formatting
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.long
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "EEEE"
        dateFormatter.timeZone = timezone
        let dateString = dateFormatter.string(from: date as Date)
        return dateString
    }
    
    class func getDateFromTimeStamp(date: Date,timezone:TimeZone = .current) -> String {
        //Date formatting
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.long
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "MMMM d, yyyy"
        dateFormatter.timeZone = timezone
        let dateString = dateFormatter.string(from: date as Date)
        return dateString
    }
    
    class func getTimeFromTimeStamp(date: Date,timezone:TimeZone = .current) -> String {
        //Date formatting
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.long
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "h:mm a"
        dateFormatter.timeZone = timezone
        let dateString = dateFormatter.string(from: date as Date)
        return dateString
    }
    
    
    
    func calculateGroupHeightCell(tableView: UITableView, entityGroup: EntityRepeatableGroup,data: DDCFormModel) -> CGFloat {
        var totalHeight : CGFloat = 0
        totalHeight += self.getEntityHeigh(entityGroup: entityGroup, data: data)
        for entity in entityGroup.sortedEntitiesArray ?? [] {

            if entity.value.type == .entityGroupRepeatable || entity.value.type == .entityGroup {
                for group in entity.value.sortedEntityGroupsArray ?? [] {
                    totalHeight += self.getEntityHeigh(entityGroup: group.value, data: data)
                }
            }
        }
        if showHeader == true {
            return totalHeight + 50
        }
        return totalHeight
    }
    
    
    func calculateGroupHeight(tableView: UITableView, entityGroup: EntityRepeatableGroup,data: DDCFormModel) -> CGFloat {
        var totalHeight : CGFloat = 0
        totalHeight += self.getEntityHeigh(entityGroup: entityGroup, data: data)
        for entity in entityGroup.sortedEntitiesArray ?? [] {

            if entity.value.type == .entityGroupRepeatable || entity.value.type == .entityGroup {
                for group in entity.value.sortedEntityGroupsArray ?? [] {
                    totalHeight += self.getEntityHeigh(entityGroup: group.value, data: data)
                }
            }
        }
        if showHeader == true {
            return totalHeight + 50
        }
        return totalHeight 
    }
    
    
    func getEntityHeigh(entityGroup: EntityRepeatableGroup,data: DDCFormModel) -> CGFloat {
        var totalHeight : CGFloat = 0

        for entity in entityGroup.sortedEntitiesArray ?? [] {
            let entityData = entity.value
            if entityData.isHidden {
                totalHeight += 0
            } else if entityData.type == .calculatedEntity {
                totalHeight += 0
            }  else {
            let enumerationEntityfieldTypeIs = ComponentUtils.getEnumerationEntityFieldType(fieldData:entityData)
            let textEntityFieldType = ComponentUtils.getTextEntryEntityFieldType(fieldData:entityData)
            let messageEntityFieldType = ComponentUtils.getMeesageEntityFieldType(fieldData:entityData)
           

        print(textEntityFieldType)
        if enumerationEntityfieldTypeIs == .radioButton {

//        let dropDownSet = data.valueSet?.filter{ $0.refID!.localizedCaseInsensitiveContains((entity.valueSetRef)!)}
//
            let dropDownSet = data.valueSet?[(entity.value.valueSetRef!)]

        let dynamicHeightforRadioCell = dropDownSet!.count * 50 + 51
//
            totalHeight += CGFloat(dynamicHeightforRadioCell) + ComponentUtils.getResetHeight() + ComponentUtils.getErrorMessageHeight(entity: entityData) + (entityData.attributedTitleHeight - 20.5)
//            totalHeight += 100

      } else  if enumerationEntityfieldTypeIs == .checkBox {

//        let dropDownSet = data.valueSet?.filter{ $0.refID!.localizedCaseInsensitiveContains((entity.valueSetRef)!)}
          let dropDownSet = data.valueSet?[(entity.value.valueSetRef!)]

      let dynamicHeightforRadioCell = dropDownSet!.count * 50 + 51
//
          totalHeight += CGFloat(dynamicHeightforRadioCell) + ComponentUtils.getResetHeight() + ComponentUtils.getErrorMessageHeight(entity: entityData) + (entityData.attributedTitleHeight - 20.5)

      } else if enumerationEntityfieldTypeIs == .dropDownField {
          
          totalHeight += 85 + ComponentUtils.getResetHeight() + ComponentUtils.getErrorMessageHeight(entity: entityData)//UITableView.automaticDimension

       } else if textEntityFieldType == .textareaField {
        
           totalHeight += 200 + ComponentUtils.getResetHeight() + ComponentUtils.getErrorMessageHeight(entity: entityData)//UITableView.automaticDimension
       } else if textEntityFieldType == .datePicker {
           
           totalHeight += 91 + ComponentUtils.getResetHeight() + ComponentUtils.getErrorMessageHeight(entity: entityData)//UITableView.automaticDimension
       } else if messageEntityFieldType == .messageField {
           totalHeight += (entityData.attributedTitleHeight + 20)//200 //UITableView.automaticDimension
       } else if textEntityFieldType == .timePicker {
           totalHeight += 91 + ComponentUtils.getResetHeight() + ComponentUtils.getErrorMessageHeight(entity: entityData)//UITableView.automaticDimension
       } else if textEntityFieldType == .picker {
           totalHeight += 91 + ComponentUtils.getResetHeight() + ComponentUtils.getErrorMessageHeight(entity: entityData)//UITableView.automaticDimension
       } else if textEntityFieldType == .slider {
           totalHeight += 85 + ComponentUtils.getResetHeight() + ComponentUtils.getErrorMessageHeight(entity: entityData) //UITableView.automaticDimension
       } else if textEntityFieldType == .toggleSwitch {
           totalHeight += 85 + ComponentUtils.getResetHeight() + ComponentUtils.getErrorMessageHeight(entity: entityData) //UITableView.automaticDimension
       } else if textEntityFieldType == .lineeditField {
           totalHeight += 85 + ComponentUtils.getResetHeight() + ComponentUtils.getErrorMessageHeight(entity: entityData) //UITableView.automaticDimension
       } else if textEntityFieldType == .autocomplete {
           totalHeight += 85 + ComponentUtils.getResetHeight() + ComponentUtils.getErrorMessageHeight(entity: entityData) //UITableView.automaticDimension
       } else {
           totalHeight += 100
       }
        }
        }
        return totalHeight
    }
    
    //Calculate label height
    class func getLableHeightRuntime(attributedText : NSAttributedString?) -> CGFloat {
        let width = UIScreen.main.bounds.width - 40
          let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = attributedText?.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        return ceil(boundingBox?.height ?? 10)
      }
    
    

}
