//
//  RadioButtonTableViewCell.swift
//  Compan
//
//  Created by Ambu Sangoli on 16/05/22.
//

import UIKit
import SelectionList

class RadioButtonTableViewCell: UITableViewCell {

    @IBOutlet var selectionList: SelectionList!
    @IBOutlet weak var uriLbl: UILabel!
    @IBOutlet weak var resetBtn: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var errorLabelHeight: NSLayoutConstraint!

    var data : DDCFormModel?
    var indexPath : IndexPath?
    var entity : Entity?
    var entityGroupId: String = ""

    var fieldValueArray = [String]()
    var fieldIdArray = [String]()
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
    
    func setUpRadioCell(data: DDCFormModel,entity: Entity, indexPath: IndexPath ,entityGroupId: String,parentEntityGroupId:String = "99",groupOrder: Int = 0) {
        self.isUserInteractionEnabled = true
        if isReadOnly {
            self.isUserInteractionEnabled = false
        }
        self.entityGroupId = entityGroupId
        self.entity = entity
        self.data = data
        self.indexPath = indexPath
        let dataa : Entity? = entity
        self.parentEntityGroupId = parentEntityGroupId
        self.groupOrder = groupOrder

//        if data.template?.entities![indexPath.section].type == .entityGroupRepeatable {
//            dataa = data.template?.entities![indexPath.section].entityGroups![0].entities![indexPath.row]
//        } else {
//            dataa = data.template?.entities![indexPath.section]
//        }
             



        var selectedIndex : Int?

        var fieldValueArray = [String]()
        var fieldIDArray = [String]()

        let dropDownSet = data.valueSet?[(dataa?.valueSetRef!)!]
        for i in 0..<(dropDownSet?.count ?? 0) {
            let item = dropDownSet![i]
            fieldValueArray.append(item.values.first!)
            fieldIDArray.append(item.keys.first!)
            
            if item.keys.first! == dataa?.value?.value as? String {
                selectedIndex = i
            }
        }
        
        self.fieldValueArray = fieldValueArray
        self.fieldIdArray = fieldIDArray
        
        selectionList.items = fieldValueArray
//        selectionList.selectedIndexes = []

        selectionList.allowsMultipleSelection = false
        selectionList.tableView.isScrollEnabled = false
        selectionList.rowHeight = 50
        selectionList.addTarget(self, action: #selector(selectionChanged), for: .valueChanged)
        selectionList.setupCell = { (cell: UITableViewCell, _: Int) in
            cell.textLabel?.textColor = .gray
        }
        if let index = selectedIndex {
            selectionList.selectedIndex = index
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

    var ddcModel: DDCFormModel?

    @objc func selectionChanged() {
//        print(selectionList.selectedIndexes)
        let newValue = self.fieldIdArray[selectionList.selectedIndex ?? 0]
        if newValue == "" { return }
//        RequestHelper.shared.createRequestForEntity(data: self.data!, index: self.indexPath!, newValue: newValue)
        RequestHelper.shared.createRequestForEntity(entity: self.entity!, newValue: newValue, entityGroupId: entityGroupId,parentEntityGroupId: parentEntityGroupId,groupOrder: groupOrder,dataModel: self.ddcModel)

    }
    
    
    @IBAction func resetBtn(_ sender: Any) {
        RequestHelper.shared.createRequestForEntity(entity: self.entity!, newValue: "", entityGroupId: entityGroupId,parentEntityGroupId: parentEntityGroupId,groupOrder: groupOrder,dataModel: self.ddcModel)
    }

}
