//
//  LoginRegistrationViewModel.swift
//  quanti-di
//
//  Created by George Ivannikov on 1/19/20.
//  Copyright © 2020 George Ivannikov. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol LoginRegistrationViewModelProtocol {
    var username: BehaviorRelay<String?> { get }
    var email: BehaviorRelay<String?> { get }
    var password: BehaviorRelay<String?> { get }
    var confirmPassword: BehaviorRelay<String?> { get }
    var loginAction: PublishSubject<Void> { get }
    var registrationAction: PublishSubject<Void> { get }
    var isEmptyFieldsObservable: Observable<Bool> { get }
    var startActionObservable: Observable<LoginRegistrationAction> { get }
    var isLoadingStateObservable: Observable<Bool> { get }
}

final class LoginRegistrationViewModel: LoginRegistrationViewModelProtocol {
    let username = BehaviorRelay<String?>(value: "")
    let email = BehaviorRelay<String?>(value: "")
    let password = BehaviorRelay<String?>(value: "")
    let confirmPassword = BehaviorRelay<String?>(value: "")
    let loginAction: PublishSubject<Void> = PublishSubject<Void>()
    let registrationAction: PublishSubject<Void> = PublishSubject<Void>()
    let isEmptyFieldsObservable: Observable<Bool>
    let startActionObservable: Observable<LoginRegistrationAction>
    let isLoadingStateObservable: Observable<Bool>

    private let isLoadingState: PublishSubject<Bool> = PublishSubject<Bool>()    
    private let firebaseController: FirebaseControllerProtocol
    private var bag = DisposeBag()
    
    init(
        firebaseController: FirebaseControllerProtocol = QuantiDI.forceResolve(),
        reachabilityController: ReachabilityControllerProtocolol = QuantiDI.forceResolve()
    ) {
        self.firebaseController = firebaseController
        let startAction = PublishSubject<LoginRegistrationAction>()
        let isEmptyFields = PublishSubject<Bool>()
        isLoadingStateObservable = isLoadingState.asObservable()
        self.startActionObservable = startAction.asObservable()
        isLoadingState.onNext(false)
        isEmptyFieldsObservable = isEmptyFields.asObservable()
        isEmptyFieldsObservable
            .subscribe(onNext: { isEmpty in
                if isEmpty {
                    startAction.onNext(.emptyFieldsAlert)
                } else {
                    if reachabilityController.isConnectedToNetwork() {
                        self.isLoadingState.onNext(true)
                        let loginObservable = firebaseController.signIn(email: self.email.value ?? "",
                                                                        password: self.password.value ?? "")
                        loginObservable
                            .bind(to: startAction)
                            .disposed(by: self.bag)
                    } else {
                        startAction.onNext(.noConnectionAlert)
                    }
                }
            })
            .disposed(by: bag)
        
        loginAction.asObservable()
            .map { [weak self] in
                self?.email.value?.isEmpty ?? true ||
                self?.password.value?.isEmpty ?? true    
            }
            .bind(to: isEmptyFields)
            .disposed(by: bag)
        
        startActionObservable
            .map { $0 == .failureLogin }
            .subscribe(onNext: { [weak self] isFail in
                if isFail {
                    self?.isLoadingState.onNext(false)
                }
            })
            .disposed(by: bag)
    }
}
