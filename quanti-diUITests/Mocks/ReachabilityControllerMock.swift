//
//  ReachabilityControllerMock.swift
//  quanti-diUITests
//
//  Created by George Ivannikov on 1/21/20.
//  Copyright © 2020 George Ivannikov. All rights reserved.
//

enum ReachabilityControllerMockUseCases {
    case online
    case offline
    case unknown
}

final class ReachabilityControllerMock: ReachabilityControllerProtocolol {
    var isConnected: Bool!
    
    init(useCase: ReachabilityControllerMockUseCases = .unknown) {
        switch useCase {
            case .online:
                isConnected = true
            case .offline:
                isConnected = false
            case .unknown:
                break
        }
    }
    
    func isConnectedToNetwork() -> Bool {
        return isConnected
    }
    
    
}
