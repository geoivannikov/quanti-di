//
//  FirebaseControllerMock.swift
//  quanti-diUITests
//
//  Created by George Ivannikov on 1/20/20.
//  Copyright © 2020 George Ivannikov. All rights reserved.
//

import RxSwift

enum FirebaseControllerMockUseCases {
    case userIsNotLoggedIn
    case userIsLoggedIn
    case displayUsername
    case successSignIn
    case failureSignIn
    case unknown
}

final class FirebaseControllerMock: FirebaseControllerProtocol {
    private var isUserLogged: Bool!
    private var username: String!
    private var signInResult: LoginRegistrationAction!
    
    init(useCase: FirebaseControllerMockUseCases = .unknown) {
        switch useCase {
            case .userIsLoggedIn:
                isUserLogged = true
            case .userIsNotLoggedIn:
                isUserLogged = false
            case .displayUsername:
                isUserLogged = true
                username = "test user"
            case .successSignIn:
                signInResult = .successLogin
            case .failureSignIn:
                signInResult = .failureLogin
            case .unknown:
                break
        }
    }
    
    func isUserLoggedIn() -> Bool {
        return isUserLogged
    }
    
    func getUsername() -> Observable<String?> {
        return Observable.create { observable in
            observable.onNext(self.username)
            return Disposables.create()
        }
    }
    
    func signIn(email: String, password: String) -> Observable<LoginRegistrationAction> {
        return Observable.create { observable in
            observable.onNext(self.signInResult)
            return Disposables.create()
        }
    }
    
    func signOut() {}
}
