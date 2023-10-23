//
//  RequestHelper.swift
//  Compan
//
//  Created by Ambu Sangoli on 5/31/22.
//

import Foundation
import JavaScriptCore

class NewRequestHelper : NSObject {
    
    static let shared = NewRequestHelper()
    let context = JSContext()!
    
    func updateEntityValue(entity: Entity,value: Any, isFromCalculative: Bool = false){
        var newValue = value
        var previousValue : Any = ""

        if let instrumentsData = instruments?.entities {
            for i in 0..<instrumentsData.count {
                if instrumentsData[i].entityTemplateID == entity.id  ?? "" {
                    if let valueString = instrumentsData[i].value  {
                        let valueArray = valueString.components(separatedBy: ",")
                        previousValue = valueArray
                    }
                }
            }
        }
        
        if entity.onValue != nil && entity.onValue != "" {
            print(value)
            if let valueString = value as? String {
                let valueArray = valueString.components(separatedBy: ",")
                self.executeScript(currentValue: valueArray, previousValue: previousValue, scriptString: entity.onValue!) { newValueDic in
                    print("onValue",newValueDic)
                    //TODO: None js script handling
                    // update this value and do table reload
//                    var newValue = newValueDic //pass as string with joined ","
//                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ReloadTable"), object: nil)  //Reload table

                }
            }
        }
        
        var instrumentId = ""
        if let instrumentsData = instruments?.entities {
            for i in 0..<instrumentsData.count {
                if instrumentsData[i].entityTemplateID == entity.id  ?? "" {
                    instrumentId = instrumentsData[i].id!
                    instrumentsData[i].value = newValue as? String
                }
            }
        }
        let entityData = [
            "id": instrumentId,
            "value": value
        ]
        let parameter : [String:Any] = ["entityInstrumentPayloadList": [entityData], "updatedBy": "iOS" ]
        let jsonData = try! JSONSerialization.data(withJSONObject: parameter, options: JSONSerialization.WritingOptions.prettyPrinted)
        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        print(jsonString)
        
        if !(isFromCalculative) {
            NewScriptHelper.shared.checkIsVisibleEntity(ddcModel: ddcModel)
        }

        APIManager.sharedInstance.makeRequestToUpdateEntityValue(data: jsonData){ (success, response,statusCode)  in
            if (success) {
                print(response)
                
            } else {
                APIManager.sharedInstance.showAlertWithMessage(message: ERROR_MESSAGE_DEFAULT)
                ERProgressHud.shared.hide()
            }
        }
    }
    
    func updateIndexField(eventId: String) {
        var instrumentId = ""
        if let instrumentsData = instruments?.entities {
            for i in 0..<instrumentsData.count {
                print(instrumentsData[i].value as Any)
                if instrumentsData[i].value == "random-uuid" {
                    
                    instrumentId = instrumentsData[i].id!
                    instrumentsData[i].value = eventId
                }
            }
        }
       
        let entityData = [
            "id": instrumentId,
            "value": eventId
          ]
        
        let parameter : [String:Any] = ["entityInstrumentPayloadList": [entityData], "updatedBy": "iOS" ]
        let jsonData = try! JSONSerialization.data(withJSONObject: parameter, options: JSONSerialization.WritingOptions.prettyPrinted)
        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        print(jsonString)

        APIManager.sharedInstance.makeRequestToUpdateEntityValue(data: jsonData){ (success, response,statusCode)  in
            if (success) {
                print(response)
            
            } else {
                APIManager.sharedInstance.showAlertWithMessage(message: ERROR_MESSAGE_DEFAULT)
                ERProgressHud.shared.hide()
            }
        }
    }
    

    
    func resetInstrument(){
        guard let id = instruments?.id else { return }
        let parameter : [String:Any] = ["instrumentId": id, "lastUpdatedBy": "iOS" ]
        let jsonData = try! JSONSerialization.data(withJSONObject: parameter, options: JSONSerialization.WritingOptions.prettyPrinted)
        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        print(jsonString)

        APIManager.sharedInstance.makeRequestToResetInstrument(data: jsonData){ (success, response,statusCode)  in
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
                                              NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ReloadTable"), object: nil)
                                      } catch {
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
    
    
    func addRepeatableGroup(entityGroup: Entity){
        var instrumentId = ""
        if let instrumentsData = instruments?.entities {
            for data in instrumentsData {
                if data.entityTemplateID == entityGroup.parentEntityTemplateID  ?? "" {
                    instrumentId = data.id!
                }
            }
        }
        
        let parameter : [String:Any] = ["entityInstrumentId": instrumentId, "order": 2 ]
        let jsonData = try! JSONSerialization.data(withJSONObject: parameter, options: JSONSerialization.WritingOptions.prettyPrinted)
        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        print(jsonString)

        APIManager.sharedInstance.makeRequestToAddRepeatableGroup(data: jsonData){ (success, response,statusCode)  in
            if (success) {
                print(response)

            } else {
                APIManager.sharedInstance.showAlertWithMessage(message: ERROR_MESSAGE_DEFAULT)
                ERProgressHud.shared.hide()
            }
        }
    }
    
    func deleteRepeatableGroup(entityGroup: Entity){
        var instrumentId = ""
        if let instrumentsData = instruments?.entities {
            for data in instrumentsData {
                if data.entityTemplateID == entityGroup.parentEntityTemplateID  ?? "" {
                    instrumentId = data.id!
                }
            }
        }
        let parameter : [String:Any] = ["entityInstrumentId": instrumentId, "order": 2 ]
        let jsonData = try! JSONSerialization.data(withJSONObject: parameter, options: JSONSerialization.WritingOptions.prettyPrinted)
        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        print(jsonString)

        APIManager.sharedInstance.makeRequestToDeleteRepeatableGroup(data: jsonData){ (success, response,statusCode)  in
            if (success) {
                print(response)

            } else {
                APIManager.sharedInstance.showAlertWithMessage(message: ERROR_MESSAGE_DEFAULT)
                ERProgressHud.shared.hide()
            }
        }
    }
    
    
    func randomStringWithLength(len: Int = 10) -> String {

        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"

        let randomString : NSMutableString = NSMutableString(capacity: len)

        for _ in 1...len{
            let length = UInt32 (letters.length)
            let rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.character(at: Int(rand)))
        }

        return randomString as String
    }
    
    func json(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
    func executeScript(currentValue: Any, previousValue: Any, scriptString:String, completion: @escaping  ([String]) -> ()) {

        //Array of strings
//        let currentValueString = self.json(from: (currentValue as? [String] ?? [])) ?? ""//.convertToString
//        let previousValueString = self.json(from: (previousValue as? [String] ?? [])) ?? ""

        //String
        let currentValueString = (currentValue as? [String] ?? []).joined(separator: ",")
        let previousValueString = (previousValue as? [String] ?? []).joined(separator: ",")

        let jsCode = scriptString
        

        print(jsCode)
        
        let script = "\"use strict\"; function  ddcscript(currentValueString,previousValueString) { " +
        "var currentValue=currentValueString; " +
        "var previousValue=previousValueString; " +
        "var executeJSCode = function(currentValue,previousValue) {" + jsCode + "}; " +
        "return executeJSCode(currentValue,previousValue); " +
        "}";
        
        context.evaluateScript(script)

        let result: JSValue = context.evaluateScript("ddcscript(\(currentValueString),\(previousValueString));")
        print("onValue jsScript Result ---- ",result)
        let value = result.toArray() as? [String] ?? []
        completion(value)
    }

}
