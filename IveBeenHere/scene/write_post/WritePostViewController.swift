//
//  WritePostViewController.swift
//  IveBeenHere
//
//  Created by 김동준 on 2022/08/24.
//

import UIKit

protocol WritePostViewPresentable: AnyObject {
    func didPopChildView()
}

final class WritePostViewController: UIViewController {
    static let id = String(describing: WritePostViewController.self)
    private let searchBarDelegate = LocationSearchBarDelegate()
    private let searchTableDataSource = SearchTableDataSource()
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
        guard let viewModel = self.viewModel else { return }
        searchBarDelegate.searchBarChangeObserver = viewModel.searchBarDidEditing
        
        viewModel.presentAddLocation
            .observe(on: DispatchQueue.main)
            .bind(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.presentPlaceAddMap()
            })
            .disposed(by: disposeBag)
        
        viewModel.attributeView
            .observe(on: DispatchQueue.main)
            .bind(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.attributeView()
            })
            .disposed(by: disposeBag)
        
        viewModel.locationRelay
            .observe(on: DispatchQueue.main)
            .bind(onNext: { [weak self] places in
                guard let self = self else { return }
                self.locationSearchBar.scopeButtonTitles = places.map { $0.name }
            })
            .disposed(by: disposeBag)
        
        viewModel.presentSelectPhoto
            .observe(on: DispatchQueue.main)
            .bind { [weak self] _ in
                guard let self = self else { return }
                self.presentPhotoPicker()
            }
            .disposed(by: disposeBag)
        
        viewModel.searchingLocations
            .observe(on: DispatchQueue.main)
            .bind { [weak self] places in
                guard let self = self else { return }
                if places.count > 0 {
                    self.searchTableDataSource.updatePlaces(from: places)
                    self.searchTableView.reloadData()
                    self.searchTableView.alpha = 1
                } else {
                    self.searchTableView.alpha = 0
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func presentPlaceAddMap() {
        let viewController = PlaceAddMapBuilder().build()
        viewController.presentableWriteView = self
        present(viewController, animated: true)
    }
    
    private func attributeView() {
        searchTableView.dataSource = searchTableDataSource
        searchTableDataSource.tappedRelay = viewModel?.searchTableCellDidTapped
        searchTableView.backgroundColor = .systemGray5
        
        registerTapEvent()
    }
    
    private func registerTapEvent() {
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(buttonTapped)))
        imageView.isUserInteractionEnabled = true
    }
    
    @objc func buttonTapped(sender: UITapGestureRecognizer) {
        viewModel?.tappedAddImageButton.accept(value: ())
    }
    
    private func presentPhotoPicker() {
        
    }
}
extension WritePostViewController: WritePostViewPresentable {
    func didPopChildView() {
        viewModel?.didPopChildView.accept(value: ())
    }
}
