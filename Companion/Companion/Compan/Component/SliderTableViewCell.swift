//
//  SliderTableViewCell.swift
//  Compan
//
//  Created by Ambu Sangoli on 5/24/22.
//

import UIKit

class SliderTableViewCell: UITableViewCell {

    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var valueSlider: UISlider!
    @IBOutlet weak var uriLbl: UILabel!
    @IBOutlet weak var resetBtn: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var errorLabelHeight: NSLayoutConstraint!

    
    var data : DDCFormModell?
    var indexPath : IndexPath?
    var entity : Entity?

    var ddcModel: DDCFormModell?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func setupSliderCell(data: DDCFormModell,entity: Entity, indexPath: IndexPath) {
        self.isUserInteractionEnabled = true
        if isReadOnly {
            self.isUserInteractionEnabled = false
        }
        self.entity = entity
        self.data = data
        self.indexPath = indexPath

        let dataa : Entity? = entity

        if let entity = dataa {
            let minValue = Int(entity.settings?.min ?? "0") ?? 0
            let maxValue = Int(entity.settings?.max ?? "0") ?? 0
            self.valueSlider.minimumValue = Float(minValue)
            self.valueSlider.maximumValue = Float(maxValue)
            self.valueSlider.isContinuous = false
            
//            let valueString = entity.value?.value as? String
//            if valueString == "" || valueString == nil {
//                self.valueSlider.value = Float(minValue)
//                self.valueLabel.text = minValue.description
//            } else {
//                self.valueSlider.value = Float(valueString!) ?? 0
//                self.valueLabel.text = valueString
//            }
//            let array = (minValue...maxValue).map { $0 }
//            for i in array {
//                self.values.append(String(i))
//            }
            if let instrumentsData = instruments?.entities {
                for instrument in instrumentsData {
                    if instrument.entityTemplateID == entity.id  ?? "" {
                        if let value = instrument.value  {
                            self.valueLabel.text! = value
                            self.valueSlider.value = Float(value) ?? 0
                        } else {
                            self.valueSlider.value = Float(minValue)
                            self.valueLabel.text = minValue.description
                        }
                    }
                }
            }
        }
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
    
    @IBAction func valueChanged(_ sender: UISlider) {
        self.valueSlider.value = Float(Int(round(sender.value)))
        self.valueLabel.text = Int(round(sender.value)).description
        NewRequestHelper.shared.updateEntityValue(entity: self.entity!, value: self.valueLabel.text!)
    }
    
    @IBAction func resetBtn(_ sender: Any) {
//        RequestHelper.shared.createRequestForEntity(entity: self.entity!, newValue: "", entityGroupId: entityGroupId,parentEntityGroupId: parentEntityGroupId,groupOrder: groupOrder, dataModel: self.ddcModel)
    }
    

}

