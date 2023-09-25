//
//  BaseViewController.swift
//  ddcv2
//
//  Created by ambu sangoli on 18/07/23.
//

import UIKit
import SwiftyJSON

var instruments : Instruments?

class BaseViewController: UIViewController {

    @IBOutlet weak var uriTextField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.getTemplate()
    }
    
    
//Get Template Api Call
    func getTemplate(){
        ERProgressHud.shared.show()
        
        //All components
//        let templateId = "ddc:template_f4b7cf10-da8a-4197-b90b-aaf615b71c1d"
    
        var instrumentID : String?
        instrumentID = "ddc:Instrument_1973915a-ca26-4c8f-a815-b5d889ded126"
        
        //is visible
//        let templateId = "ddc:template_f071d80f-acf1-4182-bad1-d7b02bbc81b7"
        
        //Repeatable
        let templateId = "ddc:template_34bb1e8b-9914-4e40-b220-02177fe42cc5"
        
        //Repeatable inside repeatable
//        let templateId = "ddc:template_4ee2f722-0ab1-401f-b75c-d98b5aff9012"
        
        //Safe check
//        let templateId = "ddc:template_5d28e9e5-83cc-41d1-afdf-67d1e4f153fd"
        
        //Create Event
//        let templateId = "ddc:template_c6c08dfe-097b-43eb-aff0-3ac705fbb910"

        //Dyspnea Activity Motivation
//        let templateId = "ddc:template_d6ecb67d-6e87-426b-88fa-b4907844b12a"


        APIManager.sharedInstance.makeRequestToGetTemplate(templateId: templateId){ (success, response,statusCode)  in
            if (success) {
                print(response)
                if let responseData = response as? Dictionary<String, Any> {
                                  var jsonData: Data? = nil
                                  do {
                                      jsonData = try JSONSerialization.data(
                                          withJSONObject: responseData as Any,
                                          options: .prettyPrinted)
                                      do{
                                          let jsonDataModels = try JSONDecoder().decode(DDCFormModell.self, from: jsonData!)
                                          print(jsonDataModels)
                                          let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                          let vc = storyboard.instantiateViewController(withIdentifier: "dynamic") as! DynamiccTemplateViewController
                                          ddcModel = jsonDataModels
                                          if let id = instrumentID {
                                              self.getInstrument(instrumentId: id)
                                          } else {
                                              self.saveInstrument(templateId: jsonDataModels.id!)
                                          }
                                          self.navigationController?.pushViewController(vc, animated: true)

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
    
    
    func saveInstrument(templateId: String){
        let parameter : [String:Any] = ["templateId": templateId, "predefinedFields": [:] ]
        let jsonData = try! JSONSerialization.data(withJSONObject: parameter, options: JSONSerialization.WritingOptions.prettyPrinted)
        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        print(jsonString)

        APIManager.sharedInstance.makeRequestToSaveInstrument(data: jsonData){ (success, response,statusCode)  in
            if (success) {
                print(response)
                if let responseData = response as? Dictionary<String, Any> {
                                  var jsonData: Data? = nil
                                  do {
                                      jsonData = try JSONSerialization.data(
                                          withJSONObject: responseData as Any,
                                          options: .prettyPrinted)
                                      do{
                                          let jsonDataModels = try JSONDecoder().decode(Instruments.self, from: jsonData!)
                                          print(jsonDataModels)
                                          instruments = jsonDataModels
                                          NewScriptHelper.shared.checkIsVisibleEntity(ddcModel: ddcModel)
                                      } catch {
                                          print(error)
                                      }
                                  } catch {
                                      print(error)
                                  }
                        }            } else {
                APIManager.sharedInstance.showAlertWithMessage(message: ERROR_MESSAGE_DEFAULT)
                ERProgressHud.shared.hide()
            }
        }
    }
    
    func getInstrument(instrumentId: String){
        APIManager.sharedInstance.makeRequestToGetInstrument(instrumentId: instrumentId){ (success, response,statusCode)  in
            if (success) {
                print(response)
                if let responseData = response as? Dictionary<String, Any> {
                                  var jsonData: Data? = nil
                                  do {
                                      jsonData = try JSONSerialization.data(
                                          withJSONObject: responseData as Any,
                                          options: .prettyPrinted)
                                      do{
                                          let jsonDataModels = try JSONDecoder().decode(Instruments.self, from: jsonData!)
                                          instruments = jsonDataModels
                                          NewScriptHelper.shared.checkIsVisibleEntity(ddcModel: ddcModel)

                                          if (self.navigationController?.topViewController as? DynamiccTemplateViewController) != nil {
                                              NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ReloadTable"), object: nil)
                                              return
                                          }
                                          
                                      } catch {
                                          print(error)
                                      }
                                  } catch {
                                      print(error)
                                  }
                        }            } else {
                APIManager.sharedInstance.showAlertWithMessage(message: ERROR_MESSAGE_DEFAULT)
                ERProgressHud.shared.hide()
            }
        }
    }


}



