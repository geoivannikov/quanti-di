//
//  LaunchArgument.swift
//  quanti-di
//
//  Created by George Ivannikov on 1/21/20.
//  Copyright © 2020 George Ivannikov. All rights reserved.
//

import Foundation

enum LaunchArgumentKey: String {
    case url
    case gateway
    case uitest
    case cache
    case isOffline
}

extension LaunchArgumentKey {
    var string: String? {
        return UserDefaults.standard.string(forKey: self.rawValue)
    }

    var bool: Bool {
        return UserDefaults.standard.bool(forKey: self.rawValue)
    }
}
