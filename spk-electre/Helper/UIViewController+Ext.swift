import UIKit

extension UIViewController {
    func showAlert(
        title: String? = nil,
        message: String? = nil,
        preferredStyle: UIAlertController.Style = .alert,
        actions: [UIAlertAction] = [UIAlertAction(title: "OK", style: .default, handler: nil)]
    ) {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: preferredStyle
        )
        actions.forEach { alertController.addAction($0) }
        present(alertController, animated: true, completion: nil)
    }

    func switchToRootViewController(with newViewController: UIViewController) {
        guard let window = currentWindow() else { return }

        UIView.transition(
            with: window,
            duration: 0.3,
            options: .transitionCrossDissolve,
            animations: nil,
            completion: nil
        )
        window.rootViewController = newViewController
    }

    func currentWindow() -> UIWindow? {
        var window: UIWindow?
        if #available(iOS 13.0, *) {
            for scene in UIApplication.shared.connectedScenes {
                if let windowScene = scene as? UIWindowScene {
                    window = windowScene.keyWindow
                    break
                }
            }
        } else {
            window = UIApplication.shared.keyWindow
        }
        return window
    }

    func addUserRightBarButtonItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "User",
            style: .plain,
            actionClosure: { [weak self] in self?.presentToUserViewController() }
        )
    }

    func addCancelLeftBarButtonItem() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Cancel",
            style: .plain,
            actionClosure: { [weak self] in self?.dismiss(animated: true) }
        )
    }

    private func presentToUserViewController() {
        present(UINavigationController(rootViewController: UserViewController()), animated: true)
    }

    func showLoadingIndicator() {
        let backgroundView = UIView(frame: view.bounds)
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.25)
        backgroundView.tag = 69
        view.addSubview(backgroundView)

        backgroundView.addSubview(ProgressHUD(text: "Loading..."))
    }

    func dismissLoadingIndicator() {
        for subview in view.subviews {
            if subview.tag == 69 {
                subview.removeFromSuperview()
                break
            }
        }
    }
}
