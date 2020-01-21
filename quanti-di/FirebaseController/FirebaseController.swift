//
//  FirebaseController.swift
//  quanti-di
//
//  Created by George Ivannikov on 1/19/20.
//  Copyright © 2020 George Ivannikov. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import RxSwift

protocol FirebaseControllerProtocol {
    func isUserLoggedIn() -> Bool
    func getUsername() -> Observable<String?>
    func signIn(email: String, password: String) -> Observable<LoginRegistrationAction>
    func signOut()
}

final class FirebaseController: FirebaseControllerProtocol {
    private var userID: String? = {
        let id = Auth.auth().currentUser?.uid
        return id
    }()
    
    func isUserLoggedIn() -> Bool {
        return Auth.auth().currentUser?.uid != nil
    }
    
    func getUsername() -> Observable<String?> {
        return Observable.create { observable in
            guard let userID = self.userID else {
                observable.onNext("")
                return Disposables.create()
            }
            let reference = Database.database().reference()
            reference.child(userID).child("username").observeSingleEvent(of: .value, with: { (snapshot) in
                observable.onNext(snapshot.value as? String)
              }) { (error) in
                observable.onNext(error.localizedDescription)
            }
            observable.onNext("")
            return Disposables.create()
        }
    }
    
    func signIn(email: String, password: String) -> Observable<LoginRegistrationAction> {
        return Observable.create { observable in
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                if let error = error, let _ = AuthErrorCode(rawValue: error._code) {
                    observable.onNext(.failureLogin)
                } else {
                    observable.onNext(.successLogin)
                }
            }
            return Disposables.create()
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {}
    }
}
