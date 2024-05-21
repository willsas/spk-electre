import FirebaseCore
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        FirebaseApp.configure()
        setInitialViewController()
        return true
    }

    private func setInitialViewController() {
        window = UIWindow(frame: UIScreen.main.bounds)

        var initialViewController: UIViewController = BaseTabbarViewController()
        
        if !isLoggedIn() {
            let nav = UINavigationController()
            nav.viewControllers = [LoginViewController()]
            initialViewController = nav
        }

        window?.rootViewController = initialViewController
        window?.makeKeyAndVisible()
    }

    private func isLoggedIn() -> Bool {
        GetUser.user() != nil
    }
}
