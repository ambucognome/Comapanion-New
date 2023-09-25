//
//  CheckBoxTableViewCell.swift
//  Compan
//
//  Created by Ambu Sangoli on 23/05/22.
//

//
//  RadioButtonTableViewCell.swift
//  Compan
//
//  Created by Ambu Sangoli on 16/05/22.
//

import UIKit
import SelectionList

class CheckBoxTableViewCell: UITableViewCell {

    @IBOutlet var selectionList: SelectionList!
    @IBOutlet weak var uriLbl: UILabel!
    @IBOutlet weak var resetBtn: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var errorLabelHeight: NSLayoutConstraint!

    var data : DDCFormModell?
    var indexPath : IndexPath?
    var entity : Entity?
    var fieldValueArray = [String]()
    var fieldIdArray = [String]()


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUpCheckBoxCell(data: DDCFormModell,entity: Entity, indexPath: IndexPath) {
        self.isUserInteractionEnabled = true
        if isReadOnly {
            self.isUserInteractionEnabled = false
        }
        self.entity = entity
        self.data = data
        self.indexPath = indexPath


        var fieldValueArray = [String]()
        var fieldIDArray = [String]()
        var selectedIndex: [Int]? = []

        
        var dropDownSet : ValueSet?
        for valueSet in data.valueSets ?? [] {
            if valueSet.id == entity.valueSetID {
                dropDownSet = valueSet
            }
        }
        
        var valueArray = [String]()
        if let instrumentsData = instruments?.entities {
            for instrument in instrumentsData {
                if instrument.entityTemplateID == entity.id  ?? "" {
                    if let value = instrument.value {
                        let values = value.components(separatedBy: ",")
                        valueArray = values
                    }
                }
            }
        }
        
        
        for i in 0..<( dropDownSet?.valueSetData?.count ?? 0) {
            let item = dropDownSet!.valueSetData![i]
            fieldValueArray.append(item.value!)
            fieldIDArray.append(item.uri!)
            for value in valueArray {
                if item.uri == value {
                    selectedIndex?.append(i)
                }
            }

        }
        
        
        self.fieldValueArray = fieldValueArray
        self.fieldIdArray = fieldIDArray


        //Set title
        //uriLbl.text = data.template?.entities?[index].uri
        selectionList.tableView.isScrollEnabled = false
        selectionList.rowHeight = 50
        selectionList.items = fieldValueArray
        selectionList.allowsMultipleSelection = true
        selectionList.addTarget(self, action: #selector(selectionChanged), for: .valueChanged)
        selectionList.setupCell = { (cell: UITableViewCell, _: Int) in
            cell.textLabel?.textColor = .gray
        }
        if let indexes = selectedIndex {
            selectionList.selectedIndexes = indexes
        }
        
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
    var ddcModel: DDCFormModell?

    @objc func selectionChanged() {
        print(selectionList.selectedIndexes)
        var values = [String]()
        for index in selectionList.selectedIndexes {
//            if self.fieldValueArray[index].lowercased() == "none" {
//                values = [self.fieldIdArray[index]]
//            } else {
                values.append(self.fieldIdArray[index])
//            }
        }
        print(values)
        let valueString = values.joined(separator: ",")
        NewRequestHelper.shared.updateEntityValue(entity: self.entity!, value: valueString)

    }
    
    @IBAction func resetBtn(_ sender: Any) {
//        RequestHelper.shared.createRequestForEntity(entity: self.entity!, newValue: "", entityGroupId: entityGroupId,parentEntityGroupId: parentEntityGroupId,groupOrder: groupOrder, dataModel: self.ddcModel)
    }
    
}


