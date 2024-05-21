import UIKit

private var searchBarTextChangedClosureKey: UInt8 = 0

extension UISearchBar {
    typealias TextChangedCallback = (String) -> Void
    private var textChangedClosure: TextChangedCallback? {
        get {
            return objc_getAssociatedObject(
                self,
                &searchBarTextChangedClosureKey
            ) as? TextChangedCallback
        }
        set {
            objc_setAssociatedObject(
                self,
                &searchBarTextChangedClosureKey,
                newValue,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }

    func textDidChange(_ callback: @escaping TextChangedCallback) {
        textChangedClosure = callback
        delegate = self
    }
}

// Conform to UISearchBarDelegate to handle text changes
extension UISearchBar: UISearchBarDelegate {
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        textChangedClosure?(searchText)
    }
}
