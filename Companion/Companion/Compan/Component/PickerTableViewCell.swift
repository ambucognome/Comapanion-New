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
    var data : DDCFormModell?
    var indexPath : IndexPath?

    var entity : Entity?

    var ddcModel: DDCFormModell?

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
    
    func setupPickerCell(data: DDCFormModell,entity: Entity, indexPath: IndexPath) {
        self.isUserInteractionEnabled = true
        if isReadOnly {
            self.isUserInteractionEnabled = false
        }
        self.entity = entity
        self.data = data
        self.indexPath = indexPath
        let dataa : Entity? = entity
        
        if let instrumentsData = instruments?.entities {
            for instrument in instrumentsData {
                if instrument.entityTemplateID == entity.id  ?? "" {
                    if let value = instrument.value {
                        self.textField.text! = value
                    }
                }
            }
        }
        
        if let entity = dataa {
            let minValue = Double(entity.settings?.min ?? "") ?? 0
            let maxValue = Double(entity.settings?.max ?? "") ?? 0
            let step = Double(entity.settings?.step ?? "") ?? 0

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
        
//        self.resetBtn.isHidden = true
//        if isResetAvailable {
//            self.resetBtn.isHidden = false
//    }
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
        NewRequestHelper.shared.updateEntityValue(entity: self.entity!, value: self.textField.text!)
    }
    
    @objc func cancelPickerView(){
        self.endEditing(true)
    }
    
    
    @IBAction func resetBtn(_ sender: Any) {
//        RequestHelper.shared.createRequestForEntity(entity: self.entity!, newValue: "", entityGroupId: entityGroupId,parentEntityGroupId: parentEntityGroupId,groupOrder: groupOrder, dataModel: self.ddcModel)
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
