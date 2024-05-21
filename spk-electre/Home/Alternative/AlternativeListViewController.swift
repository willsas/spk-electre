import UIKit

final class AlternativeListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    private let viewModel = AlternativeListViewModel.make()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "List Alternative"
        setupTableView()
        setupViewModel()
        searchBar.textDidChange { [weak self] in self?.viewModel.search(name: $0) }
        
        Task { [weak self] in await self?.viewModel.fetch() }
    }

    private func setupViewModel() {
        viewModel.onReload = { [weak self] in self?.tableView.reloadData() }
    }

    private func setupTableView() {
        tableView.register(
            .init(nibName: String(describing: AlternativeTableViewCell.self), bundle: nil),
            forCellReuseIdentifier: "cell"
        )
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension AlternativeListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.alternatives.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView
            .dequeueReusableCell(
                withIdentifier: "cell",
                for: indexPath
            ) as? AlternativeTableViewCell
        else { return UITableViewCell() }

        let alternative = viewModel.alternatives[indexPath.row]
        cell.setup(name: alternative.name, criteria: alternative.criteria)

        return cell
    }
}
