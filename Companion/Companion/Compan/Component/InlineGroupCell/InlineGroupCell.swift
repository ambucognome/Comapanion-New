//
//  InlineGroupCell.swift
//  ddcv2
//
//  Created by Ambu Sangoli on 31/09/23.
//

import UIKit

class InlineGroupCell: UITableViewCell {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerViewHeight: NSLayoutConstraint!

    @IBOutlet weak var tableView: UITableView!
    
    var entityGroup : Entity?
    var parentEntityGroupId : String = ""
    
    var ddcModel: DDCFormModell?


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = .red
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupRepeatableGroupCell(entityGroup: Entity,data: DDCFormModell,parentEntityGroupId: String) {
        self.parentEntityGroupId = parentEntityGroupId
        self.entityGroup = entityGroup
        self.registerCells()
        
    }
    
    func setupHeaderView(entityGroup: Entity,groupCount: Int, sectionIndex: Int){
//        if showHeader == false {
//            self.headerViewHeight.constant = 0
//            return
//        }
        self.headerViewHeight.constant = 50
        for v in headerView.subviews {
            v.removeFromSuperview()
        }
        headerView.backgroundColor = UIColor(red: 168.0/255.0, green: 219.0/255.0, blue: 205.0/255.0, alpha: 1)
        let titleLabel = UILabel(frame: CGRect(x: 20, y: 0, width: self.tableView.frame.width - 40, height: 50))
        titleLabel.textColor = .white
        headerView.addSubview(titleLabel)
        titleLabel.text =  entityGroup.label
//        headerView.backgroundColor = headerBackgroundColor
//        titleLabel.textColor = headerFontColor
//        titleLabel.font = headerFont



//        if entityGroup.sortedEntitiesArray?[sectionIndex].value.type == .entityGroupRepeatable || entityGroup.sortedEntitiesArray?[sectionIndex].value.type == .entityGroup {
//            titleLabel.text = entityGroup.sortedEntitiesArray?[sectionIndex].value.title
//        }
        
    }

    
    
    func registerCells(){
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "DefaultCell")
        //Register cell for using in tableview
        let frameworkBundle = Bundle(for: DynamiccTemplateViewController.self)

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
        self.tableView.reloadData()
        
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
    }
    
}

extension InlineGroupCell: UITableViewDelegate, UITableViewDataSource {
                   
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return (self.entityGroup?.entities?.count) ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if self.entityGroup?.sortedEntitiesArray?[section].value.type == .entityGroupRepeatable ||  self.entityGroup?.sortedEntitiesArray?[section].value.type == .entityGroup {
//            return entityGroup?.sortedEntitiesArray?[section].value.sortedEntityGroupsArray?.count ?? 0
//        }
        return 1
    }
        

        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//            if self.entityGroup?.sortedEntitiesArray?[section].value.type == .entityGroupRepeatable || self.entityGroup?.sortedEntitiesArray?[section].value.type == .entityGroup {
//                return 0
//            } else {
//            if section == 0 {
//                return 0
//            }
//            }
            return 0
            
        }


        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            var data : Entity?

            data = self.entityGroup?.entities![indexPath.section]
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

                return CGFloat(dynamicHeightforRadioCell)
                //return 700
          } else  if enumerationEntityfieldTypeIs == .checkBox {

                    var dropDownSet : ValueSet?
                    for valueSet in ddcModel!.valueSets ?? [] {
                        if valueSet.id == data!.valueSetID {
                            dropDownSet = valueSet
                        }
                    }
                    let dynamicHeightforRadioCell = dropDownSet!.valueSetData!.count * 50 + 80

                return CGFloat(dynamicHeightforRadioCell)
                //return 700

          } else if enumerationEntityfieldTypeIs == .dropDownField {
              return 100
           } else if textEntityFieldType == .textareaField {
            return 200//UITableView.automaticDimension
           }
            else if textEntityFieldType == .datePicker {
               return 100//UITableView.automaticDimension
           } else if messageEntityFieldType == .messageField {
               return 100//UITableView.automaticDimension
           } else if textEntityFieldType == .timePicker {
               return 100//UITableView.automaticDimension
           } else if textEntityFieldType == .picker {
               return 100//UITableView.automaticDimension
           } else if textEntityFieldType == .slider {
               return 100//UITableView.automaticDimension
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
//            if ddcModel?.entities![indexPath.section].entityType == .entityGroupRepeatable {
//                let cell = tableView.dequeueReusableCell(withIdentifier: "RepeatableTableViewCell", for: indexPath) as! RepeatableTableViewCell
//                cell.setupRepeatableGroupCell(entityGroup: (ddcModel?.entities![indexPath.section].entityGroup!)!, data:ddcModel!, parentEntityGroupId: (ddcModel?.entities![indexPath.section].entityGroup!.parentEntityTemplateID)!)
//
//                cell.setupHeaderView(entityGroup: (ddcModel?.entities![indexPath.section].entityGroup!)!, groupCount: 1, sectionIndex: 0)
//                cell.ddcModel = ddcModel
//                return cell
//            } else {
            data = self.entityGroup?.entities?[indexPath.section]
//            }
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
    
}

