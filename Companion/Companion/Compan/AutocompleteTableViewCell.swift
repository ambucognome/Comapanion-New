//
//  AutocompleteTableViewCell.swift
//  Compan
//
//  Created by Ambu Sangoli on 30/08/22.
//

import UIKit
import Alamofire

class AutocompleteTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var uriLbl: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var resetBtn: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var errorLabelHeight: NSLayoutConstraint!

    var data : DDCFormModel?
    var indexPath : IndexPath?
    var entity : Entity?
    var entityGroupId: String = ""
    var parentEntityGroupId = ""
    var groupOrder = 0
    let dropDown = DropDownList()


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUpTextFieldCell(data: DDCFormModel,entity: Entity, indexPath: IndexPath,entityGroupId: String,parentEntityGroupId:String = "99",groupOrder: Int = 0) {
        self.isUserInteractionEnabled = true
        if isReadOnly {
            self.isUserInteractionEnabled = false
        }
        self.entityGroupId = entityGroupId
        self.entity = entity
        self.textField.delegate = self
        self.data = data
        self.indexPath = indexPath
        let dataa : Entity? = entity
        self.parentEntityGroupId = parentEntityGroupId
        self.textField.placeholder = dataa?.settings?.placeholderText ?? ""
        textField.delegate = self
        textField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)


        if let dic = dataa?.value?.value as? [String:Any] {
            let name = dic["display"] as? String ?? ""
            self.textField.text = name
        }
        self.groupOrder = groupOrder
        self.resetBtn.isHidden = true
        if isResetAvailable {
            self.resetBtn.isHidden = false
        }
        self.errorLabel.isHidden = true
        self.errorLabelHeight.constant = 0
        if ComponentUtils.showErrorMessage(entity: entity) {
            self.errorLabel.text = entity.errorMessage
            self.errorLabel.isHidden = false
            self.errorLabelHeight.constant = 12
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField == self.textField {
            self.makeRequestToGetSearchResult(searchText: textField.text!)
        }
    }
    
    @IBAction func resetBtn(_ sender: Any) {
        RequestHelper.shared.createRequestForEntity(entity: self.entity!, newValue: "", entityGroupId: entityGroupId,parentEntityGroupId: parentEntityGroupId,groupOrder: groupOrder)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
//        print(RequestHelper.shared.createRequestForEntity(data: self.data!, index: self.indexPath!, newValue: textField.text!))
//        RequestHelper.shared.createRequestForEntity(entity: self.entity!, newValue: textField.text!, entityGroupId: entityGroupId,parentEntityGroupId: parentEntityGroupId,groupOrder: groupOrder)
    }
    
    func updateValue(value: [String:Any]) {
        RequestHelper.shared.createRequestForEntity(entity: self.entity!, newValue: value, entityGroupId: entityGroupId,parentEntityGroupId: parentEntityGroupId,groupOrder: groupOrder)
    }
    
    struct SearchResult {
        var name = ""
        var id : NSNumber
    }
    
    func makeRequestToGetSearchResult(searchText:String = "enti") {
        self.dropDown.hide()
        if let searchUrl = self.entity?.settings?.url {
            let path = (searchUrl + searchText)
            let url = try! path.asURL()
        var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = HTTPMethod.get.rawValue
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

            ERProgressHud.shared.show()
        Alamofire.request(urlRequest).responseJSON { response in
            switch response.result {
            case .success(let JSON):
                ERProgressHud.shared.hide()
                let statusCode = response.response?.statusCode ?? 0
                if statusCode != 200 {
                    APIManager.sharedInstance.showAlertWithCode(code: statusCode)
                    return
                }
                guard let jsonData =  JSON  as? NSArray else {
                    return
                }
                print(jsonData)
                if jsonData.count == 0 { return }
                var searchResult = [SearchResult]()
                for i in jsonData {
                    if let data = i as? NSDictionary {
                        let name = data["display"] as? String ?? ""
                        let id = data["id"] as? NSNumber ?? 0
                        searchResult.append(SearchResult(name: name, id: id))
                    }
                }
                
                self.dropDown.anchorView = self.textField // UIView or UIBarButtonItem
                var names = [String]()
                for pro in searchResult {
                    names.append(pro.name)
                }
                self.dropDown.dataSource = names
                self.dropDown.direction = .any
                self.dropDown.topOffset = CGPoint(x: 0, y:-((self.dropDown.anchorView?.plainView.bounds.height ?? 0) + 15))
                self.dropDown.bottomOffset = CGPoint(x: 0, y:(self.dropDown.anchorView?.plainView.bounds.height)!)
                
                self.dropDown.show()
                self.dropDown.selectionAction = { (index: Int, item: String) in
                    self.textField.text = searchResult[index].name
                    self.textField.endEditing(true)
                    let dic : [String: Any] = ["display": searchResult[index].name,"id": searchResult[index].id]
                    self.updateValue(value: dic)
//                    self.caretakerId = self.caretakerData[index].careTakerId
                }
            case .failure( _):
                APIManager.sharedInstance.showAlertWithMessage(message: ERROR_MESSAGE_DEFAULT)
            }
        
        }
    }
        
    }
    
}
