//
//  ChatsViewController.swift
//  MessangerApp
//
//  Created by andy on 08.11.2021.
//

import UIKit

private let chatCellIdentifier = "chatCellIdentifier"

private extension Style {
    enum ChatsViewController {
        static var cellHeight: CGFloat { 74 }
    }
}

class ChatsViewController: UITableViewController {
    // MARK: - Properties

    var viewModel: ChatsViewModelProtocol!

    // MARK: - Private properties

    private lazy var style = Style.ChatsViewController.self

    private lazy var searchController = UISearchController(searchResultsController: nil)
    private var isFiltering: Bool {
        searchController.isActive && !(searchController.searchBar.text?.isEmpty ?? true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = L10n.Chats.title

        view.backgroundColor = .systemGray5

        tableView.register(ChatTableViewCell.self, forCellReuseIdentifier: chatCellIdentifier)

        setupSearchController()

        viewModel.delegate = self
        viewModel.start()
    }

    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search chats"

        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension ChatsViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.count(isFiltering: isFiltering)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: chatCellIdentifier,
            for: indexPath
        ) as! ChatTableViewCell

        cell.configure(chat: viewModel.itemForRowAt(indexPath: indexPath, isFiltering: isFiltering))

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)

        viewModel.didSelectRowAt(indexPath: indexPath, isFiltering: isFiltering)
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        style.cellHeight
    }
}

// MARK: - ChatsViewModelDelegate

extension ChatsViewController: ChatsViewModelDelegate {
    func reloadData() {
        tableView.reloadData()
    }
}

// MARK: - UISearchResultsUpdating

extension ChatsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        print("CALL updateSearchResults: \(searchController.searchBar.text!)")
        viewModel.filterChats(searchText: searchController.searchBar.text!)
    }
}
