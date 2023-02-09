//
//  PostViewModel.swift
//  Profile
//
//  Created by 임영선 on 2023/02/09.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation
import Combine
import Common
import Core

protocol PostViewModelInput {
    
    var input: PostViewModelInput { get }
    func viewDidLoad()
}

public final class PostViewModel {
    
    private var currentState: CurrentValueSubject<ViewModelState?, Never> = .init(nil)
    private var cancellables: Set<AnyCancellable> = .init()
    
    public init() { }
    
}

extension PostViewModel: PostViewModelInput {
    var input: PostViewModelInput { self }
    
    func viewDidLoad() {
        currentState.send(.isLoading(true))
      
        Task {
            do {
                let postResponse = try await getPost(boardToken: "brd_8C7UuQondUigImjn")
                print("PostViewModel response \(postResponse.data)")
                
            } catch {
                Logger.debug(error: error, message: "test fail")
            }
        }

    }
        
}

extension PostViewModel: ViewModelType {
    
    public enum ViewModelState {
        case isLoading(Bool)
        case errorMessage(String)
        case post(PostResponse)
    }
    
    public var state: AnyPublisher<ViewModelState, Never> { currentState.compactMap { $0 }.eraseToAnyPublisher() }

}

extension PostViewModel {
    func getPost(boardToken: String) async throws -> PostResponse {
        let response = try await FitftyAPI.request(
            target: .getPost(boardToken: boardToken),
            dataType: PostResponse.self
        )
        return response
    }
}
