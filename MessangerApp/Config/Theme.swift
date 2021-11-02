import UIKit

protocol Theme {
    var textColor: UIColor { get }
    var backgroundColor: UIColor { get }
    var buttonBackgroundColor: UIColor { get }
    var buttonTextColor: UIColor { get }
}

struct PrimaryTheme: Theme {
    var textColor: UIColor { BaseColors.black }
    var backgroundColor: UIColor { BaseColors.white }
    var buttonBackgroundColor: UIColor { BaseColors.blue }
    var buttonTextColor: UIColor { BaseColors.white }
}

struct LoginTheme: Theme {
    var textColor: UIColor { BaseColors.white }
    var backgroundColor: UIColor { BaseColors.blue }
    var buttonBackgroundColor: UIColor { BaseColors.white }
    var buttonTextColor: UIColor { BaseColors.blue }
}
