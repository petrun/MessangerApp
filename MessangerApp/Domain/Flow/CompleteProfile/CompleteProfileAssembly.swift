//
//  CompleteProfileAssembly.swift
//  MessangerApp
//
//  Created by andy on 08.12.2021.
//

import Foundation

import Swinject
import SwinjectAutoregistration

class CompleteProfileAssembly: Assembly {
    func assemble(container: Container) {
        container.register(CompleteProfileViewModelProtocol.self) { (r: Resolver, uid: String) in
            CompleteProfileViewModel(
                uid: uid,
                editProfileHandler: r.resolve(EditProfileHandlerProtocol.self)!
            )
        }

        container.register(CompleteProfileViewController.self) { (r: Resolver, uid: String) in
            let controller = CompleteProfileViewController()
            controller.viewModel = r.resolve(CompleteProfileViewModelProtocol.self, argument: uid)
            return controller
        }
    }
}
