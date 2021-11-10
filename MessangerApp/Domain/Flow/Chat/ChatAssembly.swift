//
//  ChatAssembly.swift
//  MessangerApp
//
//  Created by andy on 07.11.2021.
//

import Swinject
import SwinjectAutoregistration

class ChatAssembly: Assembly {
    func assemble(container: Container) {
//        container.autoregister(RegistrationViewModelProtocol.self, initializer: RegistrationViewModel.init)

        container.register(ChatViewController.self) { _ in
            let controller = ChatViewController()
//            controller.viewModel = $0.resolve(RegistrationViewModelProtocol.self)
            return controller
        }
    }
}
