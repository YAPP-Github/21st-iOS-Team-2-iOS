//
//  PersonalInfoViewModel.swift
//  Profile
//
//  Created by Ari on 2023/01/28.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation
import Combine

import Common
import Core

enum PersonalInfoSection {
    case info
    case gender
    case etc
    
    init?(index: Int) {
        switch index {
        case 0: self = .info
        case 1: self = .gender
        case 2: self = .etc
        default: return nil
        }
    }
}

public final class PersonalInfoViewModel: ViewModelType {
    public enum ViewModelState {
        case updateUserPrivacy(userPrivacy: UserPrivacy)
        case pushWithdrawAccountView
        case showAuthView
        case popView
        case showErrorAlert(_ error: Error)
    }
    
    private let repository: SettingRepository
    
    public var state: AnyPublisher<ViewModelState, Never> { currentState.compactMap { $0 }.eraseToAnyPublisher() }
    private var currentState: CurrentValueSubject<ViewModelState?, Never> = .init(nil)
    
    private var userPrivacy = UserPrivacy(email: "")
    private var hasAvailableNickname = false
    private var hasAvailableBirthday = false
    
    public init(repository: SettingRepository) {
        self.repository = repository
    }
    
    func didTapSaveButton(nickname: String?, birthday: String?) {
        checkAvailableNickname(nickname)
        checkAvailableBirthday(birthday)
        
        guard hasAvailableNickname else {
            currentState.send(.showErrorAlert(SettingError.noAvailableNickname))
            return
        }

        guard hasAvailableBirthday else {
            currentState.send(.showErrorAlert(SettingError.noAvailableBirthday))
            return
        }
        
        userPrivacy.nickname = nickname
        userPrivacy.birtyday = birthday
        
        saveNewUserPrivacy()
    }
    
    func getUserPrivacy() {
        Task {
            do {
                let response = try await repository.getUserPrivacy()
                
                userPrivacy = UserPrivacy(email: response.data?.email,
                                          nickname: response.data?.nickname,
                                          birtyday: response.data?.birthday,
                                          gender: response.data?.gender)
                currentState.send(.updateUserPrivacy(userPrivacy: userPrivacy))
            } catch {
                currentState.send(.showErrorAlert(error))
            }
        }
    }
    
    func didTapGender(item: Int) {
        if item == 0 {
            userPrivacy.gender = "FEMALE"
        } else {
            userPrivacy.gender = "MALE"
        }
        
        currentState.send(.updateUserPrivacy(userPrivacy: userPrivacy))
    }
    
    func withdrawAccount() {
        currentState.send(.pushWithdrawAccountView)
    }
    
    func logout() {
        repository.logout()
        currentState.send(.showAuthView)
    }
    
    func isFemaleUser() -> Bool {
        return userPrivacy.gender == "FEMALE" ? true : false
    }
    
    func isMaleUser() -> Bool {
        return userPrivacy.gender == "MALE" ? true : false
    }
}

private extension PersonalInfoViewModel {
    func saveNewUserPrivacy() {
        guard let nickname = userPrivacy.nickname,
              let birthday = userPrivacy.birtyday,
              let gender = userPrivacy.gender else {
            return
        }
        
        Task {
            do {
                try await repository.updateUserPrivacy(nickname: nickname,
                                                       birthday: birthday,
                                                       gender: gender)
                currentState.send(.popView)
            } catch {
                currentState.send(.showErrorAlert(error))
            }
        }
    }
    
    func checkAvailableNickname(_ nickname: String?) {
        userPrivacy.nickname = nickname
        let regex = "^[0-9a-zA-Z._]{1,30}$"
        if nickname?.range(of: regex, options: .regularExpression) != nil {
            hasAvailableNickname = true
        } else {
            hasAvailableNickname = false
        }
    }
    
    func checkAvailableBirthday(_ birthday: String?) {
        if birthday?.isEmpty == true {
            userPrivacy.birtyday = nil
            hasAvailableBirthday = true
            return
        }
        
        userPrivacy.birtyday = birthday
        let regex = "^[0-9]{6}$"
        if birthday?.range(of: regex, options: .regularExpression) != nil {
            hasAvailableBirthday = true
        } else {
            hasAvailableBirthday = false
        }
    }
}
