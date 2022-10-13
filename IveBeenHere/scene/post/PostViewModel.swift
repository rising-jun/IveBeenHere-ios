//
//  PostViewModel.swift
//  IveBeenHere
//
//  Created by 김동준 on 2022/10/11.
//

import Foundation

final class PostViewModel {
    var usecase: PostUsecase?
    
    var viewDidLoad = PublishRelay<Void>()
    var receiveVisitDetail = PublishRelay<VisitDTO>()

    var viewAttirbute = PublishRelay<Void>()
    var contributeView = PublishRelay<VisitEntity>()
    
    private let disposeBag = DisposeBag()
    init() {
        viewDidLoad.bind { [weak self] _ in
            guard let self = self else { return }
            self.viewAttirbute.accept(value: ())
        }
        .disposed(by: disposeBag)
        
        receiveVisitDetail.bind { [weak self] visit in
            guard let self = self else { return }
            Task {
                if let usecase = self.usecase {
                    let entity = await usecase.convertEntity(from: visit)
                    self.contributeView.accept(value: entity)
                }
            }
        }
        .disposed(by: disposeBag)
    }
}
