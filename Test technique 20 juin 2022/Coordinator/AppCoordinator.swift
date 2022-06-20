//
//  AppCoordinator.swift
//  Test technique 20 juin 2022
//
//  Created by Koussaïla Ben Mamar on 20/06/2022.
//

import Foundation
import UIKit

final class AppCoordinator: NSObject, Coordinator, UINavigationControllerDelegate {
    
    weak var parent: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    private let navigationController: UINavigationController
    private let window: UIWindow
    
    init(navigationController: UINavigationController = UINavigationController(), window: UIWindow = UIWindow(frame: UIScreen.main.bounds)) {
        self.navigationController = navigationController
        self.window = window
    }
    
    func start() {
        navigationController.delegate = self
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
