//
//  ProfileAssembly.swift
//  MessangerApp
//
//  Created by andy on 12.11.2021.
//

import Swinject
import SwinjectAutoregistration

class EditProfileAssembly: Assembly {
    func assemble(container: Container) {
        container.register(EditProfileViewModelProtocol.self) { (r: Resolver, user: User) in
            EditProfileViewModel(
                user: user,
                editProfileHandler: r.resolve(EditProfileHandlerProtocol.self)!
            )
        }

        container.register(EditProfileViewController.self) { (r: Resolver, user: User) in
            let controller = EditProfileViewController()
            controller.viewModel = r.resolve(EditProfileViewModelProtocol.self, argument: user)

            return controller
        }
    }
}
