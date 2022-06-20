//
//  ImageService.swift
//  Test technique 20 juin 2022
//
//  Created by Koussaïla Ben Mamar on 20/06/2022.
//

import Foundation

class ImageService {
    private let apiKey = "18021445-326cf5bcd3658777a9d22df6f"
    
    func fetchImages(with query: String, completion: @escaping (Result<ImageResult, APIError>) -> ()) {
        let imageURL = URL(string: "https://pixabay.com/api/?key=\(apiKey)&q=\(query)&per_page=100&image_type=photo")
        print("URL = \("https://pixabay.com/api/?key=\(apiKey)&q=\(query)&image_type=photo")")
        
        guard let url = imageURL else {
            completion(.failure(.invalidURL))
            
            return
        }
        
        getRequest(url: url, completion: completion)
    }
    
    func getRequest<T: Decodable>(url: URL, completion: @escaping(Result<T, APIError>) -> ()) {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            // Network error
            guard error == nil else {
                print(error?.localizedDescription ?? "Erreur réseau")
                completion(.failure(.networkError))
                
                return
            }
            
            // No server response
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.failed))
                
                return
            }
            
            switch httpResponse.statusCode {
                // Code 200, check if data exists
                case (200...299):
                    if let data = data {
                        print(data.debugDescription)
                        var output: T?
                        
                        do {
                            output = try JSONDecoder().decode(T.self, from: data)
                        } catch {
                            completion(.failure(.decodeError))
                            return
                        }
                        
                        if let object = output {
                            completion(.success(object))
                        }
                    } else {
                        completion(.failure(.failed))
                    }
                default:
                    completion(.failure(.notFound))
            }
        }
        task.resume()
    }
}
