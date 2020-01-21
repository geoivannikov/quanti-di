//
//  LoginRegistrationViewModelTests.swift
//  quanti-diUITests
//
//  Created by George Ivannikov on 1/21/20.
//  Copyright © 2020 George Ivannikov. All rights reserved.
//

import XCTest
import RxSwift

class LoginRegistrationViewModelTests: XCTestCase {
    var viewModel: LoginRegistrationViewModel!
    var bag: DisposeBag!
    
    override func setUp() {
        super.setUp()
        bag = DisposeBag()
        viewModel = LoginRegistrationViewModel(firebaseController: FirebaseControllerMock(),
                                          reachabilityController: ReachabilityControllerMock())
    }
    
    func testEmptyFields() {
        viewModel = LoginRegistrationViewModel(firebaseController: FirebaseControllerMock(useCase: .userIsNotLoggedIn),
                                          reachabilityController: ReachabilityControllerMock(useCase: .online))
        viewModel.email.accept("")
        viewModel.password.accept("")
        
        viewModel.isEmptyFieldsObservable
            .subscribe(onNext: { isEmpty in
                XCTAssertTrue(isEmpty)
            })
            .disposed(by: bag)
        
        viewModel.startActionObservable
            .subscribe(onNext: { action in
                XCTAssertEqual(action, .emptyFieldsAlert)
            })
            .disposed(by: bag)
        
        viewModel.loginAction.onNext(())
    }
    
    func testEmptyEmailField() {
        viewModel = LoginRegistrationViewModel(firebaseController: FirebaseControllerMock(useCase: .userIsNotLoggedIn),
                                          reachabilityController: ReachabilityControllerMock(useCase: .online))
        viewModel.email.accept("")
        viewModel.password.accept("1234")
        
        viewModel.isEmptyFieldsObservable
            .subscribe(onNext: { isEmpty in
                XCTAssertTrue(isEmpty)
            })
            .disposed(by: bag)
        
        viewModel.startActionObservable
            .subscribe(onNext: { action in
                XCTAssertEqual(action, .emptyFieldsAlert)
            })
            .disposed(by: bag)
        
        viewModel.loginAction.onNext(())
    }
    
    func testEmptyPasswordField() {
        viewModel = LoginRegistrationViewModel(firebaseController: FirebaseControllerMock(useCase: .userIsNotLoggedIn),
                                          reachabilityController: ReachabilityControllerMock(useCase: .online))
        viewModel.email.accept("email@gmail.com")
        viewModel.password.accept("")
        
        viewModel.isEmptyFieldsObservable
            .subscribe(onNext: { isEmpty in
                XCTAssertTrue(isEmpty)
            })
            .disposed(by: bag)
        
        viewModel.startActionObservable
            .subscribe(onNext: { action in
                XCTAssertEqual(action, .emptyFieldsAlert)
            })
            .disposed(by: bag)
        
        viewModel.loginAction.onNext(())
    }
    
    func testOfflineLogin() {
        viewModel = LoginRegistrationViewModel(firebaseController: FirebaseControllerMock(useCase: .userIsNotLoggedIn),
                                          reachabilityController: ReachabilityControllerMock(useCase: .offline))
        viewModel.email.accept("email@gmail.com")
        viewModel.password.accept("1234")
        
        viewModel.startActionObservable
            .subscribe(onNext: { action in
                XCTAssertEqual(action, .noConnectionAlert)
            })
            .disposed(by: bag)
        
        viewModel.loginAction.onNext(())
    }
    
    func testSuccessSignIn() {
        viewModel = LoginRegistrationViewModel(firebaseController: FirebaseControllerMock(useCase: .successSignIn),
                                          reachabilityController: ReachabilityControllerMock(useCase: .online))
        viewModel.email.accept("email@gmail.com")
        viewModel.password.accept("1234")
        
        viewModel.startActionObservable
            .subscribe(onNext: { action in
                XCTAssertEqual(action, .successLogin)
            })
            .disposed(by: bag)
        
        let expectation = self.expectation(description: "Wait")
        viewModel.isLoadingStateObservable
            .subscribe(onNext: { isLoading in
                XCTAssertTrue(isLoading)
                expectation.fulfill()
            })
            .disposed(by: bag)
        
        viewModel.loginAction.onNext(())
        waitForExpectations(timeout: Constants.TestConstants.timeout)
    }
    
    func testFailureSignIn() {
        viewModel = LoginRegistrationViewModel(firebaseController: FirebaseControllerMock(useCase: .failureSignIn),
                                          reachabilityController: ReachabilityControllerMock(useCase: .online))
        viewModel.email.accept("email@gmail.com")
        viewModel.password.accept("1234")
        
        viewModel.startActionObservable
            .subscribe(onNext: { action in
                XCTAssertEqual(action, .failureLogin)
            })
            .disposed(by: bag)
        
        viewModel.loginAction.onNext(())
    }
}
