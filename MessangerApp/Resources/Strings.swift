// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {

  internal enum Chats {
    /// Chats
    internal static let title = L10n.tr("Localizable", "chats.title")
  }

  internal enum DontHaveAnAccountQuestion {
    /// Don't have an account?
    internal static let title = L10n.tr("Localizable", "dont_have_an_account_question.title")
  }

  internal enum Email {
    /// Email
    internal static let placeholder = L10n.tr("Localizable", "email.placeholder")
  }

  internal enum FullName {
    /// Full Name
    internal static let placeholder = L10n.tr("Localizable", "full_name.placeholder")
  }

  internal enum Groups {
    /// Groups
    internal static let title = L10n.tr("Localizable", "groups.title")
  }

  internal enum IHaveAnAccount {
    /// I have an account
    internal static let title = L10n.tr("Localizable", "i_have_an_account.title")
  }

  internal enum Login {
    /// Login
    internal static let title = L10n.tr("Localizable", "login.title")
  }

  internal enum Password {
    /// Password
    internal static let label = L10n.tr("Localizable", "password.label")
    /// Password
    internal static let placeholder = L10n.tr("Localizable", "password.placeholder")
  }

  internal enum Settings {
    /// Settings
    internal static let title = L10n.tr("Localizable", "settings.title")
  }

  internal enum SignUp {
    /// Sign Up
    internal static let title = L10n.tr("Localizable", "sign_up.title")
  }

  internal enum Username {
    /// Username
    internal static let placeholder = L10n.tr("Localizable", "username.placeholder")
  }

  internal enum Users {
    /// Users
    internal static let title = L10n.tr("Localizable", "users.title")
  }
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
