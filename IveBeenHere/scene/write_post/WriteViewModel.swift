//
//  WriteViewModel.swift
//  IveBeenHere
//
//  Created by 김동준 on 2022/08/26.
//

import Foundation

final class WriteViewModel {
    var writeManagable: WriteUsecase?
    var viewDidLoad = PublishRelay<Void>()
    var tappedAddImageButton = PublishRelay<Void>()
    var addLocationButtonTapped = PublishRelay<Void>()
    var searchBarDidEditing = PublishRelay<String>()
    var didPopChildView = PublishRelay<Void>()
    var searchTableCellDidTapped = PublishRelay<Int>()
    
    private let disposeBag = DisposeBag()
    private var places = [PlaceDTO]()
    
    var attributeView = PublishRelay<Void>()
    var locationRelay = PublishRelay<[PlaceDTO]>()
    var searchingLocations = PublishRelay<[PlaceDTO]>()
    var presentAddLocation = PublishRelay<Void>()
    var presentSelectPhoto = PublishRelay<Void>()
    
    init() {
        viewDidLoad.bind { [weak self] _ in
            guard let self = self else { return }
            self.writeManagable?.requestPlaces()
            self.attributeView.accept(value: ())
        }
        .disposed(by: disposeBag)
        
        tappedAddImageButton.bind { [weak self] _ in
            guard let self = self else { return }
            self.presentSelectPhoto.accept(value: ())
        }
        .disposed(by: disposeBag)
        
        didPopChildView.bind { [weak self] _ in
            guard let self = self else { return }
            self.writeManagable?.requestPlaces()
        }
        .disposed(by: disposeBag)
        
        addLocationButtonTapped.bind { [weak self] _ in
            guard let self = self else { return }
            self.presentAddLocation.accept(value: ())
        }
        .disposed(by: disposeBag)
        
        searchBarDidEditing.bind { [weak self] location in
            guard let self = self else { return }
            let searchingLocations = self.places.filter { $0.name.contains(location) }
            self.searchingLocations.accept(value: searchingLocations)
        }
        .disposed(by: disposeBag)
        
        locationRelay.bind { [weak self] places in
            guard let self = self else { return }
            self.places = places
        }
        .disposed(by: disposeBag)
        
        searchTableCellDidTapped.bind { [weak self] item in
            guard let self = self else { return }
            let place = self.places[item]
        }
        .disposed(by: disposeBag)
    }
}
extension WriteViewModel: WriteViewModelOutput {
    
}
protocol WriteViewModelOutput {
    var locationRelay: PublishRelay<[PlaceDTO]> { get }
}
