import UIKit

final class UserViewController: UIViewController {

    @IBOutlet weak var nameValueLabel: UILabel!
    @IBOutlet weak var emailValueLabel: UILabel!
    @IBOutlet weak var roleLabelValue: UILabel!

    private let viewModel = UserViewModel.make()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "User"
        addCancelLeftBarButtonItem()
        setupViewModel()
        viewModel.loadUser()
    }

    private func setupViewModel() {
        viewModel.onUserUpdate = { [weak self] user in
            self?.nameValueLabel.text = user.name
            self?.emailValueLabel.text = user.email
            self?.roleLabelValue.text = user.role
        }

        viewModel.onLogoutSucceed = { [weak self] in self?.switchToLogin() }
        viewModel.onError = { [weak self] in self?.showAlert(title: $0) }
    }

    @IBAction
    func logoutButtonDidTapped(_ sender: Any) {
        viewModel.doLogout()
    }

    private func switchToLogin() {
        let nav = UINavigationController(rootViewController: LoginViewController())
        switchToRootViewController(with: nav)
    }
}
