//
//  DemoScrollElementViewController.swift
//  BaseExtension
//
//  Created by Chu Van Truong on 12/12/19.
//  Copyright © 2019 Chu Van Truong. All rights reserved.
//

import UIKit
import LoremIpsum
import TinyConstraints


class DemoScrollElementViewController: UIViewController {
    
    //Configure ScrollView
    let scrollview = D_ScrollView()
    let scrollViewContainer = D_ScrollViewContainer(axis: .vertical, spacing: 20)
    let scrollViewElement = D_ScrollViewElement(width: UIScreen.main.bounds.width)
    
    //Configure views in scrollview
    lazy var usernameTextField = TextFieldWithLeftIcon(insets: .init(top: 0, left: 50, bottom: 0, right: 8), image: UIImage(systemName: "person.fill"), sizeImage: .init(width: 24, height: 24), sizeFrame: .init(width: 50, height: 50)).placeholder("User name").font(UIFont.systemFont(ofSize: 16)).background(.white)
    
    lazy var passwordTextField = TextFieldWithLeftIcon(insets: .init(top: 0, left: 50, bottom: 0, right: 8), isSecure: true, image: UIImage(systemName: "lock.fill"), sizeImage: .init(width: 24, height: 24), sizeFrame: .init(width: 50, height: 50)).placeholder("Password").font(UIFont.systemFont(ofSize: 16)).background(.white)
    
    lazy var materialTF = MaterialTextField(placeHolder: "Input text")
    
    lazy var contentLabel = UILabel().text(.red).numberOfLines(0)
    
    let loginBtn = PressButton().text("Login")
    lazy var loginbutton = D_SCButtonView(loginBtn, radius: 10, offset: .init(width: 1, height: 1), opacity: 0.2, cornerRadius: 45/2)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewLogin()
    }
    
    func setupViewLogin() {
        view.gradientBackground(from: .systemOrange, to: .purple, direction: .topToBottom)
        let viewLoginContainer = UIView().setWidth(view.frame.width)
        view.addSubview(viewLoginContainer)
        viewLoginContainer.translatesAutoresizingMaskIntoConstraints = false
        viewLoginContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        viewLoginContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        viewLoginContainer.D_VStack(
            usernameTextField,
            passwordTextField,
            materialTF,
            Spacer().setHeight(30),
            loginbutton,
            spacing: 10)
            .padding([.allMargins], amount: 16).setupSubview(backgroundColor: .clear)
        
        usernameTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 48).isActive = true
        materialTF.height(50)
        materialTF.textField.placeholderColor(.white)
        
        loginBtn.heightAnchor.constraint(equalToConstant: 45).isActive = true
        loginBtn.addTarget(self, action: #selector(onTapLoginButton), for: .touchUpInside)
        
        let viewBottom = UIView().D_HStack(UIView().setFrame(.init(width: 60, height: 60)).setBackground(color: .systemGreen),
                                           UIView().setFrame(.init(width: 60, height: 60)).setBackground(color: .systemGreen),
                                           UIView().setFrame(.init(width: 60, height: 60)).setBackground(color: .systemGreen),
                                           spacing: 10,
                                           alignment: .center,
                                           distribution: .equalCentering)
        view.addSubview(viewBottom)
        viewBottom.centerXToSuperview()
        viewBottom.topToBottom(of: viewLoginContainer).constant = 20
    }
    
    func setupScrollView() {
        view.gradientBackground(from: .systemOrange, to: .purple, direction: .topToBottom)
        view.addScrollView(scrollview, container: scrollViewContainer, elements: scrollViewElement)
        scrollViewElement.backgroundColor = .clear
        scrollViewElement.D_VStack(
            usernameTextField,
            passwordTextField,
            loginbutton,
            spacing: 20)
            .padding([.allMargins], amount: 16).setupSubview(backgroundColor: .clear)
        
        usernameTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 48).isActive = true
        loginBtn.heightAnchor.constraint(equalToConstant: 45).isActive = true
        scrollview.showsVerticalScrollIndicator = false
    }
    
    @objc func onTapLoginButton() {
        let licensesController = LicensesViewController()
        licensesController.loadPlist(Bundle.main, resourceName: "Credits")
        navigationController?.pushViewController(licensesController, animated: true)
    }
}
