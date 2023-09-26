//
//  SurveyListVC.swift
//  Companion
//
//  Created by Ambu Sangoli on 21/09/23.
//

import UIKit
import NotificationBannerSwift

class SurveyListVC: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    
    var vc : HomeViewController?
    var nav : UINavigationController?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Surveys"
        self.tableView.reloadData()
    }
    

}

extension SurveyListVC : UITableViewDataSource, UITableViewDelegate, DynamicTemplateViewControllerDelegate {

    
    func didSubmitEventForm(response: NSArray) {
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return surveyData.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let data = surveyData[section]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyy"
        let newDate = dateFormatter.date(from: data.date)

        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d, yyyy"
        let dateString = formatter.string(from: newDate! as Date)
                return dateString
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SurveyCell") as! SurveyCell
        cell.nameLabel.text = surveyData[indexPath.section].surverys[0].name
        cell.completedDateLabel.text = "SurveyId: \(surveyData[indexPath.section].surverys[0].surveyId)"
        cell.tagView.layer.cornerRadius = 4
        cell.tagView.layer.borderWidth = 1

        if surveyData[indexPath.section].surverys[0].concept == "SURVEY ASSIGNED" {
            cell.tagView.layer.borderColor = DARK_BLUE_COLOR.cgColor
            cell.typeLabel.textColor = DARK_BLUE_COLOR
            cell.typeLabel.text = "Assigned"
        } else if surveyData[indexPath.section].surverys[0].concept == "SURVEY STARTED" {
            cell.tagView.layer.borderColor = UIColor(red: 246/255, green: 109/255, blue: 109/255, alpha: 1.0).cgColor
            cell.typeLabel.textColor = UIColor(red: 246/255, green: 109/255, blue: 109/255, alpha: 1.0)
            cell.typeLabel.text = "Pending"
        } else if surveyData[indexPath.section].surverys[0].concept == "SURVEY SUBMITTED" {
            cell.tagView.layer.borderColor = UIColor(red: 51/255, green: 102/255, blue: 0/255, alpha: 1.0).cgColor
            cell.typeLabel.textColor = UIColor(red: 51/255, green: 102/255, blue: 0/255, alpha: 1.0)
            cell.typeLabel.text = "Completed"
        }
        return cell
    }
    

    
    // MARK:- UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.openDDCForm(index: indexPath.section)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func openDDCForm(index: Int) {
        let templatedId = surveyData[index].surverys[0].templateId
        let surveyStatus = surveyData[index].surverys[0].concept
        let eventId = surveyData[index].surverys[0].eventId
        let instrumentId = surveyData[index].surverys[0].instrumentId
        var shouldStartSurvey = false
        var isReadOnly = false
        if surveyStatus == "SURVEY ASSIGNED" {
            shouldStartSurvey = true
        }  else if surveyStatus == "SURVEY SUBMITTED" {
            isReadOnly = true
        }
        self.openForm(templateId: templatedId,eventId: eventId,callStartSurvey: shouldStartSurvey,instrumentId: instrumentId, isReadOnly: isReadOnly)
    }
    
    
    func openForm(templateId: String, eventId: String, callStartSurvey: Bool,instrumentId: String?,isReadOnly: Bool) {
        if callStartSurvey {
            self.startSurvey(eventId: eventId, templateId: templateId)
        } else {
            self.getTemplate(templateId: templateId, eventId: eventId, instrumentId: instrumentId,isReadOly: isReadOnly)
        }
    }
    
    func didSubmitSurveyForm(response: NSArray, eventId: String) {
        self.submitSurvey(ddcResponse: response, eventId: eventId)
    }
    
    //Get Template Api Call
    func getTemplate(templateId: String,eventId: String, shouldUpdateIndex: Bool = false, newEventId: String = "",instrumentId:String?,isReadOly: Bool = false){
            ERProgressHud.shared.show()
            APIManager.sharedInstance.makeRequestToGetTemplate(templateId: templateId){ (success, response,statusCode)  in
                if (success) {
                    print(response)
                    if let responseData = response as? Dictionary<String, Any> {
                                      var jsonData: Data? = nil
                                      do {
                                          jsonData = try JSONSerialization.data(
                                              withJSONObject: responseData as Any,
                                              options: .prettyPrinted)
                                          do{
                                              let jsonDataModels = try JSONDecoder().decode(DDCFormModell.self, from: jsonData!)
                                              print(jsonDataModels)
                                              let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                              let vc = storyboard.instantiateViewController(withIdentifier: "dynamic") as! DynamiccTemplateViewController
                                              ddcModel = jsonDataModels
                                              vc.delegate = self
                                              vc.eventId = eventId
                                              vc.hideIndexField = true
                                              isReadOnly = false
                                              if let id = instrumentId {
                                                  isReadOnly = isReadOly
                                                  self.getInstrument(instrumentId: id)
                                              } else {
                                                  self.saveInstrument(templateId: jsonDataModels.id!,shouldUpdateIndex: shouldUpdateIndex, newEventId: newEventId, oldEventId: eventId)
                                              }
                                              vc.hidesBottomBarWhenPushed = true
                                              self.navigationController?.pushViewController(vc, animated: true)

                                          }catch {
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
        
        
    func saveInstrument(templateId: String,shouldUpdateIndex: Bool = false, newEventId: String = "", oldEventId: String = "",isEventTemplate : Bool = false){
            let parameter : [String:Any] = ["templateId": templateId, "predefinedFields": [:] ]
            let jsonData = try! JSONSerialization.data(withJSONObject: parameter, options: JSONSerialization.WritingOptions.prettyPrinted)
            let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
            print(jsonString)

            APIManager.sharedInstance.makeRequestToSaveInstrument(data: jsonData){ (success, response,statusCode)  in
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
                                              if !isEventTemplate {
                                                  if shouldUpdateIndex {
                                                      NewRequestHelper.shared.updateIndexField(eventId: newEventId)
                                                  } else {
                                                      NewRequestHelper.shared.updateIndexField(eventId: oldEventId)
                                                  }
                                              } else {
                                                  NewRequestHelper.shared.updateIndexField(eventId: self.random(digits: 8))
                                              }
                                              NewScriptHelper.shared.checkIsVisibleEntity(ddcModel: ddcModel)
                                              if (self.navigationController?.topViewController as? DynamiccTemplateViewController) != nil {
                                                  NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ReloadTable"), object: nil)
                                                  return
                                              }
                                          } catch {
                                              print(error)
                                          }
                                      } catch {
                                          print(error)
                                      }
                            }            } else {
                    APIManager.sharedInstance.showAlertWithMessage(message: ERROR_MESSAGE_DEFAULT)
                    ERProgressHud.shared.hide()
                }
            }
        }
        
        func getInstrument(instrumentId: String){
            APIManager.sharedInstance.makeRequestToGetInstrument(instrumentId: instrumentId){ (success, response,statusCode)  in
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
                                              instruments = jsonDataModels
                                              NewScriptHelper.shared.checkIsVisibleEntity(ddcModel: ddcModel)
                                              if (self.navigationController?.topViewController as? DynamiccTemplateViewController) != nil {
                                                  NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ReloadTable"), object: nil)
                                                  return
                                              }
                                              
                                          } catch {
                                              print(error)
                                          }
                                      } catch {
                                          print(error)
                                      }
                            }            } else {
                    APIManager.sharedInstance.showAlertWithMessage(message: ERROR_MESSAGE_DEFAULT)
                    ERProgressHud.shared.hide()
                }
            }
        }
    
    func startSurvey(eventId: String, templateId: String) {
        BaseAPIManager.sharedInstance.makeRequestToStartSurveyNew(eventId: eventId){ (success, response,statusCode)  in
            if (success) {
                print(response)
                let newEventId = response["eventId"] as? String ?? ""
                self.getTemplate(templateId: templateId,eventId: eventId, shouldUpdateIndex: true,newEventId: newEventId, instrumentId: nil)
            } else {
                APIManager.sharedInstance.showAlertWithMessage(message: ERROR_MESSAGE_DEFAULT)
                ERProgressHud.shared.hide()
            }
        }
    }
    
    func submitSurvey(ddcResponse: NSArray, eventId: String) {
        let observationKey : [String:Any] = ["observations":ddcResponse]
        var parameter : [String:Any] = ["ddcResponse": observationKey, "eventId": eventId]
        if let retrievedCodableObject = SafeCheckUtils.getUserData() {
            parameter["mei"] = retrievedCodableObject.user?.mail
        }
            let jsonData = try! JSONSerialization.data(withJSONObject: parameter, options: JSONSerialization.WritingOptions.prettyPrinted)
            let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
            print(jsonString)

            BaseAPIManager.sharedInstance.makeRequestToSubmitSurvey(data: jsonData){ (success, response,statusCode)  in
                if (success) {
                    print(response)
                    let banner = NotificationBanner(title: "Success", subtitle: "Survey Submitted successfully.", style: .success)
                    banner.show()
                    self.nav?.popToRootViewController(animated: true)
                } else {
                    APIManager.sharedInstance.showAlertWithMessage(message: ERROR_MESSAGE_DEFAULT)
                    ERProgressHud.shared.hide()
                }
            }
    }
    
    func random(digits:Int) -> String {
        var number = String()
        for _ in 1...digits {
           number += "\(Int.random(in: 1...9))"
        }
        return number
    }
    
}
