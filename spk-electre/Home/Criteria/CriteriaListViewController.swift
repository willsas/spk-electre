import UIKit

final class CriteriaListViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    private let viewModel = CriteriaListViewModel.make()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "List Kriteria"
        setupTableView()
        setupViewModel()
        
        searchBar.textDidChange { [weak self] in self?.viewModel.search(name: $0) }
        
        Task { [weak self] in await self?.viewModel.fetch() }
    }
    
    private func setupViewModel() {
        viewModel.onReload = { [weak self] in self?.tableView.reloadData() }
    }
    
    private func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell-id")
        tableView.dataSource = self
    }
}

extension CriteriaListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.criterions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell-id", for: indexPath)
        let criterion = viewModel.criterions[indexPath.row]
        
        var config = cell.defaultContentConfiguration()
        config.text = "\(criterion.name) (\(criterion.code))"
        config.secondaryText = "Bobot: \(criterion.weight)"
        
        cell.contentConfiguration = config
        return cell
    }
}
