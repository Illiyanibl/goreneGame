//
//  MainCoordinator.swift
//  gorene
//
//  Created by Illya Blinov on 13.07.24.
//

import UIKit

final class MainCoordinator: MainCoordinatorProtocol {
    func moveTo(flow: AppFlow) {
    }
    
    var rootViewController: UIViewController = UIViewController()

    func start() -> UIViewController {
        
        rootViewController = UINavigationController(rootViewController: UIViewController())
        return rootViewController
    }
    
    var parentCoordinator: MainCoordinatorProtocol?
    

}
