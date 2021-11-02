import UIKit

enum Style {
    enum BaseColors {
        static let white = UIColor.white
        static let black = UIColor.black
        static let blue = UIColor.rgb(red: 29, green: 161, blue: 242)
    }

    enum Colors {
//        static var primary: UIColor { BaseColors.black }
//        static var secondary: UIColor { BaseColors.blue }

        static var primaryBG: UIColor { BaseColors.white }
        static var secondaryBG: UIColor { BaseColors.blue }
    }

    enum FontSizes {
        static var base: CGFloat { 16 }
        static var h1: CGFloat { 2.5 * base }
        static var h2: CGFloat { 2 * base }
        static var h3: CGFloat { 1.75 * base }
        static var h4: CGFloat { 1.5 * base }
        static var h5: CGFloat { 1.25 * base }
        static var h6: CGFloat { base }
    }

    enum Fonts {
        static var base: UIFont { .systemFont(ofSize: FontSizes.base) }
        static var h1: UIFont { .systemFont(ofSize: FontSizes.h1) }
        static var h2: UIFont { .systemFont(ofSize: FontSizes.h2) }
        static var h3: UIFont { .systemFont(ofSize: FontSizes.h3) }
        static var h4: UIFont { .systemFont(ofSize: FontSizes.h4) }
        static var h5: UIFont { .systemFont(ofSize: FontSizes.h5) }
        static var h6: UIFont { .systemFont(ofSize: FontSizes.h6) }
    }

    enum Spacers {
        private static let spacer: CGFloat = 8
        static var space0: CGFloat { 0 }
        static var space1: CGFloat { 1 * Spacers.spacer }
        static var space2: CGFloat { 2 * Spacers.spacer }
        static var space3: CGFloat { 3 * Spacers.spacer }
    }
}

extension Style {
    enum Buttons {
        enum BaseButton {
            static var backgroundColor: UIColor { BaseColors.white }
            static let borderRadius = CGFloat(5)
            static var color: UIColor { BaseColors.blue }
            static var font: UIFont { Fonts.h5 }
            static let height = CGFloat(50)
        }

        enum LinkButton {
            static var color: UIColor { BaseColors.white }
            static var font: UIFont { Fonts.base }
        }
    }
}

extension Style {
    enum TextFields {
        enum Base {
            static var color: UIColor { BaseColors.white }
            static var font: UIFont { Fonts.base }
            static var placeholderColor: UIColor { BaseColors.white }
        }
    }
}

extension Style {
    enum Views {
        enum ContainerFrom {
            static let imageSize = CGSize(width: 24, height: 24)
            static let height = 50
            static var dividerBackgroundColor: UIColor { BaseColors.white }
            static let dividerHeight = 0.75
        }
    }
}
