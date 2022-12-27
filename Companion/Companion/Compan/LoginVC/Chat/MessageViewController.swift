//
//  MessageViewController.swift
//  Companion
//
//  Created by Ambu Sangoli on 14/11/22.
//

import UIKit
import WebRTC
import NotificationBannerSwift


var userName = ""

class MessageViewController: ChatViewController {

    var viewModel: MessageViewModel!
    var imagePickerHelper: ImagePickerHelper?
    var numberUserTypings = 0
    
    var roomID = ""
    var ohsUserName = ""
    var message = ""
    var userToSignal = ""

    
    private var connectionFactory: RTCPeerConnectionFactory? = nil
    private var peerConnection: RTCPeerConnection? = nil
    
    private var dataChannel: RTCDataChannel? = nil
    let callButton = UIButton(type: .system)

    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupData()
        bindViewModel()
        self.viewModel.currentUser = UserChat(id: 2, name: userName, avatarURL: URL(string: "https://i.imgur.com/LIe72Gc.png"))

        // Get user data firstly
        DispatchQueue.main.async { [weak self] in
            self?.viewModel.getUserData()
        }
        viewModel.firstLoadData { [weak self] in
            DispatchQueue.main.async {
                self?.updateUI()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.peerConnection == nil {
        self.listenToEvents()
        self.navigationController?.navigationBar.topItem?.titleView = setTitle(title: userName, subtitle: "Waiting")
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.messages.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = viewModel.messages[indexPath.row]
        let cellIdentifer = message.cellIdentifer()
        let user = viewModel.getUserFromID(message.sendByID)
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifer, for: indexPath) as! MessageCell
        let positionInBlock = viewModel.getPositionInBlockForMessageAtIndex(indexPath.row)

        cell.transform = tableView.transform
        cell.bind(withMessage: viewModel.messages[indexPath.row], user: user)
        cell.updateUIWithBubbleStyle(viewModel.bubbleStyle, isOutgoingMessage: message.isOutgoing)
        cell.updateLayoutForBubbleStyle(viewModel.bubbleStyle, positionInBlock: positionInBlock)

        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let chatCell = cell as! MessageCell
        let positionInBlock = viewModel.getPositionInBlockForMessageAtIndex(indexPath.row)

        chatCell.layoutIfNeeded()
        
        // Update UI for cell
        chatCell.showHideUIWithBubbleStyle(viewModel.bubbleStyle, positionInBlock: positionInBlock)
        chatCell.updateAvatarPosition(bubbleStyle: viewModel.bubbleStyle)
        chatCell.roundViewWithBubbleStyle(viewModel.bubbleStyle, positionInBlock: positionInBlock)
    }

    override func didPressSendButton(_ sender: Any?) {
        guard let currentUser = viewModel.currentUser else {
            return
        }

        let message = Message(id: UUID().uuidString, sendByID: currentUser.id,
                              createdAt: Date(), text: chatBarView.textView.text, isIncoming: false)
        addMessage(message)
                           
        let data = ["time":self.convertDateToTimestamp(),"message":chatBarView.textView.text!,"name": userName,"type":"text"] as [String : Any]
        let jsonData = try! JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)

        let buffer = RTCDataBuffer(data: jsonData, isBinary: false)
        dataChannel?.sendData(buffer)

        super.didPressSendButton(sender)
    }

    override func didPressGalleryButton(_ sender: Any?) {
        guard configuration.imagePickerType == .actionSheet else {
            super.didPressGalleryButton(sender)
            return
        }

        /// Dismiss keyboard if keyboard is showing
        if currentKeyboardType == .default {
            dismissKeyboard()
        }
        
        imagePickerHelper?.takeOrChoosePhoto()
    }
    
    override func didSelectVideo(url: URL?) {
        print("URL \(url!)")
    }
    
    override func didSelectImage(url: URL?) {
        print("URL \(url!)")
        if let imageData = try? Data(contentsOf: url!) {
            let buffer = RTCDataBuffer(data: imageData, isBinary: false)
            dataChannel?.sendData(buffer)
        }
        

    }
    
    func convertDateToTimestamp() -> String {
        let myFormatter = DateFormatter()
        myFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        let dateString = myFormatter.string(from: Date())
        return dateString
    }
    
}

extension MessageViewController {

    private func setupUI() {
        self.navigationController?.navigationBar.isHidden = false
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 0.64, green: 0.77, blue: 0.86, alpha: 1.00)


        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance

