//
//  LoginModel.swift
//  Compan
//
//  Created by Ambu Sangoli on 7/29/22.
//
//
//   let loginModel = try? newJSONDecoder().decode(LoginModel.self, from: jsonData)

import Foundation

// MARK: - LoginModel
class LoginModel: Codable {
    var showScreen: String?
    var user: User?

    init(showScreen: String?, user: User?) {
        self.showScreen = showScreen
        self.user = user
    }
}

// MARK: - User
class User: Codable {
    var ohsInfo: Dictionary<String,AnyCodable>?
    var eid, firstname, mail, campusHcm: String?
    var persArea, cmp, lastname, primaryPhone: String?
    var managerName, ouTitle: String?
    var managerID: String?
    var jwtToken, jobTitle, ouAddress: String?

    enum CodingKeys: String, CodingKey {
        case ohsInfo = "ohs_info"
        case eid, firstname, mail
        case campusHcm = "campus_hcm"
        case persArea = "pers_area"
        case cmp, lastname
        case primaryPhone = "primary_phone"
        case managerName = "manager_name"
        case ouTitle = "ou_title"
        case managerID = "manager_id"
        case jwtToken
        case jobTitle = "job_title"
        case ouAddress = "ou_address"
    }

    init(ohsInfo: Dictionary<String,AnyCodable>?, eid: String?, firstname: String?, mail: String?, campusHcm: String?, persArea: String?, cmp: String?, lastname: String?, primaryPhone: String?, managerName: String?, ouTitle: String?, managerID: String?, jwtToken: String?, jobTitle: String?, ouAddress: String?) {
        self.ohsInfo = ohsInfo
        self.eid = eid
        self.firstname = firstname
        self.mail = mail
        self.campusHcm = campusHcm
        self.persArea = persArea
        self.cmp = cmp
        self.lastname = lastname
        self.primaryPhone = primaryPhone
        self.managerName = managerName
        self.ouTitle = ouTitle
        self.managerID = managerID
        self.jwtToken = jwtToken
        self.jobTitle = jobTitle
        self.ouAddress = ouAddress
    }
}

// MARK: - OhsInfo
class OhsInfo: Codable {
    var exception: String?
    var afterTravelNegativeResultLabTestDate, returnClearance, afterSymptomsNegativeResultLabTestDate, clearanceDate: JSONNull?
    var labTestDate, labOrderDate, testDate, currSympt: JSONNull?
    var firstName, outEnd, quarantineOverride, symptomsStart: JSONNull?
    var positiveResultLabTestDate, travelDateReturn, outOfWork, mrn: JSONNull?
    var exposureDate, lastName: JSONNull?
    var travelQuarentineEnd: String?
    var dayZero: JSONNull?
    var recordID: String?
    var travel, testResults, outStart: JSONNull?

    enum CodingKeys: String, CodingKey {
        case exception
        case afterTravelNegativeResultLabTestDate = "after_travel_negative_result_lab_test_date"
        case returnClearance = "return_clearance"
        case afterSymptomsNegativeResultLabTestDate = "after_symptoms_negative_result_lab_test_date"
        case clearanceDate = "clearance_date"
        case labTestDate = "lab_test_date"
        case labOrderDate = "lab_order_date"
        case testDate = "test_date"
        case currSympt = "curr_sympt"
        case firstName = "first_name"
        case outEnd = "out_end"
        case quarantineOverride = "quarantine_override"
        case symptomsStart = "symptoms_start"
        case positiveResultLabTestDate = "positive_result_lab_test_date"
        case travelDateReturn = "travel_date_return"
        case outOfWork = "out_of_work"
        case mrn
        case exposureDate = "exposure_date"
        case lastName = "last_name"
        case travelQuarentineEnd = "travel_quarentine_end"
        case dayZero
        case recordID = "record_id"
        case travel
        case testResults = "test_results"
        case outStart = "out_start"
    }

    init(exception: String?, afterTravelNegativeResultLabTestDate: JSONNull?, returnClearance: JSONNull?, afterSymptomsNegativeResultLabTestDate: JSONNull?, clearanceDate: JSONNull?, labTestDate: JSONNull?, labOrderDate: JSONNull?, testDate: JSONNull?, currSympt: JSONNull?, firstName: JSONNull?, outEnd: JSONNull?, quarantineOverride: JSONNull?, symptomsStart: JSONNull?, positiveResultLabTestDate: JSONNull?, travelDateReturn: JSONNull?, outOfWork: JSONNull?, mrn: JSONNull?, exposureDate: JSONNull?, lastName: JSONNull?, travelQuarentineEnd: String?, dayZero: JSONNull?, recordID: String?, travel: JSONNull?, testResults: JSONNull?, outStart: JSONNull?) {
        self.exception = exception
        self.afterTravelNegativeResultLabTestDate = afterTravelNegativeResultLabTestDate
        self.returnClearance = returnClearance
        self.afterSymptomsNegativeResultLabTestDate = afterSymptomsNegativeResultLabTestDate
        self.clearanceDate = clearanceDate
        self.labTestDate = labTestDate
        self.labOrderDate = labOrderDate
        self.testDate = testDate
        self.currSympt = currSympt
        self.firstName = firstName
        self.outEnd = outEnd
        self.quarantineOverride = quarantineOverride
        self.symptomsStart = symptomsStart
        self.positiveResultLabTestDate = positiveResultLabTestDate
        self.travelDateReturn = travelDateReturn
        self.outOfWork = outOfWork
        self.mrn = mrn
        self.exposureDate = exposureDate
        self.lastName = lastName
        self.travelQuarentineEnd = travelQuarentineEnd
        self.dayZero = dayZero
        self.recordID = recordID
        self.travel = travel
        self.testResults = testResults
        self.outStart = outStart
    }
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}


extension Encodable {

    /// Converting object to postable dictionary
    func toDictionary(_ encoder: JSONEncoder = JSONEncoder()) throws -> [String: Any] {
        let data = try! encoder.encode(self)
        let object = try! JSONSerialization.jsonObject(with: data)
        guard let json = object as? [String: Any] else {
            let context = DecodingError.Context(codingPath: [], debugDescription: "Deserialized object is not a dictionary")
            throw DecodingError.typeMismatch(type(of: object), context)
        }
        return json
    }
}
