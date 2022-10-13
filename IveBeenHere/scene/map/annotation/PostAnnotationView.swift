//
//  PostAnnotationView.swift
//  IveBeenHere
//
//  Created by 김동준 on 2022/10/11.
//

import MapKit
import UIKit

final class PostAnnotation: NSObject, MKAnnotation {
    let visitDTO: VisitDTO
    var didTapRelay: PublishRelay<Void>?
    let coordinate: CLLocationCoordinate2D
    init(visitDTO: VisitDTO) {
        coordinate = CLLocationCoordinate2D(latitude: visitDTO.place.latitude, longitude: visitDTO.place.longitude)
        self.visitDTO = visitDTO
    }
}

final class PostAnnotationView: MKAnnotationView {
    static let identifier = "PostAnnotationView"
    private var didTapRelay: PublishRelay<Void>?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 1
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    private let placeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 1
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 10)
        return label
    }()
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        frame = CGRect(x: 0, y: 0, width: 80, height: 40)
        centerOffset = CGPoint(x: 0, y: -frame.size.height / 2)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .black
        addSubview(titleLabel)
        addSubview(placeLabel)
        self.layer.cornerRadius = 10
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize(width: 1, height: 1)
        layer.shadowPath = nil
        
        NSLayoutConstraint.activate([titleLabel.topAnchor.constraint(equalTo: self.topAnchor),
                                     titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                                     titleLabel.widthAnchor.constraint(equalToConstant: 70),
                                     placeLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
                                     placeLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                                     placeLabel.widthAnchor.constraint(equalToConstant: 70)])
        
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTap)))
    }
    
    @objc func didTap(sender: UITapGestureRecognizer) {
        didTapRelay?.accept(value: ())
    }
    
    func configuration(with visit: VisitDTO) {
        titleLabel.text = visit.title
        placeLabel.text = visit.place.name
    }
    
    func addAction(with tapRelay: PublishRelay<Void>?) {
        self.didTapRelay = tapRelay
    }
}
