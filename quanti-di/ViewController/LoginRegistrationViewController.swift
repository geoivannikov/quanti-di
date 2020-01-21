//
//  LoginRegistrationViewController.swift
//  quanti-di
//
//  Created by George Ivannikov on 1/19/20.
//  Copyright © 2020 George Ivannikov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LoginRegistrationViewController: UIViewController {
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var loadingIndikator: UIActivityIndicatorView!
    @IBOutlet weak var actionButton: UIButton!
    
    private var loginRegistrationViewModel: LoginRegistrationViewModelProtocol!
    private var bag = DisposeBag()
    
    static func instantiate(
        loginRegistrationViewModel: LoginRegistrationViewModelProtocol
    ) -> LoginRegistrationViewController {
        let viewController: LoginRegistrationViewController = UIViewController.load(viewController: .loginRegistration,
                                                                                    from: .main)
        viewController.loginRegistrationViewModel = loginRegistrationViewModel
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindRx()
        setUpLoadingIndicator()
    }
    
    private func bindRx() {
        segmentedControl.rx.selectedSegmentIndex
            .subscribe(onNext: { [weak self] index in
                switch index {
                case 0:
                    self?.setUpForLogin()
                case 1:
                    self?.setUpForRegistration()
                default:
                    break
                }
            })
        .disposed(by: bag)
        
        usernameTextField.rx.text
            .subscribe(onNext: { self.loginRegistrationViewModel.username.accept($0) })
            .disposed(by: bag)
        
        emailTextField.rx.text
            .subscribe(onNext: { self.loginRegistrationViewModel.email.accept($0) })
            .disposed(by: bag)
        
        passwordTextField.rx.text
            .subscribe(onNext: { self.loginRegistrationViewModel.password.accept($0) })
            .disposed(by: bag)
        
        confirmPasswordTextField.rx.text
            .subscribe(onNext: { self.loginRegistrationViewModel.confirmPassword.accept($0) })
            .disposed(by: bag)
        
        actionButton.rx.tap
            .map { self.segmentedControl.selectedSegmentIndex == 0 }
            .do(onNext: { [weak self] isLogin in
                if isLogin {
                    self?.loginRegistrationViewModel.loginAction.onNext(())
                } else {
                    self?.loginRegistrationViewModel.registrationAction.onNext(())
                }
            })
            .subscribe()
            .disposed(by: bag)
        
        loginRegistrationViewModel.isLoadingStateObservable
            .map { !$0 }
            .bind(to: loadingIndikator.rx.isHidden)
            .disposed(by: bag)
    }
    
    private func setUpLoadingIndicator() {
            loadingIndikator.isHidden = true
            loadingIndikator.startAnimating()
    }
    
    private func setUpForLogin() {
        usernameTextField.isHidden = true
        confirmPasswordTextField.isHidden = true
        actionButton.setTitle("Login", for: .normal)
    }
    
    private func setUpForRegistration() {
        usernameTextField.isHidden = false
        confirmPasswordTextField.isHidden = false
        actionButton.setTitle("Register", for: .normal)
    }
}
