//
//  DatePickerTableViewCell.swift
//  Compan
//
//  Created by Ambu Sangoli on 23/05/22.
//

import UIKit

class DatePickerTableViewCell: UITableViewCell, UITextFieldDelegate {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var uriLbl: UILabel!
    @IBOutlet weak var resetBtn: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var errorLabelHeight: NSLayoutConstraint!

    var ddcModel: DDCFormModel?

    
    let datePicker = DatePickerDialog()
    
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
    
    func setUpDatePickerCell(data: DDCFormModel,entity: Entity, indexPath: IndexPath,entityGroupId: String,parentEntityGroupId:String = "99",groupOrder: Int = 0) {
        self.isUserInteractionEnabled = true
        if isReadOnly {
            self.isUserInteractionEnabled = false
        }
        self.entityGroupId = entityGroupId
        self.data = data
        self.indexPath = indexPath
        let dataa : Entity? = entity
        self.entity = entity
        self.parentEntityGroupId = parentEntityGroupId
        self.groupOrder = groupOrder

//        if data.template?.entities![indexPath.section].type == .entityGroupRepeatable {
//            dataa = data.template?.entities![indexPath.section].entityGroups![0].entities![indexPath.row]
//        } else {
//            dataa = data.template?.entities![indexPath.section]
//        }
        
        self.textField.text = dataa?.value?.value as? String ?? ""
        self.textField.placeholder = "Select \(dataa?.title ?? "")"
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
    
    func datePickerTapped() {
        let currentDate = Date()
        var dateComponents = DateComponents()
        dateComponents.month = -3
        let threeMonthAgo = Calendar.current.date(byAdding: dateComponents, to: currentDate)
        datePicker.show("Select Date",
                        doneButtonTitle: "Done",
                        cancelButtonTitle: "Cancel",
                        minimumDate: nil,
                        maximumDate: nil,
                        datePickerMode: .date) { (date) in
            if let dt = date {
                let formatter = DateFormatter()
                formatter.dateFormat = "dd/MM/YYYY"
                self.textField.text = formatter.string(from: dt)
//                RequestHelper.shared.createRequestForEntity(data: self.data!, index: self.indexPath!, newValue: self.textField.text!)
                RequestHelper.shared.createRequestForEntity(entity: self.entity!, newValue: self.textField.text!, entityGroupId: self.entityGroupId,parentEntityGroupId: self.parentEntityGroupId,groupOrder: self.groupOrder, dataModel: self.ddcModel)

                
            }
        }
    }
    
    //MARK: Textfield Delegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.textField {
            datePickerTapped()
            return false
        }
        return true
    }
    
    @IBAction func resetBtn(_ sender: Any) {
        RequestHelper.shared.createRequestForEntity(entity: self.entity!, newValue: "", entityGroupId: entityGroupId,parentEntityGroupId: parentEntityGroupId,groupOrder: groupOrder, dataModel: self.ddcModel)
    }
}



extension UITextField {
    func addBottomBorder(){
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: self.frame.size.height - 1, width: self.frame.size.width, height: 1)
        bottomLine.backgroundColor = UIColor.black.cgColor
        borderStyle = .none
        layer.addSublayer(bottomLine)
    }
}


class UnderlinedTextField: UITextField {
    private let defaultUnderlineColor = UIColor.black
    private let bottomLine = UIView()

    override func awakeFromNib() {
        super.awakeFromNib()

        borderStyle = .none
        bottomLine.translatesAutoresizingMaskIntoConstraints = false
        bottomLine.backgroundColor = defaultUnderlineColor

        self.addSubview(bottomLine)
        bottomLine.topAnchor.constraint(equalTo: self.bottomAnchor, constant: 1).isActive = true
        bottomLine.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        bottomLine.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        bottomLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }

    public func setUnderlineColor(color: UIColor = .red) {
        bottomLine.backgroundColor = color
    }

    public func setDefaultUnderlineColor() {
        bottomLine.backgroundColor = defaultUnderlineColor
    }
}
