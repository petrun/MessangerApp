//
// https://github.com/twbs/bootstrap/blob/main/scss/_variables.scss
// https://betterprogramming.pub/organizing-your-swift-global-constants-for-beginners-251579485046
// https://cocoacasts.com/tips-and-tricks-managing-build-configurations-in-xocde
//
import UIKit

enum BaseColors {
    static let white = UIColor.white
    static let black = UIColor.black
    static let blue = UIColor(red: 29, green: 161, blue: 242)
}

enum Style {
    static var textColor: UIColor { BaseColors.black }
    static var backgroundColor: UIColor { BaseColors.white }
    static var buttonBackgroundColor: UIColor { Asset.backgroundColor.color }
    static var buttonTextColor: UIColor { BaseColors.white }

    private enum FontSizes {
        static var base: CGFloat { 15 }
        static var sub: CGFloat { 13 }
        static var mini: CGFloat { 10 }
        static var headingOne: CGFloat { 24 }
        static var headingTwo: CGFloat { 20 }
        static var headingThree: CGFloat { 17 }

        static var large: CGFloat { 17 }
    }

    enum Fonts {
        static var body: UIFont { .systemFont(ofSize: FontSizes.base) }
        static var bold: UIFont { .systemFont(ofSize: FontSizes.base, weight: .bold) }
        static var sub: UIFont { .systemFont(ofSize: FontSizes.sub) }
        static var mini: UIFont { .systemFont(ofSize: FontSizes.mini, weight: .medium) }
        static var headingOne: UIFont { .systemFont(ofSize: FontSizes.headingOne, weight: .semibold) }
        static var headingTwo: UIFont { .systemFont(ofSize: FontSizes.headingTwo, weight: .semibold) }
        static var headingThree: UIFont { .systemFont(ofSize: FontSizes.headingThree, weight: .semibold) }

        static var large: UIFont { .systemFont(ofSize: FontSizes.large) }
    }

    enum Spacers {
        private static let spacer: CGFloat = 8
        static var space0: CGFloat { 0 }
        static var space1: CGFloat { 1 * Spacers.spacer }
        static var space2: CGFloat { 2 * Spacers.spacer }
        static var space3: CGFloat { 3 * Spacers.spacer }
    }
}
