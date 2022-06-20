//
//  APIError.swift
//  Test technique 20 juin 2022
//
//  Created by Koussaïla Ben Mamar on 20/06/2022.
//

import Foundation

enum APIError: String, Error {
    case noApiKey = "Erreur 400: Clé d'API invalide ou manquante."
    case notFound = "Erreur 404: Ressource non trouvée."
    case tooManyRequests = "Erreur 429: Trop de requêtes HTTP effectuées."
    case invalidURL = "Erreur: URL invalide."
    case decodeError = "Erreur au décodage des données."
    case networkError = "Erreur réseau."
    case failed = "Une erreur est survenue."
}
