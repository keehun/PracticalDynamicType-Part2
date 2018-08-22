import Foundation
import UIKit

class Hal9000: UIView {
    let font: UIFont = UIFont(name: "GillSans-Light", size: 36.0)!

    lazy var dialog: UILabel = {
        let label = UILabel()
        label.font = FontMetrics.default.scaledFont(for: self.font)
        label.text = "I'm sorry, Dave. I'm afraid I can't do that."
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(dialog)
        NSLayoutConstraint.activate([
            dialog.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            dialog.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            dialog.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            dialog.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            ])

        NotificationCenter.default.addObserver(self, selector: #selector(contentSizeCategoryChanged),
                                               name: Notification.Name.FontMetricsContentSizeCategoryDidChange,
                                               object: nil)
    }

    @objc func contentSizeCategoryChanged() {
        dialog.font = FontMetrics.default.scaledFont(for: self.font)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not implemented for this article.")
    }
}

///
///
/// Hal9000 class compatible with the original `FontMetrics` wrappe
///
///

/***
class Hal9000Before: UIView {
    let staticFont: UIFont = UIFont(name: "GillSans-Light", size: 36.0)!

    lazy var dialog: UILabel = {
        let label = UILabel()
        label.font = FontMetrics().scaledFont(for: staticFont)
        label.text = "I'm sorry, Dave. I'm afraid I can't do that."
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(dialog)
        NSLayoutConstraint.activate([
            dialog.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            dialog.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            dialog.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            dialog.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            ])
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not implemented for this article.")
    }
}
***/
