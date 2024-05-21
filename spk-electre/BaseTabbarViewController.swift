import UIKit

final class BaseTabbarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [
            makeHomeViewController(),
            makeCriteriaViewController(),
            makeAlternativeViewController(),
            makeResultViewController()
        ]
    }

    private func makeHomeViewController() -> UIViewController {
        let nav = UINavigationController(rootViewController: HomeViewController())
        nav.tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(systemName: "house.fill"),
            selectedImage: nil
        )
        return nav
    }
    
    private func makeCriteriaViewController() -> UIViewController {
        let nav = UINavigationController(rootViewController: CriteriaViewController())
        nav.tabBarItem = UITabBarItem(
            title: "Criteria",
            image: UIImage(systemName: "newspaper.fill"),
            selectedImage: nil
        )
        return nav
    }
    
    private func makeAlternativeViewController() -> UIViewController {
        let nav = UINavigationController(rootViewController: AlternativeViewController())
        nav.tabBarItem = UITabBarItem(
            title: "Alternative",
            image: UIImage(systemName: "list.bullet.rectangle.fill"),
            selectedImage: nil
        )
        return nav
    }
    
    private func makeResultViewController() -> UIViewController {
        let nav = UINavigationController(rootViewController: ResultViewController())
        nav.tabBarItem = UITabBarItem(
            title: "Result",
            image: UIImage(systemName: "person.3.sequence.fill"),
            selectedImage: nil
        )
        return nav
    }
}
