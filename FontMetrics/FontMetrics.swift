import UIKit

/// Delegate protocol for `FontMetrics` to respond to updates in UIContentSizeCategory.
public protocol UIContentSizeCategoryDelegate: class {
    func contentSizeCategoryChanged()
}

/// Notification to use instead of UIContentSizeCategoryDidChange.
extension NSNotification.Name {
    public static let FontMetricsContentSizeCategoryDidChange: NSNotification.Name = Notification.Name("FontMetricsContentSizeCategoryDidChange")
}

/// A `UIFontMetrics` wrapper class, allowing iOS 11 devices to take advantage of `UIFontMetrics`
/// scaling, while earlier iOS versions fall back on a scale calculation. Optionally assignable
/// sizeCategory: UIContentSizeCategory to override the system Accessibility settings for unit
/// testing. Manually adjusting the accessibility dynamic text slider will reset the manually
/// assigned sizeCategory value.
///
public class FontMetrics {

    /// By declaring `default` as a static let, we will be able to use a globally consistent instance of
    /// `FontMetrics`. It behaves similarly to `NotificationCenter.default` or `UIDevice.current`.
    public static let `default` = FontMetrics()

    /// A delegate which will handle the change of the system's actual setting of Dynamic Type size.
    public weak var delegate: UIContentSizeCategoryDelegate?

    /// Initializer will take the system's `preferredContentSizeCategory` at startup if it is not provided.
    /// Therefore, `FontMetrics.default` will be initialized with the system's current Dynamic Type setting.
    public init(withSizeCategory sizeCategory: UIContentSizeCategory = UIScreen.main.traitCollection.preferredContentSizeCategory) {
        
        delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(uiContentSizeCategoryChanged),
                                               name: .UIContentSizeCategoryDidChange,
                                               object: nil)
        self.sizeCategory = sizeCategory
    }

    /// Public variable to hold preferred content size. Assigning a new value will post the
    /// FontMetricsContentSizeCategoryDidChange notification.
    public var sizeCategory: UIContentSizeCategory! = .small {
        didSet {
            NotificationCenter.default.post(Notification(name: .FontMetricsContentSizeCategoryDidChange))
        }
    }

    /// By using a delegate instead of directly changing the `sizeCategory` here, a user of `FontMetrics` can later
    /// define custom behavior when the system's Dynamic Type setting changes instead of being forced to change
    /// the class itself.
    @objc private func uiContentSizeCategoryChanged() {
        delegate?.contentSizeCategoryChanged()
    }

    /// A scale value based on the current device text size setting. With the device using the
    /// default Large setting, `scaler` will be `1.0`. Only used when `UIFontMetrics` is not
    /// available.
    private var scaler: CGFloat {
        return UIFont.preferredFont(forTextStyle: .body,
                                    compatibleWith: UITraitCollection(preferredContentSizeCategory: self.sizeCategory)).pointSize / 17.0
    }

    /// Returns a version of the specified font that adopts the current font metrics.
    ///
    /// - Parameter font: A font at its default point size.
    /// - Returns: The font at its scaled point size.
    ///
    public func scaledFont(for font: UIFont) -> UIFont {
        if #available(iOS 11.0, *) {
            return UIFontMetrics.default.scaledFont(for: font, compatibleWith: UITraitCollection(preferredContentSizeCategory: self.sizeCategory))
        } else {
            return font.withSize(scaler * font.pointSize)
        }
    }

    /// Returns a version of the specified font that adopts the current font metrics and is
    /// constrained to the specified maximum size.
    ///
    /// - Parameters:
    ///   - font: A font at its default point size.
    ///   - maximumPointSize: The maximum point size to scale up to.
    /// - Returns: The font at its constrained scaled point size.
    ///
    public func scaledFont(for font: UIFont, maximumPointSize: CGFloat) -> UIFont {
        if #available(iOS 11.0, *) {
            return UIFontMetrics.default.scaledFont(for: font,
                                                    maximumPointSize: maximumPointSize,
                                                    compatibleWith: UITraitCollection(preferredContentSizeCategory: self.sizeCategory))
        } else {
            return font.withSize(min(scaler * font.pointSize, maximumPointSize))
        }
    }

    /// Scales an arbitrary layout value based on the current Dynamic Type settings.
    ///
    /// - Parameter value: A default size value.
    /// - Returns: The value scaled based on current Dynamic Type settings.
    ///
    public func scaledValue(for value: CGFloat) -> CGFloat {
        if #available(iOS 11.0, *) {
            return UIFontMetrics.default.scaledValue(for: value, compatibleWith: UITraitCollection(preferredContentSizeCategory: self.sizeCategory))
        } else {
            return scaler * value
        }
    }
}

/// FontMetrics is its own delegate right now, but it can also be assigned another implementation of
/// UIContentSizeCategoryDelegate.
extension FontMetrics: UIContentSizeCategoryDelegate {
    public func contentSizeCategoryChanged() {
        /// Overwrite sizeCategory with the system's new setting
        self.sizeCategory = UIScreen.main.traitCollection.preferredContentSizeCategory
    }
}
