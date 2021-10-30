import Swinject
import SwinjectAutoregistration

class LoginAssembly: Assembly {
    func assemble(container: Container) {
        container.autoregister(LoginViewModelProtocol.self, initializer: LoginViewModel.init)

        container.register(LoginViewController.self) {r in
            let controller = LoginViewController()
            controller.viewModel = r.resolve(LoginViewModelProtocol.self)
            return controller
        }
    }
}
