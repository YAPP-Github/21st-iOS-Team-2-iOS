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
    func viewWillAppear(boardToken: String)
    func didTapBookmark(boardToken: String)
}

public final class PostViewModel {
    
    private var currentState: CurrentValueSubject<ViewModelState?, Never> = .init(nil)
    private var cancellables: Set<AnyCancellable> = .init()
    private var isBookmarked: Bool?
    private var currentIsBookmarked: Bool?
    private var bookmarkCount: Int?
    
    public init() { }
    
}

extension PostViewModel: PostViewModelInput {
    
    var input: PostViewModelInput { self }
    
    func viewWillAppear(boardToken: String) {
        currentState.send(.isLoading(true))
        update(boardToken: boardToken)
    }
    
    func didTapBookmark(boardToken: String) {
        if DefaultUserManager.shared.getCurrentGuestState() {
            currentState.send(.errorMessage("로그인이 필요합니다."))
        } else {
            requestBookmark(boardToken: boardToken)
        }
    }
    
}

extension PostViewModel: ViewModelType {
    
    public enum ViewModelState {
        case isLoading(Bool)
        case errorMessage(String)
        case update(PostResponse)
        case bookmark(Bool?, Bool?, Int?)
    }
    
    public var state: AnyPublisher<ViewModelState, Never> { currentState.compactMap { $0 }.eraseToAnyPublisher() }
    
}

private extension PostViewModel {
    
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
                self.isBookmarked = response.data?.bookmarked
                self.currentIsBookmarked = response.data?.bookmarked
                self.bookmarkCount = response.data?.bookmarkCnt
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
    
    func requestBookmark(boardToken: String) {
        Task { [weak self] in
            guard let self = self else {
                return
            }
            do {
                guard let isBookmarked = self.isBookmarked else {
                    return
                }
                let response = try await bookmark(isBookmarked, boardToken: boardToken)
                if response.result == .fail {
                    self.currentState.send(.errorMessage("북마크 업데이트 실패"))
                }
                self.isBookmarked = !isBookmarked
                self.currentState.send(.bookmark(self.currentIsBookmarked, self.isBookmarked, self.bookmarkCount))
            } catch {
                self.currentState.send(.errorMessage("북마크 업데이트 실패"))
                Logger.debug(error: error, message: "북마크 업데이트 실패")
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
    
    func bookmark(_ isBookmark: Bool, boardToken: String) async throws -> BookmarkResponse {
        let target: FitftyAPI = isBookmark ? .deleteBookmark(boardToken: boardToken) : .addBookmark(boardToken: boardToken)
        return try await FitftyAPI.request(target: target, dataType: BookmarkResponse.self)
    }
    
}
