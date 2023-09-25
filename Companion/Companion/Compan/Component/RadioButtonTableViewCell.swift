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

    var data : DDCFormModell?
    var indexPath : IndexPath?
    var entity : Entity?
    var entityGroupId: String = ""

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
    
    func setUpRadioCell(data: DDCFormModell,entity: Entity, indexPath: IndexPath) {
        self.isUserInteractionEnabled = true
        if isReadOnly {
            self.isUserInteractionEnabled = false
        }
        self.entity = entity
        self.data = data
        self.indexPath = indexPath

        var selectedIndex : Int?

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
        
        for i in 0..<( dropDownSet?.valueSetData?.count ?? 0) {
            let item = dropDownSet!.valueSetData![i]
            fieldValueArray.append(item.value!)
            fieldIDArray.append(item.uri!)
            if item.uri == valueData {
                selectedIndex = i
            }
        }
        
        self.fieldValueArray = fieldValueArray
        self.fieldIdArray = fieldIDArray
        
        selectionList.items = fieldValueArray

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
//        print(selectionList.selectedIndexes)
        let newValue = self.fieldIdArray[selectionList.selectedIndex ?? 0]
        if newValue == "" { return }
        print(newValue)
        NewRequestHelper.shared.updateEntityValue(entity: self.entity!, value: newValue)
    }
    
    
    @IBAction func resetBtn(_ sender: Any) {
//        RequestHelper.shared.createRequestForEntity(entity: self.entity!, newValue: "", entityGroupId: entityGroupId,parentEntityGroupId: parentEntityGroupId,groupOrder: groupOrder,dataModel: self.ddcModel)
    }

}
