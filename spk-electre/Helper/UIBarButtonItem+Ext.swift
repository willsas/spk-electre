import UIKit

extension UIBarButtonItem {
    convenience init(title: String?, style: UIBarButtonItem.Style, actionClosure: (() -> Void)?) {
        self.init(title: title, style: style, target: nil, action: nil)
        if let action = actionClosure {
            self.actionClosure = action
            target = self
            self.action = #selector(barButtonAction(sender:))
        }
    }

    private struct AssociatedKeys {
        static var ActionClosure: UInt8 = 0
    }

    private var actionClosure: (() -> Void)? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.ActionClosure) as? () -> Void
        }
        set {
            objc_setAssociatedObject(
                self,
                &AssociatedKeys.ActionClosure,
                newValue,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }

    @objc
    func barButtonAction(sender: UIBarButtonItem) {
        actionClosure?()
    }
}
