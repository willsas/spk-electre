import UIKit

extension UITextField {
    func didChange(_ callback: @escaping (String) -> Void) {
        addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        objc_setAssociatedObject(
            self,
            &AssociatedKeys.textChangeCallback,
            callback,
            .OBJC_ASSOCIATION_RETAIN_NONATOMIC
        )
    }

    @objc
    private func textFieldDidChange(_ textField: UITextField) {
        if let callback = objc_getAssociatedObject(
            self,
            &AssociatedKeys.textChangeCallback
        ) as? ((String) -> Void) {
            callback(textField.text ?? "")
        }
    }
}

private struct AssociatedKeys {
    static var textChangeCallback: UInt8 = 0
}
