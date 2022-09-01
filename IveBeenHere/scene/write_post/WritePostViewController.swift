//
//  WritePostViewController.swift
//  IveBeenHere
//
//  Created by 김동준 on 2022/08/24.
//

import UIKit

final class WritePostViewController: UIViewController {
    static let id = String(describing: WritePostViewController.self)
    private let searchBarDelegate = LocationSearchBarDelegate()
    private let disposeBag = DisposeBag()
    var viewModel: WriteViewModel? {
        didSet { binding() }
    }
    
    static func instance() -> WritePostViewController {
        return WritePostViewController(nibName: id, bundle: nil)
    }
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var locationSearchBar: UISearchBar!
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var contentText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationSearchBar.delegate = searchBarDelegate
        viewModel?.viewDidLoad.accept(value: ())
    }
    
    @IBAction func AddLocationButtonTapped(_ sender: Any) {
        viewModel?.addLocationButtonTapped.accept(value: ())
    }
}

extension WritePostViewController {
    private func binding() {
        searchBarDelegate.searchBarChangeObserver = viewModel?.searchBarDidEditing
        
        viewModel?.presentAddLocation
            .observe(on: DispatchQueue.main)
            .bind(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.presentPlaceAddMap()
            })
            .disposed(by: disposeBag)
        
        viewModel?.locationRelay
            .observe(on: DispatchQueue.main)
            .bind(onNext: { [weak self] places in
                guard let self = self else { return }
                print("excute")
                
                self.locationSearchBar.scopeButtonTitles = places.map { $0.name }
            })
            .disposed(by: disposeBag)
    }
    
    private func presentPlaceAddMap() {
        let viewController = PlaceAddMapBuilder().build()
        present(viewController, animated: true)
    }
}
