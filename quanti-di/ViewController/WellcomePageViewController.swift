//
//  WellcomePageViewController.swift
//  quanti-di
//
//  Created by George Ivannikov on 1/19/20.
//  Copyright © 2020 George Ivannikov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class WellcomePageViewController: UIViewController {
    @IBOutlet weak var wellcomeLabel: UILabel!
    @IBOutlet weak var logOutButton: UIButton!
    
    private var wellcomePageViewModel: WellcomePageViewModelProtocol!
    private var bag = DisposeBag()

    static func instantiate(
        wellcomePageViewModel: WellcomePageViewModelProtocol
    ) -> WellcomePageViewController {
        let viewController: WellcomePageViewController = UIViewController.load(viewController: .wellcomePage,
                                                                               from: .main)
        viewController.wellcomePageViewModel = wellcomePageViewModel
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindRx()
        wellcomePageViewModel.applicationOpened()
    }
    
    private func bindRx() {
        wellcomePageViewModel.helloMessageObservable
            .bind(to: wellcomeLabel.rx.text)
            .disposed(by: bag)
        
        logOutButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.wellcomePageViewModel.doLogout()
            })
            .disposed(by: bag)
    }
}
