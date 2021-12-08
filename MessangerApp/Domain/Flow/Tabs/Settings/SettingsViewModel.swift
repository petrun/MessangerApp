//
//  SettingsViewModel.swift
//  MessangerApp
//
//  Created by andy on 10.11.2021.
//

import Foundation

protocol SettingsViewModelProtocol: AnyObject {
    var currentUser: User { get }

    func numberOfSections() -> Int
    func numberOfRowsInSection(section: Int) -> Int
    func item(for indexPath: IndexPath) -> SettingItemType
    func didSelectRowAt(indexPath: IndexPath)
}

enum SettingItemType {
    case profile
    case link
    case logout
}

final class SettingsViewModel {
    var coordinatorHandler: SettingsCoordinatorDelegate?

    let currentUser: User
    private let items: [[SettingItemType]] = [
        [.profile],
        [.link, .link],
        [.logout]
    ]

    init(userSession: UserSessionProtocol) {
        currentUser = userSession.user!
    }
}

extension SettingsViewModel: SettingsViewModelProtocol {
    func numberOfSections() -> Int {
        items.count
    }

    func numberOfRowsInSection(section: Int) -> Int {
        items[section].count
    }

    func item(for indexPath: IndexPath) -> SettingItemType {
        items[indexPath.section][indexPath.row]
    }

    func didSelectRowAt(indexPath: IndexPath) {
        switch self.item(for: indexPath) {
        case .profile:
            coordinatorHandler?.showProfile(user: currentUser)
        case .link:
            coordinatorHandler?.showLink()
        case .logout:
            coordinatorHandler?.logout()
        }
    }
}
