//
//  SettingsViewModel.swift
//  MessangerApp
//
//  Created by andy on 10.11.2021.
//

import Foundation

protocol SettingsViewModelProtocol: AnyObject {
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
    private let items: [[SettingItemType]] = [
        [.profile],
        [.link, .link],
        [.logout]
    ]

//    private let authService: AuthServiceProtocol
//    private let logger: LoggerService
    var coordinatorHandler: SettingsCoordinatorDelegate?

//    init(authService: AuthServiceProtocol, logger: LoggerService) {
//        self.authService = authService
//        self.logger = logger
//    }
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
            coordinatorHandler?.showProfile()
        case .link:
            coordinatorHandler?.showLink()
        case .logout:
            coordinatorHandler?.logout()
        }
    }
}
