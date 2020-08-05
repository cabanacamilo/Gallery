//
//  OpenImageController.swift
//  Gallery
//
//  Created by Camilo Cabana on 21/07/20.
//  Copyright © 2020 Camilo Cabana. All rights reserved.
//

import UIKit
import MessageUI

class OpenImageController: UIViewController {
    
    var item: ItemViewModel!
    var openImageView = OpenImageView()
    weak var image: UIImage!
    
    lazy var emailButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Email", style: .plain, target: self, action: #selector(sendByEmail))
        return button
    }()
    
    lazy var saveButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveImage))
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
    }
    
    override func loadView() {
        openImageView.item = self.item
        self.image = openImageView.galleryImage.image
        view = openImageView
    }
    
    func setNavigationBar() {
        navigationItem.title = item.title
        navigationItem.rightBarButtonItems = [emailButton, saveButton]
    }
    
    @objc func saveImage() {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            CostumizeAlert.alert(self, title: "System", message: error.localizedDescription)
        } else {
            CostumizeAlert.alert(self, title: "The image has saved in the photo labrary", message: nil)
        }
    }
}

extension OpenImageController: MFMailComposeViewControllerDelegate {
    @objc func sendByEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.addAttachmentData(image.pngData() ?? Data(), mimeType: "image/png", fileName: "imageName.png")
            present(mail, animated: true)
        } else {
            CostumizeAlert.alert(self, title: "System", message: "the app could not send the email")
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
