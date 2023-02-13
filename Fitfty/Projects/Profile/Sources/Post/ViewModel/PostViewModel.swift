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
    func viewDidLoad(boardToken: String)
    func didTapBookmark(boardToken: String)
}

public final class PostViewModel {
    
    private var currentState: CurrentValueSubject<ViewModelState?, Never> = .init(nil)
    private var cancellables: Set<AnyCancellable> = .init()
    
    public init() { }
    
}

extension PostViewModel: PostViewModelInput {
    var input: PostViewModelInput { self }
    
    func viewDidLoad(boardToken: String) {
        currentState.send(.isLoading(true))
        
        update(boardToken: boardToken)
    }
    
    func didTapBookmark(boardToken: String) {
        requestBookmark()
        update(boardToken: boardToken)
    }
    
}

extension PostViewModel: ViewModelType {
    
    public enum ViewModelState {
        case isLoading(Bool)
        case errorMessage(String)
        case update(PostResponse)
    }
    
    public var state: AnyPublisher<ViewModelState, Never> { currentState.compactMap { $0 }.eraseToAnyPublisher() }
    
}

extension PostViewModel {
    
    func update(boardToken: String) {
        Task { [weak self] in
            guard let self = self else {
                return
            }
            do {
                self.currentState.send(.isLoading(true))
                let response = try await getPost(boardToken: boardToken)
                guard response.result == "SUCCESS" else {
                    return
                }
                self.currentState.send(.update(response))
                currentState.sink(receiveValue: { [weak self] state in
                    switch state {
                    case .update, .errorMessage:
                        self?.currentState.send(.isLoading(false))
                        
                    default: return
                    }
                }).store(in: &cancellables)
                
            } catch {
                Logger.debug(error: error, message: "게시글 조회를 실패")
                currentState.send(.errorMessage("게시글을 조회에 알 수 없는 에러가 발생했습니다."))
            }
        }
        
    }
    
    func getPost(boardToken: String) async throws -> PostResponse {
        let response = try await FitftyAPI.request(
            target: .getPost(boardToken: boardToken),
            dataType: PostResponse.self
        )
        return response
    }
    
}

private extension PostViewModel {
    
    func requestBookmark() {
//        Task { [weak self] in
//            guard let self = self else {
//                return
//            }
//            do {
//                let response = try await fitftyRepository.bookmark(self.isBookmark, boardToken: self.cody.boardToken)
//                if response.result == .fail {
//                    let error = CodyCellViewModelError.failure(errorCode: response.errorCode ?? "", message: response.message ?? "")
//                    Logger.debug(error: error, message: "북마크 업데이트 실패")
//                }
//            } catch {
//                Logger.debug(error: error, message: "북마크 업데이트 실패")
//            }
//        }
    }
    
}
