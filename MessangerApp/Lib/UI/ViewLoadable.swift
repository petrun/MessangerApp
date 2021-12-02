//
//  ViewController.swift
//  MessangerApp
//
//  Created by andy on 30.10.2021.
//

import UIKit

public protocol ViewLoadable {
    associatedtype MainView: UIView
}

extension ViewLoadable where Self: UIViewController {
    // The UIViewController's custom view.
    public var mainView: MainView {
        guard let customView = view as? MainView else {
            fatalError("Expected view to be of type \(MainView.self) but got \(type(of: view)) instead")
        }
        return customView
    }
}

open class ViewController<ViewType: UIView>: UIViewController, ViewLoadable {
    public typealias MainView = ViewType

    open override func loadView() {
        view = MainView()
    }
}
