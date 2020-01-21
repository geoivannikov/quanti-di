//
//  WellcomePageViewModelTests.swift
//  quanti-diUITests
//
//  Created by George Ivannikov on 1/20/20.
//  Copyright © 2020 George Ivannikov. All rights reserved.
//

import XCTest
import RxSwift

class WellcomePageViewModelTests: XCTestCase {
    var viewModel: WellcomePageViewModel!
    var bag: DisposeBag!
    
    override func setUp() {
        super.setUp()
        bag = DisposeBag()
        viewModel = WellcomePageViewModel(firebaseController: FirebaseControllerMock(),
                                          reachabilityController: ReachabilityControllerMock())
    }
    
    func testUserIsLoggedIn() {
        viewModel = WellcomePageViewModel(firebaseController: FirebaseControllerMock(useCase: .userIsLoggedIn),
                                          reachabilityController: ReachabilityControllerMock(useCase: .online))

        viewModel.isUserLoggedInObservable
            .subscribe(onNext: { isLoggedIn in
                XCTAssertTrue(isLoggedIn)
            })
            .disposed(by: bag)

        viewModel.applicationOpened()
    }
    
    func testUserIsNotLoggedIn() {
        viewModel = WellcomePageViewModel(firebaseController: FirebaseControllerMock(useCase: .userIsNotLoggedIn),
                                          reachabilityController: ReachabilityControllerMock(useCase: .online))

        viewModel.isUserLoggedInObservable
            .subscribe(onNext: { isLoggedIn in
                XCTAssertFalse(isLoggedIn)
            })
            .disposed(by: bag)
        
        viewModel.startActionObservable
            .subscribe(onNext: { action in
                XCTAssertEqual(action, .navigateToLogin)
            })
            .disposed(by: bag)

        viewModel.applicationOpened()
    }
    
    func testApplicationOpenedInOffline() {
        viewModel = WellcomePageViewModel(firebaseController: FirebaseControllerMock(useCase: .userIsLoggedIn),
                                          reachabilityController: ReachabilityControllerMock(useCase: .offline))

        viewModel.startActionObservable
            .subscribe(onNext: { action in
                XCTAssertEqual(action, .displayNoConnectionMessage)
            })
            .disposed(by: bag)
        
        viewModel.helloMessageObservable
            .subscribe(onNext: { helloMessage in
                XCTAssertEqual(helloMessage, "Wellcome!")
            })
            .disposed(by: bag)

        viewModel.applicationOpened()
    }
    
    func testLogoutTapped() {
        viewModel = WellcomePageViewModel(firebaseController: FirebaseControllerMock(useCase: .userIsLoggedIn),
                                          reachabilityController: ReachabilityControllerMock(useCase: .online))

        viewModel.startActionObservable
            .subscribe(onNext: { action in
                XCTAssertEqual(action, .navigateToLogin)
            })
            .disposed(by: bag)

        viewModel.doLogout()
    }
    
    func testDisplayUsername() {
        viewModel = WellcomePageViewModel(firebaseController: FirebaseControllerMock(useCase: .displayUsername),
                                          reachabilityController: ReachabilityControllerMock(useCase: .online))

        viewModel.helloMessageObservable
            .subscribe(onNext: { helloMessage in
                XCTAssertEqual(helloMessage, "Wellcome, test user!")
            })
            .disposed(by: bag)

        viewModel.applicationOpened()
    }
}
