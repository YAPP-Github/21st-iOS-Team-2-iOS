//
//  PostBottomSheetViewModel.swift
//  Profile
//
//  Created by 임영선 on 2023/02/12.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation
import Combine
import Common
import Core

protocol PostBottomSheetViewModelInput {
    
    var input: PostBottomSheetViewModelInput { get }
    func didTapDeleteButton(boardToken: String, filepath: String)
}

public final class PostBottomSheetViewModel {
    
    private var currentState: CurrentValueSubject<ViewModelState?, Never> = .init(nil)
    private var cancellables: Set<AnyCancellable> = .init()
    
    public init() { }
    
    private func filenameFromFilepath(_ filepath: String) -> String? {
        if filepath.contains("female") {
            let splitGender = filepath.components(separatedBy: "female")
            return "female" + splitGender[1]
        } else if filepath.contains("male") {
            let splitGender = filepath.components(separatedBy: "male")
            return "male" + splitGender[1]
        } else {
            return nil
        }
    }
    
}

extension PostBottomSheetViewModel: PostBottomSheetViewModelInput {
    var input: PostBottomSheetViewModelInput { self }
    
    func didTapDeleteButton(boardToken: String, filepath: String) {
        Task { [weak self] in
            guard let self = self else {
                return
            }
            do {
                guard let filename = self.filenameFromFilepath(filepath) else {
                    return
                }
                self.currentState.send(.isLoading(true))
                let response = try await deletePost(boardToken: boardToken)
                if response.result == "SUCCESS" {
                    try await AmplifyManager.shared.delete(fileName: filename)
                    self.currentState.send(.completed(true))
                } else {
                    self.currentState.send(.errorMessage("게시글 삭제에 알 수 없는 에러가 발생했습니다."))
                    self.currentState.send(.completed(false))
                }
                
            } catch {
                Logger.debug(error: error, message: "게시글 삭제 실패")
                currentState.send(.errorMessage("게시글 삭제에 알 수 없는 에러가 발생했습니다."))
            }
        }
    }
    
}

extension PostBottomSheetViewModel: ViewModelType {
    
    public enum ViewModelState {
        case isLoading(Bool)
        case errorMessage(String)
        case completed(Bool)
    }
    
    public var state: AnyPublisher<ViewModelState, Never> { currentState.compactMap { $0 }.eraseToAnyPublisher() }
    
}

extension PostBottomSheetViewModel {
    
    func deletePost(boardToken: String) async throws -> FitftyResponse {
        let response = try await FitftyAPI.request(
            target: .deletePost(boardToken: boardToken),
            dataType: FitftyResponse.self
        )
        return response
    }
    
}
