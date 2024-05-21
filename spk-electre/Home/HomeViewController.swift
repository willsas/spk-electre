import UIKit

final class HomeViewController: UIViewController {

    @IBOutlet weak var seeAllAlternative: UIButton!
    @IBOutlet weak var seeAllCriteria: UIButton!

    private let viewModel = HomeViewModel.make()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        addUserRightBarButtonItem()
        setupViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task { [weak self] in await self?.viewModel.fetchAll() }
    }
    
    @IBAction func alternativeButtonTapped(_ sender: Any) {
        let vc = AlternativeListViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func criteriaButtonTapped(_ sender: Any) {
        let vc = CriteriaListViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func setupViewModel() {
        viewModel
            .onUpdateAlternativeTitle = { [weak self] in
                self?.seeAllAlternative.setTitle($0, for: .normal)
            }
        viewModel
            .onUpdateCriteriaTitle = { [weak self] in
                self?.seeAllCriteria.setTitle($0, for: .normal)
            }
    }
}
