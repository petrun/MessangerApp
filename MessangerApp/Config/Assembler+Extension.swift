import Swinject

extension Assembler {
    static let sharedAssembler: Assembler = Assembler([
        ServicesAssembly(),
        LoginAssembly(),
        RegistrationAssembly(),
    ], container: Container())
}
