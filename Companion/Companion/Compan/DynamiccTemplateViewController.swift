//
//  DynamiccTemplateViewController.swift
//  Compan
//
//  Created by Ambu Sangoli on 10/05/22.
//

import UIKit
import SwiftUI
import NotificationBannerSwift

//Model declared globally
var ddcModel : DDCFormModell?

var showValidations = false // validate before submit
var isReadOnly = false // read only

protocol DynamicTemplateViewControllerDelegate {
    func didSubmitSurveyForm(response: NSArray, eventId: String)
    func didSubmitEventForm(response: NSArray)

}

class DynamiccTemplateViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var footerViewHeight: NSLayoutConstraint!

    
    var delegate: DynamicTemplateViewControllerDelegate?
    var eventId = ""
    var hideIndexField = false
    var isEventTemplate = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isReadOnly {
            self.footerView.isHidden = true
            self.footerViewHeight.constant = 0
        } else {
            self.footerView.isHidden = false
            self.footerViewHeight.constant = 80
        }

        // Do any additional setup after loading the view.
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "DefaultCell")
//        tableView.dataSource = self
        
        //Register cell for using in tableview
        tableView.register(UINib(nibName: "TextfieldComponent", bundle: nil), forCellReuseIdentifier: "TextfieldComponent")
        tableView.register(UINib(nibName: "DropDownTableViewCell", bundle: nil), forCellReuseIdentifier: "DropDownTableViewCell")
        tableView.register(UINib(nibName: "RadioButtonTableViewCell", bundle: nil), forCellReuseIdentifier: "RadioButtonTableViewCell")
        tableView.register(UINib(nibName: "CheckBoxTableViewCell", bundle: nil), forCellReuseIdentifier: "CheckBoxTableViewCell")
        tableView.register(UINib(nibName: "TextViewTableViewCell", bundle: nil), forCellReuseIdentifier: "TextViewTableViewCell")
        tableView.register(UINib(nibName: "DatePickerTableViewCell", bundle: nil), forCellReuseIdentifier: "DatePickerTableViewCell")
        tableView.register(UINib(nibName: "MessageTableViewCell", bundle: nil), forCellReuseIdentifier: "MessageTableViewCell")
        tableView.register(UINib(nibName: "TimePickerTableViewCell", bundle: nil), forCellReuseIdentifier: "TimePickerTableViewCell")
        tableView.register(UINib(nibName: "PickerTableViewCell", bundle: nil), forCellReuseIdentifier: "PickerTableViewCell")
        tableView.register(UINib(nibName: "SliderTableViewCell", bundle: nil), forCellReuseIdentifier: "SliderTableViewCell")
        tableView.register(UINib(nibName: "RepeatableTableViewCell", bundle: nil), forCellReuseIdentifier: "RepeatableTableViewCell")
        tableView.register(UINib(nibName: "ToggleSwitchTableViewCell", bundle: nil), forCellReuseIdentifier: "ToggleSwitchTableViewCell")
        tableView.register(UINib(nibName: "AutocompleteTableViewCell", bundle: nil), forCellReuseIdentifier: "AutocompleteTableViewCell")


        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.keyboardDismissMode = .onDrag
        self.hideKeyboardWhenTappedAround()
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        self.addObservers()
    }
    deinit {
        removeObservers()
    }
    

    func setUpData() {
        
    }
    
    func addObservers(){
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(notificationAction),
            name: NSNotification.Name(rawValue: "ReloadTable") ,
            object: nil
        )
    }
    func removeObservers(){
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue:"ReloadTable"), object: nil)
    }
    
    @objc func notificationAction() {
        self.tableView.reloadData()
      }
    
    
    @IBAction func submitButton(_ sender: Any) {
        if ValidationHelper.shared.checkValidation(ddcModel: ddcModel) == false {
            let leftView = UIImageView(image: UIImage(named: "warning"))
            let banner = GrowingNotificationBanner(title: "Incomplete form", subtitle: "Please fill all required fields.", leftView: leftView, style: .warning)
            banner.haptic = .medium
            banner.show()
            showValidations = true
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ReloadTable"), object: nil)
            return
        }
        showValidations = false
        self.updateAllEntityValue(instruments: instruments!)
    }
    
    @IBAction func resetButton(_ sender: Any) {
        showValidations = false
        NewRequestHelper.shared.resetInstrument()
    }
    
    func updateAllEntityValue(instruments: Instruments){
        ERProgressHud.shared.show()
        var entityData : [[String:Any]] = []
        if let instrumentsData = instruments.entities {
            for data in instrumentsData {
                if data.entityType == "ENTITY_INSTRUMENT" {
                    let dic = ["id": data.id,
                               "value": data.value]
                    entityData.append(dic as [String : Any])
                }
            }
        }
        let parameter : [String:Any] = ["entityInstrumentPayloadList": entityData, "updatedBy": "iOS" ]
        let jsonData = try! JSONSerialization.data(withJSONObject: parameter, options: JSONSerialization.WritingOptions.prettyPrinted)
        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        print(jsonString)

        APIManager.sharedInstance.makeRequestToUpdateEntityValue(data: jsonData){ (success, response,statusCode)  in
            if (success) {
                print(response)
                ERProgressHud.shared.hide()
                if self.isEventTemplate {
                    self.delegate?.didSubmitEventForm(response: response)
                } else {
                    self.delegate?.didSubmitSurveyForm(response: response,eventId: self.eventId)
                }
                self.navigationController?.popViewController(animated: true)
            } else {
                APIManager.sharedInstance.showAlertWithMessage(message: ERROR_MESSAGE_DEFAULT)
                ERProgressHud.shared.hide()
            }
        }
    }
    
    

