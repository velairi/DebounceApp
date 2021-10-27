//
//  ViewController.swift
//  DebounceApp
//
//  Created by Valerie Don on 10/19/21.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegateFlowLayout {

    lazy var searchField: UITextField = {
        var textfield = UITextField(frame: .zero)
        textfield.placeholder = "Search Google Places..."
        textfield.backgroundColor = .white
        textfield.textColor = .black
        textfield.borderStyle = .roundedRect
        textfield.textAlignment = .left
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()

    lazy var collectionView: UICollectionView = {
        let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        collectionView.backgroundColor = .lightGray
        collectionView.register(ResultsCell.self, forCellWithReuseIdentifier: "resultsCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()

    var objects: [PredictionElement] = []

    override func loadView() {
        super.loadView()
        searchField.frame = CGRect(x: 0, y: 20, width: view.coordinateSpace.bounds.width, height: 60)
        view.addSubview(collectionView)
        view.addSubview(searchField)
        self.view = view
        NSLayoutConstraint.activate([
            searchField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            searchField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            searchField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            searchField.heightAnchor.constraint(equalToConstant: 42),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        collectionView.contentInset = UIEdgeInsets(top: 70, left: 0, bottom: 0, right: 0)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        searchField.addTarget(self, action: #selector(editingChanged(_:)), for: .editingChanged)
    }

    @objc func editingChanged(_ textfield: UITextField) {
        NSObject.cancelPreviousPerformRequests(
            withTarget: self,
            selector: #selector(debounce),
            object: nil
        )
        perform(#selector(debounce), with: nil, afterDelay: 0.2)
    }

    @objc func debounce() {
        guard let query = searchField.text else { return }
        let searchRequest = SearchRequest(query: query, sort: Sort(direction: .ascending, timestamp: "last_edited_time"))
        GooglePlacesClient.search(searchRequest).execute(forResponse: Prediction.self) { [weak self] result in
            switch result {
            case .success(let searchResult):
                DispatchQueue.main.async {
                    self?.objects = searchResult.predictions
                    self?.collectionView.reloadData()
                }
            case .failure(let error):
                break
            }
        }
    }
}

extension ViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.coordinateSpace.bounds.width, height: 50)
    }
}

extension ViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let resultsCell = collectionView.dequeueReusableCell(withReuseIdentifier: "resultsCell", for: indexPath) as? ResultsCell else { fatalError("Must dequeue ResultsCell") }
        resultsCell.model = objects[indexPath.row]
        return resultsCell
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        objects.count
    }
}
