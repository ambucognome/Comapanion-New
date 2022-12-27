//
//  NeumorphicTextField.swift
//  Fitpeo
//
//  Created by ValetPlz on 14/09/21.
//  Copyright © 2021 Fitpeo. All rights reserved.
//

import Foundation
import UIKit


class NeumorphicTextField: UITextField {

    let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 5)

    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    required override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.addSoftUIEffectForView(themeColor:UIColor(hexString: "#123865"))
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
     if action == #selector(UIResponderStandardEditActions.paste(_:)) {
             return false
         }
         return super.canPerformAction(action, withSender: sender)
    }
    
  
    public func addSoftUIEffectForView(cornerRadius: CGFloat = 22, themeColor: UIColor = UIColor.white) {
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = false
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize(width: -5, height: -5)
        self.layer.shadowColor = UIColor(red: 205/255, green: 217/255, blue: 229/255, alpha: 0.9).cgColor
        
        let shadowLayer = CAShapeLayer()
        shadowLayer.frame = bounds
        shadowLayer.backgroundColor = themeColor.cgColor
        shadowLayer.shadowColor = UIColor.white.cgColor
        shadowLayer.cornerRadius = cornerRadius
        shadowLayer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        shadowLayer.shadowOpacity = 1
        shadowLayer.shadowRadius = 5
        shadowLayer.name = "shadow"
        for layer in self.layer.sublayers ?? [] {
            if layer.name == "shadow" {
                layer.removeFromSuperlayer()
            }
        }
        self.layer.insertSublayer(shadowLayer, at: 0)
    }
}
