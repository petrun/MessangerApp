import Swinject

extension Assembler {
    static let sharedAssembler = Assembler(
        [
            ServicesAssembly(),

            ChatAssembly(),
            CompleteProfileAssembly(),
            LoginAssembly(),
            RegistrationAssembly(),
            EditProfileAssembly(),

            // Tabs
            ChatsAssembly(),
            UsersAssembly(),
            SettingsAssembly()
        ],
        container: Container()
    )
}
