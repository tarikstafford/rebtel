//
//  ViewController.swift
//  RebtelDialConcept
//
//  Created by Tarik Stafford on 17/12/18.
//  Copyright © 2018 Tarik Stafford. All rights reserved.
//

import UIKit

class MainController: UIViewController {
    
    lazy var imageView: UIImageView = {
        let iv = UIImageView.init()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = .red
        return iv
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = RotatingCollectionLayout.init(gap: 10, itemSize: CGSize.init(width: 100, height: 100))
        let cv = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .clear
        cv.decelerationRate = .fast
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    lazy var searchBar: UISearchBar = {
        let sB = UISearchBar()
        sB.delegate = self
        sB.placeholder = "Filter countries..."
        sB.barTintColor = Theme.primaryColor
        sB.tintColor = UIColor.synthPurple
        sB.translatesAutoresizingMaskIntoConstraints = false
        sB.layer.borderWidth = 1
        sB.layer.borderColor = Theme.primaryColor.cgColor
        return sB
    }()
    
    lazy var countryDisplay: CountryDisplayView = {
       let cD = CountryDisplayView.init(country: nil, frame: CGRect.zero)
        cD.translatesAutoresizingMaskIntoConstraints = false
        cD.backgroundColor = Theme.primaryColor
        return cD
    }()
    
    var countries = [Country]() {
        didSet{
            self.collectionView.reloadData()
            self.collectionView.collectionViewLayout.invalidateLayout()
        }
    }
    
    var countriesCopy = [Country]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib.init(nibName: "CountryRotatingCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "CountryRotatingCell")
        
        self.view.backgroundColor = .white
        self.title = "Country Finder"
    
        let clearBarButton = UIBarButtonItem.init(title: "\u{f1f8}", style: .plain, target: self, action: #selector(clearQuery))
        let attributesClearButton = [
            NSAttributedString.Key.font: Theme.fontAwesome,
            NSAttributedString.Key.foregroundColor: UIColor.white ]
        clearBarButton.setTitleTextAttributes(attributesClearButton, for: .normal)
        clearBarButton.setTitleTextAttributes(attributesClearButton, for: .highlighted)
        clearBarButton.title = "\u{f1f8}"
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = clearBarButton
        
        addViews()
        fetchAll()
    }
    
    fileprivate func addViews() {
        self.view.addSubview(searchBar)
        self.view.addSubview(collectionView)
        self.view.addSubview(countryDisplay)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            searchBar.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 50),
            searchBar.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            
            collectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            collectionView.topAnchor.constraint(equalTo: self.searchBar.bottomAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height*0.3),
            
            countryDisplay.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
            countryDisplay.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            countryDisplay.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            countryDisplay.rightAnchor.constraint(equalTo: self.view.rightAnchor)
            ])
    }
    
    fileprivate func fetchAll(){
        var countries = Country.fetchAll()
        countries.sort {
            $0.name < $1.name
        }
        self.countries = countries
    }
    
    fileprivate func updateDatasource(for country: Country) {
        if let index = self.countries.firstIndex(where: {$0.name == country.name }) {
            self.countries[index] = country
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

// MARK: Collection View Delegate & Datasource
extension MainController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = countries.count
        return count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CountryRotatingCell", for: indexPath) as! CountryRotatingCell
        cell.flagView.image = countries[indexPath.row].getImage(type: .medium)
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let country = countries[indexPath.row]

        countryDisplay.country = country
        
        loadData(for: country, indexPath: indexPath)
        
        centerCell(for: indexPath)
    }
    
    // This allows selection of the cell that is at the center
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let midPoint = collectionView.bounds.width/2 + collectionView.contentOffset.x
        
        collectionView.visibleCells.forEach({ (cell) in
            // Round to the tens and then find the cell that is closest to the midpoint
            if round(midPoint/10) == round(cell.frame.midX/10) {
                guard let indexPath = self.collectionView.indexPath(for: cell) else {
                    return
                }
                self.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: UICollectionView.ScrollPosition.centeredHorizontally)
                self.collectionView(self.collectionView, didSelectItemAt: indexPath)
            }
        })
    }
    
    fileprivate func loadData(for country: Country, indexPath: IndexPath) {
        // Unwrap ISO
        guard let iso = country.iso else {
            let alert = UIAlertController.init(title: "Invalid ISO Code", message: "Country code not found", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default))
            present(alert, animated: true, completion: nil)
            return
        }
        
        // Check if the data has already been called ( this needs to be tested )
        guard country.capital == nil else {
            self.countryDisplay.country = countries[indexPath.row]
            return
        }
        
        // If not fetch the data and then push it to the display & update the datasource ( this needs to be tested )
        _ = CountryAPIService.countryAPIServiceShared.send(FetchCountry.init(isoCode: iso), completion: { (result) in
            switch result {
            case .failure(let error):
                let alert = UIAlertController.init(title: "API Failed", message: (error.errorDescription ?? "No description"), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default))
                DispatchQueue.main.async {
                    self.present(alert, animated: true, completion: nil)
                }
            case.success(let response):
                DispatchQueue.main.async {
                    self.countryDisplay.country = response
                    self.updateDatasource(for: response)
                }
            }
        })
    }
    
    fileprivate func centerCell(for indexPath: IndexPath) {
        let midPoint = collectionView.bounds.width/2 + collectionView.contentOffset.x
        
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        
        var delta: CGFloat = 0
        delta = cell.frame.midX - midPoint
        
        let newContentOffset = CGPoint(x: (collectionView.contentOffset.x + delta), y: collectionView.contentOffset.y)
        
        collectionView.setContentOffset(newContentOffset, animated: true)
    }
}

// MARK: Search Bar Delegate
extension MainController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        // Reset the datasource if search query is deleted
        guard !searchText.isEmpty else {
            self.countries = countriesCopy.sorted(by: { $0.name < $1.name })
            return
        }
        
        self.clearQuery()
        
        var filteredCountries = [Country]()
        
        /*
         Create a set to create uniquness - this enables us to make the copy
         additive so we always query the complete collection of objects.
         */
        
        let set = Set(self.countriesCopy)
        let union = set.union(self.countries)
        self.countriesCopy = Array(union)
        filteredCountries = self.countriesCopy.filter { (country) -> Bool in
            country.name.contains(searchText)
        }
        
        guard !filteredCountries.isEmpty else {
            return
        }
        
        self.countries = filteredCountries
        var newContentOffset = collectionView.contentOffset
        newContentOffset.x = 0
        self.collectionView.setContentOffset(newContentOffset, animated: true)
    }
    
    @objc private func clearQuery() {
        self.countryDisplay.country = nil
    }
}
