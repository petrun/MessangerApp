//
//  RegistrationAssembly.swift
//  MessangerApp
//
//  Created by andy on 30.10.2021.
//

import Swinject
import SwinjectAutoregistration

class RegistrationAssembly: Assembly {
    func assemble(container: Container) {
        container.autoregister(RegistrationViewModelProtocol.self, initializer: RegistrationViewModel.init)

        container.register(RegistrationViewController.self) {
            let controller = RegistrationViewController()
            controller.viewModel = $0.resolve(RegistrationViewModelProtocol.self)
            return controller
        }
    }
}
