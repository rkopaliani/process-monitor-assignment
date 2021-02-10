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

extension NSViewController {
    func embed(_ childViewController: NSViewController, in container: NSView) {
        addChild(childViewController)
        let embeddingView = childViewController.view
        embeddingView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(embeddingView)
        NSLayoutConstraint.activate(embeddingView.constraintsAnchoringTo(boundsOf: container))
    }
}

extension NSView {
    func constraintsAnchoringTo(boundsOf view: NSView) -> [NSLayoutConstraint] {
        return [
            topAnchor.constraint(equalTo: view.topAnchor),
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor)
        ]
    }
}
