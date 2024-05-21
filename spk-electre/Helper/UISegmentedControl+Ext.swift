import UIKit

extension UISegmentedControl {
    typealias ValueChangeCallback = (Int) -> Void

    private struct AssociatedKeys {
        static var valueChangeCallback: UInt8 = 0
    }

    var selectedIndexChanged: ValueChangeCallback? {
        get {
            return objc_getAssociatedObject(
                self,
                &AssociatedKeys.valueChangeCallback
            ) as? ValueChangeCallback
        }
        set {
            objc_setAssociatedObject(
                self,
                &AssociatedKeys.valueChangeCallback,
                newValue,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
            addTarget(self, action: #selector(valueChanged), for: .valueChanged)
        }
    }

    @objc
    private func valueChanged() {
        selectedIndexChanged?(selectedSegmentIndex)
    }
}
