//
//  ViewController.swift
//  Compan
//
//  Created by Ambu Sangoli on 25/04/22.
//

import UIKit
import SwiftyJSON

class ViewController: UIViewController {

    @IBOutlet weak var uriTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addObservers()
    }
    deinit {
        removeObservers()
    }
    
    func addObservers(){
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(notificationAction),
            name: NSNotification.Name(rawValue: "ReloadAPI") ,
            object: nil
        )
    }
    func removeObservers(){
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue:"ReloadAPI"), object: nil)

    }
    
    @objc func notificationAction() {
        self.loginUser()

      }
    
    
//Login Api Call
    @IBAction func loginUser(){
//        if self.uriTextField.text! == "" {
//            APIManager.sharedInstance.showAlertWithMessage(message: "Please enter Uri")
//            return
//        }
        ERProgressHud.shared.show()
        //Basic Components
//        let parameters: [String: Any] = [
//            "author" : "System",
//            "template_uri" : "http://chdi.montefiore.org/basicComponents",
//            "context": [
//                    "key" : "test",
//        ]
//        ]
        
////        Repeatable
//        let parameters: [String: Any] = [
//            "author" : "System",
//            "template_uri" : "http://chdi.montefiore.org/patientInfo",
//            "context": [
//                    "key" : "test",
//        ]
//        ]

        //Repeatable inside repeatable
//        let parameters: [String: Any] = [
//            "author" : "System",
//            "template_uri" : "http://chdi.montefiore.org/patientInfoTest",
//            "context": [
//                    "key" : "test",
//        ]
//      ]
        
//        //Demo link
//        let parameters: [String: Any] = [
//            "author" : "System",
//            "template_uri" : "http://chdi.montefiore.org/CovidSafeCheck",
//            "context": [
//                    "key" : "test",
//        ]
//      ]
//
        let parameters: [String: Any] = [
            "author" : "System",
            "template_uri" : "http://chdi.montefiore.org/v1/covidsafecheckv2",
            "context": [
                    "key" : "test",
        ]
      ]

//        let parameters: [String: Any] = [
//            "author" : "System",
//            "template_uri" : "\(self.uriTextField.text!)",
//            "context": [
//                    "key" : "test",
//        ]
//        ]
        
//        let parameters: [String: Any] = [
//            "author" : "System",
//            "template_uri" : "http://chdi.montefiore.org/formik4",
//            "context": [
//                    "key" : "ambu",
//        ]
//      ]
//
//        let parameters: [String: Any] = [
//            "author" : "System",
//            "template_uri" : "http://chdi.montefiore.org/allComponents",
//            "context": [
//                    "key" : "ambu",
//        ]
//      ]
        
        context_parameters = parameters

        APIManager.sharedInstance.makeRequestToGetTemplate(params: parameters as [String:Any]){ (success, response,statusCode)  in
            if (success) {
                ERProgressHud.shared.hide()
                print(response)
                if let responseData = response as? Dictionary<String, Any> {
                                  var jsonData: Data? = nil
                                  do {
                                      jsonData = try JSONSerialization.data(
                                          withJSONObject: responseData as Any,
                                          options: .prettyPrinted)
                                      do{
                                          let jsonDataModels = try JSONDecoder().decode(DDCFormModel.self, from: jsonData!)
                                          print(response)
                                          let frameworkBundle = Bundle(for: ViewController.self)
                                          let storyboard = UIStoryboard(name: "Main", bundle: frameworkBundle)
                                          let vc = storyboard.instantiateViewController(withIdentifier: "dynamic") as! DynamicTemplateViewController
                                          ddcModel = jsonDataModels
//                                          self.present(vc, animated: true, completion: nil)
                                          if (self.navigationController?.topViewController as? DynamicTemplateViewController) != nil {
                                              NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ReloadTable"), object: nil)
                                              ScriptHelper.shared.checkIsVisibleEntity()
                                              return
                                          }
                                          
                                          self.navigationController?.pushViewController(vc, animated: true)
                                          showValidations = false
                                          ScriptHelper.shared.checkIsVisibleEntity()

                                      }catch {
                                          print(error)
                                      }
                                  } catch {
                                      print(error)
                                  }
                        }
            } else {
                APIManager.sharedInstance.showAlertWithMessage(message: ERROR_MESSAGE_DEFAULT)
                ERProgressHud.shared.hide()
            }
        }
    }
    
    
    func getTempleWith(author: String, uri: String, context: String) {
        let parameters: [String: Any] = [
            "author" : author,
            "template_uri" : (uri),
            "context": [
                    "key" : context,
        ]
        ]
        
        APIManager.sharedInstance.makeRequestToGetTemplate(params: parameters as [String:Any]){ (success, response,statusCode)  in
            if (success) {
                ERProgressHud.shared.hide()
                print(response)
                if let responseData = response as? Dictionary<String, Any> {
                                  var jsonData: Data? = nil
                                  do {
                                      jsonData = try JSONSerialization.data(
                                          withJSONObject: responseData as Any,
                                          options: .prettyPrinted)
                                      do{
                                          let jsonDataModels = try JSONDecoder().decode(DDCFormModel.self, from: jsonData!)
                                          print(response)
                                          
                                          let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                          let vc = storyboard.instantiateViewController(withIdentifier: "dynamic") as! DynamicTemplateViewController
                                          ddcModel = jsonDataModels
//                                          self.present(vc, animated: true, completion: nil)
                                          if (self.navigationController?.topViewController as? DynamicTemplateViewController) != nil {
                                              ScriptHelper.shared.checkIsVisibleEntity()
                                              return
                                          }
                                          
                                          self.navigationController?.pushViewController(vc, animated: true)
                                          ScriptHelper.shared.checkIsVisibleEntity()

                                      }catch {
                                          print(error)
                                      }
                                  } catch {
                                      print(error)
                                  }
                        }
            } else {
                APIManager.sharedInstance.showAlertWithMessage(message: ERROR_MESSAGE_DEFAULT)
                ERProgressHud.shared.hide()
            }
        }
    }

}

