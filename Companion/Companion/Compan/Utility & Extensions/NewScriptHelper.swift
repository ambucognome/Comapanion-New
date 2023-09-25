//
//  ScriptHelper.swift
//  ddcv2
//
//  Created by Ambu Sangoli on 30/08/23.
//

import Foundation
import JavaScriptCore

class NewScriptHelper : NSObject {

    let context = JSContext()!
    static let shared = NewScriptHelper()
    
    func checkIsVisibleEntity(ddcModel : DDCFormModell?) {
        let mainEntities = ddcModel?.entities
        for entityIndex in 0..<(mainEntities?.count ?? 0) {
            if let entity = mainEntities?[entityIndex] {
                if entity.isVisible != nil {
                    self.executeScrip(parentObj: ddcModel.convertToString ?? "", scriptString: entity.isVisible!, ddcModel: ddcModel) { isHidden, isVisible in
                        print(isVisible)
                    }
                }
                if entity.entityType == .entityGroupRepeatable || entity.entityType == .entityGroup {
                    if let entityGroup = entity.entityGroup {
                        let data = entityGroup.entities
                            for nestedEntityIndex in 0..<(data?.count ?? 0) {
                                if let nestedEntity = data?[nestedEntityIndex] {
                                    if nestedEntity.isVisible != nil {
                                        self.executeScrip(parentObj: ddcModel?.entities?[entityIndex].entityGroup?.convertToString ?? "", scriptString: nestedEntity.isVisible!, ddcModel: ddcModel) { isHidden,isVisible  in
                                            print("isVisible found")
                                            //                                            ddcModel?.template?.sortedArray?[entityIndex].value.sortedEntityGroupsArray?[entityGroupIndex].value.sortedEntitiesArray?[nestedEntityIndex].value.isHidden = isHidden
                                        }
                                    }
                                }
                        }
                    }
                }
            }
        }
        
    }
    
    
    //TODO: Change script according to new model
//    func executeScrip(parentObj:String,scriptString: String,ddcModel: DDCFormModel?, completion: @escaping  (Bool, Bool) -> ()) {
//        let template = ddcModel.convertToString ?? ""
//
//        let jsCode = scriptString
//
//        let script = "\"use strict\"; function  ddcscript(templateString,parentString) { " +
//        "var parent=parentString; " +
//        "var template=templateString; " +
//        "template.executeJSCode = function(parent) {" + jsCode + "}; " +
//        "return template.executeJSCode(parent); " +
//        "}";
//
//        let stringtoint = "function stringToInt(value) { return (value && !Number.isNaN(value) ? parseInt(value, 10) : NaN) }"
//
//        context.evaluateScript(stringtoint)
//        context.evaluateScript(script)
//
//        let result: JSValue = context.evaluateScript("ddcscript(\(template),\(parentObj));")
//        print("isVisible jsScript Result - ",result, "-------", jsCode)
//        let boolValue = result.toBool()
//        completion(!boolValue, boolValue)
//    }
    
    
    func executeScrip(parentObj:String,scriptString: String,ddcModel: DDCFormModell?, completion: @escaping  (Bool, Bool) -> ()) {
        let jsCode = scriptString
        
        var entityDic = [Any]()
        if let instrumentEntities = instruments?.entities {
            for entity in instrumentEntities {
                if let id = entity.entityTemplateID {
                    if let data = (entity.convertToString ?? "").data(using: .utf8) {
                            do {
                                let dic = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                                let array : [Any] = [id,dic!]
                                entityDic.append(array)
                    
//                                entityDic[id] = dic
                            } catch {
                                print(error.localizedDescription)
                            }
                        }
                }
            }
        }
        
        let jsonData = try! JSONSerialization.data(withJSONObject: entityDic, options: .prettyPrinted)
//        let entityMapStr = try! JSONSerialization.jsonObject(with: jsonData, options: [])
        
        let convertedString = String(data: jsonData, encoding: String.Encoding.utf8) ?? ""

        
        let script = "\"use strict\"; function  ddcscript(parentString,entityMapString) { " +
        "var parent=parentString; " +
        "var entityMap=entityMapString; " +
        jsCode + "}";

 
        let stringtoint = "function stringToInt(value) { return (value && !Number.isNaN(value) ? parseInt(value, 10) : NaN) }"

        let getEntityById = "function getEntityById(id, entities) { for (let i = 0; i < entities.length; i++) {if (entities[i]['@id'] === id) {return entities[i]}}}"
        
        context.evaluateScript(stringtoint)
        context.evaluateScript(getEntityById)
        context.evaluateScript(script)
        
        let result: JSValue = context.evaluateScript("ddcscript(\(parentObj),\(convertedString));")
        print("isVisible jsScript Result - ",result, "-------", jsCode)
        let boolValue = result.toBool()
        completion(!boolValue, boolValue)
    }
    
    
}
