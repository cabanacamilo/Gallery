//
//  OpenImageCell.swift
//  Gallery
//
//  Created by Camilo Cabana on 22/07/20.
//  Copyright © 2020 Camilo Cabana. All rights reserved.
//

import UIKit

class OpenImageCell: UICollectionViewCell {
    
    var item: ItemViewModel! {
        didSet {
            galleryImage.loadCacheImage(url: item.image)
            authorLabel.text = item.author
            dateTakenLabel.text = item.dateTaken
            descriptionText.text = item.description
            datePublishedLabel.text = item.datePublished
            let height = sizeForMessage(item.description).height + 500
            cellView.heightAnchor.constraint(equalToConstant: height).isActive = true
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    func setLayout() {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(scrollView)
        scrollView.addSubview(cellView)
        cellView.addSubview(galleryImage)
        cellView.addSubview(authorLabel)
        cellView.addSubview(dateTakenLabel)
        cellView.addSubview(descriptionText)
        cellView.addSubview(datePublishedLabel)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor), scrollView.leadingAnchor.constraint(equalTo: leadingAnchor), scrollView.widthAnchor.constraint(equalTo: widthAnchor), scrollView.heightAnchor.constraint(equalTo: heightAnchor),
            cellView.topAnchor.constraint(equalTo: scrollView.topAnchor), cellView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor), cellView.widthAnchor.constraint(equalTo: scrollView.widthAnchor), cellView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            authorLabel.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 20), authorLabel.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 10), authorLabel.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -10),
            galleryImage.topAnchor.constraint(equalTo: authorLabel.bottomAnchor,constant: 20), galleryImage.leadingAnchor.constraint(equalTo: cellView.leadingAnchor), galleryImage.trailingAnchor.constraint(equalTo: cellView.trailingAnchor), galleryImage.heightAnchor.constraint(equalToConstant: 300),
            dateTakenLabel.topAnchor.constraint(equalTo: galleryImage.bottomAnchor, constant: 10), dateTakenLabel.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 10), dateTakenLabel.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -10),
            descriptionText.topAnchor.constraint(equalTo: dateTakenLabel.bottomAnchor, constant: 10), descriptionText.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 10), descriptionText.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -10), datePublishedLabel.bottomAnchor.constraint(equalTo: cellView.bottomAnchor, constant: -10), datePublishedLabel.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 10), datePublishedLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)])
    }
    
    func sizeForMessage(_ text: String) -> CGRect {
        let size = CGSize(width: frame.width, height: 9999)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)], context: .none)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
