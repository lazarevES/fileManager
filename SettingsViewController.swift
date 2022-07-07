//
//  SettingsViewController.swift
//  FileManager
//
//  Created by Егор Лазарев on 07.07.2022.
//

import Foundation
import UIKit

class SettingsViewController: UIViewController {
    
    var sortAsc = false
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Сортировать по дате добавления"
        return label
    }()
    
    lazy var sortToggle: UISwitch = {
        let toggle = UISwitch()
        toggle.translatesAutoresizingMaskIntoConstraints = false
        toggle.addTarget(self, action: #selector(tapToToggle), for: .valueChanged)
        return toggle
    }()
    
    lazy var changePassword: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.setTitle("Сменить пароль", for: .normal)
        button.titleLabel?.textColor = .white
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 4, height: 4)
        button.layer.shadowOpacity = 0.7
        button.layer.shadowRadius = 4
        button.addTarget(self, action: #selector(changePass), for: .touchUpInside)
        
        if let image = UIImage(named: "blue_pixel") {
            button.imageView?.contentMode = .scaleAspectFill
            button.setBackgroundImage(image.imageWithAlpha(alpha: 1), for: .normal)
            button.setBackgroundImage(image.imageWithAlpha(alpha: 0.9), for: .selected)
            button.setBackgroundImage(image.imageWithAlpha(alpha: 0.9), for: .highlighted)
            button.setBackgroundImage(image.imageWithAlpha(alpha: 0.7), for: .disabled)
        }
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(label)
        view.addSubview(sortToggle)
        view.addSubview(changePassword)
        useConstraint()
        setup()
    }
    
    func useConstraint() {
        NSLayoutConstraint.activate([label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
                                     label.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
                                     label.heightAnchor.constraint(equalToConstant: 20),
                                     sortToggle.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 10),
                                     sortToggle.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
                                     sortToggle.heightAnchor.constraint(equalToConstant: 20),
                                     changePassword.topAnchor.constraint(equalTo: sortToggle.bottomAnchor, constant: 30),
                                     changePassword.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 50),
                                     changePassword.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -50),
                                     changePassword.heightAnchor.constraint(equalToConstant: 40)])
        
    }
    
    func setup() {
        sortAsc = UserDefaults.standard.bool(forKey: "SortAsc")
        sortToggle.isOn = sortAsc
    }
    
    @objc func changePass() {
        let vc = LoginViewController()
        vc.state = .changePass
        self.navigationController?.setViewControllers([vc], animated: true)
    }
    
    @objc func tapToToggle() {
        sortAsc = sortToggle.isOn
        UserDefaults.standard.set(sortAsc, forKey: "SortAsc")
        NotificationCenter.default.post(name: NSNotification.Name("changeSort"), object: nil, userInfo: nil)
    }
    
}
