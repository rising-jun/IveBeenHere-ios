//
//  PostViewController.swift
//  IveBeenHere
//
//  Created by 김동준 on 2022/10/11.
//

import UIKit

final class PostViewController: UIViewController {
    static let id = String(describing: PostViewController.self)
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    static func instance() -> PostViewController {
        return PostViewController(nibName: Self.id, bundle: nil)
    }
    
    var viewModel: PostViewModel? {
        didSet {
            binding()
        }
    }
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.viewDidLoad.accept(value: ())
    }
}
extension PostViewController {
    private func binding() {
        guard let viewModel = viewModel else { return }
        viewModel.viewAttirbute
            .observe(on: DispatchQueue.main)
            .bind { [weak self] _ in
                guard let self = self else { return }
                self.viewAttribute()
            }
            .disposed(by: disposeBag)
    
        viewModel.contributeView
            .observe(on: DispatchQueue.main)
            .bind { [weak self] visit in
                guard let self = self else { return }
                self.contribute(with: visit)
            }
            .disposed(by: disposeBag)
    }
    
    private func contribute(with visit: VisitEntity) {
        titleLabel.text = visit.title
        placeNameLabel.text = visit.place.name
        descriptionLabel.text = visit.content
        DispatchQueue(label: "imageQueue").async {
            var image: UIImage?
            if let imageData = visit.imageData {
                image = UIImage(data: imageData)
            }
            DispatchQueue.main.async {
                self.indicatorView.stop()
                self.postImageView.image = image
            }
        }
    }
    
    private func viewAttribute() {
        view.backgroundColor = .black
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 24)
        placeNameLabel.textColor = .white
        descriptionLabel.textColor = .white
        indicatorView.start()
    }
    
    func setDetailVisit(from visit: VisitDTO) {
        viewModel?.receiveVisitDetail.accept(value: visit)
    }
}

extension UIActivityIndicatorView {
    func stop() {
        self.stopAnimating()
        self.alpha = 0
    }
    
    func start() {
        self.startAnimating()
        self.alpha = 1
    }
}
