//
//  DynamicTemplateViewController.swift
//  Compan
//
//  Created by Ambu Sangoli on 10/05/22.
//

import UIKit
import SwiftUI
import NotificationBannerSwift

//Model declared globally
//var ddcModel : DDCFormModel?

//Temporary place for setting reset value
var isResetAvailable = false // Show/hide reset button
var showValidations = false // validate before submit
var isReadOnly = false // read only
var showHeader = true // show/hide header
var savePerField = true // save per field
var headerBackgroundColor = UIColor(red: 0, green: 0.7255, blue: 0.9686, alpha: 1)
var headerFontColor = UIColor.white
var headerFont = UIFont.systemFont(ofSize: 16, weight: .medium)
var username = ""

var templateURI = ""
var surveyID = ""

protocol DynamicTemplateViewControllerDelegate {
    func didSubmitSurvey(params:[String:Any])
}

class DynamicTemplateViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerLabel: UILabel!
    
    
    var delegate: DynamicTemplateViewControllerDelegate?
    
    // declare dictionary variable for storing heights of cells
    var cellHeightsDictionary: [IndexPath: CGFloat] = [:]
    
    var dataModel: DDCFormModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.headerLabel.text = "Welcome \(username)"
        self.navigationController?.isNavigationBarHidden = true
        // Do any additional setup after loading the view.
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "DefaultCell")
        tableView.dataSource = self
        
        //Register cell for using in tableview
        let frameworkBundle = Bundle(for: DynamicTemplateViewController.self)

        tableView.register(UINib(nibName: "TextfieldComponent", bundle: frameworkBundle), forCellReuseIdentifier: "TextfieldComponent")
        tableView.register(UINib(nibName: "DropDownTableViewCell", bundle: frameworkBundle), forCellReuseIdentifier: "DropDownTableViewCell")
        tableView.register(UINib(nibName: "RadioButtonTableViewCell", bundle: frameworkBundle), forCellReuseIdentifier: "RadioButtonTableViewCell")
        tableView.register(UINib(nibName: "CheckBoxTableViewCell", bundle: frameworkBundle), forCellReuseIdentifier: "CheckBoxTableViewCell")
        tableView.register(UINib(nibName: "TextViewTableViewCell", bundle: frameworkBundle), forCellReuseIdentifier: "TextViewTableViewCell")
        tableView.register(UINib(nibName: "DatePickerTableViewCell", bundle: frameworkBundle), forCellReuseIdentifier: "DatePickerTableViewCell")
        tableView.register(UINib(nibName: "MessageTableViewCell", bundle: frameworkBundle), forCellReuseIdentifier: "MessageTableViewCell")
        tableView.register(UINib(nibName: "TimePickerTableViewCell", bundle: frameworkBundle), forCellReuseIdentifier: "TimePickerTableViewCell")
        tableView.register(UINib(nibName: "PickerTableViewCell", bundle: frameworkBundle), forCellReuseIdentifier: "PickerTableViewCell")
        tableView.register(UINib(nibName: "SliderTableViewCell", bundle: frameworkBundle), forCellReuseIdentifier: "SliderTableViewCell")
        tableView.register(UINib(nibName: "RepeatableTableViewCell", bundle: frameworkBundle), forCellReuseIdentifier: "RepeatableTableViewCell")
        tableView.register(UINib(nibName: "ToggleSwitchTableViewCell", bundle: frameworkBundle), forCellReuseIdentifier: "ToggleSwitchTableViewCell")
        tableView.register(UINib(nibName: "AutocompleteTableViewCell", bundle: frameworkBundle), forCellReuseIdentifier: "AutocompleteTableViewCell")

        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.keyboardDismissMode = .onDrag
        self.hideKeyboardWhenTappedAround()
        self.tableView.remembersLastFocusedIndexPath = true

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
        DispatchQueue.main.async {
        UIView.setAnimationsEnabled(false)
            let offset = self.tableView.contentOffset
            self.tableView.reloadData()
            self.tableView.setContentOffset(offset, animated: false)
        }
    }
    
    @IBAction func submitBtn(_ sender: Any) {
        let name = "\(SafeCheckUtils.getUserData()?.user?.firstname ?? "") \(SafeCheckUtils.getUserData()?.user?.lastname ?? "")"
        let parameter = ["blueprint": try! dataModel!.toDictionary(), "context_parameters": context_parameters, "modified_by": name] as [String : Any]
        self.saveTemplateInstance(template: parameter)
    }
    
    @IBAction func resetBtn(_ sender: Any) {
        showValidations = false
        let name = "\(SafeCheckUtils.getUserData()?.user?.firstname ?? "") \(SafeCheckUtils.getUserData()?.user?.lastname ?? "")"
        let parameter = ["blueprint": try! dataModel!.toDictionary(), "context_parameters": context_parameters, "modified_by": name] as [String : Any]
        self.resetTemplateInstance(template: parameter)
    }
    
    // Save Template instance
    func saveTemplateInstance(template: [String:Any]) {
        if ValidationHelper.shared.checkValidation(ddcModel: self.dataModel) == false {
            let leftView = UIImageView(image: UIImage(named: "warning"))
            let banner = GrowingNotificationBanner(title: "Incomplete form", subtitle: "Please fill all required fields.", leftView: leftView, style: .warning)
            banner.haptic = .medium
            banner.show()
            showValidations = true
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ReloadTable"), object: nil)
            return
        }
        showValidations = false
            var symptomKeys = [String]()
            let dropDownSet = dataModel?.valueSet?["symptomSet"]
            for i in 0..<(dropDownSet?.count ?? 0) {
                let item = dropDownSet![i]
                symptomKeys.append(item.keys.first!)
            }
        print(template)
        let jsonData = try! JSONSerialization.data(withJSONObject: template, options: JSONSerialization.WritingOptions.prettyPrinted)
        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        print(jsonString)

        ERProgressHud.shared.show()
                    APIManager.sharedInstance.makeRequestToSaveTemplateInstance(data: jsonData){ (success, response,statusCode)  in
                        if (success) {
                            ERProgressHud.shared.hide()
                            print(response)
                            if statusCode == 200 {
                                print(response)
                                if var dataDic = response as? Dictionary<String, Any> {
                                    let recordID = dataDic["id"] as? String ?? ""
                                    let symtoms = dataDic["symptoms"] as? [String] ?? []
                                    dataDic.removeValue(forKey: "id")
                                    dataDic.removeValue(forKey: "symptoms")
                                    dataDic["record_id"] = recordID
                                    dataDic["project_id"] = recordID
                                    for key in symptomKeys {
                                        for sym in symtoms {
                                            if sym == key {
                                                dataDic[key] = 1
                                            } //else {
//                                                dataDic[key] = NSNull()
//                                            }
                                        }
                                    }
                                    print(dataDic)
                                    if let surveyData = survey_data as? Dictionary<String, Any> {
                                        var newDic = surveyData
                                        newDic.merge(dict: dataDic)
                                        print(newDic)
                                        // self.completeSurvey(surveyDetails: newDic)
                                        self.navigationController?.popViewController {
                                            self.delegate?.didSubmitSurvey(params: newDic)
                                        }
                                    }
                                }
                            }
                        } else {
                            APIManager.sharedInstance.showAlertWithMessage(message: ERROR_MESSAGE_DEFAULT)
                            ERProgressHud.shared.hide()
                        }
                    }
        
    }
    
    //Reset Template instance
    func resetTemplateInstance(template: [String:Any]) {
        print(template)
        let jsonData = try! JSONSerialization.data(withJSONObject: template, options: JSONSerialization.WritingOptions.prettyPrinted)
        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        print(jsonString)

        ERProgressHud.shared.show()
                    APIManager.sharedInstance.makeRequestToResetTemplateInstance(data: jsonData){ (success, response,statusCode)  in
                        if (success) {
                            ERProgressHud.shared.hide()
                            if statusCode == 200 {
                                print(response)
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ReloadAPI"), object: nil)

                        } else {
                            APIManager.sharedInstance.showAlertWithMessage(message: ERROR_MESSAGE_DEFAULT)
                            ERProgressHud.shared.hide()
                        }
                    }
                    }
    }


    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.panGestureRecognizer.translation(in: scrollView).y < 0 {
            NotificationCenter.default.post(name: Notification.Name("ReelSectionID"), object: nil,userInfo: ["hide" : true])
        } else {
            NotificationCenter.default.post(name: Notification.Name("ReelSectionID"), object: nil,userInfo: ["hide" : false])
        }
    }

