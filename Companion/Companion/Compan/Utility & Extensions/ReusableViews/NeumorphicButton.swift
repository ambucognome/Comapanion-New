//
//  NeumorphicButton.swift
//  Fitpeo
//
//  Created by ValetPlz on 14/09/21.
//  Copyright © 2021 Fitpeo. All rights reserved.
//

import Foundation
import UIKit


public class NeumorphicButton: UIButton {
    
   
    
    public override func layoutSubviews() {
        super.layoutSubviews()
            self.addSoftUIEffectForButton(themeColor: UIColor(hexString: "#4E8DE2"))
        
    }
    
    override open var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                 setState()
            } else {
                 resetState()
            }
        }
    }
    
    override open var isEnabled: Bool {
        didSet{
            if isEnabled == false {
                setState()
            } else {
                resetState()
            }
        }
    }
    
    func setState(){
        self.layer.shadowOffset = CGSize(width: 5, height: 5)
        self.layer.sublayers?[0].shadowOffset = CGSize(width: -5, height: -5)
//        self.contentEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 0, right: 0)
    }
    
    func resetState(){
        self.layer.shadowOffset = CGSize(width: -5, height: -5)
        self.layer.sublayers?[0].shadowOffset = CGSize(width: 5, height: 5)
//        self.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 2, right: 2)
    }
    
    public func addSoftUIEffectForButton(themeColor: UIColor = UIColor.blue) {
        self.layer.cornerRadius = 22
        self.layer.masksToBounds = false
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize( width: 5, height: 5)
        self.layer.shadowColor =  UIColor.white.cgColor
        
        let shadowLayer = CAShapeLayer()
        shadowLayer.frame = bounds
        shadowLayer.backgroundColor = themeColor.cgColor
        shadowLayer.shadowColor = UIColor(red: 0.31, green: 0.55, blue: 0.89, alpha: 0.3).cgColor
        shadowLayer.cornerRadius =  22
        shadowLayer.shadowOffset = CGSize(width: -5, height: -5.0)
        shadowLayer.shadowOpacity = 1
        shadowLayer.shadowRadius = 5
        shadowLayer.name = "shadow"
        for layer in self.layer.sublayers ?? [] {
            if layer.name == "shadow" {
                layer.removeFromSuperlayer()
            }
        }
//        self.layer.insertSublayer(shadowLayer, below: self.imageView?.layer)
        self.layer.insertSublayer(shadowLayer, at: 0)

    }
    

}
