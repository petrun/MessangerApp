import Then
import UIKit

private extension Style {
    enum SettingsViewController {
        static var backgroundColor: UIColor { Style.backgroundColor2 }
        static var heightForHeaderInSection: CGFloat { 35 }
    }
}

private let settingsBaseCellIdentifier = "settingsBaseCellIdentifier"
private let settingsProfileItemCellIdentifier = "settingsProfileItemCellIdentifier"

class SettingsViewController: UIViewController {
    // MARK: - Properties

    var viewModel: SettingsViewModelProtocol!

    private lazy var tableView = UITableView()
    private let style = Style.SettingsViewController.self

    override func viewDidLoad() {
        super.viewDidLoad()

        title = L10n.Settings.title
        view.backgroundColor = style.backgroundColor

//        navigationController?.navigationBar.prefersLargeTitles = true
//        navigationItem.largeTitleDisplayMode = .always

        configureTableView()
    }

    private func configureTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: settingsBaseCellIdentifier)
        tableView.register(
            SettingsProfileItemTableViewCell.self,
            forCellReuseIdentifier: settingsProfileItemCellIdentifier
        )

        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = style.backgroundColor

        view.addSubview(tableView)

        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
    }
}

// MARK: - UITableViewDelegate/UITableViewDelegate

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRowsInSection(section: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = viewModel.item(for: indexPath)

        switch item {
        case .profile:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: settingsProfileItemCellIdentifier,
                for: indexPath
            ) as! SettingsProfileItemTableViewCell

            cell.profileImageView.image = Asset.plusPhoto.image
            cell.usernameLabel.text = "Username"
            cell.descriptionLabel.text = "Description"
            return cell
        case .link:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: settingsBaseCellIdentifier,
                for: indexPath
            )

            cell.textLabel?.text = "link"
            cell.accessoryType = .disclosureIndicator
            return cell
        case .logout:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: settingsBaseCellIdentifier,
                for: indexPath
            )

            cell.textLabel?.textAlignment = .center
            cell.textLabel?.text = "Logout"
            cell.textLabel?.textColor = .red
            return cell
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.numberOfSections()
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        section == 0 ? 0 : style.heightForHeaderInSection
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        UIView().then { $0.backgroundColor = style.backgroundColor }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)

        viewModel.didSelectRowAt(indexPath: indexPath)

//        tableView.deselectRow(at: indexPath, animated: false)
//        guard indexPath.row == 1 else { return }
//        let vc = UIViewController()
//        navigationController?.pushViewController(vc, animated: true)

//        print("Select row \(indexPath.row)")
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        viewModel.item(for: indexPath) == .profile ? 80 : 47
    }
}