// MARK: - UITableViewDataSource
func numberOfSections(in tableView: UITableView) -> Int {
    return ddcModel?.entities?.count ?? 0//template?.entities!.count)!
}

func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if ddcModel?.entities?[section].entityType == .entityGroupRepeatable {
        return 1//ddcModel?.entities?[section].entityGroup?.entities?.count ?? 0
    }
    return 1
}

//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: 50))
//        view.backgroundColor = UIColor(red: 168.0/255.0, green: 219.0/255.0, blue: 205.0/255.0, alpha: 1)
//        let titleLabel = UILabel(frame: CGRect(x: 20, y: 0, width: self.tableView.frame.width - 40, height: 50))
//        titleLabel.textColor = .white
//        view.addSubview(titleLabel)
//        if ddcModel?.template?.entities?[section].type == .entityGroupRepeatable {
//            titleLabel.text = ddcModel?.template?.entities?[section].title ?? ""
//        } else {
//            if section == 0 {
//            titleLabel.text =  ddcModel?.template?.title
//            }
//        }
//        if ddcModel?.template?.entities?[section].type == .entityGroupRepeatable {
//
//            let button = UIButton()
//                button.setBackgroundImage(UIImage.add.withTintColor(.blue), for: .normal)
//                button.frame = CGRect(x: view.frame.maxX - 40, y: view.frame.midY - 17.5, width: 35, height: 35)
//                button.addTarget(self, action: #selector(self.addButton(_:)), for: .touchUpInside)
//                button.tag = section
//                view.addSubview(button)
//
//
//            if ddcModel?.template?.entities?.count != 1 {
//                let button = UIButton()
//                button.setBackgroundImage(UIImage.remove.withTintColor(.red), for: .normal)
//                button.frame = CGRect(x: view.frame.maxX - 40, y: view.frame.midY - 17.5, width: 35, height: 35)
//                button.addTarget(self, action: #selector(self.removeButton(_:)), for: .touchUpInside)
//                button.tag = section
//                view.addSubview(button)
//
//                let addbutton = UIButton()
//                addbutton.setBackgroundImage(UIImage.add.withTintColor(.blue), for: .normal)
//                addbutton.frame = CGRect(x: button.frame.origin.x - 40, y: view.frame.midY - 17.5, width: 35, height: 35)
//                addbutton.addTarget(self, action: #selector(self.addButton(_:)), for: .touchUpInside)
//                addbutton.tag = section
//                view.addSubview(addbutton)
//            }
//
//
//        }
//        return view
//    }
//
//    @objc func addButton(_ sender: UIButton) {
//        print(sender.tag)
////        let data = ddcModel?.template?.entities![sender.tag]
//
////        let repeated  = Entity(type: data?.type, title: data?.title, active: data?.active, order: data?.order, guiControlType: data?.guiControlType, id: data?.id, value: data?.value, oldValue: data?.oldValue, lastUpdatedBy: data?.lastUpdatedBy, lastUpdatedDate: data?.lastUpdatedDate, uri: data?.uri, valueSetRef: data?.valueSetRef, settings: data?.settings, entityGroups: data?.entityGroups, isRepeated: true)
////
////        ddcModel?.template?.entities?.insert(repeated, at: sender.tag + 1)
////        self.tableView.reloadData()
////        self.tableView.scrollToRow(at: IndexPath(row: 0, section: sender.tag + 1), at: .middle, animated: true)
//    }
//
//    @objc func removeButton(_ sender: UIButton) {
//        print(sender.tag)
////        ddcModel?.template?.entities?.remove(at: sender.tag)
////        self.tableView.reloadData()
//    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if ddcModel?.entities?[section].entityType == .entityGroupRepeatable {
            return 0
        } else {
        if section == 0 {
            return 50
        }
        }
        return 0
}

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.hideIndexField && indexPath.section == 0 && isEventTemplate == false {
            return 0
        }
        if self.hideIndexField && indexPath.section == 6 && isEventTemplate {
            return 0
        }
        var data : Entity?
        if ddcModel?.entities![indexPath.section].entityType == .entityGroupRepeatable {
            return NewUtilities.shared.calculateGroupHeight(tableView: tableView, entityGroup: (ddcModel?.entities?[indexPath.section].entityGroup)!, data: ddcModel!) + 50

        }
        if ddcModel?.entities![indexPath.section].entityType == .entityGroup {
            return NewUtilities.shared.calculateGroupHeight(tableView: tableView, entityGroup: (ddcModel?.entities?[indexPath.section])!, data: ddcModel!) + 50

        } else {
            data = ddcModel?.entities![indexPath.section]
        }
        let enumerationEntityfieldTypeIs = ComponentUtils.getEnumerationEntityFieldType(fieldData:data!)
        let textEntityFieldType = ComponentUtils.getTextEntryEntityFieldType(fieldData:data!)
        let messageEntityFieldType = ComponentUtils.getMeesageEntityFieldType(fieldData:data!)

        print(textEntityFieldType)
        if enumerationEntityfieldTypeIs == .radioButton {

            var dropDownSet : ValueSet?
            for valueSet in ddcModel!.valueSets ?? [] {
                if valueSet.id == data!.valueSetID {
                    dropDownSet = valueSet
                }
            }
            let dynamicHeightforRadioCell = dropDownSet!.valueSetData!.count * 50 + 50

            return CGFloat(dynamicHeightforRadioCell) + ComponentUtils.getErrorMessageHeight(entity: data!)
            //return 700
      } else  if enumerationEntityfieldTypeIs == .checkBox {

                var dropDownSet : ValueSet?
                for valueSet in ddcModel!.valueSets ?? [] {
                    if valueSet.id == data!.valueSetID {
                        dropDownSet = valueSet
                    }
                }
                let dynamicHeightforRadioCell = dropDownSet!.valueSetData!.count * 50 + 80

            return CGFloat(dynamicHeightforRadioCell) + ComponentUtils.getErrorMessageHeight(entity: data!)
            //return 700

      } else if enumerationEntityfieldTypeIs == .dropDownField {
          return 100 + ComponentUtils.getErrorMessageHeight(entity: data!)
       } else if textEntityFieldType == .textareaField {
        return 200 + ComponentUtils.getErrorMessageHeight(entity: data!)//UITableView.automaticDimension
       }
        else if textEntityFieldType == .datePicker {
           return 100 + ComponentUtils.getErrorMessageHeight(entity: data!)//UITableView.automaticDimension
       } else if messageEntityFieldType == .messageField {
           return 100 + ComponentUtils.getErrorMessageHeight(entity: data!)//UITableView.automaticDimension
       } else if textEntityFieldType == .timePicker {
           return 100 + ComponentUtils.getErrorMessageHeight(entity: data!)//UITableView.automaticDimension
       } else if textEntityFieldType == .picker {
           return 100 + ComponentUtils.getErrorMessageHeight(entity: data!)//UITableView.automaticDimension
       } else if textEntityFieldType == .slider {
           return 100 + ComponentUtils.getErrorMessageHeight(entity: data!)//UITableView.automaticDimension
       }

        return 100
}

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

