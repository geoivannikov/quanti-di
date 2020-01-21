//
//  QuantiDI.swift
//  quanti-di
//
//  Created by George Ivannikov on 1/20/20.
//  Copyright © 2020 George Ivannikov. All rights reserved.
//

import Foundation
import Swinject

final class QuantiDI: NSObject {
    static var container = Container()
    
    static func start() {
        QuantiDI.container.register(ReachabilityControllerProtocolol.self) { _ in
            return ReachabilityController()
        }.inObjectScope(.transient)
        
        QuantiDI.container.register(FirebaseControllerProtocol.self) { _ in
            return FirebaseController()
        }.inObjectScope(.transient)
    }
    
    static func forceResolve<T>() -> T {
        return container.resolve(T.self)!
    }
}