        /// Tableview
        tableView.estimatedRowHeight = 88
        tableView.keyboardDismissMode = .none
        tableView.register(MessageTextCell.self, forCellReuseIdentifier: MessageTextCell.reuseIdentifier)
        tableView.register(MessageImageCell.self, forCellReuseIdentifier: MessageImageCell.reuseIdentifier)


        
        callButton.setImage(UIImage(named: "video_call"), for: .normal)
        callButton.addTarget(self, action:#selector(callButtonAction), for:.touchUpInside)
        callButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        callButton.isHidden = true
        let callButtonBarItem = UIBarButtonItem(customView: callButton)
        navigationItem.rightBarButtonItems = [ callButtonBarItem]
    }

    
    func listenToEvents() {
        SocketHelper.Events.server_initiated_event.listen { (result) in
            if let dataArray = result as? NSArray {
                if let string = dataArray[0] as? String {
                    if let data = string.convertToDictionary() as? NSDictionary {
                        self.roomID = data["roomID"] as? String ?? ""
                        self.ohsUserName = data["ohsUsername"] as? String ?? "null"
                        self.message = data["message"] as? String ?? ""

                    if let type = data["type"] as? String {
                        if type == "connect-ohs-safecheck" {
                            self.joinRoom()
                        } else if type == "disconnect-me-from-connections" {
                            for vc in self.navigationController?.viewControllers ?? [] {
                                if vc as? FailScreenViewController != nil {
                                    SocketHelper.shared.disconnectSocket()
                                    OnCallHelper.shared.removeOnCallView()
                                    self.navigationController?.popToViewController(vc, animated: true)
                                }
                            }
                        }
                    }
                }
              }
            }
        }
        
        SocketHelper.Events.allUsers.listen { (result) in
            print(result)
            if let dataArray = result as? NSArray {
                    if let data = dataArray[0] as? NSDictionary {
                        let users = data["users"] as? [String]
                        self.userToSignal = users?[0] ?? ""
                        self.setupWebRTC()
                }
            }
        }
    }
    
    func joinRoom() {
        let jsonString = "{\"roomID\":\"\(roomID)\",\"username\":\"\(userName)\",\"userType\":\"SAFECHECK\"}"
        SocketHelper.Events.joinRoom.emit(params: jsonString)
    }

    
    func setupWebRTC() {
        SocketHelper.Events.receiving_returned_signal.listen { (payload) in
//            print((payload))
            if let dataArray = payload as? NSArray {
                    if let data = dataArray[0] as? NSDictionary {
                        if let signal = data["signal"] as? NSDictionary {
                            if let sdp = signal["sdp"] as? String {
                                let session = RTCSessionDescription(type: .answer, sdp: sdp)
                                self.peerConnection?.setRemoteDescription(session, completionHandler: { error in
                                    if error != nil {
                                        print(error.debugDescription)
                                    }
                                })
                            }
                    }
                }
            }
        }

        let config = RTCConfiguration()
        config.bundlePolicy = .balanced
        config.iceServers = [RTCIceServer(urlStrings: ["stun:3.110.218.145:3478"]), RTCIceServer(urlStrings: ["stun:stun.l.google.com:19302"]), RTCIceServer(urlStrings: ["turn:3.110.218.145:3478"], username: "test", credential: "test123") ]

        let mandatoryConstraints = ["OfferToReceiveAudio": "true", "OfferToReceiveVideo": "true"]
//        let optionalConstraints = [ "DtlsSrtpKeyAgreement": "true", "RtpDataChannels" : "true"]


        let mediaConstraints = RTCMediaConstraints.init(mandatoryConstraints: mandatoryConstraints, optionalConstraints: nil)
        
        connectionFactory = RTCPeerConnectionFactory()
        peerConnection = connectionFactory!.peerConnection(with: config, constraints: mediaConstraints, delegate: self)
        
        //Create Data Channel
        let tt = RTCDataChannelConfiguration();
        self.dataChannel = self.peerConnection!.dataChannel(forLabel: "datachannel", configuration: tt)
        self.dataChannel!.delegate = self
        
        //Offer
        peerConnection?.offer(for: mediaConstraints, completionHandler: { session, error in
            self.peerConnection?.setLocalDescription(session!, completionHandler: { error in
                if error != nil {
                    print(error.debugDescription)
                }
            })
            let jsonString = "{\"userToSignal\":\"\(self.userToSignal)\",\"callerID\":\"\(SocketHelper.shared.socket.sid)\",\"username\":\"\(userName)\",\"userType\":\"SAFECHECK\",\"signal\":{\"type\":\"offer\",\"sdp\":\"\(session!.sdp)\"}}"
            SocketHelper.Events.sending_signal.emit(params: jsonString)
        })
    }
    
    
    func setTitle(title:String, subtitle:String, isConnected:Bool = false) -> UIView{
        let one = UILabel()
        one.text = title
        one.font = UIFont.systemFont(ofSize: 17)
        one.sizeToFit()
        
        let two = UILabel()
        two.text = subtitle
        two.font = UIFont.systemFont(ofSize: 12)
        two.textAlignment = .center
        if isConnected {
        two.textColor = .blue
        }
        two.sizeToFit()
        
        let stackView = UIStackView(arrangedSubviews: [one, two])
        stackView.distribution = .equalCentering
        stackView.axis = .vertical
        stackView.alignment = .center
        
        let width = max(one.frame.size.width, two.frame.size.width)
        stackView.frame = CGRect(x: 0, y: 0, width: width, height: 35)
        
        one.sizeToFit()
        two.sizeToFit()
        
        return  stackView
    }
    
