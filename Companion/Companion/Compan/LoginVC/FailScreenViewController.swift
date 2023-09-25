//
//  FailScreenViewController.swift
//  Compan
//
//  Created by Ambu Sangoli on 8/1/22.
//

import UIKit


protocol FailScreenViewControllerDelegate {
    func forceStart(context: [String:Any])
}

class FailScreenViewController: UIViewController {
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var notClearedLabel: UILabel!
    @IBOutlet weak var infoTextView: UITextView!
    @IBOutlet weak var chatBtn: UIButton!


    var surveyStartTime = ""

    var surveyDay = ""
    var surveyDate = ""
    
    var notClearedText = "NOT CLEARED"
    var infoText = ""
    
    var delegate : FailScreenViewControllerDelegate?


    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        SocketHelper.shared.connectSocket { success in
            print(success)
            SocketHelper.Events.server_initiated_event.listen { (result) in
                if let dataArray = result as? NSArray {
                    if let string = dataArray[0] as? String {
                        if let data = string.convertToDictionary() as? NSDictionary {
                        let success = data["success"] as? Bool ?? false
                        if let type = data["type"] as? String {
                            if type == "login" {
                                if success  {
                                    let storyBoard = UIStoryboard(name: "covidCheck", bundle: nil)
                                    let messageVC = storyBoard.instantiateViewController(withIdentifier: "MessageViewController") as! MessageViewController
                                    messageVC.viewModel = MessageViewModel(bubbleStyle: .facebook )
                                    var configuration = ChatViewConfiguration.default
                                    configuration.chatBarStyle = .default
                                    configuration.imagePickerType = .actionSheet
                                    messageVC.configuration = configuration

                                    self.navigationController?.pushViewController(messageVC, animated: true)
                                }
                            }
                        }
                    }
                  }
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
        SocketHelper.Events.server_initiated_event.off()
    }

    
    func setupViews(){
        self.chatBtn.setTitle("", for: .normal)
        self.dayLabel.text = surveyDay
        self.dateLabel.text = surveyDate
        self.notClearedLabel.text = notClearedText
        self.infoTextView.text = infoText
        
        if let retrievedCodableObject =  SafeCheckUtils.getUserData() {
            self.nameLabel.text = (retrievedCodableObject.user?.firstname ?? "") + " " + (retrievedCodableObject.user?.lastname ?? "")
        }
    }
    
    @IBAction func logoutBtn(_ sender: Any) {
        LogoutHelper.shared.logout()
    }
    
    @IBAction func startBtn(_ sender: Any) {
        self.startSurvey()
    }
    
    @IBAction func chatBtn(_ sender: Any) {
        var eid = ""
        if let retrievedCodableObject =  SafeCheckUtils.getUserData() {
            self.nameLabel.text = (retrievedCodableObject.user?.firstname ?? "") + " " + (retrievedCodableObject.user?.lastname ?? "")
            userName = (retrievedCodableObject.user?.firstname ?? "") + " " + (retrievedCodableObject.user?.lastname ?? "")
            eid = retrievedCodableObject.user?.eid ?? ""
        }
        let json2String = "{\"ezid\":\"\(eid)\",\"username\":\"\(userName)\",\"userType\":\"SAFECHECK\",\"type\":\"login\"}"
        SocketHelper.Events.event.emit(params: json2String)
        
        let jsonString = "{\"ezid\":\"\(eid)\",\"username\":\"\(userName)\",\"userType\":\"SAFECHECK\",\"type\":\"login-webrtc\"}"
        SocketHelper.Events.event.emit(params: jsonString)
    }
    
    func startSurvey() {
//        surveyID = ""
//        templateURI = ""
//        ERProgressHud.shared.show()
//        if let retrievedCodableObject =  SafeCheckUtils.getUserData() {
//            let encoder = JSONEncoder()
//            encoder.outputFormatting = .prettyPrinted
//            let orderJsonData = try! encoder.encode(retrievedCodableObject.user!)
//            let jsonString = NSString(data: orderJsonData, encoding: String.Encoding.utf8.rawValue)! as String
//            print(jsonString)
//            BaseAPIManager.sharedInstance.makeRequestToStartSurvey( data: orderJsonData, isForced: "true"){ (success, response,statusCode)  in
//                        if (success) {
//                            ERProgressHud.shared.hide()
//                            print(response)
//                            let template_uri = response["ddc_template_uri"] as? String ?? ""
//                            templateURI = template_uri
//                                    if let survey = response["survey"] as? NSDictionary {
//                                        survey_data = survey
//                                        let surveyTime =  survey["survey_start"] as? String ?? ""
//                                        let id =  survey["id"] as? NSNumber ?? 0
//                                        self.surveyStartTime = Utilities.convertDateToTimestamp(date: surveyTime)
//                                        surveyID = id.stringValue
//                                        
//                                    
//                                            //open fresh form
//                                            let context = [
//                                                "survey_id" : surveyID,
//                                            "user": retrievedCodableObject.user?.eid ?? ""
//                                            ]
//                                        self.navigationController?.popViewController {
//                                            self.delegate?.forceStart(context: context)
//                                        }
//                                        
////                                                self.getTempleWith(author: "System", uri: templateURI, context: context)
//                                }
//                        } else {
//                            APIManager.sharedInstance.showAlertWithMessage(message: ERROR_MESSAGE_DEFAULT)
//                            ERProgressHud.shared.hide()
//                        }
//            }
//        }
    }
    
//    func getTempleWith(author: String, uri: String, context: Any) {
//        let parameters: [String: Any] = [
//            "author" : author,
//            "template_uri" : (uri),
//            "context": context
//        ]
//        print("parameters for new template ========",parameters)
//        ERProgressHud.shared.show()
//        APIManager.sharedInstance.makeRequestToGetTemplate(params: parameters as [String:Any]){ (success, response,statusCode)  in
//            if (success) {
//                ERProgressHud.shared.hide()
//                print(response)
//                if let responseData = response as? Dictionary<String, Any> {
//                                  var jsonData: Data? = nil
//                                  do {
//                                      jsonData = try JSONSerialization.data(
//                                          withJSONObject: responseData as Any,
//                                          options: .prettyPrinted)
//                                      do{
//                                          let jsonDataModels = try JSONDecoder().decode(DDCFormModel.self, from: jsonData!)
//                                          print(response)
//
//                                          let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                                          let vc = storyboard.instantiateViewController(withIdentifier: "dynamic") as! DynamicTemplateViewController
//                                          ddcModel = jsonDataModels
////                                          self.present(vc, animated: true, completion: nil)
//                                          if (self.navigationController?.topViewController as? DynamicTemplateViewController) != nil {
//                                              ScriptHelper.shared.checkIsVisibleEntity()
//                                              return
//                                          }
//
//                                          self.navigationController?.pushViewController(vc, animated: true)
//                                          LogoutHelper.shared.showLogoutView()
//                                          ScriptHelper.shared.checkIsVisibleEntity()
//
//                                      }catch {
//                                          print(error)
//                                      }
//                                  } catch {
//                                      print(error)
//                                  }
//                        }
//            } else {
//                APIManager.sharedInstance.showAlertWithMessage(message: ERROR_MESSAGE_DEFAULT)
//                ERProgressHud.shared.hide()
//            }
//        }
//    }




}
