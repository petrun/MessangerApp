import Swinject

extension Assembler {
    static let sharedAssembler = Assembler(
        [
            ChatAssembly(),
            ServicesAssembly(),
            LoginAssembly(),
            RegistrationAssembly(),
            ChatsAssembly()
        ],
        container: Container()
    )
}
