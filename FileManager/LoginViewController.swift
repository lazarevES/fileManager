//
//  LoginViewController.swift
//  FileManager
//
//  Created by Егор Лазарев on 07.07.2022.
//

import Foundation
import UIKit
import KeychainAccess

class LoginViewController: UIViewController {
    
    enum StateUser {
        case hasPassword
        case newUser
        case createPassword
        case changePass
    }
    
    var isChange = false
    var state = StateUser.hasPassword
    private var tempPassword: String = ""
    
    lazy var password: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = UIColor(named: "buttonColor")
        textField.textColor = .white
        textField.font = UIFont.systemFont(ofSize: 36, weight: .regular)
        textField.tintColor = UIColor(named: "AccentColor")
        textField.autocapitalizationType = .none
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.borderWidth = 0.5
        textField.isSecureTextEntry = true
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.placeholder = "Пароль"
        textField.returnKeyType = UIReturnKeyType.default
        textField.addTarget(self, action: #selector(editingEnded), for: .editingChanged)
        return textField
    }()
    
    lazy var loginButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.setTitle("Вход", for: .normal)
        button.titleLabel?.textColor = .white
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 4, height: 4)
        button.layer.shadowOpacity = 0.7
        button.layer.shadowRadius = 4
        button.addTarget(self, action: #selector(signIn), for: .touchUpInside)
        button.isEnabled = false
        
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
        view.addSubview(password)
        view.addSubview(loginButton)
        useConstraint()
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.tabBarController?.tabBar.isHidden = false
    }
    
    func useConstraint() {
        NSLayoutConstraint.activate([password.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
                                     password.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
                                     password.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 50),
                                     password.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -50),
                                     password.heightAnchor.constraint(equalToConstant: 40),
                                     loginButton.topAnchor.constraint(equalTo: password.bottomAnchor, constant: 10),
                                     loginButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 50),
                                     loginButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -50),
                                     loginButton.heightAnchor.constraint(equalToConstant: 40)])
        
    }
    
    func setup() {
        
        let keychain = Keychain(service: "TheBestFileManager")
        var hasPassword = true
        do {
            hasPassword = (try keychain.getString("TheBestFileManager")) != nil
        } catch {
            hasPassword = false
        }
        
        if !hasPassword {
            loginButton.setTitle("Задать пароль", for: .normal)
            state = .newUser
        } else if state == .changePass {
            loginButton.setTitle("Задать пароль", for: .normal)
        }
        
    }
    
    @objc func editingEnded() {
        loginButton.isEnabled = password.text?.count ?? 0 >= 4
    }
    
    @objc func signIn() {
        
        if let pass = password.text {
            DispatchQueue.global().async {
                self.login(pass)
            }
        }
    }
    
    func login(_ password: String) {
        let keychain = Keychain(service: "TheBestFileManager")
        switch state {
        case .newUser:
            tempPassword = password
            state = .createPassword
            DispatchQueue.main.async {
                self.password.text = ""
                self.loginButton.setTitle("Повторите пароль", for: .normal)
            }
            
        case .changePass:
            tempPassword = password
            isChange = true
            state = .createPassword
            DispatchQueue.main.async {
                self.password.text = ""
                self.loginButton.setTitle("Повторите пароль", for: .normal)
            }
            
        case .createPassword:
            if tempPassword == password {
                do {
                    try keychain.set(password, key: "TheBestFileManager")
                    DispatchQueue.main.async {
                        self.navigationController?.setViewControllers([(self.isChange ? SettingsViewController() : ViewController())], animated: true)
                    }
                }
                catch let error {
                    print(error)
                }
            } else {
                DispatchQueue.main.async {
                    let alertController = UIAlertController(title: "Ошибка", message: "Пароли не совпадают", preferredStyle: .alert)
                    let action = UIAlertAction(title: "ок", style: .default, handler: nil)
                    alertController.addAction(action)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
            
        case .hasPassword:
            do {
                if let pass = try keychain.getString("TheBestFileManager"), pass == password {
                    DispatchQueue.main.async {
                        self.navigationController?.setViewControllers([ViewController()], animated: true)
                    }
                } else {
                    DispatchQueue.main.async {
                        let alertController = UIAlertController(title: "Ошибка", message: "Не верный пароль", preferredStyle: .alert)
                        let action = UIAlertAction(title: "ок", style: .default, handler: nil)
                        alertController.addAction(action)
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
            }
            catch let error {
                print(error)
            }
        }
    }
    
}
