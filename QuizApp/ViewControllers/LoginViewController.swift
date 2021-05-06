//
//  LoginViewController.swift
//  QuizApp
//
//  Created by Luka Cicak on 12.04.2021..
//

import UIKit
import Foundation
import SnapKit

class LoginViewController:UIViewController, UITextFieldDelegate{
    
    private var emailField: TextFieldWithPadding!
    private var passwordField: TextFieldWithPadding!
    private var appName: UILabel!
    private var loginButton: RoundButton!
    private var layerGradient: CAGradientLayer!
    
    private var DataSInstance = DataService()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        buildViews()
        addConstraints()
        
        emailField.delegate = self
        passwordField.delegate = self
        
        [emailField, passwordField].forEach {$0?.addTarget(self, action: #selector(editingChanged(_:)), for: .editingChanged)}
        
        loginButton.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
    }
    
    
    private func buildViews(){
        
        //view.backgroundColor = UIColor(red: 0.45, green: 0.31, blue: 0.64, alpha: 1)
        
        layerGradient = CAGradientLayer()
        layerGradient.frame = view.bounds
        layerGradient.colors = [UIColor(red: 0.45, green: 0.31, blue: 0.64, alpha: 1).cgColor,
                                UIColor(red: 0.15, green: 0.18, blue: 0.46, alpha: 1).cgColor]
        
        appName = UILabel()
        appName.textColor = .white
        appName.text = "PopQuiz"
        appName.font = UIFont(name: "SourceSansPro-Black", size: 38)
        appName.textAlignment = .center
        appName.adjustsFontSizeToFitWidth = true
        appName.translatesAutoresizingMaskIntoConstraints = false
        
    
        passwordField = TextFieldWithPadding()
        passwordField.isSecureTextEntry = true
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        passwordField.textAlignment = .left
        passwordField.font = UIFont(name: "SourceSansPro-Black", size: 15)
        passwordField.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        passwordField.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.3)
        passwordField.attributedPlaceholder = NSAttributedString(string: "Password",
                    attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 1, green: 1, blue: 1, alpha: 0.6),
                                 NSAttributedString.Key.font: UIFont(name: "SourceSansPro-Light", size: 20)!])
        
        
        
        emailField = TextFieldWithPadding()
        emailField.textAlignment = .left
        emailField.translatesAutoresizingMaskIntoConstraints = false
        emailField.font = UIFont(name: "SourceSansPro-Black", size: 15)
        emailField.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        emailField.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.3)
        emailField.attributedPlaceholder = NSAttributedString(string: "Email",
                   attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 1, green: 1, blue: 1, alpha: 0.6),
                               NSAttributedString.Key.font: UIFont(name: "SourceSansPro-Light", size: 20)!])

        
        loginButton = RoundButton()
        loginButton.setTitle("Login", for: .normal)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.55)
        loginButton.titleLabel?.font = UIFont(name: "SourceSansPro-Black", size: 20)
        loginButton.setTitleColor(UIColor(red: 0.39, green: 0.16, blue: 0.87, alpha: 1), for: .normal)
        loginButton.setTitleColor(UIColor(red: 0.39, green: 0.16, blue: 0.87, alpha: 0.8), for: .disabled)
        loginButton.isEnabled = false
        
        view.layer.addSublayer(layerGradient)
        view.addSubview(appName)
        view.addSubview(passwordField)
        view.addSubview(emailField)
        view.addSubview(loginButton)
    }
    
    private func addConstraints(){
        appName.snp.makeConstraints{ make -> Void in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalToSuperview().multipliedBy(0.07)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(40)
        }
        
        passwordField.snp.makeConstraints{ make -> Void in
            make.width.equalTo(appName).multipliedBy(1.72)
            make.height.equalTo(appName).multipliedBy(0.95)
            make.center.equalToSuperview()
            
        }
        
        emailField.snp.makeConstraints{ make -> Void in
            make.width.height.equalTo(passwordField)
            make.bottom.equalTo(passwordField.snp.top).offset(-20)
            make.centerX.equalTo(passwordField)
        }
        
        loginButton.snp.makeConstraints{make -> Void in
            make.top.equalTo(passwordField.snp.bottom).offset(20)
            make.width.height.equalTo(passwordField)
            make.centerX.equalTo(passwordField)
        }
    }
    
    
    
    @objc func editingChanged(_ textField: UITextField) {
        
        textField.text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines)

        loginButton.isEnabled = ![emailField, passwordField].compactMap {
            $0.text?.isEmpty
        }.contains(true)
        
        if loginButton.isEnabled {
            loginButton.backgroundColor = .white
        }
    }
    
    
    @objc func loginButtonPressed(){
        let status = DataSInstance.login(email: emailField.text!, password: passwordField.text!)
        
        if case .success = status{
            self.present(QuizzesViewController(), animated: true, completion: nil)
        }
    }
    
    
    @objc func fieldIsActive(_ textField: UITextField){
        passwordField.layer.borderWidth = 1
        passwordField.layer.borderColor = UIColor.white.cgColor
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == emailField{
            emailField.layer.borderColor = UIColor.white.cgColor
            emailField.layer.borderWidth = 1
        }
        else if textField == passwordField{
            passwordField.layer.borderColor = UIColor.white.cgColor
            passwordField.layer.borderWidth = 1
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == emailField{
            emailField.layer.borderWidth = 0
        }
        else if textField == passwordField{
            passwordField.layer.borderWidth = 0
        }
    }
}

