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

    
    var data : DDCFormModell?
    var indexPath : IndexPath?
    var entity : Entity?


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setUpTextViewAreaCell(data: DDCFormModell,entity: Entity, indexPath: IndexPath) {
        self.isUserInteractionEnabled = true
        if isReadOnly {
            self.isUserInteractionEnabled = false
        }
        self.entity = entity
        self.data = data
        self.indexPath = indexPath

        self.textView.text = "Enter " + (entity.label)!
        self.textView.textColor = UIColor.lightGray
        if let instrumentsData = instruments?.entities {
            for instrument in instrumentsData {
                if instrument.entityTemplateID == entity.id  ?? "" {
                    if let value = instrument.value {
                        self.textView.text! = value
                    }
                }
            }
        }
        if !(self.textView.text.isEmpty) {
            self.textView.textColor = UIColor.black
        }
        self.textView.delegate = self
        self.textView.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        self.textView.layer.borderWidth = 1.0
        self.textView.layer.cornerRadius = 5
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
    
    var ddcModel: DDCFormModell?

    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            self.textView.text = "Enter " + (entity!.label)!
            self.textView.textColor = UIColor.lightGray
        } else {
            print(textView.text!)
            NewRequestHelper.shared.updateEntityValue(entity: self.entity!, value: textView.text!)
        }
    }
    
    @IBAction func resetBtn(_ sender: Any) {
//        RequestHelper.shared.createRequestForEntity(entity: self.entity!, newValue: "", entityGroupId: entityGroupId,parentEntityGroupId: parentEntityGroupId,groupOrder: groupOrder, dataModel: self.ddcModel)
    }
}
