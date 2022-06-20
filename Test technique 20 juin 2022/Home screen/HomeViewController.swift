//
//  ViewController.swift
//  Test technique 20 juin 2022
//
//  Created by Koussaïla Ben Mamar on 20/06/2022.
//

import UIKit
import Combine

class HomeViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var button: UIButton!
    
    private var selectedItems = [Int]() {
        didSet {
            checkButton(selectedItems.count > 0 ? true : false)
        }
    }
    
    private var subscriptions = Set<AnyCancellable>()
    var presenter: HomePresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        presenter = HomePresenter(view: self)
        setSearchBar()
        setCollectionView()
        setButton()
    }
    
    @IBAction func goToNextView(_ sender: Any) {
        guard selectedItems.count > 0 else {
            return
        }
        
        guard let vc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else {
            fatalError("Impossible d'instancier DetailViewController")
        }
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeViewController {
    private func setSearchBar() {
        // Configuration barre de recherche
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = "Annuler"
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = .label
        searchBar.backgroundImage = UIImage() // Supprimer le fond par défaut
        searchBar.showsCancelButton = false
        searchBar.delegate = self
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalWidth(1/3))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitem: item, count: 3)
        group.interItemSpacing = .fixed(CGFloat(5))
        
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    private func setCollectionView() {
        // Configuration CollectionView
        collectionView.isHidden = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = createLayout()
        collectionView.allowsMultipleSelection = true
    }
    
    private func setButton() {
        button.isEnabled = false
        button.layer.cornerRadius = 8
        checkButton(false)
    }
    
    private func checkButton(_ isEnabled: Bool) {
        button.isEnabled = isEnabled
        button.backgroundColor = isEnabled ? .systemBlue : .systemGray
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.setShowsCancelButton(true, animated: true) // Afficher le bouton d'annulation
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.presenter?.searchQuery = searchText
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.presenter?.searchQuery = ""
        self.searchBar.text = ""
        self.searchBar.setShowsCancelButton(false, animated: true) // Masquer le bouton d'annulation
        searchBar.resignFirstResponder() // Masquer le clavier et stopper l'édition du texte
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder() // Masquer le clavier et stopper l'édition du texte
        self.searchBar.setShowsCancelButton(false, animated: true) // Masquer le bouton d'annulation
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedItems.append(indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if selectedItems.contains(indexPath.item) {
            self.selectedItems.remove(at: selectedItems.firstIndex(of: indexPath.item)!)
        }
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter?.images.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let imageCell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as? ImageResultCollectionViewCell else {
            print("Erreur cellule")
            return UICollectionViewCell()
        }
        
        guard let imageContent = presenter?.images[indexPath.item] else {
            print("Erreur contenu cellule")
            return UICollectionViewCell()
        }
        
        imageCell.configure(with: imageContent)
        
        return imageCell
    }
}

extension HomeViewController: PresenterView {
    func display() {
        print("Nouvelles images disponibles: \(presenter?.images.count ?? -1).")
        updateCollectionView()
    }
    
    private func updateCollectionView() {
        collectionView.isHidden = false
        collectionView.reloadData()
    }
}
