import QuickLook
import UIKit

final class DocumentViewer {

    private var filePath: URL?
    weak var viewController: UIViewController?

    func showDocument(with filePath: URL) {
        self.filePath = filePath
        let previewController = QLPreviewController()
        previewController.dataSource = self
        previewController.currentPreviewItemIndex = 0
        viewController?.present(previewController, animated: true)
    }
}

extension DocumentViewer: QLPreviewControllerDataSource {

    func numberOfPreviewItems(in controller: QLPreviewController) -> Int { 1 }
    func previewController(
        _ controller: QLPreviewController,
        previewItemAt index: Int
    ) -> QLPreviewItem {
        guard let url = filePath else { fatalError() }
        return url as QLPreviewItem
    }
}
