//
//  ChatsViewController.swift
//  MessangerApp
//
//  Created by andy on 08.11.2021.
//

import UIKit

private let chatCellIdentifier = "chatCellIdentifier"

class ChatsViewController: UITableViewController {
    // MARK: - Properties

    var viewModel: ChatsViewModelProtocol!

    private var users: [User] = [] {
        didSet {
            tableView.reloadData()
        }
    }
//    private let chat: Chat

    override func viewDidLoad() {
        super.viewDidLoad()
//        title = "Chats"

        view.backgroundColor = .systemGray5

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: chatCellIdentifier)

//        let userStorage = UserStorage()
//        userStorage.getPage(lastSnapshot: nil) { result in
//            switch result {
//            case .success(let users):
//                self.users = users
//                print("success")
//            case .failure(let error):
//                print("failure")
//                print(error)
//            }
//        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: chatCellIdentifier,
            for: indexPath
        ) as! UITableViewCell
        let user = users[indexPath.row]

        cell.textLabel?.text = user.name
        return cell
    }
}
