//
//  PostBuilder.swift
//  IveBeenHere
//
//  Created by 김동준 on 2022/10/11.
//

import Foundation

protocol PostBuildingLogic {
    typealias Destination = PostViewController
    func build() -> Destination
}

class PostBuilder: PostBuildingLogic {
    func build() -> Destination {
        let viewController = PostViewController.instance()
        let viewModel = PostViewModel()
        let usecase = PostUsecase()
        viewController.viewModel = viewModel
        viewModel.usecase = usecase
        return viewController
    }
}
