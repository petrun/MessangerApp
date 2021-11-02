// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  /// Already have an account?
  internal static let alreadyHaveAnAccountQuestionTitle = L10n.tr("Localizable", "already_have_an_account_question_title")
  /// Don't have an account?
  internal static let dontHaveAnAccountQuestionTitle = L10n.tr("Localizable", "dont_have_an_account_question_title")
  /// Email
  internal static let emailPlaceholder = L10n.tr("Localizable", "email_placeholder")
  /// Full Name
  internal static let fullNamePlaceholder = L10n.tr("Localizable", "full_name_placeholder")
  /// Login
  internal static let loginTitle = L10n.tr("Localizable", "login_title")
  /// Password
  internal static let passwordLabel = L10n.tr("Localizable", "password_label")
  /// Password
  internal static let passwordPlaceholder = L10n.tr("Localizable", "password_placeholder")
  /// Sign Up
  internal static let signUpTitle = L10n.tr("Localizable", "sign_up_title")
  /// Username
  internal static let usernamePlaceholder = L10n.tr("Localizable", "username_placeholder")
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