    private func bindViewModel() {
    
    }
    
    private func setupData() {
        guard configuration.imagePickerType == .actionSheet else {
            return
        }
        
        imagePickerHelper = ImagePickerHelper()
        imagePickerHelper?.delegate = self
        imagePickerHelper?.parentViewController = self
    }

    private func updateUI() {
        tableView.reloadData { [weak self] in
            self?.viewModel.isRefreshing = false
        }
    }

    private func addMessage(_ message: Message) {
        viewModel.messages.insert(message, at: 0)
        self.viewModel.messages = self.viewModel.handleDataSource(messages: self.viewModel.messages)

        // Insert new message cell
        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .none)
        tableView.endUpdates()
        
        // Check if we have more than one message
        switch viewModel.bubbleStyle {
        case .facebook:
            if viewModel.messages.count <= 1 { return }
            reloadLastMessageCell()
        default: break
        }
    }
    
    //MARK: Call
    @objc private func callButtonAction() {
        OnCallHelper.shared.removeOnCallView()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if let vc = appDelegate.voiceCallVC {
            self.navigationController?.pushViewController(vc, animated: true)
            return
        }
        print("call button pressed")
        self.roomID = UUID().uuidString
        let jsonString = "{\"type\":\"call\",\"name\":\"\(self.ohsUserName)\",\"userType\":\"OHS\",\"caller\":\"\(userName)\",\"vcRoomName\":\"\(self.roomID)\",\"call\":{\"status\":\"call\"}}"
        SocketHelper.Events.event.emit(params: jsonString)
        
        self.raiseCallRequest()
        
        let storyBoard = UIStoryboard(name: "covidCheck", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "JitsiMeetViewController") as! JitsiMeetViewController
        vc.meetingName = self.roomID
        appDelegate.voiceCallVC = vc
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func raiseCallRequest() {

        var request = URLRequest(url: URL(string: "wss://safechecksignalling.azurewebsites.net/call/\(userName.replacingOccurrences(of: " ", with: "_"))/\(self.ohsUserName)/\(self.roomID)")!)
        request.httpMethod = "GET"

        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            if let error = error {
                print(error)
            }
            print(response!)
            
//            do {
//                let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
//                print(json)
//            } catch {
//                print("error")
//            }
        })

        task.resume()
    }

    @objc private func handleTypingButton() {
        switch numberUserTypings {
        case 0, 1, 2:
            var user: UserChat
            switch numberUserTypings {
            case 0:
                user = UserChat (id: 1, name: "Harry")
            case 1:
                user = UserChat(id: 2, name: "Bob")
            default:
                user = UserChat(id: 3, name: "Liliana")
            }
            viewModel.users.append(user)
            typingIndicatorView.insertUser(user)
            numberUserTypings += 1
        default:
            for user in viewModel.users {
                typingIndicatorView.removeUser(user)
            }
            numberUserTypings = 0
            break
        }
    }
    
    @objc private func handleShowHideChatBar(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5) {
            sender.imageView?.transform = sender.imageView?.transform.rotated(by: CGFloat.pi) ?? CGAffineTransform.identity
        }
        setChatBarHidden(!isCharBarHidden, animated: true)
    }
    private func updateLoadMoreAble() {
        tableView.setLoadMoreEnable(viewModel.pagination?.hasMore() ?? false)
    }
    
    private func reloadLastMessageCell() {
        tableView.beginUpdates()
        let lastIndexPath = IndexPath(row: 1, section: 0)
        let cell = tableView.cellForRow(at: lastIndexPath) as? MessageCell
        let positionInBlock = viewModel.getPositionInBlockForMessageAtIndex(lastIndexPath.row)
        cell?.updateLayoutForBubbleStyle(viewModel.bubbleStyle, positionInBlock: positionInBlock)
        cell?.roundViewWithBubbleStyle(viewModel.bubbleStyle, positionInBlock: positionInBlock)
        tableView.endUpdates()
        tableView.scrollToFirstCell()
    }
    
}

