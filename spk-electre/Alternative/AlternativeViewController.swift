import UIKit

final class AlternativeViewController: UIViewController {

    @IBOutlet weak var currentDocumentButton: UIButton!
    @IBOutlet weak var uploadButton: UIButton!
    
    private let viewModel = AlternativeViewModel.make()
    private lazy var documentPicker = {
        let picker = DocumentPicker()
        picker.viewController = self
        picker.supportedTypes = [.commaSeparatedText]
        return picker
    }()

    private lazy var documentViewer = {
        let viewer = DocumentViewer()
        viewer.viewController = self
        return viewer
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Alternative"
        setupViewModel()
        addUserRightBarButtonItem()
        
        viewModel.checkUploadCapability()
        Task { [weak self] in await self?.viewModel.getAlternative() }
    }

    private func setupViewModel() {
        viewModel.onUploadSuccees = { [weak self] in
            self?.showAlert(title: "Upload file succeed")
        }
        viewModel.onErorr = { [weak self] error in
            self?.showAlert(title: "Failed to upload", message: error)
        }
        viewModel.onShowLoading = { [weak self] isLoading in
            if isLoading {
                self?.showLoadingIndicator()
            } else {
                self?.dismissLoadingIndicator()
            }
        }
        viewModel.onSavedFileName = { [weak self] fileName in
            if let fileName {
                self?.currentDocumentButton.setTitle(fileName, for: .normal)
                self?.currentDocumentButton.isEnabled = true
            } else {
                self?.currentDocumentButton.setTitle("Empty", for: .normal)
                self?.currentDocumentButton.isEnabled = false
            }
        }
        viewModel.onShowDocument = { [weak self] in self?.documentViewer.showDocument(with: $0) }
        viewModel.onUploadEnabled = { [weak self] in self?.uploadButton.isEnabled = $0 }
    }

    @IBAction
    func uploadButtonDidTapped(_ sender: Any) {
        documentPicker.pickDocument { [weak self] url in
            guard let url else { return }
            Task { await self?.viewModel.upload(url) }
        }
    }

    @IBAction
    func currentDocumentButtonDidTapped(_ sender: Any) {
        Task { [weak self] in await self?.viewModel.showAlternative() }
    }

    @IBAction
    func downloadTemplateButtonDidTapped(_ sender: Any) {
        Task { [weak self] in await self?.viewModel.showTemplate() }
    }
}
