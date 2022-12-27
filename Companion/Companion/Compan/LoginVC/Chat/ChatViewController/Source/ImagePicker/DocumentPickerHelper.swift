//
//  DocumentPickerHelper.swift
//  Companion
//
//  Created by Ambu Sangoli on 30/11/22.
//

import Foundation
import UIKit
import MobileCoreServices
import UniformTypeIdentifiers

/// Image picker result
@objc public protocol DocumentPickerHelperResultDelegate {
    @objc optional func didSelectPDF(url: URL?)
}


/// Protocol use to specify standard for ImagePickerHelper
public protocol DocumentPickerHelperable {
    // We new a variable to store parent view controller to present ImagePickerController
    var parentViewController: UIViewController? { get set }
    func accessPDF()
}

public class DocumentPickerHelper: NSObject, DocumentPickerHelperable, UIDocumentPickerDelegate {
    
    static let shared = DocumentPickerHelper()

    public weak var parentViewController: UIViewController?
    public weak var delegate: DocumentPickerHelperResultDelegate?

    public func accessPDF(){
        let types = [UTType.pdf]
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: types, asCopy: true)
            documentPicker.delegate = self
            documentPicker.allowsMultipleSelection = false
            documentPicker.shouldShowFileExtensions = true
        self.parentViewController?.present(documentPicker, animated: true, completion: nil)
    }
    
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        print(urls[0].absoluteString)
        self.delegate?.didSelectPDF?(url: urls[0])
    }

    public func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}
