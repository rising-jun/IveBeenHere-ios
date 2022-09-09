//
//  PlaceAddMapViewController.swift
//  IveBeenHere
//
//  Created by 김동준 on 2022/08/27.
//

import UIKit

final class PlaceAddMapViewController: UIViewController {
    static let id = String(describing: PlaceAddMapViewController.self)
    
    private let disposeBag = DisposeBag()
    var viewModel: PlaceAddMapViewModel? {
        didSet {
            binding()
        }
    }
    @IBOutlet weak var placeTitleField: UITextField!
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var placeTitleBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var addButtonBottomConstraint: NSLayoutConstraint!
    
    let mapViewController = MapBuilder().build()
    static func instance() -> PlaceAddMapViewController {
        return PlaceAddMapViewController(nibName: Self.id, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.viewDidLoad.accept(value: ())
    }
    @IBAction func addButtonTapped(_ sender: Any) {
        guard let button = sender as? UIButton else { return }
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.numberOfLines = 1
        viewModel?.addButtonTapped.accept(value: (placeTitleField.text ?? ""))
    }
}
extension PlaceAddMapViewController {
    private func binding() {
        guard let viewModel = self.viewModel else { return }
        viewModel.state().viewAttribute
            .observe(on: DispatchQueue.main)
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                self.viewAttribute()
            })
            .disposed(by: disposeBag)
        
        viewModel.state().updateConstraints
            .observe(on: DispatchQueue.main)
            .bind(onNext: { [weak self] height in
                guard let self = self else { return }
                self.updateConstraints(offset: height)
            })
            .disposed(by: disposeBag)
        
        viewModel.state().presentWriteView
            .observe(on: DispatchQueue.main)
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                self.presentWriteView()
            })
            .disposed(by: disposeBag)
    }
    
    private func viewAttribute() {
        addKeyBoardListener()
        view.addSubview(mapViewController.view)
        view.bringSubviewToFront(placeTitleField)
        view.bringSubviewToFront(addButton)
        
        addButton.titleLabel?.adjustsFontSizeToFitWidth = true
        addButton.titleLabel?.numberOfLines = 1
        guard let draggedPoint = viewModel?.draggedPoint else { return }
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.mapViewController.addAnnotationToUserLocation(draggedRelay: draggedPoint)
        }
    }
    
    private func addKeyBoardListener() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil);
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            viewModel?.keyboardAppear.accept(value: Float(keyboardHeight))
        }
    }
    
    private func updateConstraints(offset: Float) {
        let height = CGFloat(offset)
        UIView.animate(withDuration: 0.3) {
            self.placeTitleBottomConstraint.constant = -height + 24
            self.addButtonBottomConstraint.constant = -height + 24
            self.placeTitleField.layoutIfNeeded()
            self.addButton.layoutIfNeeded()
            self.view.layoutIfNeeded()
        }
    }
    
    private func presentWriteView() {
        self.dismiss(animated: true)
    }
}
