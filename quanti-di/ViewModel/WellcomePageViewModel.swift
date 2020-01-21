//
//  WellcomePageViewModel.swift
//  quanti-di
//
//  Created by George Ivannikov on 1/19/20.
//  Copyright © 2020 George Ivannikov. All rights reserved.
//

import Foundation
import RxSwift
import Firebase
import FirebaseDatabase

protocol WellcomePageViewModelProtocol {
    var isUserLoggedInObservable: Observable<Bool> { get }
    var startActionObservable: Observable<WellcomePageAction> { get }
    var helloMessageObservable: Observable<String> { get }
    var logoutObservable: Observable<Void> { get }
    func applicationOpened()
    func doLogout() 
}

final class WellcomePageViewModel: WellcomePageViewModelProtocol {
    let isUserLoggedInObservable: Observable<Bool>
    let startActionObservable: Observable<WellcomePageAction>
    let helloMessageObservable: Observable<String>
    let logoutObservable: Observable<Void>
    
    private let firebaseController: FirebaseControllerProtocol
    private let isUserLoggedIn = PublishSubject<Bool>()
    private let helloMessage = PublishSubject<String>()
    private let logout = PublishSubject<Void>()
    private var bag = DisposeBag()

    init(
        firebaseController: FirebaseControllerProtocol = QuantiDI.forceResolve(),
        reachabilityController: ReachabilityControllerProtocolol = QuantiDI.forceResolve()
    ) {
        self.firebaseController = firebaseController
        let startAction = PublishSubject<WellcomePageAction>()
        self.startActionObservable = startAction.asObservable()
        self.logoutObservable = logout.asObservable()
        logoutObservable
            .subscribe(onNext: { _ in
                startAction.onNext(.navigateToLogin)
            })
            .disposed(by: bag)
        helloMessageObservable = helloMessage.asObservable()
        isUserLoggedInObservable = isUserLoggedIn.asObservable()
        isUserLoggedInObservable
            .subscribe(onNext: { isUserLoggedIn in
                if !isUserLoggedIn {
                    startAction.onNext(.navigateToLogin)
                } else {
                    if reachabilityController.isConnectedToNetwork() {
                        firebaseController.getUsername()
                        .map { username in
                            "Wellcome, " + (username ?? "user") + "!"
                        }
                        .bind(to: self.helloMessage)
                        .disposed(by: self.bag)
                    } else {
                        startAction.onNext(.displayNoConnectionMessage)
                    }
                }
            })
            .disposed(by: bag)
    }
    
    func applicationOpened() {
        isUserLoggedIn.onNext(firebaseController.isUserLoggedIn())
    }
    
    func doLogout() {
        logout.onNext(firebaseController.signOut())
    }
}
