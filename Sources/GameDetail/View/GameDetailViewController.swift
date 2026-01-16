//
//  GameDetailViewController.swift
//  game-catalogue-uikit
//
//  Created by Ade Dwi Prayitno on 21/11/25.
//

import Common
import Core
import UIKit

@MainActor
public final class GameDetailViewController: UIViewController {

    enum PageSection: Int, CaseIterable {
        case header, rating, description
    }

    private let presenter: GameDetailPresenter

    private let tableView = UITableView()

    public init(presenter: GameDetailPresenter, game: Game) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        presenter.view = self
        presenter.setInitialGame(game)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        presenter.fetchGameDetail()
    }

    public override var prefersStatusBarHidden: Bool { true }

    private func setupView() {
        navigationController?.navigationBar.prefersLargeTitles = false

        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension

        tableView.register(
            GameDetailHeaderTableViewCell.self,
            forCellReuseIdentifier: GameDetailHeaderTableViewCell.name
        )
        tableView.register(
            GameDetailRatingTableViewCell.self,
            forCellReuseIdentifier: GameDetailRatingTableViewCell.name
        )
        tableView.register(
            GameDetailDescriptionTableViewCell.self,
            forCellReuseIdentifier: GameDetailDescriptionTableViewCell.name
        )

        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(
                equalTo: view.topAnchor,
                constant: -120
            ),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

extension GameDetailViewController: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        PageSection.allCases.count
    }

    public func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int { 1 }

    public func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {

        switch PageSection(rawValue: indexPath.section) {

        case .header:
            let cell =
                tableView.dequeueReusableCell(
                    withIdentifier: GameDetailHeaderTableViewCell.name,
                    for: indexPath
                ) as? GameDetailHeaderTableViewCell
            cell?.configure(data: presenter.game)
            return cell ?? UITableViewCell()

        case .rating:
            let cell =
                tableView.dequeueReusableCell(
                    withIdentifier: GameDetailRatingTableViewCell.name,
                    for: indexPath
                ) as? GameDetailRatingTableViewCell
            cell?.configure(
                data: presenter.game,
                isFavorited: presenter.isFavorited
            ) { [weak self] in
                self?.presenter.toggleFavorite()
            }
            return cell ?? UITableViewCell()

        case .description:
            let cell =
                tableView.dequeueReusableCell(
                    withIdentifier: GameDetailDescriptionTableViewCell.name,
                    for: indexPath
                ) as? GameDetailDescriptionTableViewCell
            cell?.configure(data: presenter.game)
            return cell ?? UITableViewCell()

        default:
            return UITableViewCell()
        }
    }
}

extension GameDetailViewController: UITableViewDelegate {
    public func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        switch PageSection(rawValue: indexPath.section) {
        case .header:
            return 350
        case .rating:
            return 80
        case .description:
            return UITableView.automaticDimension
        default:
            return 44
        }
    }
}

extension GameDetailViewController: GameDetailViewProtocol {
    public func showLoading(_ isLoading: Bool) {
        if isLoading {
            showSpinner()
        } else {
            hideSpinner()
        }
    }

    public func render(game: Game?, isFavorited: Bool) {
        tableView.reloadData()
    }

    public func showError(message: String) {
        let alert = UIAlertController(
            title: "error_title".localized,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(.init(title: "ok_action".localized, style: .default))
        present(alert, animated: true)
    }
}
