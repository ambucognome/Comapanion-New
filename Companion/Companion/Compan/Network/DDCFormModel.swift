//
//  DDCFormModel.swift
//  Compan
//
//  Created by Ambu Sangoli on 03/05/22.
//
//   let dDCFormModel = try? newJSONDecoder().decode(DDCFormModel.self, from: jsonData)

import Foundation

// MARK: - DDCFormModel
class DDCFormModell: Codable {
    var prefLabel, project: String?
    var tags: [String]?
    var status: String?
    var publishedDate: Int?
    var conceptID: String?
    var entities: [Entity]?
    var valueSets: [ValueSet]?
    var id, type: String?
    var context: Context?

    enum CodingKeys: String, CodingKey {
        case prefLabel, project, tags, status, publishedDate
        case conceptID = "conceptId"
        case entities, valueSets
        case id = "@id"
        case type = "@type"
        case context = "@context"
    }

    init(prefLabel: String?, project: String?, tags: [String]?, status: String?, publishedDate: Int?, conceptID: String?, entities: [Entity]?, valueSets: [ValueSet]?, id: String?, type: String?, context: Context?) {
        self.prefLabel = prefLabel
        self.project = project
        self.tags = tags
        self.status = status
        self.publishedDate = publishedDate
        self.conceptID = conceptID
        self.entities = entities
        self.valueSets = valueSets
        self.id = id
        self.type = type
        self.context = context
    }
}

// MARK: - Context
class Context: Codable {
    var template: String?
    var calculation, dateFormat, defaultValue, project: String?
    var description: String?
    var entityTemplateSetting: String?
    var isActive, type, contextRequired, entityGroup: String?
    var isReadOnly, min: String?
    var valueSetTemplate: String?
    var guiControlType, conceptID, placeholderText, value: String?
    var valueSetData, order, onValue, settings: String?
    var ddc: String?
    var isIndexed, max, prefLabel, errorMessage: String?
    var label, isVisible: String?
    var version: Version?
    var uri, url, tags: String?
    var entityTemplate: String?
    var isReferenceKey, entities, valueSetID, timeFormat: String?
    var valueSets, indexOrder, step: String?

    enum CodingKeys: String, CodingKey {
        case template, calculation, dateFormat, defaultValue, project, description, entityTemplateSetting, isActive, type
        case contextRequired = "required"
        case entityGroup, isReadOnly, min, valueSetTemplate, guiControlType
        case conceptID = "conceptId"
        case placeholderText, value, valueSetData, order, onValue, settings, ddc, isIndexed, max, prefLabel, errorMessage, label, isVisible, version, uri, url, tags, entityTemplate, isReferenceKey, entities
        case valueSetID = "valueSetId"
        case timeFormat, valueSets, indexOrder, step
    }

    init(template: String?, calculation: String?, dateFormat: String?, defaultValue: String?, project: String?, description: String?, entityTemplateSetting: String?, isActive: String?, type: String?, contextRequired: String?, entityGroup: String?, isReadOnly: String?, min: String?, valueSetTemplate: String?, guiControlType: String?, conceptID: String?, placeholderText: String?, value: String?, valueSetData: String?, order: String?, onValue: String?, settings: String?, ddc: String?, isIndexed: String?, max: String?, prefLabel: String?, errorMessage: String?, label: String?, isVisible: String?, version: Version?, uri: String?, url: String?, tags: String?, entityTemplate: String?, isReferenceKey: String?, entities: String?, valueSetID: String?, timeFormat: String?, valueSets: String?, indexOrder: String?, step: String?) {
        self.template = template
        self.calculation = calculation
        self.dateFormat = dateFormat
        self.defaultValue = defaultValue
        self.project = project
        self.description = description
        self.entityTemplateSetting = entityTemplateSetting
        self.isActive = isActive
        self.type = type
        self.contextRequired = contextRequired
        self.entityGroup = entityGroup
        self.isReadOnly = isReadOnly
        self.min = min
        self.valueSetTemplate = valueSetTemplate
        self.guiControlType = guiControlType
        self.conceptID = conceptID
        self.placeholderText = placeholderText
        self.value = value
        self.valueSetData = valueSetData
        self.order = order
        self.onValue = onValue
        self.settings = settings
        self.ddc = ddc
        self.isIndexed = isIndexed
        self.max = max
        self.prefLabel = prefLabel
        self.errorMessage = errorMessage
        self.label = label
        self.isVisible = isVisible
        self.version = version
        self.uri = uri
        self.url = url
        self.tags = tags
        self.entityTemplate = entityTemplate
        self.isReferenceKey = isReferenceKey
        self.entities = entities
        self.valueSetID = valueSetID
        self.timeFormat = timeFormat
        self.valueSets = valueSets
        self.indexOrder = indexOrder
        self.step = step
    }
}

