//
//  Coordinator.swift
//  gorene
//
//  Created by Illya Blinov on 5.06.24.
//

import UIKit

enum AppFlow {
    case start
    case main
}

protocol FlowCoordinatorProtocol: AnyObject {
    var parentCoordinator: MainCoordinatorProtocol? { get set }
}

protocol Coordinator: FlowCoordinatorProtocol {
    var rootViewController: UIViewController { get set }
    func start() -> UIViewController
    @discardableResult func resetToRoot() -> Self
}

protocol MainCoordinatorProtocol: Coordinator {
 //   var ticketsCoordinator: TicketsCoordinatorProtocol { get }
    func moveTo(flow: AppFlow)
}

extension Coordinator {
    var navigationRootViewController: UINavigationController? {
        get {
            (rootViewController as? UINavigationController)
        }
    }

    func resetToRoot() -> Self {
        navigationRootViewController?.popToRootViewController(animated: false)
        return self
    }
}
