//
//  Constants.swift
//  quanti-di
//
//  Created by George Ivannikov on 1/19/20.
//  Copyright © 2020 George Ivannikov. All rights reserved.
//

import Foundation

struct Constants {
    enum StoryboardId: String {
        case main = "Main"
    }
    
    enum ViewControllerId: String {
        case wellcomePage = "WellcomePageViewController"
        case loginRegistration = "LoginRegistrationViewController"
    }
    
    struct TestConstants {
        static let timeout: TimeInterval = 3
    }
}
