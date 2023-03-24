//
//  SafecheckConstant.swift
//  Compan
//
//  Created by Ambu Sangoli on 06/10/22.
//

import Foundation
import UIKit


//Safecheck base url

// Dev
//let FLOW_BASE_URL = "http://192.168.199.83:8081"

// UAT
let FLOW_BASE_URL = "https://safecheckbackend.azurewebsites.net"//"https://mt-vernon-safecheck-dev-backend.azurewebsites.net"

let API_END_LOGIN = "/login"
let API_END_START_SURVEY = "/startSurvey"
let API_END_COMPLETE_SURVEY = "/completeSurvey"
let API_END_ADD_TOKEN = "/add-token"


let EVENT_BASE_URL = "http://192.168.199.80:8082/events"
let API_END_CREATE_EVENT = "/create"
