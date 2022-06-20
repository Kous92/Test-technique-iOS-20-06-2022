//
//  Coordinator.swift
//  Test technique 20 juin 2022
//
//  Created by Koussaïla Ben Mamar on 20/06/2022.
//

import Foundation

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var parent: Coordinator? { get set }
    
    func start()
}

protocol Coordinatable: AnyObject {
    var coordinator: Coordinator? { get set }
}
