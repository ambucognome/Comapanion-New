//
//  Extention.swift
//  Cognome
//
//  Created by Ambu Sangoli
//  Copyright © 2022 Cognome. All rights reserved.


import Foundation
import UIKit

extension UIImage {
    func createSelectionIndicator(color: UIColor, size: CGSize, lineWidth: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(CGRect(x: 0, y:  0, width: size.width, height: lineWidth))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

// extension for shadow effect
extension UIView {
    func shake(count : Float = 3,for duration : TimeInterval = 0.3,withTranslation translation : Float = 5) {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.repeatCount = count
        animation.duration = duration/TimeInterval(animation.repeatCount)
        animation.autoreverses = true
        animation.values = [translation, -translation]
        layer.add(animation, forKey: "shake")
    }
    
    // OUTPUT 1
    func dropShadowWithBorder(cornerRadius : CGFloat = 8) {
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(white: 100.0 / 255.0, alpha: 0.3).cgColor
        self.layer.cornerRadius = cornerRadius
        self.layer.shadowPath =
              UIBezierPath(roundedRect: self.bounds,
              cornerRadius: self.layer.cornerRadius).cgPath
        self.layer.shadowColor = UIColor(red: 44.0 / 255.0, green: 39.0 / 255.0, blue: 56.0 / 255.0, alpha: 0.08).cgColor
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 4
        self.layer.shadowOpacity = 1
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
        self.layer.masksToBounds = false
    }
    
    func dropShadow(cornerRadius : CGFloat = 10) {
        self.layer.cornerRadius = cornerRadius
        self.layer.shadowPath =
              UIBezierPath(roundedRect: self.bounds,
              cornerRadius: self.layer.cornerRadius).cgPath
        self.layer.shadowColor = UIColor(red: 44.0 / 255.0, green: 39.0 / 255.0, blue: 56.0 / 255.0, alpha: 0.08).cgColor
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 4
        self.layer.shadowOpacity = 1
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
        self.layer.masksToBounds = false
    }
    
    func dropShadowToCell(cornerRadius : CGFloat = 0) {
        self.layer.cornerRadius = cornerRadius
        self.layer.shadowPath =
              UIBezierPath(roundedRect: self.bounds,
              cornerRadius: self.layer.cornerRadius).cgPath
        self.layer.shadowColor = UIColor(red: 44.0 / 255.0, green: 39.0 / 255.0, blue: 56.0 / 255.0, alpha: 0.08).cgColor
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 1
        self.layer.shadowOpacity = 1
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
        self.layer.masksToBounds = false
    }
    
    func removeShadow() {
        self.layer.shadowPath = nil
    }
    
    // OUTPUT 2
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offSet
        self.layer.shadowRadius = radius
        
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}

extension UITapGestureRecognizer {
    
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
                let layoutManager = NSLayoutManager()
                let textContainer = NSTextContainer(size: CGSize.zero)
                let textStorage = NSTextStorage(attributedString: label.attributedText!)
                let edgeInset: UIEdgeInsets? = nil
                // Configure layoutManager and textStorage
                layoutManager.addTextContainer(textContainer)
                textStorage.addLayoutManager(layoutManager)
               let alignment = label.textAlignment
                // Configure textContainer
                textContainer.lineFragmentPadding = 0.0
                textContainer.lineBreakMode = label.lineBreakMode
                textContainer.maximumNumberOfLines = label.numberOfLines
              //  let labelSize = CGSize(width: label.bounds.width - (edgeInset?.left ?? 0) - (edgeInset?.right ?? 0), height: label.bounds.height - (edgeInset?.top
                       // ?? 0) - (edgeInset?.bottom ?? 0))
             
               let width = label.bounds.width - (edgeInset?.left ?? 0) - (edgeInset?.right ?? 0)
                let height = label.bounds.height - (edgeInset?.top ?? 0) - (edgeInset?.bottom ?? 0)
                let labelSize = CGSize(width: width, height: height)
                textContainer.size = labelSize

                // Find the tapped character location and compare it to the specified range
                let locationOfTouchInLabel = self.location(in: label)
                let textBoundingBox = layoutManager.usedRect(for: textContainer)
                var xOffset: CGFloat = 0
                var yOffset: CGFloat = 0
                if alignment == .left {
                    xOffset = (edgeInset?.left ?? 0) - textBoundingBox.origin.x
                    yOffset = (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y + (edgeInset?.top ?? 0)
                } else if alignment == .right {
                    xOffset = label.bounds.width - (edgeInset?.right ?? 0) - labelSize.width - textBoundingBox.origin.x
                    yOffset = (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y + (edgeInset?.top ?? 0)
                } else {
                    xOffset = (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x + (edgeInset?.left ?? 0)
                    yOffset = (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y + (edgeInset?.top ?? 0)
                }
                let textContainerOffset = CGPoint(
                    x: xOffset,
                    y: yOffset
                )
                let locationOfTouchInTextContainer = CGPoint(
                    x: locationOfTouchInLabel.x - textContainerOffset.x,
                    y: locationOfTouchInLabel.y - textContainerOffset.y
                )
                let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)

                return NSLocationInRange(indexOfCharacter, targetRange)
    }
    
}

extension UILabel {
           ///Find the index of character (in the attributedText) at point
           func indexOfAttributedTextCharacterAtPoint(point: CGPoint) -> Int {
               let textStorage = NSTextStorage(attributedString: self.attributedText!)
               let layoutManager = NSLayoutManager()
               textStorage.addLayoutManager(layoutManager)
               let textContainer = NSTextContainer(size: self.frame.size)
               textContainer.lineFragmentPadding = 0
               textContainer.maximumNumberOfLines = self.numberOfLines
               textContainer.lineBreakMode = self.lineBreakMode
               layoutManager.addTextContainer(textContainer)

               let index = layoutManager.characterIndex(for: point, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
               return index
           }
}

extension UIColor{
    // Usage Where 30c230 is hex code
    //let greenColor = UIColor(rgb: 0x30c230)
    convenience init(rgb: UInt) {
        self.init(rgb: rgb, alpha: 1.0)
    }
    
    convenience init(rgb: UInt, alpha: CGFloat) {
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: CGFloat(alpha)
        )
    }
}

extension Data {
    func hexString() -> String {
        return self.reduce("") { string, byte in
            string + String(format: "%02X", byte)
        }
    }
}

extension UIViewController {

    func addBackButton() {
        let btnLeftMenu: UIButton = UIButton()
        let image = UIImage(named: "back");
        btnLeftMenu.setImage(image, for: .normal)
        btnLeftMenu.frame =  CGRect(x:0, y:0, width: 35, height:35)
        btnLeftMenu.addTarget(self, action: #selector (backButtonClick(sender:)), for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: btnLeftMenu)
        self.navigationItem.leftBarButtonItem = barButton
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        

    }
    
    

    @objc func backButtonClick(sender : UIButton) {
        self.navigationController?.popViewController(animated: true);
    }
}

extension Dictionary {

    func toString() -> String? {
        return (self.compactMap({ (key, value) -> String in
            return "\(key)=\(value)"
        }) as Array).joined(separator: "&")
    }

}



extension UIColor
{
    convenience init(hexString: String)
    {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        
        switch hex.count
        {
            case 3: // RGB (12-bit)
                (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
            
            case 6: // RGB (24-bit)
                (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
            
            case 8: // ARGB (32-bit)
                (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
            
            default:
                (a, r, g, b) = (255, 0, 0, 0)
        }
        
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}


extension UIAlertController {
    
    //Set background color of UIAlertController
    func setBackgroundColor(color: UIColor) {
        if let bgView = self.view.subviews.first, let groupView = bgView.subviews.first, let contentView = groupView.subviews.first {
            contentView.backgroundColor = color
        }
    }
    
    //Set message font and message color
    func setMessage(font: UIFont?, color: UIColor?) {
        guard let message = self.message else { return }
        let attributeString = NSMutableAttributedString(string: message)
        if let messageFont = font {
            attributeString.addAttributes([NSAttributedString.Key.font : messageFont],
                                          range: NSMakeRange(0, message.utf8.count))
        }
        
        if let messageColorColor = color {
            attributeString.addAttributes([NSAttributedString.Key.foregroundColor : messageColorColor],
                                          range: NSMakeRange(0, message.utf8.count))
        }
        self.setValue(attributeString, forKey: "attributedMessage")
    }
    

    
    //Set tint color of UIAlertController
    func setTint(color: UIColor) {
        self.view.tintColor = color
    }
}

extension RangeExpression where Bound == String.Index  {
    func nsRange<S: StringProtocol>(in string: S) -> NSRange { .init(self, in: string) }
}





extension URL {

    mutating func appendQueryItem(name: String, value: String?) {

        guard var urlComponents = URLComponents(string: absoluteString) else { return }

        // Create array of existing query items
        var queryItems: [URLQueryItem] = urlComponents.queryItems ??  []

        // Create query item
        let queryItem = URLQueryItem(name: name, value: value)

        // Append the new query item in the existing query items array
        queryItems.append(queryItem)

        // Append updated query items array in the url component object
        urlComponents.queryItems = queryItems

        // Returns the url from new url components
        self = urlComponents.url!
    }
}

extension StringProtocol {
    func index<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> Index? {
        range(of: string, options: options)?.lowerBound
    }
    func endIndex<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> Index? {
        range(of: string, options: options)?.upperBound
    }
    func indices<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> [Index] {
        ranges(of: string, options: options).map(\.lowerBound)
    }
    func ranges<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> [Range<Index>] {
        var result: [Range<Index>] = []
        var startIndex = self.startIndex
        while startIndex < endIndex,
            let range = self[startIndex...]
                .range(of: string, options: options) {
                result.append(range)
                startIndex = range.lowerBound < range.upperBound ? range.upperBound :
                    index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return result
    }
}

extension UIDatePicker {

    public func checkMaxYear() {
        let calendar = Calendar(identifier: .gregorian)
        var component = calendar.dateComponents([.day,.month], from: self.date)
        component.year = calendar.dateComponents([.year], from: Date()).year
        let newDate = calendar.date(from: component)!
        self.setDate(newDate, animated: true)
    }
}

extension UIView {

    func animateButtonDown() {

    UIView.animate(withDuration: 0.1, delay: 0.0, options: [.allowUserInteraction, .curveEaseIn], animations: {
        self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
    }, completion: nil)
}

func animateButtonUp() {

    UIView.animate(withDuration: 0.1, delay: 0.0, options: [.allowUserInteraction, .curveEaseOut], animations: {
        self.transform = CGAffineTransform.identity
    }, completion: nil)
}
    
        internal func fillSuperview() {
            fillSuperviewVertically()
            fillSuperviewHorizontally()
        }

        internal func fillSuperviewVertically() {
            guard let superview = superview else { return }

            self.topAnchor.constraint(equalTo: superview.topAnchor).isActive = true
            self.bottomAnchor.constraint(equalTo: superview.bottomAnchor).isActive = true
        }

        internal func fillSuperviewHorizontally() {
            guard let superview = superview else { return }

            self.leadingAnchor.constraint(equalTo: superview.leadingAnchor).isActive = true
            self.trailingAnchor.constraint(equalTo: superview.trailingAnchor).isActive = true
        }
}
extension UIApplication {
  func isFirstLaunch() -> Bool {
    if !UserDefaults.standard.bool(forKey: "HasLaunched") {
      UserDefaults.standard.set(true, forKey: "HasLaunched")
      UserDefaults.standard.synchronize()
      return true
  }
  return false
}
}


class NoActionTextField : UITextField {
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
//     if action == #selector(UIResponderStandardEditActions.paste(_:)) {
//             return false
//         }
         return false//super.canPerformAction(action, withSender: sender)
    }
    
    override func selectionRects(for range: UITextRange) -> [UITextSelectionRect] {
        []
    }

    override func caretRect(for position: UITextPosition) -> CGRect {
        .zero
    }
}

extension String {
    func removingWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
}

extension String {
    
    var isWhitespace: Bool {
        guard !isEmpty else { return true }
        
        let whitespaceChars = NSCharacterSet.whitespacesAndNewlines
        
        return self.unicodeScalars
            .filter { !whitespaceChars.contains($0) }
            .count == 0
    }
    
}

extension String {
var boolValue: Bool {
    return (self as NSString).boolValue
}}

extension UITextField {
    
    func setIcon(_ image: UIImage) {
        let iconView = UIImageView(frame:
            CGRect(x: 10, y: 5, width: 20, height: 20))
        iconView.tintColor = .blue
        iconView.image = image
        let iconContainerView: UIView = UIView(frame:
            CGRect(x: 20, y: 0, width: 40, height: 30))
        iconContainerView.addSubview(iconView)
        leftView = iconContainerView
        leftViewMode = .always
        
    }
    
    func addShadowToTextField(color: UIColor = UIColor.gray, cornerRadius: CGFloat) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowOpacity = 1.0
        self.layer.cornerRadius = cornerRadius
        
    }
    
    func setBottomBorder(color : UIColor = UIColor.white, shadowColor: UIColor = UIColor.gray) {
        self.borderStyle = .none
        self.layer.backgroundColor = color.cgColor
        self.layer.masksToBounds = false
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
   
    func changePlaceholderColor(placeholder : String, color: UIColor) {
        self.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: color])
    }
    
    func setTextAlignment(textAlignment : NSTextAlignment = .left, fontSize : CGFloat = 14.0,weight : UIFont.Weight = .regular) {
        self.textAlignment = textAlignment
        self.font = UIFont.systemFont(ofSize: fontSize, weight: weight)
        
    }
   
    func addRoundedCorner(cornerRadius: CGFloat, borderWidth : CGFloat = 1.0,color : UIColor = UIColor.label) {
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = color.cgColor
    }
}


extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeybrd))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeybrd() {
        view.endEditing(true)
    }
}

extension UserDefaults {
  func setCodableObject<T: Codable>(_ data: T?, forKey defaultName: String) {
    let encoded = try? JSONEncoder().encode(data)
    set(encoded, forKey: defaultName)
  }
    
    func codableObject<T : Codable>(dataType: T.Type, key: String) -> T? {
      guard let userDefaultData = data(forKey: key) else {
        return nil
      }
      return try? JSONDecoder().decode(T.self, from: userDefaultData)
    }
}


extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension Encodable {
    var convertToString: String? {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .prettyPrinted
        do {
            let jsonData = try jsonEncoder.encode(self)
            if let json = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers),
               let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
                // Convert to a string and print
                if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
//                   print(JSONString)
                    return JSONString
                } else { return nil }

            } else {
                print("json data malformed")
                return nil
            }
        } catch {
            return nil
        }
    }
    
    var convertToData: Data? {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .prettyPrinted
        do {
            let jsonData = try jsonEncoder.encode(self)
            if let json = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers),
               let jsonData = try? JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted) {
//                let prettyString = (String(decoding: jsonData, as: UTF8.self))
//                print(prettyString)
                // Convert to a string and print
                return jsonData

            } else {
                print("json data malformed")
                return nil
            }
        } catch {
            return nil
        }
    }
    
}
