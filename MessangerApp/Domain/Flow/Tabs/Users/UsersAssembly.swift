//
//  UsersAssembly.swift
//  MessangerApp
//
//  Created by andy on 12.11.2021.
//

import Swinject
import SwinjectAutoregistration

class UsersAssembly: Assembly {
    func assemble(container: Container) {
        container.autoregister(UsersViewModelProtocol.self, initializer: UsersViewModel.init)

        container.register(UsersViewController.self) {
            let controller = UsersViewController()
            controller.viewModel = $0.resolve(UsersViewModelProtocol.self)
            return controller
        }
    }
}
