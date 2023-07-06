//
//  ViewController.swift
//  Companion
//
//  Created by Ambu Sangoli on 03/07/23.
//

//Incoming Call
import UIKit
import CallKit
import PushKit


class BasicViewController: UIViewController, CXProviderDelegate {

    override func viewDidLoad() {
        // 1: Create an incoming call update object. This object stores different types of information about the caller. You can use it in setting whether the call has a video.
//        let update = CXCallUpdate()
//        // Specify the type of information to display about the caller during an incoming call. The different types of information available include `.generic`. For example, you could use the caller&#039;s name for the generic type. During an incoming call, the name displays to the other user. Other available information types are emails and phone numbers.
//        update.remoteHandle = CXHandle(type: .generic, value: "Amos Gyamfi")
//        //update.remoteHandle = CXHandle(type: .emailAddress, value: "amosgyamfi@gmail.com")
//        //update.remoteHandle = CXHandle(type: .phoneNumber, value: "a+35846599990")
//
//        // 2: Create and set configurations about how the calling application should behave
//        let config = CallKit.CXProviderConfiguration()
//        let imageView = UIImageView()
//        imageView.setImageForName("Amos Gyamfi", circular: true, textAttributes: nil)
//        config.iconTemplateImageData = imageView.image!.pngData()
//        config.includesCallsInRecents = true;
//        config.supportsVideo = true;
//        update.hasVideo = true
//
//        // Provide a custom ringtone
////        config.ringtoneSound = "ES_CellRingtone23.mp3";
//
//        // 3: Create a CXProvider instance and set its delegate
//        let provider = CXProvider(configuration: config)
//        provider.setDelegate(self, queue: nil)
//
//        // 4. Post local notification to the user that there is an incoming call. When using CallKit, you do not need to rely on only displaying incoming calls using the local notification API because it helps to show incoming calls to users using the native full-screen incoming call UI on iOS. Add the helper method below `reportIncomingCall` to show the full-screen UI. It must contain `UUID()` that helps to identify the caller using a random identifier. You should also provide the `CXCallUpdate` that comprises metadata information about the incoming call. You can also check for errors to see if everything works fine.
//        provider.reportNewIncomingCall(with: UUID(), update: update, completion: { error in })
    }

    func providerDidReset(_ provider: CXProvider) {
    }

    // What happens when the user accepts the call by pressing the incoming call button? You should implement the method below and call the fulfill method if the call is successful.
    func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
        print("call answered")
        action.fulfill()
        return
    }

    // What happens when the user taps the reject button? Call the fail method if the call is unsuccessful. It checks the call based on the UUID. It uses the network to connect to the end call method you provide.
    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
        print("call rejected")
        action.fail()
        return
    }

}

//extension BasicViewController : PKPushRegistryDelegate {
//    // Create an object to handle the receipt of PushKit notifications
//        func registerForVoIPCalls(_ voipRegistry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType, completion: @escaping () -> Void) {
//
//            // Create an object to handle call configurations and settings
//            let callConfigObject = CXProviderConfiguration()
//            // Enable video calls
//            callConfigObject.supportsVideo = true;
//            // Show missed, received and sent calls in the phone app's Recents category
//            callConfigObject.includesCallsInRecents = true;
//            // Set a custom ring tone for incoming calls
////            callConfigObject.ringtoneSound = "ES_CellRingtone23.mp3"
//
//            // Create an object to give update about call-related events
//            let callReport = CXCallUpdate()
//            // Display the name of the caller
//            callReport.remoteHandle = CXHandle(type: .generic, value: "Amos Gyamfi")
//            // Enable video call
//            callReport.hasVideo = true
//
//            // Create an object to give update about incoming calls
//            let callProvider = CXProvider(configuration: callConfigObject)
//            callProvider.reportNewIncomingCall(with: UUID(), update: callReport, completion: { error in })
//            callProvider.setDelegate(self, queue: nil)
//        }
//
//    // Call this function when the app receives push credentials
//        func pushRegistry(_ voipRegistry: PKPushRegistry, didUpdate pushCredentials: PKPushCredentials, for type: PKPushType) {
//            // Display the iOS device token in the Xcode console
//            print("voip",pushCredentials.token.map { String(format: "%02.2hhx", $0) }.joined())
//        }
//}
