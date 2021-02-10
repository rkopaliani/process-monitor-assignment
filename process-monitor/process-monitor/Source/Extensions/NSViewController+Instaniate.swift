//
//  NSViewController+Instaniate.swift
//  process-monitor
//
//  Created by Roman Kopaliani on 10.02.2021.
//

import AppKit

protocol StoryboardInstantiatable {
    static var storyboardName: String { get }
    static var storyboardBundle: Bundle { get }
    static var storyboardIdentifier: String { get }
}

extension StoryboardInstantiatable where Self: NSObject {
    static var storyboardName: String {
        return  "Main"
    }

    static var storyboardBundle: Bundle {
        return Bundle(for: self)
    }

    static var storyboard: NSStoryboard {
        return NSStoryboard(name: storyboardName, bundle: storyboardBundle)
    }
    
    static var storyboardIdentifier: String {
        className()
    }
}

extension StoryboardInstantiatable where Self: NSViewController {
    static var storyboardIdentifier: String {
        return String(describing: Self.self)
    }

    static func instaniate(_ configuration: (Self) -> ()) -> Self {
        guard let viewController = storyboard.instantiateController(withIdentifier: storyboardIdentifier) as? Self
        else { fatalError("Wronf instaniation class for view controller: \(String(describing: Self.self))")}
        configuration(viewController)
        return viewController
    }
}
