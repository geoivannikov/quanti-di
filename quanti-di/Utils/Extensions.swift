//
//  Extensions.swift
//  quanti-di
//
//  Created by George Ivannikov on 1/19/20.
//  Copyright © 2020 George Ivannikov. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    static func load<T: UIViewController>(viewController: Constants.ViewControllerId, from storyboard: Constants.StoryboardId) -> T {
        let storyboard = UIStoryboard(name: storyboard.rawValue, bundle: Bundle.main)
        guard let vc = storyboard.instantiateViewController(withIdentifier: viewController.rawValue) as? T else {
            fatalError("Fatal error when instantiating \(viewController) from storyboard \(storyboard).")
        }
        return vc
    }
}

extension UIAlertController {
    static func errorAlert(content: String) -> UIAlertController {
        let alert = UIAlertController(title: "Error", message: content, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        return alert
    }
}
