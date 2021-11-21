//
//  InputBarAccessoryViewDelegate.swift
//  MessangerApp
//
//  Created by andy on 18.11.2021.
//

import InputBarAccessoryView
import MessageKit

extension ChatViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        for component in inputBar.inputTextView.components {
            switch component {
            case let text as String:
                viewModel.sendMessage(kind: .text(text))
            default:
                print("Unknown component type", component)
            }
        }

        inputBar.inputTextView.text = ""
        inputBar.invalidatePlugins()
    }


    func inputBar(_ inputBar: InputBarAccessoryView, textViewTextDidChangeTo text: String) {
        if !text.isEmpty {
            print("typing")
            viewModel.isTyping()
        }

        updateMicButtonStatus(show: text.isEmpty)
    }
}
