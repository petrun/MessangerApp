//
//  UsersViewController.swift
//  MessangerApp
//
//  Created by andy on 12.11.2021.
//

import UIKit

private let userCellIdentifier = "userCellIdentifier"

class UsersViewController: UITableViewController {
    // MARK: - Properties

    var viewModel: UsersViewModelProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = L10n.Users.title

        tableView.register(UserTableViewCell.self, forCellReuseIdentifier: userCellIdentifier)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 65, bottom: 0, right: 0)

        viewModel.delegate = self
        viewModel.loadUsers()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension UsersViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.count()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: userCellIdentifier,
            for: indexPath
        ) as! UserTableViewCell
        let user = viewModel.itemForRowAt(indexPath: indexPath)
        cell.configure(user: user)

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)

        viewModel.didSelectRowAt(indexPath: indexPath)
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
}

// MARK: - UsersViewModelDelegate

extension UsersViewController: UsersViewModelDelegate {
    func reloadData() {
        tableView.reloadData()
    }
}
