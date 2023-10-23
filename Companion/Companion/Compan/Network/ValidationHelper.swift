//
//  ValidationHelper.swift
//  ddcv2
//
//  Created by Ambu Sangoli on 23/09/23.
//

import Foundation

class ValidationHelper : NSObject {
    
    static let shared = ValidationHelper()
    
    func checkValidation(ddcModel: DDCFormModell?) -> Bool {
        let mainEntities = ddcModel?.entities
        for entityIndex in 0..<(mainEntities?.count ?? 0) {
            if let entity = mainEntities?[entityIndex] {
                if entity.entityType == .entityGroupRepeatable || entity.entityType == .entityGroup {
                    if let entityGroup = entity.entityGroup {
                        let data = entityGroup.entities
                            for nestedEntityIndex in 0..<(data?.count ?? 0) {
                                if let nestedEntity = data?[nestedEntityIndex] {
                                    if ComponentUtils.isValueEmpty(entity: nestedEntity) == true {
                                        return false
                                    }
                                }
                        }
                    }
                } else {
                    if ComponentUtils.isValueEmpty(entity: entity) == true {
                        return false
                    }
                }
            }
        }
        return true
    }
    
}
