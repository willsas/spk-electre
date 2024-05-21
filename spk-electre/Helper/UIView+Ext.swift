import UIKit

extension UIView {
    func addKeyboardDismissGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        tapGesture.cancelsTouchesInView = false
        addGestureRecognizer(tapGesture)
    }

    @objc private func handleTapGesture(_ sender: UITapGestureRecognizer) {
        endEditing(true)
    }
}
