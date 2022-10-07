//
//  MainMapViewController.swift
//  IveBeenHere
//
//  Created by 김동준 on 2022/08/27.
//

import UIKit

final class MainMapViewController: UIViewController {
    static let id = String(describing: MainMapViewController.self)
    
    @IBOutlet weak var addPostButton: UIButton!
    private let disposeBag = DisposeBag()
    private let mapViewController = MapBuilder().build()
    var viewModel: MainMapViewModelType? {
        didSet {
            binding()
        }
    }
    
    static func instance() -> MainMapViewController {
        return MainMapViewController(nibName: Self.id, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.viewDidLoad.accept(value: ())
    }
}
extension MainMapViewController {
    private func viewAttribute() {
        view.addSubview(mapViewController.view)
        addPostButton.layer.zPosition = 999
        view.bringSubviewToFront(addPostButton)
        addPostButton.addTarget(self, action: #selector(addPostButtonTapped), for: .touchUpInside)
    }
    
    private func binding() {
        viewModel?.state()
            .viewAttirbute
            .observe(on: DispatchQueue.main)
            .bind(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.viewAttribute()
            })
            .disposed(by: disposeBag)
        
        viewModel?.state()
            .didLogin
            .observe(on: DispatchQueue.main)
            .bind(onNext: { [weak self] result in
                guard let self = self else { return }
                result ? self.presentWritePopup() : self.presentLoginPopup()
            })
            .disposed(by: disposeBag)
    }
    
    @objc func addPostButtonTapped(sender: Any) {
        viewModel?.action()
            .addPostButtonTapped
            .accept(value: ())
    }
    
    private func presentLoginPopup() {
        let alert = UIAlertController(title: "로그인이 필요합니다.", message: "로그인 후 사용해주세요.", preferredStyle: .alert)
        let kakaoLogin = UIAlertAction(title: "카카오 로그인", style: .default) { alert in
            self.viewModel?.action().userRequestLogin.accept(value: ())
        }
        let close = UIAlertAction(title: "나중에", style: .default)
        alert.addAction(kakaoLogin)
        alert.addAction(close)
        self.present(alert, animated: false, completion: nil)
    }
    
    private func presentWritePopup() {
        let writePostViewController = WriteBuilder().build()
        self.present(writePostViewController, animated: false, completion: nil)
    }
}
