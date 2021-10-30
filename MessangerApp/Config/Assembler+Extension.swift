import Swinject

extension Assembler {
    static let sharedAssembler: Assembler = Assembler([
        ServicesAssembly(),
        LoginAssembly(),
    ], container: Container())
}
