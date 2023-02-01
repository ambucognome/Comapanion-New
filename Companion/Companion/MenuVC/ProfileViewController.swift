//
//  ProfileViewController.swift
//  Companion
//
//  Created by Ambu Sangoli on 31/01/23.
//

import UIKit
import AVFoundation

class ProfileViewController: UIViewController {
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var mainScroll: UIScrollView!

    var activeTextField: UITextField!
    var selectedImage: UIImage!

    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Profile"
        self.nameLabel.text = username
        self.emailLabel.text = username.removingWhitespaces() + "@demo.com"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
//        self.bottomView.addTopRoundedCornerToView(targetView: self.bottomView, desiredCurve: 0.6)
//        
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.frame = self.topView.bounds
//        gradientLayer.colors = [UIColor.init(red: 103/255.0, green: 75/255.0, blue: 157/255.0, alpha: 1.0).cgColor, UIColor.init(red: 195/255.0, green: 74/255.0, blue: 130/255.0, alpha: 1.0).cgColor]
//        self.topView.layer.addSublayer(gradientLayer)
//        
//        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2.0
//        profileImageView.layer.borderWidth = 3.0
//        profileImageView.layer.borderColor = UIColor.white.cgColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.bottomView.addTopRoundedCornerToView(targetView: self.bottomView, desiredCurve: 0.6)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.topView.bounds
        gradientLayer.colors = [UIColor.init(red: 103/255.0, green: 75/255.0, blue: 157/255.0, alpha: 1.0).cgColor, UIColor.init(red: 195/255.0, green: 74/255.0, blue: 130/255.0, alpha: 1.0).cgColor]
        self.topView.layer.addSublayer(gradientLayer)
        
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2.0
        profileImageView.layer.borderWidth = 3.0
        profileImageView.layer.borderColor = UIColor.white.cgColor
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
    }

    // MARK: - Memory Management
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func changeImageButtonTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        alert.addAction(UIAlertAction(title: "Open Camera", style: UIAlertAction.Style.default, handler: { (action) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                if AVCaptureDevice.authorizationStatus(for: .video) == .authorized {
                    self.openCamera()
                } else if AVCaptureDevice.responds(to: #selector(AVCaptureDevice.requestAccess(for:completionHandler:))) {
                    AVCaptureDevice.requestAccess(for: .video, completionHandler: {(_ granted: Bool) -> Void in
                        if granted {
                            self.openCamera()
                        } else {
                            let settingsAlert = UIAlertController(title: "Camera permission is required", message: nil, preferredStyle: UIAlertController.Style.alert)
                            settingsAlert.addAction(UIAlertAction(title: "Settings", style: UIAlertAction.Style.default, handler: { (action) -> Void in
                                let settingsURL = URL(string: UIApplication.openSettingsURLString)
                                UIApplication.shared.open(settingsURL!, options: [:], completionHandler: nil)
                            }))
                            settingsAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
                            self.present(settingsAlert, animated: true, completion: nil)
                        }
                    })
                }
            } else {
                APIManager.sharedInstance.showAlertWithMessage(message: "No camera available")
            }
        }))
        alert.addAction(UIAlertAction(title: "Open Gallery", style: UIAlertAction.Style.default, handler: { (action) -> Void in
            let controller = UIImagePickerController()
            controller.delegate = self
            controller.sourceType = .photoLibrary
            self.present(controller, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { (action) -> Void in
            print("cancel")
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    

    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func openCamera() {
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.sourceType = .camera
        self.present(controller, animated: true, completion: nil)
    }
    
    func writeImage(inDocumentsDirectory image: UIImage) {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory: String = paths[0]
        let savedImagePathStr: String = URL(fileURLWithPath: documentsDirectory).appendingPathComponent("savedImage.png").absoluteString
        let imageData: Data? = image.pngData()
        let savedImagePath: URL = URL(string: savedImagePathStr)!
        do {
            try imageData?.write(to: savedImagePath, options: .atomic)
        } catch {
            print(error)
        }
    }
    
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    

}


//MARK: - UIImagePickerController Delegate

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            let imageData = image.jpegData(compressionQuality: 0.7)
            var newImage = UIImage.init(data: imageData!)!
            newImage = self.resizeImage(image: newImage, targetSize: CGSize(width: 115.0, height: 115.0))
            profileImageView.image = newImage
            selectedImage = newImage
        } else {
            print("Something went wrong")
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

// MARK: - View Extention

extension UIView {
    
    func addTopRoundedCornerToView(targetView: UIView?, desiredCurve: CGFloat?) {
        let offset:CGFloat =  targetView!.frame.width/desiredCurve!
        let bounds: CGRect = targetView!.bounds
        
        let rectBounds: CGRect = CGRect(x: bounds.origin.x, y: bounds.origin.y+bounds.size.height / 2, width: bounds.size.width, height: bounds.size.height / 2)
        
        let rectPath: UIBezierPath = UIBezierPath(rect: rectBounds)
        let ovalBounds: CGRect = CGRect(x: bounds.origin.x - offset / 2, y: bounds.origin.y, width: bounds.size.width + offset, height: bounds.size.height)
        let ovalPath: UIBezierPath = UIBezierPath.init(ovalIn: ovalBounds)
        rectPath.append(ovalPath)
        
        // Create the shape layer and set its path
        let maskLayer: CAShapeLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = rectPath.cgPath
        
        // Set the newly created shape layer as the mask for the view's layer
        targetView!.layer.mask = maskLayer
    }
}
