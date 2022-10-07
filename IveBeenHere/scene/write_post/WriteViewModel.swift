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
    var searchTableCellDidTapped = PublishRelay<String>()
    var postImageData = PublishRelay<Data>()
    var writeButtonTapped = PublishRelay<Void>()
    var titleEdited = PublishRelay<String>()
    var contentEdited = PublishRelay<String>()
    
    private let disposeBag = DisposeBag()
    private var places = [PlaceDTO]()
    
    private var thumbnailImageData: Data?
    private var place: PlaceDTO?
    private var title: String?
    private var content: String?
    
    var attributeView = PublishRelay<Void>()
    var locationRelay = PublishRelay<[PlaceDTO]>()
    var searchingLocations = PublishRelay<[PlaceDTO]>()
    var presentAddLocation = PublishRelay<Void>()
    var presentSelectPhoto = PublishRelay<Void>()
    var updateThumbnailImage = PublishRelay<Data>()
    var updateSelectedPlace = PublishRelay<String>()
    var noticeMessage = PublishRelay<LackingInfo>()
    
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
        
        searchTableCellDidTapped.bind { [weak self] placeName in
            guard let self = self else { return }
            self.place = self.places.filter { placeName == $0.name }.first
            guard let placeName = self.place?.name else { return }
            self.updateSelectedPlace.accept(value: placeName)
        }
        .disposed(by: disposeBag)
        
        postImageData.bind { [weak self] data in
            guard let self = self else { return }
            self.updateThumbnailImage.accept(value: data)
            self.thumbnailImageData = data
        }
        .disposed(by: disposeBag)
        
        titleEdited.bind { [weak self] title in
            guard let self = self else { return }
            self.title = title
        }
        .disposed(by: disposeBag)
        
        contentEdited.bind { [weak self] content in
            guard let self = self else { return }
            self.content = content
        }
        .disposed(by: disposeBag)
        
        writeButtonTapped.bind { [weak self] _ in
            guard let self = self else { return }
            guard let imageData = self.thumbnailImageData else {
                self.noticeMessage.accept(value: .photo)
                return
            }
            
            guard let place = self.place else {
                self.noticeMessage.accept(value: .place)
                return
            }
            
            guard let title = self.title else {
                self.noticeMessage.accept(value: .title)
                return
            }
            
            Task {
                let url = try await String(describing: self.writeManagable?.requestUploadImage(imageData: imageData))
                let dto = VisitDTO(place: place, date: Date(), title: title, content: self.content, imageURL: url)
                print(dto)
                guard let result = try await self.writeManagable?.requestWriteVisitDTO(from: dto) else { return }
                switch result {
                case .success(_):
                    print("sucecess logic")
                case .failure(let error):
                    print(error)
                }
            }
        }
        .disposed(by: disposeBag)
    }
}
extension WriteViewModel {
    
}

extension WriteViewModel: WriteViewModelOutput {
    
}
protocol WriteViewModelOutput {
    var locationRelay: PublishRelay<[PlaceDTO]> { get }
}

enum LackingInfo {
    case photo
    case place
    case title
}
