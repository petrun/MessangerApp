import Swinject
import SwinjectAutoregistration

class LoginAssembly: Assembly {
    func assemble(container: Container) {
        container.autoregister(LoginViewModelProtocol.self, initializer: LoginViewModel.init)

        container.register(LoginViewController.self) {
            let controller = LoginViewController()
            controller.viewModel = $0.resolve(LoginViewModelProtocol.self)
            return controller
        }
    }
}
