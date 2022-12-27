//
//  PickerTableViewCell.swift
//  Compan
//
//  Created by Ambu Sangoli on 5/24/22.
//

import UIKit

class PickerTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var uriLbl: UILabel!
    @IBOutlet weak var resetBtn: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var errorLabelHeight: NSLayoutConstraint!


    var valuePicker = UIPickerView()
    var data : DDCFormModel?
    var indexPath : IndexPath?

    var entity : Entity?
    var entityGroupId: String = ""
    var parentEntityGroupId = ""
    var groupOrder = 0


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        textField.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var values = [String]()
    
    func setupPickerCell(data: DDCFormModel,entity: Entity, indexPath: IndexPath ,entityGroupId: String,parentEntityGroupId:String = "99",groupOrder: Int = 0) {
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
        self.textField.text = dataa?.value?.value as? String
        if let value = dataa?.value?.value as? String {
            self.textField.text = value
        } else if let value = dataa?.value?.value as? Double {
            self.textField.text = String(value)
        }
        
        if let entity = dataa {
            let minValue = Double(entity.settings?.min ?? 0)
            let maxValue = Double(entity.settings?.max ?? 0)
            let step = Double(entity.settings?.step ?? 0)

//            let array = (minValue...maxValue).map { $0 }
            let myArray = Array(stride(from: minValue, through: maxValue, by: step))
            print(myArray)
            for i in myArray {
                
                self.values.append(String(i.rounded(toPlaces: 1)))
            }
        }
        
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneBtn = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(done))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPickerView))
        toolbar.setItems([cancelButton,spaceButton,doneBtn], animated: false)
        textField.inputAccessoryView = toolbar
        textField.inputView = valuePicker
        valuePicker.delegate = self
        valuePicker.dataSource = self
        
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
    
    @objc func done(){
        self.endEditing(true)
//        RequestHelper.shared.createRequestForEntity(data: self.data!, index: self.indexPath!, newValue: self.textField.text!)
        RequestHelper.shared.createRequestForEntity(entity: self.entity!, newValue: self.textField.text!, entityGroupId: entityGroupId,parentEntityGroupId: parentEntityGroupId,groupOrder: groupOrder)
    }
    
    @objc func cancelPickerView(){
        self.endEditing(true)
    }
    
    
    @IBAction func resetBtn(_ sender: Any) {
        RequestHelper.shared.createRequestForEntity(entity: self.entity!, newValue: "", entityGroupId: entityGroupId,parentEntityGroupId: parentEntityGroupId,groupOrder: groupOrder)
    }
}


extension PickerTableViewCell : UIPickerViewDelegate,UIPickerViewDataSource  {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return values.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            if row == 0{
                if (textField.text!.isEmpty){
                self.textField.text = self.values[row]
                }
            }
            return values[row]
        
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            self.textField.text = self.values[row]
      
    }
    
}
