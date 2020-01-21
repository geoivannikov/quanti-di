//
//  LoginRegistrationCoordinator.swift
//  quanti-di
//
//  Created by George Ivannikov on 1/19/20.
//  Copyright © 2020 George Ivannikov. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

final class LoginRegistrationCoordinator: Coordinator {
    private let navigationController: UINavigationController
    private let presentNavigationController: UINavigationController
    private let bag = DisposeBag()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.presentNavigationController = UINavigationController()
    }
    
    func start() {
        let loginRegistrationViewModel = LoginRegistrationViewModel()
        
        loginRegistrationViewModel.startActionObservable
            .subscribe(onNext: { [weak self] type in
                self?.takeAction(for: type)
            })
            .disposed(by: bag)
        
        let viewController = LoginRegistrationViewController.instantiate(loginRegistrationViewModel: loginRegistrationViewModel)
        presentNavigationController.viewControllers = [viewController]
        presentNavigationController.modalPresentationStyle = .fullScreen
        navigationController.present(presentNavigationController, animated: false, completion: nil)
    }
    
    private func takeAction(for action: LoginRegistrationAction) {
        switch action {
            case .emptyFieldsAlert:
                let alert = UIAlertController.errorAlert(content: "All fields must be filled")
                presentNavigationController.present(alert, animated: true)
            case .noConnectionAlert:
                let alert = UIAlertController.errorAlert(content: "Check your internet connection")
                presentNavigationController.present(alert, animated: true)
            case .successLogin:
                presentNavigationController.dismiss(animated: true, completion: nil)
            case .failureLogin:
                    let alert = UIAlertController.errorAlert(content: "Incorrect login or password")
                    presentNavigationController.present(alert, animated: true)
        }
    }
}
