//
//  ProfileAssembly.swift
//  MessangerApp
//
//  Created by andy on 12.11.2021.
//

import Swinject
import SwinjectAutoregistration

class ProfileAssembly: Assembly {
    func assemble(container: Container) {
        container.register(ProfileViewModelProtocol.self) { _, user in
            ProfileViewModel(user: user)
        }

        container.register(ProfileViewController.self) { (r: Resolver, user: User) in
            let controller = ProfileViewController()
            controller.viewModel = r.resolve(
                ProfileViewModelProtocol.self,
                argument: user
            ) // as! ProfileViewModelProtocol

//            let animal1 = container.resolve(Animal.self, argument: "Spirit")!
//            controller.viewModel = $0.resolve(RegistrationViewModelProtocol.self)
            return controller
        }
    }
}
