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
    var addLocationButtonTapped = PublishRelay<Void>()
    var searchBarDidEditing = PublishRelay<String>()
    
    private let disposeBag = DisposeBag()
    private var location = [PlaceDTO]()
    
    var presentAddLocation = PublishRelay<Void>()
    init() {
        viewDidLoad.bind { [weak self] _ in
            guard let self = self else { return }
            
        }
        .disposed(by: disposeBag)
        
        addLocationButtonTapped.bind { [weak self] _ in
            guard let self = self else { return }
            self.presentAddLocation.accept(value: ())
        }
        .disposed(by: disposeBag)
        
        searchBarDidEditing.bind { location in
            
        }
        .disposed(by: disposeBag)
    }
}
extension WriteViewModel {
    
}
