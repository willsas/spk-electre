import UIKit

final class RegisterViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var roleSegmentedControl: UISegmentedControl! {
        didSet {
            guard let role = roleSegmentedControl.selectedSegmentIndex.asRole else { return }
            viewModel.role = role
        }
    }
    
    private let viewModel = RegisterViewModel.make()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Register"
        setupComponentObserver()
        setupViewModel()
        view.addKeyboardDismissGesture()
    }
    
    private func setupViewModel() {
        viewModel.showError = { [weak self] error in
            self?.showAlert(title: error)
        }
        
        viewModel.successRegister = { [weak self] in
            self?.switchToRootViewController(with: BaseTabbarViewController())
        }
    }
    
    private func setupComponentObserver() {
        emailTextField.didChange { [weak self] in
            self?.viewModel.email = $0
        }
        nameTextField.didChange { [weak self] in
            self?.viewModel.name = $0
        }
        passwordTextField.didChange { [weak self] in
            self?.viewModel.password = $0
        }
        roleSegmentedControl.selectedIndexChanged = { [weak self] in
            guard let role = $0.asRole else { return }
            self?.viewModel.role = role
        }
    }

    @IBAction func registerButtonDidTapped(_ sender: Any) {
        Task { [weak self] in
            await self?.viewModel.registerUser()
        }
    }
    
    private func changeRootToHome() {
        
    }
}

extension Int {
    var asRole: String? {
        switch self {
        case 0: return "admin"
        case 1: return "visitor"
        default: return nil
        }
    }
}
