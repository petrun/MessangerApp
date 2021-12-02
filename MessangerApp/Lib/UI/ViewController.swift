//
//  ViewController.swift
//  MessangerApp
//
//  Created by andy on 02.12.2021.
//

import UIKit

class ViewController<ViewType: UIView>: UIViewController, ViewLoadable {
    public typealias MainView = ViewType

    open override func loadView() {
        view = MainView()
    }
}
