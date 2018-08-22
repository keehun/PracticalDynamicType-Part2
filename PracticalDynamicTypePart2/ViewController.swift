import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let hal9000 = Hal9000(frame: .zero)
        hal9000.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(hal9000)

        NSLayoutConstraint.activate([
            hal9000.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            hal9000.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            hal9000.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            hal9000.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            ])
    }
}

