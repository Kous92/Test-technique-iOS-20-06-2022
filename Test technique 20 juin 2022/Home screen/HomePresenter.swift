//
//  HomePresenter.swift
//  Test technique 20 juin 2022
//
//  Created by Koussaïla Ben Mamar on 20/06/2022.
//

import Foundation
import Combine

final class HomePresenter {
    weak var view: PresenterView?
    private let service = ImageService()
    private var imageResult: ImageResult?
    var images = [Hit]()
    
    // Lorsque son contenu est modifié depuis le ViewController, le Publisher va réagir et automatiquement effectuer un appel HTTP en fonction du contenu (après filtrage).
    @Published var searchQuery = ""
    
    // Pour la gestion mémoire et l'annulation des abonnements
    private var subscriptions = Set<AnyCancellable>()
    
    init(view: PresenterView) {
        self.view = view
        setBindings()
    }
    
    private func setBindings() {
        $searchQuery
            .receive(on: RunLoop.main)
            .removeDuplicates()
            .filter { !$0.isEmpty }
            .debounce(for: .seconds(0.8), scheduler: RunLoop.main)
            .sink { [weak self] value in
                print("Recherche enclenchée")
                self?.searchContent(with: value)
            }.store(in: &subscriptions)
    }
    
    func searchContent(with query: String) {
        service.fetchImages(with: query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") { [weak self] result in
            switch result {
            case .success(let response):
                self?.imageResult = response
                self?.parseData()
            case .failure(let error):
                print(error.rawValue)
            }
        }
    }
    
    private func parseData() {
        guard let imageResult = imageResult else {
            print("Erreur parsing")
            return
        }
        
        print("Images téléchargées: \(imageResult.hits.count)")
        images = imageResult.hits
        
        DispatchQueue.main.async { [weak self] in
            self?.view?.display()
        }
    }
}
