import MobileCoreServices
import UIKit
import UniformTypeIdentifiers

final class DocumentPicker: NSObject {
    
    weak var viewController: UIViewController?
    var supportedTypes: [UTType] = [.commaSeparatedText]

    private var onGetURL: ((URL?) -> Void)?
    private var documentPicker: UIDocumentPickerViewController?
    
    func pickDocument(onGetURL: @escaping (URL?) -> Void) {
        self.onGetURL = onGetURL
        documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: supportedTypes)
        documentPicker?.delegate = self
        viewController?.present(documentPicker!, animated: true)
    }
}

extension DocumentPicker: UIDocumentPickerDelegate {

    func documentPicker(
        _ controller: UIDocumentPickerViewController,
        didPickDocumentsAt urls: [URL]
    ) {
        guard let url = urls.first else { return }
        onGetURL?(url)
    }

    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {}
}
