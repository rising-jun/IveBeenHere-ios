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
    var draggedPoint = PublishRelay<Coordinate>()
    private let disposeBag = DisposeBag()
    
    var viewAttribute = PublishRelay<Void>()
    init() {
        viewDidLoad.bind { [weak self] _ in
            guard let self = self else { return }
            self.viewAttribute.accept(value: ())
        }
        .disposed(by: disposeBag)
        
        draggedPoint.bind { [weak self] coordi in
            guard let self = self else { return }
            print("coordi : \(coordi)")
        }
    }
}
