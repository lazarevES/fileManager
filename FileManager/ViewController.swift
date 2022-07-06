//
//  ViewController.swift
//  FileManager
//
//  Created by Егор Лазарев on 05.07.2022.
//

import UIKit
import Photos

class ViewController: UIViewController{
    
    lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        layout.scrollDirection = .vertical
        return layout
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self

        return collectionView
    }()
    
    var photos = [String]()
    var documentsUrl: URL?
    var imageCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let infoBarButtonItem = UIBarButtonItem(title: "Добавить", style: .plain, target: self, action: #selector(AddPhoto))
        self.navigationItem.rightBarButtonItem  = infoBarButtonItem
       
        view.addSubview(collectionView)
        collectionView.register(PhotosItem.self, forCellWithReuseIdentifier: PhotosItem.identifire)
        useConstraint()
        
        do {
            documentsUrl = try FileManager.default.url(for: .documentDirectory,
                                                       in: .userDomainMask,
                                                       appropriateFor: nil,
                                                       create: false)
            if let documentsUrl = documentsUrl {
                let contents = try FileManager.default.contentsOfDirectory(at: documentsUrl,
                                                                           includingPropertiesForKeys: nil,
                                                                           options: [.skipsHiddenFiles])
                for file in contents {
                    photos.append(file.path)
                    imageCount += 1
                }
                collectionView.reloadData()
            }
        } catch {
            let alertController = UIAlertController(title: "Ошибка получения каталога", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "ок", style: .default, handler: nil)
            alertController.addAction(action)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
        
    private func useConstraint() {
        NSLayoutConstraint.activate([collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                                     collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                                     collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                                     collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)])
    }
    
    func checkPhotoLibraryPermission() -> Bool {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .notDetermined: // Пользователь еще не сделал выбор
            PHPhotoLibrary.requestAuthorization() { (status) in
                if status == .authorized {
                    DispatchQueue.main.async {
                        self.AddPhoto()
                    }
                }
            }
            return false
        case .authorized: // авторизованный
            return true
        case .denied: // Пользователь отклонен
            return false
        case .restricted: // Родительский контроль
            return false
        case .limited:
            return false
        @unknown default:
            return false
        }
    }
    
    public func getPhoto(image: UIImage) {
        
        if let documentsUrl = documentsUrl {
            let name = "image" + String(imageCount)
            imageCount += 1
            let data = image.jpegData(compressionQuality: 1)
            let fileUrl = documentsUrl.appendingPathComponent(name)
            FileManager.default.createFile(atPath: fileUrl.path,
                                                   contents: data,
                                                   attributes: nil)
            photos.append(fileUrl.path)
            collectionView.reloadData()
        }
    }
    
    @objc func AddPhoto() {
                
        if !checkPhotoLibraryPermission() {
            return
        }
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }

}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotosItem.identifire, for: indexPath) as? PhotosItem
        else { return UICollectionViewCell()}
        
        let path = photos[indexPath.item]
        let image = UIImage(named: path)
        if let image = image {
            cell.setupPost(image: image) {
                
                do{
                    try FileManager.default.removeItem(atPath: self.photos[indexPath.item])
                    self.photos.remove(at: indexPath.item)
                    self.collectionView.reloadData()
                } catch {
                    let alertController = UIAlertController(title: "Ошибка удаления данных", message: "", preferredStyle: .alert)
                    let action = UIAlertAction(title: "ок", style: .default, handler: nil)
                    alertController.addAction(action)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width/2 - 16, height: collectionView.frame.width/2 - 16)
        }
    
}

extension ViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let tempImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            getPhoto(image: tempImage)
            picker.dismiss(animated: true)
        }
    }
}

