//
//  ScriptHelper.swift
//  Compan
//
//  Created by Ambu Sangoli on 7/4/22.
//

import Foundation
import JavaScriptCore

var calculativeCount = 0

class ScriptHelper : NSObject {
    
    static let shared = ScriptHelper()
    
    var pathCreation = ""
    var url = ""

    let context = JSContext()!
    
    func checkIsVisibleEntity() {
        self.getCalculativeCount()
        url = "template"
        let mainEntities = ddcModel?.template?.sortedArray
        for entityIndex in 0..<(mainEntities?.count ?? 0) {
            if let entity = mainEntities?[entityIndex].value {
                if entity.isVisible != nil {
                    
                    self.executeScrip(parentObj: ddcModel?.template?.convertToString ?? "", scriptString: entity.isVisible!) { isHidden, isVisible in
                        ddcModel?.template?.sortedArray?[entityIndex].value.isHidden = isHidden
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ReloadTable"), object: nil)
                        if (isVisible)  {
                            ddcModel?.template?.sortedArray?[entityIndex].value.invokation = true
                        } else if !isVisible && entity.value != "" && (entity.type?.rawValue ?? "") != FieldType.messageEntity.rawValue {
                            //API Call
                            self.url += ".entities.\(entity.uri ?? "")"
                            self.revokeEntity(entityObj: entity.convertToString ?? "", path: self.url)
                        }
                    }
                }
                if entity.type == .calculatedEntity && entity.calculation != nil {
                    self.executeCalculativeScrip(parentObj: ddcModel?.template?.convertToString ?? "", scriptString: entity.calculation!) { value in
                        RequestHelper.shared.createRequestForEntity(entity: entity, newValue: value, entityGroupId: ddcModel?.template?.uniqueId ?? "" ,parentEntityGroupId: "",isCalculativeEntity: true, groupOrder: 0)
                        ddcModel?.template?.sortedArray?[entityIndex].value.value = AnyCodable(value)
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ReloadTable"), object: nil)

                    }
                }
                if entity.type == .entityGroupRepeatable || entity.type == .entityGroup {
                    if let entityGroup = entity.sortedEntityGroupsArray {
                        for entityGroupIndex in 0..<(entityGroup.count ) {
                            let data = entityGroup[entityGroupIndex].value
                            for nestedEntityIndex in 0..<(data.sortedEntitiesArray?.count ?? 0) {
                                if let nestedEntity = data.sortedEntitiesArray?[nestedEntityIndex].value {
                                    if nestedEntity.isVisible != nil {
                                        self.executeScrip(parentObj: ddcModel?.template?.sortedArray?[entityIndex].value.sortedEntityGroupsArray?[entityGroupIndex].value.convertToString ?? "", scriptString: nestedEntity.isVisible!) { isHidden,isVisible  in
                                            
                                            ddcModel?.template?.sortedArray?[entityIndex].value.sortedEntityGroupsArray?[entityGroupIndex].value.sortedEntitiesArray?[nestedEntityIndex].value.isHidden = isHidden
                                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ReloadTable"), object: nil)
                                            if (isVisible)  {
                                                ddcModel?.template?.sortedArray?[entityIndex].value.sortedEntityGroupsArray?[entityGroupIndex].value.sortedEntitiesArray?[nestedEntityIndex].value.invokation = true
                                            } else if !isVisible && entity.value != ""  && (nestedEntity.type?.rawValue ?? "") != FieldType.messageEntity.rawValue {
                                                //API Call
                                                self.url += ".entities.\(entity.uri ?? "")"
                                                self.url += ".entity_groups[\(entityGroupIndex.description)].\(entityGroup[entityGroupIndex].value.uri ?? "")"
                                                self.revokeEntity(entityObj: nestedEntity.convertToString ?? "", path: self.url)
                                            }
                                            
                                        }
                                    }
                                    if nestedEntity.type == .calculatedEntity && nestedEntity.calculation != nil {
                                        self.executeCalculativeScrip(parentObj: ddcModel?.template?.sortedArray?[entityIndex].value.sortedEntityGroupsArray?[entityGroupIndex].value.convertToString ?? "", scriptString: nestedEntity.calculation!) { value in
                                            
                                            RequestHelper.shared.createRequestForEntity(entity: nestedEntity, newValue: value, entityGroupId:data.uniqueId  ,parentEntityGroupId: ddcModel?.template?.uniqueId ?? "" ,isCalculativeEntity: true, groupOrder: ddcModel?.template?.sortedArray?[entityIndex].value.sortedEntityGroupsArray?[entityGroupIndex].value.order ?? 0)
                                            
                                            ddcModel?.template?.sortedArray?[entityIndex].value.sortedEntityGroupsArray?[entityGroupIndex].value.sortedEntitiesArray?[nestedEntityIndex].value.value = AnyCodable(value)
                                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ReloadTable"), object: nil)
                                        
                                    }
                                    }
                                    if nestedEntity.type == .entityGroupRepeatable || entity.type == .entityGroup{
                                        if let nestedEntityGroup = nestedEntity.sortedEntityGroupsArray {
                                            for nentityGroupIndex in 0..<(nestedEntityGroup.count ) {
                                                let data = nestedEntityGroup[nentityGroupIndex].value
                                                for nnestedEntityIndex in 0..<(data.sortedEntitiesArray?.count ?? 0) {
                                                    if let nestedEntity = data.sortedEntitiesArray?[nnestedEntityIndex].value {
                                                        if nestedEntity.isVisible != nil {
                                                            self.executeScrip(parentObj: ddcModel?.template?.sortedArray?[entityIndex].value.sortedEntityGroupsArray?[nentityGroupIndex].value.convertToString ?? "", scriptString: nestedEntity.isVisible!) { isHidden,isVisible in
                                                                ddcModel?.template?.sortedArray?[entityIndex].value.sortedEntityGroupsArray?[entityGroupIndex].value.sortedEntitiesArray?[nestedEntityIndex].value.sortedEntityGroupsArray?[nentityGroupIndex].value.sortedEntitiesArray?[nnestedEntityIndex].value.isHidden = isHidden
                                                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ReloadTable"), object: nil)
                                                                if (isVisible)  {
                                                                    ddcModel?.template?.sortedArray?[entityIndex].value.sortedEntityGroupsArray?[entityGroupIndex].value.sortedEntitiesArray?[nestedEntityIndex].value.sortedEntityGroupsArray?[nentityGroupIndex].value.sortedEntitiesArray?[nnestedEntityIndex].value.invokation = true
                                                                } else if !isVisible && entity.value != "" && (nestedEntity.type?.rawValue ?? "") != FieldType.messageEntity.rawValue {
                                                                    //API Call
                                                                    self.url = self.url.replacingOccurrences(of: ".entities.\(entity.uri ?? "")", with: "")

                                                                    self.url += ".entities.\(entity.uri ?? "")"
                                                                    self.url += ".entity_groups[\(entityGroupIndex.description)].\(entityGroup[entityGroupIndex].value.uri ?? "")"
                                                                    self.url += ".entities.\(nestedEntity.uri ?? "")"

                                                                    self.revokeEntity(entityObj: nestedEntity.convertToString ?? "", path: self.url)
                                                                }

                                                            }
                                                        }
                                                        if nestedEntity.type == .calculatedEntity && nestedEntity.calculation != nil {
                                                            self.executeCalculativeScrip(parentObj: ddcModel?.template?.sortedArray?[entityIndex].value.sortedEntityGroupsArray?[nentityGroupIndex].value.convertToString ?? "", scriptString: nestedEntity.calculation!) { value in
                                                                
                                                                RequestHelper.shared.createRequestForEntity(entity: nestedEntity, newValue: value, entityGroupId: nestedEntityGroup[nentityGroupIndex].value.uniqueId  ,parentEntityGroupId: data.uniqueId ,isCalculativeEntity: true, groupOrder: ddcModel?.template?.sortedArray?[entityIndex].value.sortedEntityGroupsArray?[nentityGroupIndex].value.order ?? 0)

                                                                
                                                                ddcModel?.template?.sortedArray?[entityIndex].value.sortedEntityGroupsArray?[entityGroupIndex].value.sortedEntitiesArray?[nestedEntityIndex].value.sortedEntityGroupsArray?[nentityGroupIndex].value.sortedEntitiesArray?[nnestedEntityIndex].value.value = AnyCodable(value)
                                                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ReloadTable"), object: nil)
                                                          }
                                                        }

                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    func getCalculativeCount() {
        entities = [:]
        calculativeCount = 0
        let mainEntities = ddcModel?.template?.sortedArray
        for entityIndex in 0..<(mainEntities?.count ?? 0) {
            if let entity = mainEntities?[entityIndex].value {
                if entity.type == .calculatedEntity && entity.calculation != nil {
                   calculativeCount += 1
                }
                if entity.type == .entityGroupRepeatable || entity.type == .entityGroup {
                    if let entityGroup = entity.sortedEntityGroupsArray {
                        for entityGroupIndex in 0..<(entityGroup.count ) {
                            let data = entityGroup[entityGroupIndex].value
                            for nestedEntityIndex in 0..<(data.sortedEntitiesArray?.count ?? 0) {
                                if let nestedEntity = data.sortedEntitiesArray?[nestedEntityIndex].value {

                                    if nestedEntity.type == .calculatedEntity && nestedEntity.calculation != nil {
                                        calculativeCount += 1
                                    }
                                    if nestedEntity.type == .entityGroupRepeatable || entity.type == .entityGroup{
                                        if let nestedEntityGroup = nestedEntity.sortedEntityGroupsArray {
                                            for nentityGroupIndex in 0..<(nestedEntityGroup.count ) {
                                                let data = nestedEntityGroup[nentityGroupIndex].value
                                                for nnestedEntityIndex in 0..<(data.sortedEntitiesArray?.count ?? 0) {
                                                    if let nestedEntity = data.sortedEntitiesArray?[nnestedEntityIndex].value {

                                                        if nestedEntity.type == .calculatedEntity && nestedEntity.calculation != nil {
                                                            calculativeCount += 1
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    func revokeEntity(entityObj:String, path:String) {
        var entityDic  = [String:Any]()
        if let data = entityObj.data(using: .utf8) {
            let dic = try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.fragmentsAllowed) as! [String: Any]
            entityDic = dic
            
        }
        let parameters : [String: Any] = [
            "baseEntity_path" : path,
            "baseEntity" : entityDic,
            "template_instance_id" : ddcModel?.template?.instanceID ?? ""
        ]
        
        let jsonData = try! JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions.prettyPrinted)
        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        print(jsonString)

        ERProgressHud.shared.show()
        APIManager.sharedInstance.makeRequestToRevokeBaseEntity(data: jsonData){ (success, response,statusCode)  in
            if (success) {
                ERProgressHud.shared.hide()
                print(response)
            } else {
//                APIManager.sharedInstance.showAlertWithMessage(message: ERROR_MESSAGE_DEFAULT)
                ERProgressHud.shared.hide()
            }
        }
    }
    
    func executeScrip(parentObj:String,scriptString: String, completion: @escaping  (Bool, Bool) -> ()) {
        let template = ddcModel?.template?.convertToString ?? ""
        
//        let jsCode = "return this.entities.symptoms.value.includes(\"symptoms___1\") ; "
        let jsCode = scriptString

        let script = "\"use strict\"; function  ddcscript(templateString,parentString) { " +
        "var parent=parentString; " +
        "var template=templateString; " +
        "template.executeJSCode = function(parent) {" + jsCode + "}; " +
        "return template.executeJSCode(parent); " +
        "}";
        
        let stringtoint = "function stringToInt(value) { return (value && !Number.isNaN(value) ? parseInt(value, 10) : NaN) }"
        
        context.evaluateScript(stringtoint)
        context.evaluateScript(script)
        
        let result: JSValue = context.evaluateScript("ddcscript(\(template),\(parentObj));")
        print("isVisible jsScript Result - ",result, "-------", jsCode)
        let boolValue = result.toBool()
        completion(!boolValue, boolValue)
        
//        let parameters : [String: String] = [
//            "jsCode" : scriptString,
//            "parent" : parentObj,
//            "template" : ddcModel?.template?.convertToString ?? ""
//        ]
//
//        let jsonData = try! JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions.prettyPrinted)
//        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
//        print(jsonString)
//
//        ERProgressHud.shared.show()
//        APIManager.sharedInstance.makeRequestToExecuteDDCScript(jsonString: jsonString, data: jsonData){ (success, response,statusCode)  in
//            if (success) {
//                ERProgressHud.shared.hide()
//                print(response)
//                let isHidden = !response
//                completion(isHidden)
//            } else {
//                completion(true)
////                APIManager.sharedInstance.showAlertWithMessage(message: ERROR_MESSAGE_DEFAULT)
//                ERProgressHud.shared.hide()
//            }
//        }
    }
    
    
    func executeCalculativeScrip(parentObj:String,scriptString: String, completion: @escaping  (String) -> ()) {
        let template = ddcModel?.template?.convertToString ?? ""
        
//        let jsCode = "return this.entities.symptoms.value.includes(\"symptoms___1\") ; "
        let jsCode = scriptString

        let script = "\"use strict\"; function  ddcscript(templateString,parentString) { " +
        "var parent=parentString; " +
        "var template=templateString; " +
        "template.executeJSCode = function(parent) {" + jsCode + "}; " +
        "return template.executeJSCode(parent); " +
        "}";
        
        let stringtoint = "function stringToInt(value) { return (value && !Number.isNaN(value) ? parseInt(value, 10) : NaN) }"
        
        context.evaluateScript(stringtoint)
        context.evaluateScript(script)
        
        let result1s: JSValue = context.evaluateScript("ddcscript(\(template),\(parentObj));")
        
        print("Calculative jsScript Result - ",(result1s.toString()!))
        
        let value = result1s.toString()!
        completion(value)
        
        
//        ddcModel?.template?.sortedArray?[calcuEntityIndex].value.value = AnyCodable(value)
//        print(ddcModel?.template?.sortedArray?[calcuEntityIndex].value.value)
        
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ReloadTable"), object: nil)
        
//        let parameters : [String: String] = [
//            "jsCode" : scriptString,
//            "parent" : parentObj,
//            "template" : ddcModel?.template?.convertToString ?? ""
//        ]
//        let jsonData = try! JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions.prettyPrinted)
//        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
//        print(jsonString)
//
//        ERProgressHud.shared.show()
//        APIManager.sharedInstance.makeRequestToExecuteCalculativeDDCScript(jsonString: jsonString, data: jsonData){ (success, response,statusCode)  in
//            if (success) {
//                ERProgressHud.shared.hide()
//                print(response)
//            } else {
//                APIManager.sharedInstance.showAlertWithMessage(message: ERROR_MESSAGE_DEFAULT)
//                ERProgressHud.shared.hide()
//            }
//        }
    }
    
    
}
