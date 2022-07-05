//
//  PhotosItem.swift
//  FileManager
//
//  Created by Егор Лазарев on 05.07.2022.
//

import Foundation
import UIKit

class PhotosItem: UICollectionViewCell {
    
    static let identifire = "PhotosItem"
    
    let photo: UIImageView = {
        let photo = UIImageView()
        photo.translatesAutoresizingMaskIntoConstraints = false
        photo.isUserInteractionEnabled = true
        return photo
    }()
    
    lazy var closeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        button.imageView?.contentMode = .scaleAspectFit
        button.backgroundColor = .white
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.addTarget(self, action: #selector(deleteImage), for: .touchUpInside)
        return button
    }()
    
    var callback: (()->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        contentView.addSubview(photo)
        contentView.addSubview(closeButton)
        useConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func useConstraint() {
        NSLayoutConstraint.activate([photo.topAnchor.constraint(equalTo: contentView.topAnchor),
                                     photo.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                                     photo.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                                     photo.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                                     closeButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
                                     closeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
                                     closeButton.widthAnchor.constraint(equalToConstant: 20),
                                     closeButton.heightAnchor.constraint(equalToConstant: 20)
                                    ])
    }
    
    func setupPost(image: UIImage, callback: @escaping ()->Void) {
        self.photo.image = image
        self.callback = callback
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(showCloseButton))
        photo.addGestureRecognizer(recognizer)
    }
    
    @objc func showCloseButton() {
        
        if self.closeButton.isHidden {
            UIImageView.animate(
                withDuration: 0.8,
                animations: {
                    self.closeButton.alpha = 1
                    self.closeButton.isHidden = false
                },
                completion: nil)
        } else {
            
            UIImageView.animate(
                withDuration: 0.3,
                animations: {
                    self.closeButton.alpha = 0
                    self.closeButton.isHidden = true
                },
                completion: nil)
        }
    }
    
    @objc func deleteImage() {
        if let callback = callback {
            self.closeButton.alpha = 0
            self.closeButton.isHidden = true
            callback()
        }
    }
    
}
