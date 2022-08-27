//
//  WriteBuilder.swift
//  IveBeenHere
//
//  Created by 김동준 on 2022/08/26.
//

import Foundation

protocol WriteBuildingLogic {
    typealias Destination = WritePostViewController
    func build() -> Destination
}

class WriteBuilder: WriteBuildingLogic {
    func build() -> Destination {
        let viewController = WritePostViewController.instance()
        let viewModel = WriteViewModel()
        let mapUsecase = WriteUsecase()
        
        viewController.viewModel = viewModel
        return viewController
    }
}
