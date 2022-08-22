//
//  PublishRelay.swift
//  IveBeenHere
//
//  Created by 김동준 on 2022/08/22.
//

import Foundation

protocol Disposable {
    func removeBind()
    func disposed(by disposeBag: DisposeBag)
}

final class PublishRelay<T>: Disposable {
    typealias Element = (T) -> Void
    private var binder: ((T) -> Void)?
    private var dispatch: DispatchQueue?
    private(set) var value: T?
    
    func bind(onNext: @escaping Element) {
        binder = onNext
    }
    
    func observe(on dispatch: DispatchQueue) {
        self.dispatch = dispatch
    }
    
    func accept(value: T) -> Disposable {
        self.value = value
        if let binder = binder {
            if let dispatch = dispatch {
                dispatch.async {
                    binder(value)
                }
            } else {
                DispatchQueue.global().async {
                    binder(value)
                }
            }
        }
        return self
    }
    
    func removeBind() {
        binder = nil
    }
    
    func disposed(by disposeBag: DisposeBag) {
        disposeBag.append(disposable: self)
    }
}

class DisposeBag {
    private var bag: [Disposable] = []
    func append(disposable: Disposable) {
        bag.append(disposable)
    }
    
    deinit {
        bag.forEach { $0.removeBind() }
        bag.removeAll()
    }
}
