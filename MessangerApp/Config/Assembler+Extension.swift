import Swinject

extension Assembler {
    static let sharedAssembler = Assembler(
        [
            ServicesAssembly(),
            LoginAssembly(),
            RegistrationAssembly()
        ],
        container: Container()
    )
}
