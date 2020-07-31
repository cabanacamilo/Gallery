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
    var item: ItemViewModel! {
        didSet {
            galleryImage.loadCacheImage(url: item.image)
            authorLabel.text = item.author
            dateTakenLabel.text = item.dateTakenString
            descriptionText.text = item.description
            datePublishedLabel.text = item.datePublishedString
            cellView.heightAnchor.constraint(equalToConstant: sizeForView(item.description).height + 500).isActive = true
        }
    }
    
    let galleryImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.layer.borderColor = UIColor.gray.cgColor
        image.layer.borderWidth = 0.5
        return image
    }()
    
    let authorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 15)
        label.textAlignment = .center
        return label
    }()
    
    let dateTakenLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.font = .systemFont(ofSize: 15)
        label.textAlignment = .center
        return label
    }()
    
    let descriptionText: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.backgroundColor = .clear
        textView.font = .systemFont(ofSize: 15)
        return textView
    }()
    
    let datePublishedLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.font = .systemFont(ofSize: 15)
        label.textAlignment = .right
        return label
    }()
    
    let cellView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
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
        setLayout()
        setNavigationBar()
    }
    
    func setLayout() {
        view.backgroundColor = .white
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(cellView)
        cellView.addSubview(galleryImage)
        cellView.addSubview(authorLabel)
        cellView.addSubview(dateTakenLabel)
        cellView.addSubview(descriptionText)
        cellView.addSubview(datePublishedLabel)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor), scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor), scrollView.widthAnchor.constraint(equalTo: view.widthAnchor), scrollView.heightAnchor.constraint(equalTo: view.heightAnchor),
            cellView.topAnchor.constraint(equalTo: scrollView.topAnchor), cellView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor), cellView.widthAnchor.constraint(equalTo: scrollView.widthAnchor), cellView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            authorLabel.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 20), authorLabel.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 10), authorLabel.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -10),
            galleryImage.topAnchor.constraint(equalTo: authorLabel.bottomAnchor,constant: 20), galleryImage.leadingAnchor.constraint(equalTo: cellView.leadingAnchor), galleryImage.trailingAnchor.constraint(equalTo: cellView.trailingAnchor), galleryImage.heightAnchor.constraint(equalToConstant: 300),
            dateTakenLabel.topAnchor.constraint(equalTo: galleryImage.bottomAnchor, constant: 10), dateTakenLabel.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 10), dateTakenLabel.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -10),
            descriptionText.topAnchor.constraint(equalTo: dateTakenLabel.bottomAnchor, constant: 10), descriptionText.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 10), descriptionText.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -10), datePublishedLabel.bottomAnchor.constraint(equalTo: cellView.bottomAnchor, constant: -10), datePublishedLabel.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 10), datePublishedLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)])
    }
    
    func setNavigationBar() {
        navigationItem.title = item.title
        navigationItem.rightBarButtonItems = [emailButton, saveButton]
    }
    
    func sizeForView(_ text: String) -> CGRect {
        let size = CGSize(width: view.frame.width, height: 9999)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)], context: .none)
    }
    
    @objc func saveImage() {
        UIImageWriteToSavedPhotosAlbum(galleryImage.image ?? UIImage(), self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
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
            mail.addAttachmentData(galleryImage.image?.pngData() ?? Data(), mimeType: "image/png", fileName: "imageName.png")
            present(mail, animated: true)
        } else {
            CostumizeAlert.alert(self, title: "System", message: "the app could not send the email")
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