// MARK: - UITableViewDataSource
func numberOfSections(in tableView: UITableView) -> Int {
//    return (ddcModel?.template?.entities?.count)!
    return (dataModel?.template?.sortedArray?.count)!
}

func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if dataModel?.template?.sortedArray?[section].value.type == .entityGroupRepeatable || dataModel?.template?.sortedArray?[section].value.type == .entityGroup {
        return dataModel?.template?.sortedArray?[section].value.sortedEntityGroupsArray?.count ?? 0
    }
    return 1
}

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if showHeader == false {
            return nil
        }
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: 50))
        let titleLabel = UILabel(frame: CGRect(x: 20, y: 0, width: self.tableView.frame.width - 40, height: 50))
        view.backgroundColor = headerBackgroundColor
        titleLabel.textColor = headerFontColor
        titleLabel.font = headerFont
        view.addSubview(titleLabel)
        if dataModel?.template?.sortedArray?[section].value.type == .entityGroupRepeatable || dataModel?.template?.sortedArray?[section].value.type == .entityGroup {
            titleLabel.text = dataModel?.template?.sortedArray?[section].value.title ?? ""
        } else {
            if section == 0 {
            titleLabel.text =  dataModel?.template?.title
            }
        }
        if dataModel?.template?.sortedArray?[section].value.type == .entityGroupRepeatable || dataModel?.template?.sortedArray?[section].value.type == .entityGroup {

            let button = UIButton()
                button.setBackgroundImage(UIImage.add.withTintColor(.blue), for: .normal)
                button.frame = CGRect(x: view.frame.maxX - 40, y: view.frame.midY - 17.5, width: 35, height: 35)
                button.addTarget(self, action: #selector(self.addButton(_:)), for: .touchUpInside)
                button.tag = section
                view.addSubview(button)


            if dataModel?.template?.entities?.count != 1 {
                let button = UIButton()
                button.setBackgroundImage(UIImage.remove.withTintColor(.red), for: .normal)
                button.frame = CGRect(x: view.frame.maxX - 40, y: view.frame.midY - 17.5, width: 35, height: 35)
                button.addTarget(self, action: #selector(self.removeButton(_:)), for: .touchUpInside)
                button.tag = section
                view.addSubview(button)

                let addbutton = UIButton()
                addbutton.setBackgroundImage(UIImage.add.withTintColor(.blue), for: .normal)
                addbutton.frame = CGRect(x: button.frame.origin.x - 40, y: view.frame.midY - 17.5, width: 35, height: 35)
                addbutton.addTarget(self, action: #selector(self.addButton(_:)), for: .touchUpInside)
                addbutton.tag = section
                view.addSubview(addbutton)
            }


        }
        return view
    }
    
    @objc func addButton(_ sender: UIButton) {
        print(sender.tag)
//        let data = ddcModel?.template?.entities![sender.tag]
        
//        let repeated  = Entity(type: data?.type, title: data?.title, active: data?.active, order: data?.order, guiControlType: data?.guiControlType, id: data?.id, value: data?.value, oldValue: data?.oldValue, lastUpdatedBy: data?.lastUpdatedBy, lastUpdatedDate: data?.lastUpdatedDate, uri: data?.uri, valueSetRef: data?.valueSetRef, settings: data?.settings, entityGroups: data?.entityGroups, isRepeated: true)
//
//        ddcModel?.template?.entities?.insert(repeated, at: sender.tag + 1)
//        self.tableView.reloadData()
//        self.tableView.scrollToRow(at: IndexPath(row: 0, section: sender.tag + 1), at: .middle, animated: true)
    }
    
    @objc func removeButton(_ sender: UIButton) {
        print(sender.tag)
//        ddcModel?.template?.entities?.remove(at: sender.tag)
//        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if showHeader == false {
            return 0
        }
        if dataModel?.template?.sortedArray?[section].value.type == .entityGroupRepeatable || dataModel?.template?.sortedArray?[section].value.type == .entityGroup {
            return 0
        } else {
        if section == 0 {
            return 50
        }
        }
        return 0
        
    }


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var data : Entity?
        if dataModel?.template?.sortedArray![indexPath.section].value.type == .entityGroupRepeatable {
//            data = ddcModel?.template?.entities![indexPath.section].entityGroups![0].entities![indexPath.row]
            return Utilities.shared.calculateGroupHeight(tableView: tableView, entityGroup: (dataModel?.template?.sortedArray![indexPath.section].value.sortedEntityGroupsArray?[indexPath.row].value)!, data: dataModel!)
        } else {
            data = dataModel?.template?.sortedArray![indexPath.section].value
        }
        if data!.type == .calculatedEntity {
            return 0
        }
            
        if data!.isHidden {
            return 0
        }
        let enumerationEntityfieldTypeIs = ComponentUtils.getEnumerationEntityFieldType(fieldData:data!)
        let textEntityFieldType = ComponentUtils.getTextEntryEntityFieldType(fieldData:data!)
        let messageEntityFieldType = ComponentUtils.getMeesageEntityFieldType(fieldData:data!)

        print(textEntityFieldType)
        if enumerationEntityfieldTypeIs == .radioButton {

//        let dropDownSet = ddcModel?.valueSet?.filter{ $0.refID!.localizedCaseInsensitiveContains((data!.valueSetRef)!)}
        let dropDownSet = dataModel?.valueSet?[(data!.valueSetRef!)]

        let dynamicHeightforRadioCell = dropDownSet!.count * 50 + 51 + 22

            return CGFloat(dynamicHeightforRadioCell) + ComponentUtils.getResetHeight() + ComponentUtils.getErrorMessageHeight(entity: data!) + (data!.attributedTitleHeight - 20.5)
      } else  if enumerationEntityfieldTypeIs == .checkBox {

//        let dropDownSet = ddcModel?.valueSet?.filter{ $0.refID!.localizedCaseInsensitiveContains((data!.valueSetRef)!)}
//
          let dropDownSet = dataModel?.valueSet?[(data!.valueSetRef!)]
        let dynamicHeightforRadioCell = dropDownSet!.count * 50 + 51 + 22

          return CGFloat(dynamicHeightforRadioCell) + ComponentUtils.getResetHeight() + ComponentUtils.getErrorMessageHeight(entity: data!) + (data!.attributedTitleHeight - 20.5)
      } else if enumerationEntityfieldTypeIs == .dropDownField {
          
          return 85 + ComponentUtils.getResetHeight() + ComponentUtils.getErrorMessageHeight(entity: data!)//100//UITableView.automaticDimension

       } else if textEntityFieldType == .textareaField {
        return 200 + ComponentUtils.getResetHeight() + ComponentUtils.getErrorMessageHeight(entity: data!)//UITableView.automaticDimension
       } else if textEntityFieldType == .datePicker {
           
           return 91 + ComponentUtils.getResetHeight() + ComponentUtils.getErrorMessageHeight(entity: data!)//UITableView.automaticDimension
       } else if messageEntityFieldType == .messageField {
//           if indexPath.section == 0 {return 50}
           return (data!.attributedTitleHeight + 20)//200 //+ ComponentUtils.getResetHeight() + ComponentUtils.getErrorMessageHeight(entity: data!)//UITableView.automaticDimension
       } else if textEntityFieldType == .timePicker {
           return 91 + ComponentUtils.getResetHeight() + ComponentUtils.getErrorMessageHeight(entity: data!)//UITableView.automaticDimension
       } else if textEntityFieldType == .picker {
           return 91 + ComponentUtils.getResetHeight() + ComponentUtils.getErrorMessageHeight(entity: data!)//UITableView.automaticDimension
       } else if textEntityFieldType == .slider {
           return 85 + ComponentUtils.getResetHeight() + ComponentUtils.getErrorMessageHeight(entity: data!) //UITableView.automaticDimension
       } else if textEntityFieldType == .lineeditField {
           return 85 + ComponentUtils.getResetHeight()  + ComponentUtils.getErrorMessageHeight(entity: data!)//UITableView.automaticDimension
       } else if textEntityFieldType == .toggleSwitch {
           return 85 + ComponentUtils.getResetHeight() + ComponentUtils.getErrorMessageHeight(entity: data!) //UITableView.automaticDimension
       } else if textEntityFieldType == .autocomplete {
           return 85 + ComponentUtils.getResetHeight() + ComponentUtils.getErrorMessageHeight(entity: data!) //UITableView.automaticDimension
       }

        return 100
}
    
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

