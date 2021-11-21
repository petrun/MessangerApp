//
//  SettingsAssembly.swift
//  MessangerApp
//
//  Created by andy on 10.11.2021.
//

import Swinject
import SwinjectAutoregistration

class SettingsAssembly: Assembly {
    func assemble(container: Container) {
        container.autoregister(SettingsViewModelProtocol.self, initializer: SettingsViewModel.init)

        container.register(SettingsViewController.self) {
            let controller = SettingsViewController()
            controller.viewModel = $0.resolve(SettingsViewModelProtocol.self)
            return controller
        }
    }
}