let cellIdentifier = "DefaultCell"

var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
if cell == nil {
    cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
}
    
    if ddcModel != nil {
        var data : Entity?
        if ddcModel?.entities![indexPath.section].entityType == .entityGroupRepeatable {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RepeatableTableViewCell", for: indexPath) as! RepeatableTableViewCell
            cell.setupRepeatableGroupCell(entityGroup: (ddcModel?.entities![indexPath.section].entityGroup!)!, data:ddcModel!, parentEntityGroupId: (ddcModel?.entities![indexPath.section].entityGroup!.parentEntityTemplateID)!)
            
            cell.setupHeaderView(entityGroup: (ddcModel?.entities![indexPath.section].entityGroup!)!, groupCount: 1, sectionIndex: 0)
            cell.ddcModel = ddcModel
            return cell
        } else if ddcModel?.entities![indexPath.section].entityType == .entityGroup {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RepeatableTableViewCell", for: indexPath) as! RepeatableTableViewCell
            cell.setupRepeatableGroupCell(entityGroup: (ddcModel?.entities![indexPath.section])!, data:ddcModel!, parentEntityGroupId: (ddcModel?.entities![indexPath.section].parentEntityTemplateID ?? ""))
            
            cell.setupHeaderView(entityGroup: (ddcModel?.entities![indexPath.section])!, groupCount: 1, sectionIndex: 0)
            cell.ddcModel = ddcModel
            return cell
        } else {
            data = ddcModel?.entities?[indexPath.section]
        }
        if data?.entityType  == .textEntryEntity {
            let fieldTypeIs = ComponentUtils.getTextEntryEntityFieldType(fieldData:data!)
            if fieldTypeIs == .lineeditField {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "TextfieldComponent", for: indexPath) as! TextfieldComponent
                cell.uriLbl.text = data?.label//?.htmlToAttributedString
                cell.textField.setBottomBorder()
                cell.textField.placeholder = "Enter " + (data?.label)!
                cell.setUpTextFieldCell(data: ddcModel!, entity: data!,indexPath: indexPath)
                cell.ddcModel = ddcModel
                return cell
            } else if fieldTypeIs == .textareaField {
                let cell = tableView.dequeueReusableCell(withIdentifier: "TextViewTableViewCell", for: indexPath) as! TextViewTableViewCell
            cell.uriLbl.text = data?.label
            cell.setUpTextViewAreaCell(data: ddcModel!, entity: data!,indexPath: indexPath)
            cell.ddcModel = ddcModel
                return cell
        } else if fieldTypeIs == .datePicker {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DatePickerTableViewCell", for: indexPath) as! DatePickerTableViewCell
            cell.uriLbl.text = data?.label
            cell.setUpDatePickerCell(data: ddcModel!, entity: data!,indexPath: indexPath)
            cell.ddcModel = ddcModel

            return cell
 } else if fieldTypeIs == .timePicker {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimePickerTableViewCell", for: indexPath) as! TimePickerTableViewCell
        cell.uriLbl.text = data?.label
        cell.setUpTimePickerCell(data: ddcModel!, entity: data!,indexPath: indexPath)
        cell.ddcModel = ddcModel

        return cell

 } else if fieldTypeIs == .picker {

     let cell = tableView.dequeueReusableCell(withIdentifier: "PickerTableViewCell", for: indexPath) as! PickerTableViewCell
     cell.uriLbl.text = data?.label
     cell.setupPickerCell(data: ddcModel!, entity: data!,indexPath: indexPath)
     cell.ddcModel = ddcModel

     return cell
 }
     else if fieldTypeIs == .slider {

        let cell = tableView.dequeueReusableCell(withIdentifier: "SliderTableViewCell", for: indexPath) as! SliderTableViewCell
         cell.uriLbl.text = data?.label
         cell.setupSliderCell(data: ddcModel!, entity: data!,indexPath: indexPath)
         cell.ddcModel = ddcModel

        return cell

    }
            else if fieldTypeIs == .toggleswitch {

        let cell = tableView.dequeueReusableCell(withIdentifier: "ToggleSwitchTableViewCell", for: indexPath) as! ToggleSwitchTableViewCell
         cell.uriLbl.text = data?.label
         cell.setupSliderCell(data: ddcModel!, entity: data!,indexPath: indexPath)
        cell.ddcModel = ddcModel
        return cell

    } else if fieldTypeIs == .autocomplete {

        let cell = tableView.dequeueReusableCell(withIdentifier: "AutocompleteTableViewCell", for: indexPath) as! AutocompleteTableViewCell
        cell.uriLbl.text = data?.label
        cell.textField.setBottomBorder()
        cell.setUpTextFieldCell(data: ddcModel!, entity: data!,indexPath: indexPath)
        cell.ddcModel = ddcModel
        return cell
}
        } else if data?.entityType == .enumerationEntity {
            let fieldTypeIs = ComponentUtils.getEnumerationEntityFieldType(fieldData:data!)
            if fieldTypeIs == .dropDownField {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DropDownTableViewCell", for: indexPath) as! DropDownTableViewCell
                cell.setUpDropDownCell(data: ddcModel!, entity: data!,indexPath: indexPath)
                cell.ddcModel = ddcModel
                return cell
            }  else if fieldTypeIs == .radioButton {
                let cell = tableView.dequeueReusableCell(withIdentifier: "RadioButtonTableViewCell", for: indexPath) as! RadioButtonTableViewCell
                cell.uriLbl.text = data?.label
                cell.setUpRadioCell(data: ddcModel!, entity: data!,indexPath: indexPath)
                cell.ddcModel = ddcModel
                return cell
            } else if fieldTypeIs == .checkBox {
                let cell = tableView.dequeueReusableCell(withIdentifier: "CheckBoxTableViewCell", for: indexPath) as! CheckBoxTableViewCell
                cell.uriLbl.attributedText = data?.label?.htmlToAttributedString
                cell.setUpCheckBoxCell(data: ddcModel!, entity: data!,indexPath: indexPath)
                cell.ddcModel = ddcModel
                return cell
            }
        } else if data?.entityType  == .messageEntity {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MessageTableViewCell", for: indexPath) as! MessageTableViewCell
            cell.setUpMessageCell(data: ddcModel!, entity: data!,indexPath: indexPath, tableView: self.tableView)
            return cell
}
            
        
    }

    return cell!
}

//// MARK: - UITableViewDelegate
func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

}

}