let cellIdentifier = "DefaultCell"

var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
if cell == nil {
    cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
}
//if indexPath.section == 0 {
  
    if dataModel != nil {
        var data : Entity?
        if dataModel?.template?.sortedArray![indexPath.section].value.type == .entityGroupRepeatable {
//            data = ddcModel?.template?.entities![indexPath.section].entityGroups![0].entities![indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "RepeatableTableViewCell", for: indexPath) as! RepeatableTableViewCell
            cell.setupRepeatableGroupCell(entityGroup: (dataModel?.template?.sortedArray![indexPath.section].value.sortedEntityGroupsArray![indexPath.row].value)!, data:dataModel!, parentEntityGroupId: (dataModel?.template?.sortedArray![indexPath.section].value.sortedEntityGroupsArray![indexPath.row].value.uniqueId)!)
            
            cell.setupHeaderView(entityGroup: (dataModel?.template?.sortedArray![indexPath.section].value.sortedEntityGroupsArray![indexPath.row])!.value, groupCount: dataModel?.template?.sortedArray![indexPath.section].value.sortedEntityGroupsArray!.count ?? 0, sectionIndex: 0)
            cell.ddcModel = self.dataModel
            return cell
        } else {
            data = dataModel?.template?.sortedArray![indexPath.section].value
        }
        if data?.type  == .textEntryEntity {
            let fieldTypeIs = ComponentUtils.getTextEntryEntityFieldType(fieldData:data!)
            if fieldTypeIs == .lineeditField {

                let cell = tableView.dequeueReusableCell(withIdentifier: "TextfieldComponent", for: indexPath) as! TextfieldComponent
//                cell.uriLbl.attributedText = NSAttributedString(string: (data?.uri)!, attributes:
//                    [.underlineStyle: NSUnderlineStyle.single.rawValue])
                cell.uriLbl.attributedText = data?.title?.htmlToAttributedString
                cell.textField.setBottomBorder()
                cell.textField.placeholder = "Enter " + (data?.uri)!
                cell.setUpTextFieldCell(data: dataModel!, entity: data!,indexPath: indexPath, entityGroupId: dataModel?.template?.uniqueId ?? "")
                cell.ddcModel = self.dataModel
                return cell

        } else if fieldTypeIs == .textareaField {

                let cell = tableView.dequeueReusableCell(withIdentifier: "TextViewTableViewCell", for: indexPath) as! TextViewTableViewCell
//                cell.uriLbl.attributedText = NSAttributedString(string: (data?.uri)!, attributes:
//                    [.underlineStyle: NSUnderlineStyle.single.rawValue])
            cell.uriLbl.attributedText = data?.title?.htmlToAttributedString

            cell.setUpTextViewAreaCell(data: dataModel!, entity: data!,indexPath: indexPath, entityGroupId: dataModel?.template?.uniqueId ?? "")
            cell.ddcModel = self.dataModel

                return cell

        } else if fieldTypeIs == .datePicker {

                   let cell = tableView.dequeueReusableCell(withIdentifier: "DatePickerTableViewCell", for: indexPath) as! DatePickerTableViewCell
//                   cell.uriLbl.attributedText = NSAttributedString(string: (data?.uri)!, attributes:
//                       [.underlineStyle: NSUnderlineStyle.single.rawValue])
            cell.uriLbl.attributedText = data?.title?.htmlToAttributedString
            cell.setUpDatePickerCell(data: dataModel!, entity: data!,indexPath: indexPath, entityGroupId: dataModel?.template?.uniqueId ?? "")
            cell.ddcModel = self.dataModel

                   return cell

        } else if fieldTypeIs == .timePicker {

            let cell = tableView.dequeueReusableCell(withIdentifier: "TimePickerTableViewCell", for: indexPath) as! TimePickerTableViewCell
//            cell.uriLbl.attributedText = NSAttributedString(string: (data?.uri)!, attributes:
//                           [.underlineStyle: NSUnderlineStyle.single.rawValue])
            cell.uriLbl.attributedText = data?.title?.htmlToAttributedString
            cell.setUpTimePickerCell(data: dataModel!, entity: data!,indexPath: indexPath, entityGroupId: dataModel?.template?.uniqueId ?? "")
            cell.ddcModel = self.dataModel

            return cell

        } else if fieldTypeIs == .picker {

            let cell = tableView.dequeueReusableCell(withIdentifier: "PickerTableViewCell", for: indexPath) as! PickerTableViewCell
//            cell.uriLbl.attributedText = NSAttributedString(string: (data?.uri)!, attributes:
//                           [.underlineStyle: NSUnderlineStyle.single.rawValue])
            cell.uriLbl.attributedText = data?.title?.htmlToAttributedString
            cell.setupPickerCell(data: dataModel!, entity: data!,indexPath: indexPath, entityGroupId: dataModel?.template?.uniqueId ?? "")
            cell.ddcModel = self.dataModel
            return cell

        }
            else if fieldTypeIs == .slider {

               let cell = tableView.dequeueReusableCell(withIdentifier: "SliderTableViewCell", for: indexPath) as! SliderTableViewCell
//               cell.uriLbl.attributedText = NSAttributedString(string: (data?.uri)!, attributes:
//                              [.underlineStyle: NSUnderlineStyle.single.rawValue])
                cell.uriLbl.attributedText = data?.title?.htmlToAttributedString
                cell.setupSliderCell(data: dataModel!, entity: data!,indexPath: indexPath, entityGroupId: dataModel?.template?.uniqueId ?? "")
                cell.ddcModel = self.dataModel
               return cell

           } else if fieldTypeIs == .toggleSwitch {
               
               let cell = tableView.dequeueReusableCell(withIdentifier: "ToggleSwitchTableViewCell", for: indexPath) as! ToggleSwitchTableViewCell
//               cell.uriLbl.attributedText = NSAttributedString(string: (data?.uri)!, attributes:
//                              [.underlineStyle: NSUnderlineStyle.single.rawValue])
                cell.uriLbl.attributedText = data?.title?.htmlToAttributedString
                cell.setupSliderCell(data: dataModel!, entity: data!,indexPath: indexPath, entityGroupId: dataModel?.template?.uniqueId ?? "")
               cell.ddcModel = self.dataModel
               return cell

           } else if fieldTypeIs == .autocomplete {
               
               let cell = tableView.dequeueReusableCell(withIdentifier: "AutocompleteTableViewCell", for: indexPath) as! AutocompleteTableViewCell
//                cell.uriLbl.attributedText = NSAttributedString(string: (data?.uri)!, attributes:
//                    [.underlineStyle: NSUnderlineStyle.single.rawValue])
               cell.uriLbl.attributedText = data?.title?.htmlToAttributedString
               cell.textField.setBottomBorder()
               cell.setUpTextFieldCell(data: dataModel!, entity: data!,indexPath: indexPath, entityGroupId: dataModel?.template?.uniqueId ?? "")
               cell.ddcModel = self.dataModel
               return cell
       }


        } else if data?.type  == .enumerationEntity {
            let fieldTypeIs = ComponentUtils.getEnumerationEntityFieldType(fieldData:data!)
            if fieldTypeIs == .dropDownField {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DropDownTableViewCell", for: indexPath) as! DropDownTableViewCell
              //  cell.uriLbl.attributedText = NSAttributedString(string: (data?.uri)!, attributes:
                //    [.underlineStyle: NSUnderlineStyle.single.rawValue])
                cell.uriLbl.attributedText = data?.title?.htmlToAttributedString

                cell.setUpDropDownCell(data: dataModel!, entity: data!,indexPath: indexPath, entityGroupId: dataModel?.template?.uniqueId ?? "")
                cell.ddcModel = self.dataModel
                return cell
        } else if fieldTypeIs == .radioButton {
                let cell = tableView.dequeueReusableCell(withIdentifier: "RadioButtonTableViewCell", for: indexPath) as! RadioButtonTableViewCell
              // cell.uriLbl.attributedText = NSAttributedString(string: (data?.uri)!, attributes:
             //      [.underlineStyle: NSUnderlineStyle.single.rawValue])
            cell.uriLbl.attributedText = data?.title?.htmlToAttributedString

            cell.setUpRadioCell(data: dataModel!, entity: data!,indexPath: indexPath, entityGroupId: dataModel?.template?.uniqueId ?? "")
            cell.ddcModel = self.dataModel
                return cell
        } else if fieldTypeIs == .checkBox {
                 let cell = tableView.dequeueReusableCell(withIdentifier: "CheckBoxTableViewCell", for: indexPath) as! CheckBoxTableViewCell
//                cell.uriLbl.attributedText = NSAttributedString(string: (data?.uri)!, attributes:
//                    [.underlineStyle: NSUnderlineStyle.single.rawValue])
            cell.uriLbl.attributedText = data?.title?.htmlToAttributedString
            cell.setUpCheckBoxCell(data: dataModel!, entity: data!,indexPath: indexPath, entityGroupId: dataModel?.template?.uniqueId ?? "")
            cell.ddcModel = self.dataModel
                 return cell
        }
        }
            else if data?.type  == .messageEntity {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MessageTableViewCell", for: indexPath) as! MessageTableViewCell
//               cell.uriLbl.attributedText = NSAttributedString(string: (data?.uri)!, attributes:
//                   [.underlineStyle: NSUnderlineStyle.single.rawValue])
                cell.setUpMessageCell(data: dataModel!, entity: data!,indexPath: indexPath,tableView: self.tableView)
                return cell
        }


//    }
}

    return cell!
}

// MARK: - UITableViewDelegate
func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

}
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            self.cellHeightsDictionary[indexPath] = cell.frame.size.height
        }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
            if let height =  self.cellHeightsDictionary[indexPath]{
                return height
            }
        return UITableView.automaticDimension
        }

    /// Title height
    
    func heightForTitle(text:String, font:UIFont, width:CGFloat) -> CGFloat {
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text

        label.sizeToFit()
        return label.frame.height
    }
}