extension MessageViewController: RTCPeerConnectionDelegate, RTCDataChannelDelegate {
    

    //RTCDataChannelDelegate
    func dataChannelDidChangeState(_ dataChannel: RTCDataChannel) {
        print("channel.state \(dataChannel.readyState.rawValue)");
        let buffer = RTCDataBuffer(data: "COMPANION-TOKEN".data(using: .utf8)!, isBinary: false)
        dataChannel.sendData(buffer)
        dataChannel.delegate = self
    }
    
    func dataChannel(_ dataChannel: RTCDataChannel, didReceiveMessageWith buffer: RTCDataBuffer) {
        print("didReceiveMessageWith.state \(buffer.data.description)");
        DispatchQueue.main.async {
            let message = String(data: buffer.data, encoding: .utf8) ?? "(Binary: \(buffer.data.count) bytes)"
            if message == "OHS-TOKEN" {
                self.callButton.isHidden = false
                self.navigationController?.navigationBar.topItem?.titleView = self.setTitle(title: userName, subtitle: "Connected",isConnected: true)
                return
            }
            let json = try! JSONSerialization.jsonObject(with: buffer.data, options: .mutableContainers) as? [String:Any]
            if let dict = json {
                if let textMessage = dict["message"] as? String {
                    let newMessage = Message(id: UUID().uuidString, sendByID: 99, createdAt: Date(), text: textMessage, isIncoming: true)
                    self.addMessage(newMessage)
                    if let navVC = UIApplication.getTopViewControllerNav() as? UINavigationController {
                        if navVC.visibleViewController as? JitsiMeetViewController != nil {
                            print("Jitsi meetview is open")
                            let banner = NotificationBanner(title: "New message", subtitle: textMessage, style: .success)
                            banner.show()
                            banner.onTap = {
                                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                if let vc = appDelegate.voiceCallVC {
                                    vc.minimize()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    //RTCPeerConnectionDelegate
    public func peerConnection(_ peerConnection: RTCPeerConnection, didOpen dataChannel: RTCDataChannel) {
        print("didOpen \(dataChannel.readyState.rawValue)");
    }
    
    public func peerConnection(_ peerConnection: RTCPeerConnection, didAdd stream: RTCMediaStream) {
        print("didAdd")
    }
    
    public func peerConnection(_ peerConnection: RTCPeerConnection, didGenerate candidate: RTCIceCandidate) {
        print("didGenerate candidate")
    }
    
    //MARK: - To be continued ...
    public func peerConnection(_ peerConnection: RTCPeerConnection, didRemove stream: RTCMediaStream) {}
    public func peerConnectionShouldNegotiate(_ peerConnection: RTCPeerConnection) {}
    public func peerConnection(_ peerConnection: RTCPeerConnection, didChange newState: RTCIceConnectionState) {
        print("didChange RTCIceConnectionState \(newState.rawValue)")
        if newState == .checking {
            print("RTCIceConnection is checking")
        } else if newState == .connected {
            print("RTCIceConnection is connected")
        } else if newState == .completed {
            print("RTCIceConnection is completed")
        } else if newState == .closed {
            print("RTCIceConnection is closed")
        }

    }
    public func peerConnection(_ peerConnection: RTCPeerConnection, didChange newState: RTCIceGatheringState) {
        print("didChange RTCIceGatheringState")
    }
    
    public func peerConnection(_ peerConnection: RTCPeerConnection, didRemove candidates: [RTCIceCandidate]) {
        print("candidates.state \(candidates)");
    }
    
    public func peerConnection(_ peerConnection: RTCPeerConnection, didChange stateChanged: RTCSignalingState) {
        print("stateChanged.state \(stateChanged.rawValue)");
    }
    

    
    
}
