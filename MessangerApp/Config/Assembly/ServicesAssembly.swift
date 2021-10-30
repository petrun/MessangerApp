import Swinject
import SwinjectAutoregistration

class ServicesAssembly: Assembly {
    func assemble(container: Container) {
        container.autoregister(RouterFactoryProtocol.self, initializer: RouterFactory.init).inObjectScope(ObjectScope.container)
    }
}
