import Swinject
import SwinjectAutoregistration
import SwiftyBeaver

class ServicesAssembly: Assembly {
    func assemble(container: Container) {
        container.autoregister(
            RouterFactoryProtocol.self,
            initializer: RouterFactory.init
        )
        .inObjectScope(ObjectScope.container)

        container.autoregister(
            AuthServiceProtocol.self,
            initializer: AuthService.init
        )
        .inObjectScope(ObjectScope.container)

        container.register(LoggerService.self) {_ in
            let console = ConsoleDestination()
            console.format = "$DHH:mm:ss.SSS$d $L [$N.$F:$l] $M $X"

            console.levelString.verbose = "🐷"
            console.levelString.debug = "🛠️"
            console.levelString.info = "ℹ️"
            console.levelString.warning = "⚠️"
            console.levelString.error = "💥"

            return SwiftyBeaverLoggerService(destinations: [console])
        }
        .inObjectScope(ObjectScope.container)
    }
}
