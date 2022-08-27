//
//  PlaceAddMapViewModel.swift
//  IveBeenHere
//
//  Created by 김동준 on 2022/08/27.
//

import Foundation

final class PlaceAddMapViewModel {
    var placeAddMapManagable: PlaceAddMapUsecase?
    var viewDidLoad = PublishRelay<Void>()
    private let disposeBag = DisposeBag()
    
    var setMapView = PublishRelay<Void>()
    init() {
        viewDidLoad.bind { [weak self] _ in
            guard let self = self else { return }
            self.setMapView.accept(value: ())
        }
        .disposed(by: disposeBag)
        
    }
}
