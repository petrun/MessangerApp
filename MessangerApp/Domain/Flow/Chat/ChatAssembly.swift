//
//  ChatAssembly.swift
//  MessangerApp
//
//  Created by andy on 07.11.2021.
//

import Swinject
import SwinjectAutoregistration

class ChatAssembly: Assembly {
    func assemble(container: Container) {
        container.register(ChatViewModelProtocol.self) { (r: Resolver, chat: Chat) in
            ChatViewModel(
                chat: chat,
                messageStorage: r.resolve(MessageStorageProtocol.self)!,
                typingService: r.resolve(TypingServiceProtocol.self)!,
                sendMessageHandler: r.resolve(SendMessageHandlerProtocol.self)!,
                userSession: r.resolve(UserSessionProtocol.self)!
            )
        }

        container.register(ChatViewController.self) { (r: Resolver, chat: Chat) in
            let controller = ChatViewController()
            controller.viewModel = r.resolve(ChatViewModelProtocol.self, argument: chat)

            return controller
        }
    }
}
