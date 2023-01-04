//
//  ValidationHelper.swift
//  Compan
//
//  Created by Ambu Sangoli on 8/22/22.
//

import Foundation

class ValidationHelper : NSObject {
    
    static let shared = ValidationHelper()
    
    func checkValidation(ddcModel: DDCFormModel?) -> Bool {
        let mainEntities = ddcModel?.template?.sortedArray
        for entityIndex in 0..<(mainEntities?.count ?? 0) {
            if let entity = mainEntities?[entityIndex].value {
                
                if entity.type == .entityGroupRepeatable || entity.type == .entityGroup{
                    if let entityGroup = entity.sortedEntityGroupsArray {
                        for entityGroupIndex in 0..<(entityGroup.count ) {
                            let data = entityGroup[entityGroupIndex].value
                            for nestedEntityIndex in 0..<(data.sortedEntitiesArray?.count ?? 0) {
                                if let nestedEntity = data.sortedEntitiesArray?[nestedEntityIndex].value {
                                    
                                    if nestedEntity.type == .entityGroupRepeatable || entity.type == .entityGroup{
                                        if let nestedEntityGroup = nestedEntity.sortedEntityGroupsArray {
                                            for nentityGroupIndex in 0..<(nestedEntityGroup.count ) {
                                                let data = nestedEntityGroup[nentityGroupIndex].value
                                                for nnestedEntityIndex in 0..<(data.sortedEntitiesArray?.count ?? 0) {
                                                    if let nestedEntity = data.sortedEntitiesArray?[nnestedEntityIndex].value {
                                                        if ComponentUtils.isValueEmpty(entity: nestedEntity) == true {
                                                            return false
                                                        }
                                                        }
                                                    }
                                                }
                                            }
                                    } else {
                                        if ComponentUtils.isValueEmpty(entity: nestedEntity) == true {
                                            return false
                                        }
                                    }
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
    
