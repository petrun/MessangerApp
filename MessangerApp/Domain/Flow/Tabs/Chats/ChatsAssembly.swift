//
//  ChatsAssembly.swift
//  MessangerApp
//
//  Created by andy on 10.11.2021.
//

import Swinject
import SwinjectAutoregistration

class ChatsAssembly: Assembly {
    func assemble(container: Container) {
        container.autoregister(ChatsViewModelProtocol.self, initializer: ChatsViewModel.init)

        container.register(ChatsViewController.self) {
            let controller = ChatsViewController()
            controller.viewModel = $0.resolve(ChatsViewModelProtocol.self)
            return controller
        }
    }
}
