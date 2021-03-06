import Swinject
import SwinjectAutoregistration
import SwiftyBeaver

class ServicesAssembly: Assembly {
    func assemble(container: Container) {
        // AuthService
        container.autoregister(AuthServiceProtocol.self, initializer: AuthService.init)
        .inObjectScope(ObjectScope.container)

        // ChatStorage
        container.autoregister(ChatStorageProtocol.self, initializer: ChatStorage.init)
        .inObjectScope(ObjectScope.container)

        // FileStorage
        container.autoregister(FileStorageProtocol.self, initializer: FileStorage.init)
        .inObjectScope(ObjectScope.container)

        // FirebaseFirestoreWrapperProtocol
        container.autoregister(FirebaseFirestoreWrapperProtocol.self, initializer: FirebaseFirestoreWrapper.init)
        .inObjectScope(ObjectScope.container)

        // Logger
        container.register(LoggerService.self) {_ in
            let console = ConsoleDestination()
//            console.format = "$DHH:mm:ss.SSS$d $L [$N.$F:$l] $M $X"
            console.format = "$L $M $X [$N.$F:$l]"

            console.levelString.verbose = "đˇ"
            console.levelString.debug = "đ ī¸"
            console.levelString.info = "âšī¸"
            console.levelString.warning = "â ī¸"
            console.levelString.error = "đĨ"

            return SwiftyBeaverLoggerService(destinations: [console])
        }
        .inObjectScope(ObjectScope.container)

        // MessageStorage
        container.autoregister(MessageStorageProtocol.self, initializer: MessageStorage.init)
        .inObjectScope(ObjectScope.container)

        // RouterFactory
        container.autoregister(RouterFactoryProtocol.self, initializer: RouterFactory.init)
        .inObjectScope(ObjectScope.container)

        // SendMessageHandler
        container.autoregister(SendMessageHandlerProtocol.self, initializer: SendMessageHandler.init)
        .inObjectScope(ObjectScope.container)

        // TypingService
        container.autoregister(TypingServiceProtocol.self, initializer: TypingService.init)
        .inObjectScope(ObjectScope.container)

        // EditProfileHandlerProtocol
        container.autoregister(EditProfileHandlerProtocol.self, initializer: EditProfileHandler.init)
        .inObjectScope(ObjectScope.container)

        // UploadVideoHandlerProtocol
        container.autoregister(UploadVideoHandlerProtocol.self, initializer: UploadVideoHandler.init)
        .inObjectScope(ObjectScope.container)

        // UserProfile
        container.register(UserProfileProtocol.self) {
            UserProfile(
                cache: Cache(),
                userStorage: $0.resolve(UserStorageProtocol.self)!
            )
        }

        // UserSessionProtocol
        container.autoregister(UserSessionProtocol.self, initializer: UserSession.init)
        .inObjectScope(ObjectScope.container)

        // UserStorage
        container.autoregister(UserStorageProtocol.self, initializer: UserStorage.init)
        .inObjectScope(ObjectScope.container)

        // DataMappers

        container.autoregister(ChatDataMapper.self, initializer: ChatDataMapper.init)
        .inObjectScope(ObjectScope.container)

        container.autoregister(MessageDataMapper.self, initializer: MessageDataMapper.init)
        .inObjectScope(ObjectScope.container)
    }
}