// MARK: - Version
class Version: Codable {
    var id, type: String?

    enum CodingKeys: String, CodingKey {
        case id = "@id"
        case type = "@type"
    }

    init(id: String?, type: String?) {
        self.id = id
        self.type = type
    }
}

// MARK: - Entity
class Entity: Codable {
    var entityType: EntityType?
    var label: String?
    var description: String?
    var isActive: Bool?
    var conceptID: String?
    var order: Int?
    var guiControlType: String?
    var isIndex: Bool?
    var indexOrder: Int?
    var isReferenceKey, entityRequired: Bool?
    var errorMessage, id: String?
    var type: TypeEnum?
    var valueSetID: String?
    var settings: Settings?
    var entityGroup: Entity?
    var parentEntityTemplateID: String?
    var entities: [Entity]?
    var isVisible : String?
    var isHidden : Bool = false
    let calculation: String?
    var onValue : String?

    enum CodingKeys: String, CodingKey {
        case entityType = "type"
        case label, description, isActive
        case conceptID = "conceptId"
        case order, guiControlType, isIndex, indexOrder, isReferenceKey
        case entityRequired = "required"
        case errorMessage
        case id = "@id"
        case type = "@type"
        case valueSetID = "valueSetId"
        case settings
        case parentEntityTemplateID = "parentEntityTemplateId"
        case entityGroup
        case entities
        case isVisible
        case calculation
        case onValue
    }

    init(entityType: EntityType?, label: String?, description: String?, isActive: Bool?, conceptID: String?, order: Int?, guiControlType: String?, isIndex: Bool?, indexOrder: Int?, isReferenceKey: Bool?, entityRequired: Bool?, errorMessage: String?, id: String?, type: TypeEnum?, valueSetID: String?, settings: Settings?,parentEntityTemplateID: String?, entities: [Entity]?, entityGroup: Entity?, isVisible: String?, calculation: String?, onValue: String?) {
        self.entityType = entityType
        self.label = label
        self.description = description
        self.isActive = isActive
        self.conceptID = conceptID
        self.order = order
        self.guiControlType = guiControlType
        self.isIndex = isIndex
        self.indexOrder = indexOrder
        self.isReferenceKey = isReferenceKey
        self.entityRequired = entityRequired
        self.errorMessage = errorMessage
        self.id = id
        self.type = type
        self.valueSetID = valueSetID
        self.settings = settings
        self.parentEntityTemplateID = parentEntityTemplateID
        self.entityGroup = entityGroup
        self.isVisible = isVisible
        self.calculation = calculation
    }
}

enum EntityType: String, Codable {
    case enumerationEntity = "EnumerationEntity"
    case messageEntity = "MessageEntity"
    case textEntryEntity = "TextEntryEntity"
    case entityGroupRepeatable = "EntityGroupRepeatable"
    case entityGroup = "EntityGroup"
    case calculatedEntity = "CalculatedEntity"
    
}

// MARK: - Settings
class Settings: Codable {
    var dateFormat, id, type, timeFormat: String?
    var min, max, step: String?
    var url: String?
    var placeholderText: String?

    enum CodingKeys: String, CodingKey {
        case dateFormat
        case id = "@id"
        case type = "@type"
        case timeFormat, min, max, step, url, placeholderText
    }

    init(dateFormat: String?, id: String?, type: String?, timeFormat: String?, min: String?, max: String?, step: String?, url: String?, placeholderText: String?) {
        self.dateFormat = dateFormat
        self.id = id
        self.type = type
        self.timeFormat = timeFormat
        self.min = min
        self.max = max
        self.step = step
        self.url = url
        self.placeholderText = placeholderText
    }
}

enum TypeEnum: String, Codable {
    case ddcEntityTemplate = "ddc:EntityTemplate"
}

// MARK: - ValueSet
class ValueSet: Codable {
    var prefLabel: String?
    var valueSetData: [ValueSetDatum]?
    var id, type: String?

    enum CodingKeys: String, CodingKey {
        case prefLabel, valueSetData
        case id = "@id"
        case type = "@type"
    }

    init(prefLabel: String?, valueSetData: [ValueSetDatum]?, id: String?, type: String?) {
        self.prefLabel = prefLabel
        self.valueSetData = valueSetData
        self.id = id
        self.type = type
    }
}

// MARK: - ValueSetDatum
class ValueSetDatum: Codable {
    var uri: String?
    var value: String?

    init(uri: String?, value: String?) {
        self.uri = uri
        self.value = value
    }
}
