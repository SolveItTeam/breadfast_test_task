import UIKit

public extension UIViewController {
    func showErrorAlert(message: String) {
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
}
