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
    
    func sinkOnMainThread(receiveCompletion: @escaping ((Subscribers.Completion<Self.Failure>) -> Void), receiveValue: @escaping ((Self.Output) -> Void)) -> AnyCancellable {
        if #available(iOS 14, *) {
            return receive(on: DispatchQueue.main)
                .sink(receiveCompletion: receiveCompletion, receiveValue: receiveValue)
        } else {
            return sink { completion in
                DispatchQueue.main.async {
                    receiveCompletion(completion)
                }
            } receiveValue: { output in
                DispatchQueue.main.async {
                    receiveValue(output)
                }
            }
        }
    }
    
    func sinkOnMainThread(receiveValue: @escaping ((Self.Output) -> Void)) -> AnyCancellable where Self.Failure == Never {
        if #available(iOS 14, *) {
            return receive(on: DispatchQueue.main)
                .sink(receiveValue: receiveValue)
        } else {
            return sink { output in
                DispatchQueue.main.async {
                    receiveValue(output)
                }
            }
        }
    }
}
