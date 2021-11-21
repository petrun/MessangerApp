import Swinject

extension Assembler {
    static let sharedAssembler = Assembler(
        [
            ServicesAssembly(),

            ChatAssembly(),
            LoginAssembly(),
            RegistrationAssembly(),
            ProfileAssembly(),

            // Tabs
            ChatsAssembly(),
            UsersAssembly(),
            SettingsAssembly()
        ],
        container: Container()
    )
}
