//
//  Instruments.swift
//  ddcv2
//
//  Created by Ambu Sangoli on 01/09/23.
//

import Foundation

// MARK: - Instruments
class Instruments: Codable {
    var indexes: [String]?
    var instrumentsContext, templateID: String?
    var isActive: Bool?
    var conceptID: String?
    var entities: [Entityy]?
    var id: String?
    var type: String?
    var context: Context?

    enum CodingKeys: String, CodingKey {
        case indexes
        case instrumentsContext = "context"
        case templateID = "templateId"
        case isActive
        case conceptID = "conceptId"
        case entities
        case id = "@id"
        case type = "@type"
        case context = "@context"
    }

    init(indexes: [String]?, instrumentsContext: String?, templateID: String?, isActive: Bool?, conceptID: String?, entities: [Entityy]?, id: String?, type: String?, context: Context?) {
        self.indexes = indexes
        self.instrumentsContext = instrumentsContext
        self.templateID = templateID
        self.isActive = isActive
        self.conceptID = conceptID
        self.entities = entities
        self.id = id
        self.type = type
        self.context = context
    }
}

// MARK: - Context
class Contextt: Codable {
    var lastUpdatedBy: String?
    var ddc, instrument: String?
    var templateID, entityTemplateID: TemplateID?
    var entityInstrument: String?
    var lastUpdatedDate, indexes, entities, context: String?
    var conceptID, value, status, order: String?

    enum CodingKeys: String, CodingKey {
        case lastUpdatedBy, ddc, instrument
        case templateID = "templateId"
        case entityTemplateID = "entityTemplateId"
        case entityInstrument, lastUpdatedDate, indexes, entities, context
        case conceptID = "conceptId"
        case value, status, order
    }

    init(lastUpdatedBy: String?, ddc: String?, instrument: String?, templateID: TemplateID?, entityTemplateID: TemplateID?, entityInstrument: String?, lastUpdatedDate: String?, indexes: String?, entities: String?, context: String?, conceptID: String?, value: String?, status: String?, order: String?) {
        self.lastUpdatedBy = lastUpdatedBy
        self.ddc = ddc
        self.instrument = instrument
        self.templateID = templateID
        self.entityTemplateID = entityTemplateID
        self.entityInstrument = entityInstrument
        self.lastUpdatedDate = lastUpdatedDate
        self.indexes = indexes
        self.entities = entities
        self.context = context
        self.conceptID = conceptID
        self.value = value
        self.status = status
        self.order = order
    }
}

// MARK: - TemplateID
class TemplateID: Codable {
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
class Entityy: Codable {
    var parentEntityInstrumentID, conceptID, entityTemplateID: String?
    var order: Int?
    var instrumentID: String?
    var entityType: String?
    var lastUpdatedDate: Int?
    var lastUpdatedBy: String?
    var value, id: String?
    var type: String?

    enum CodingKeys: String, CodingKey {
        case parentEntityInstrumentID = "parentEntityInstrumentId"
        case conceptID = "conceptId"
        case entityTemplateID = "entityTemplateId"
        case order
        case instrumentID = "instrumentId"
        case entityType = "type"
        case lastUpdatedDate, lastUpdatedBy, value
        case id = "@id"
        case type = "@type"
    }

    init(parentEntityInstrumentID: String?, conceptID: String?, entityTemplateID: String?, order: Int?, instrumentID: String?, entityType: String?, lastUpdatedDate: Int?, lastUpdatedBy: String?, value: String?, id: String?, type: String?) {
        self.parentEntityInstrumentID = parentEntityInstrumentID
        self.conceptID = conceptID
        self.entityTemplateID = entityTemplateID
        self.order = order
        self.instrumentID = instrumentID
        self.entityType = entityType
        self.lastUpdatedDate = lastUpdatedDate
        self.lastUpdatedBy = lastUpdatedBy
        self.value = value
        self.id = id
        self.type = type
    }
}

