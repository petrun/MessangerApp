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
        title = "Users"

//        view.backgroundColor = .yellow

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

//        cell.textLabel?.text = user.name
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

extension UsersViewController {
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let y = scrollView.contentOffset.y
        let h = scrollView.contentSize.height
        let s = scrollView.frame.size.height
        print("y=\(y) h=\(h) s=\(s) \(y + s)")
        if y > h / 1.1 {
            print("scroll")
        }
    }
//    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let position = scrollView.contentOffset.y
//        let contentSizeHeight = tableView.contentSize.height
//        let scrollHeight = scrollView.frame.size.height
////        print("contentSizeHeight = \(contentSizeHeight) scrollHeight = \(scrollHeight) position = \(position)")
//        guard position > contentSizeHeight - 100 - scrollHeight else {
//            return
//        }
//        print(position)
//        //fetchData pagination = true
//    }
}
