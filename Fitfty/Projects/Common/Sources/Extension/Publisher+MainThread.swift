//
//  Publisher+MainThread.swift
//  Common
//
//  Created by Ari on 2023/02/03.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation
import Combine

public extension Publisher {
    
    func sinkOnMainThread(
        receiveCompletion: @escaping ((Subscribers.Completion<Self.Failure>) -> Void),
        receiveValue: @escaping ((Self.Output) -> Void)
    ) -> AnyCancellable {
        return receive(on: DispatchQueue.main)
            .sink(receiveCompletion: receiveCompletion, receiveValue: receiveValue)
    }
    
    func sinkOnMainThread(
        receiveValue: @escaping ((Self.Output) -> Void)
    ) -> AnyCancellable where Self.Failure == Never {
        return receive(on: DispatchQueue.main)
            .sink(receiveValue: receiveValue)
    }
}
