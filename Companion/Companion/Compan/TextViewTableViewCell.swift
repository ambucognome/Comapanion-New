//
//  TextViewTableViewCell.swift
//  Compan
//
//  Created by Ambu Sangoli on 23/05/22.
//

import UIKit

class TextViewTableViewCell: UITableViewCell,UITextViewDelegate {

    @IBOutlet weak var uriLbl: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var resetBtn: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var errorLabelHeight: NSLayoutConstraint!

    
    var data : DDCFormModel?
    var indexPath : IndexPath?
    var entity : Entity?
    var entityGroupId: String = ""
    var parentEntityGroupId = ""
    var groupOrder = 0


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setUpTextViewAreaCell(data: DDCFormModel,entity: Entity, indexPath: IndexPath ,entityGroupId: String,parentEntityGroupId:String = "99",groupOrder: Int = 0) {
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
        self.textView.text = "Enter " + (dataa!.title)!
        self.textView.textColor = UIColor.lightGray
        if let value = dataa?.value?.value as? String, value != "" {
            self.textView.text = value
            self.textView.textColor = UIColor.black
        }
        self.textView.delegate = self
        self.textView.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        self.textView.layer.borderWidth = 1.0
        self.textView.layer.cornerRadius = 5
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
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {

        if textView.textColor == UIColor.lightGray {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    var ddcModel: DDCFormModel?

    
    func textViewDidEndEditing(_ textView: UITextView) {

        if textView.text == "" {
            self.textView.text = "Enter " + (entity!.title)!
            self.textView.textColor = UIColor.lightGray
        } else {
//            RequestHelper.shared.createRequestForEntity(data: self.data!, index: self.indexPath!, newValue: textView.text!)
            RequestHelper.shared.createRequestForEntity(entity: self.entity!, newValue: textView.text!, entityGroupId: entityGroupId,parentEntityGroupId: parentEntityGroupId,groupOrder: groupOrder,dataModel: self.ddcModel)
        }
    }
    
    @IBAction func resetBtn(_ sender: Any) {
        RequestHelper.shared.createRequestForEntity(entity: self.entity!, newValue: "", entityGroupId: entityGroupId,parentEntityGroupId: parentEntityGroupId,groupOrder: groupOrder, dataModel: self.ddcModel)
    }
}
