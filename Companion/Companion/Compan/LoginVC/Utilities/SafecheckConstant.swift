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


// PROD
//let EVENT_BASE_URL = "https://companioneventapi.azurewebsites.net"//"http://192.168.199.90:8080"//

// DEV
let EVENT_BASE_URL = "https://companion-evenetapi-dev.azurewebsites.net"//"http://192.168.199.90:8080"//

let API_END_CREATE_EVENT = "/eventapi/events/create"
let API_END_GET_EVENTS = "/eventapi/events/survey/date-range"//"/eventapi/events/date-range"
let API_END_DELETE_EVENT = "/eventapi/events/delete"
let API_END_ADD_DEVICE_TOKEN = "/eventapi/add-token"
let API_END_GUEST_LOGIN = "/eventapi/guest-login"
let API_END_GET_CALL_LOGS = "/eventapi/call-logs-for-user"
let API_END_GET_MEETING_LOGS = "/eventapi/meeting-logs-for-user"

let API_END_START_CALL = "/eventapi/start-call"
let API_END_ACCEPT_CALL = "/eventapi/accept-call"
let API_END_REJECT_CALL = "/eventapi/reject-call"
let API_END_END_CALL = "/eventapi/end-call"
let API_END_LOGOUT = "/eventapi/logout"
let API_END_GET_CARETEAM = "/eventapi/get-care-team"

let API_END_JOIN_EVENT = "/eventapi/join-event"
let API_END_LEAVE_EVENT = "/eventapi/leave-event"
let API_END_GET_EVENT_DETAILS = "/eventapi/get-event-details"
let API_END_USER_BUSY = "/eventapi/user-busy"


let API_END_START_SURVEY_NEW = "/eventapi/start-survey/"
let API_END_SUBMIT_SURVEY = "/eventapi/submit-survey"

let API_END_SAVE_INSTRUMENTID = "/eventapi/save-instrument-id-started-event"
