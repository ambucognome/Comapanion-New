//
//  ERProgressHud.swift
//  Compan
//
//  Created by Ambu Sangoli on 10/05/22.
//

import UIKit
import SwiftyGif
import Lottie

class ERProgressHud: NSObject  {
    // MARK: Shared Instance
    
    static let shared = ERProgressHud()
    
    //MARK: Member Variables
    
    let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
    let containerView = UIView()
    let progressDialogue = UILabel()
    let dialogueContainerView = UIView()
    
    // show the progress view
    func show() {
        containerView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        let color = UIColor.gray
        let alphaColor = color.withAlphaComponent(0.5)
        containerView.backgroundColor = alphaColor
        activityIndicator.center =  CGPoint(x: UIScreen.main.bounds.size.width/2, y: UIScreen.main.bounds.size.height/2)
        activityIndicator.color = UIColor.white
        activityIndicator.hidesWhenStopped = true
        
        if let window :UIWindow = UIApplication.shared.windows.filter({$0.isKeyWindow}).first {
            containerView.addSubview(activityIndicator)
            window.addSubview(containerView)
            activityIndicator.startAnimating()
        }
    }
    
    // hide the progress view
    func hide() {
        activityIndicator.stopAnimating()
        containerView.removeFromSuperview()
    }
    
    // Hide a progress view which has the dialgoue in it.
    func hideProgressWithDialogue() {
        activityIndicator.stopAnimating()
        dialogueContainerView.removeFromSuperview()
        progressDialogue.removeFromSuperview()
    }
    
    // Show a progress view which has a dialogue in it.
    // Params :
    // text : the text that is to be displayed as a progress dialogue
    func showProgressWithDialogue(text : String) {
        dialogueContainerView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        
        progressDialogue.frame = CGRect(x: 0, y: UIScreen.main.bounds.size.height/2  , width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height/4)
        progressDialogue.text = text
        progressDialogue.textColor = UIColor.white
        progressDialogue.numberOfLines = 0
        progressDialogue.lineBreakMode = .byWordWrapping
        progressDialogue.textAlignment = .center
        
        let font = UIFont(name: "Roboto-Regular", size: 12)
        progressDialogue.font = font
        let color = UIColor.gray
        let alphaColor = color.withAlphaComponent(0.5)
        dialogueContainerView.backgroundColor = alphaColor
        
        activityIndicator.center =  CGPoint(x: UIScreen.main.bounds.size.width/2, y: UIScreen.main.bounds.size.height/2)
        activityIndicator.color = UIColor.white
        activityIndicator.hidesWhenStopped = true
        
        if let window :UIWindow = UIApplication.shared.keyWindow {
            dialogueContainerView.addSubview(activityIndicator)
            window.addSubview(dialogueContainerView)
            activityIndicator.startAnimating()
            dialogueContainerView.addSubview(progressDialogue)
        }
    }
    
    // Get container view
    func getContainerView() -> UIView {
        return containerView
    }
}

