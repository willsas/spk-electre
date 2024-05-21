import UIKit

@MainActor
final class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    private let viewModel = LoginViewModel.make()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Login"
        setupComponentObserver()
        setupViewModel()
        view.addKeyboardDismissGesture()
    }

    @IBAction
    func loginDidTapped(_ sender: Any) {
        Task { await viewModel.loginUser() }
    }
    @IBAction func registerDidTapped(_ sender: Any) {
        navigationController?.pushViewController(RegisterViewController(), animated: true)
    }
    
    private func setupComponentObserver() {
        emailTextField.didChange { [weak self] in
            self?.viewModel.email = $0
        }
        passwordTextField.didChange { [weak self] in
            self?.viewModel.password = $0
        }
    }

    private func setupViewModel() {
        viewModel.showError = { [weak self] error in
            self?.showAlert(title: error)
        }

        viewModel.successLogin = { [weak self] in
            self?.switchToRootViewController(with: BaseTabbarViewController())
        }
    }
}
