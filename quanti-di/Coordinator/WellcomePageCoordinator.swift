//
//  WellcomePageCoordinator.swift
//  quanti-di
//
//  Created by George Ivannikov on 1/19/20.
//  Copyright © 2020 George Ivannikov. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class WellcomePageCoordinator: Coordinator {
    private let navigationController: UINavigationController
    private let loginRegistrationCoordinator: LoginRegistrationCoordinator
    private let bag = DisposeBag()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        loginRegistrationCoordinator = LoginRegistrationCoordinator(navigationController: navigationController)
    }
    
    func start() {
        let wellcomePageViewModel = WellcomePageViewModel()
        
        wellcomePageViewModel.startActionObservable
            .subscribe(onNext: { [weak self] type in
                self?.takeAction(for: type)
            })
            .disposed(by: bag)
        
        let viewController = WellcomePageViewController.instantiate(wellcomePageViewModel: wellcomePageViewModel)
        navigationController.pushViewController(viewController, animated: false)
    }
    
    private func takeAction(for action: WellcomePageAction) {
        switch action {
            case .navigateToLogin:
                loginRegistrationCoordinator.start()
            case .displayNoConnectionMessage:
                let alert = UIAlertController.errorAlert(content: "Check your internet connection")
                navigationController.present(alert, animated: true)
        }
    }
}
