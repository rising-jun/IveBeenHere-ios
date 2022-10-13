//
//  MainMapViewController.swift
//  IveBeenHere
//
//  Created by 김동준 on 2022/08/27.
//

import UIKit
import MapKit

protocol MainMapViewPresentable: AnyObject {
    func dismissCompleteUpload(dto: VisitDTO)
}

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
        viewModel?.action()
            .viewDidLoad
            .accept(value: ())
    }
    
    private var mapView: MKMapView?
    private var mapDelegate: MapViewDelegate?
}
extension MainMapViewController {
    private func viewAttribute() {
        view.addSubview(mapViewController.view)
        addPostButton.layer.zPosition = 999
        view.bringSubviewToFront(addPostButton)
        addPostButton.addTarget(self, action: #selector(addPostButtonTapped), for: .touchUpInside)
        self.mapView = mapViewController.mapView
    }
    
    private func binding() {
        guard let viewModel = viewModel else { return }
        viewModel.state()
            .viewAttirbute
            .observe(on: DispatchQueue.main)
            .bind(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.viewAttribute()
            })
            .disposed(by: disposeBag)
        
        viewModel.state()
            .didLogin
            .observe(on: DispatchQueue.main)
            .bind(onNext: { [weak self] result in
                guard let self = self else { return }
                result ? self.presentWritePopup() : self.presentLoginPopup()
            })
            .disposed(by: disposeBag)
        
        viewModel.state()
            .updateVisits
            .observe(on: DispatchQueue.main)
            .bind(onNext: { [weak self] visits in
                guard let self = self else { return }
                for (index, visitDTO) in visits.enumerated() {
                    self.addVisitAnnotation(visitDTO: visitDTO, tapRelay: viewModel.action().postDidTapRelays[index])
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.state()
            .firebaseError
            .observe(on: DispatchQueue.main)
            .bind(onNext: { error in
                print("visits result Error \(error)")
            })
            .disposed(by: disposeBag)
        
        viewModel.state()
            .presentPost
            .observe(on: DispatchQueue.main)
            .bind { [weak self] visitDTO in
                guard let self = self else { return }
                self.presentPostView(with: visitDTO)
            }
            .disposed(by: disposeBag)
    }
    
    @objc func addPostButtonTapped(sender: Any) {
        viewModel?.action()
            .addPostButtonTapped
            .accept(value: ())
    }
    
    private func presentPostView(with visitDTO: VisitDTO) {
        let postViewController = PostBuilder().build()
        postViewController.setDetailVisit(from: visitDTO)
        present(postViewController, animated: true)
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
        writePostViewController.presentableMainView = self
        self.present(writePostViewController, animated: true, completion: nil)
    }
    
    private func addVisitAnnotation(visitDTO: VisitDTO, tapRelay: PublishRelay<Void>) {
        guard let mapView = self.mapView else { return }
        let point = PostAnnotation(visitDTO: visitDTO)
        point.didTapRelay = tapRelay
        mapView.addAnnotation(point)
    }
}
extension MainMapViewController: MainMapViewPresentable {
    func dismissCompleteUpload(dto: VisitDTO) {
        guard let viewModel = viewModel else { return }
        viewModel.uploadedPost.accept(value: dto)
    }
}
