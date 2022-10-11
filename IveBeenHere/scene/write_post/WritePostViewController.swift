//
//  WritePostViewController.swift
//  IveBeenHere
//
//  Created by 김동준 on 2022/08/24.
//

import UIKit

protocol WritePostViewPresentable: AnyObject {
    func didPopChildView()
}

final class WritePostViewController: UIViewController {
    static let id = String(describing: WritePostViewController.self)
    private let searchBarDelegate = LocationSearchBarDelegate()
    private let searchTableDataSource = SearchTableDataSource()
    private let delegate = ImagePickerDelegate()
    private let disposeBag = DisposeBag()
    var viewModel: WriteViewModel? {
        didSet { binding() }
    }
    
    static func instance() -> WritePostViewController {
        return WritePostViewController(nibName: id, bundle: nil)
    }
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var locationSearchBar: UISearchBar!
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var contentText: UITextView!
    
    weak var presentableMainView: MainMapViewPresentable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationSearchBar.delegate = searchBarDelegate
        viewModel?.viewDidLoad.accept(value: ())
    }
    
    @IBAction func writeButtonTapped(_ sender: Any) {
        viewModel?.titleEdited.accept(value: titleField.text ?? "")
        viewModel?.contentEdited.accept(value: contentText.text)
        viewModel?.writeButtonTapped.accept(value: ())
    }
    
    @IBAction func AddLocationButtonTapped(_ sender: Any) {
        viewModel?.addLocationButtonTapped.accept(value: ())
    }
}

extension WritePostViewController {
    private func binding() {
        guard let viewModel = self.viewModel else { return }
        searchBarDelegate.searchBarChangeObserver = viewModel.searchBarDidEditing
        
        viewModel.presentAddLocation
            .observe(on: DispatchQueue.main)
            .bind(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.presentPlaceAddMap()
            })
            .disposed(by: disposeBag)
        
        viewModel.attributeView
            .observe(on: DispatchQueue.main)
            .bind(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.attributeView()
            })
            .disposed(by: disposeBag)
        
        viewModel.locationRelay
            .observe(on: DispatchQueue.main)
            .bind(onNext: { [weak self] places in
                guard let self = self else { return }
                self.locationSearchBar.scopeButtonTitles = places.map { $0.name }
            })
            .disposed(by: disposeBag)
        
        viewModel.presentSelectPhoto
            .observe(on: DispatchQueue.main)
            .bind { [weak self] _ in
                guard let self = self else { return }
                self.presentPhotoPicker()
            }
            .disposed(by: disposeBag)
        
        viewModel.searchingLocations
            .observe(on: DispatchQueue.main)
            .bind { [weak self] places in
                guard let self = self else { return }
                if places.count > 0 {
                    self.searchTableDataSource.updatePlaces(from: places)
                    self.searchTableView.reloadData()
                    self.searchTableView.alpha = 1
                } else {
                    self.searchTableView.alpha = 0
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.updateThumbnailImage
            .observe(on: DispatchQueue.main)
            .bind { [weak self] imageData in
                guard let self = self else { return }
                DispatchQueue(label: "serial").async {
                    let image = UIImage(data: imageData)
                    DispatchQueue.main.async {
                        self.imageView.image = image
                    }
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.updateSelectedPlace
            .observe(on: DispatchQueue.main)
            .bind { [weak self] placeName in
                guard let self = self else { return }
                self.locationSearchBar.text = placeName
            }
            .disposed(by: disposeBag)
        
        viewModel.uploadSuccess
            .observe(on: DispatchQueue.main)
            .bind { [weak self] visitDTO in
                guard let self = self else { return }
                self.uploadDismiss(dto: visitDTO)
            }
            .disposed(by: disposeBag)
        
        viewModel.noticeMessage
            .observe(on: DispatchQueue.main)
            .bind { [weak self] lacking in
                guard let self = self else { return }
                self.noticeError(lacking: lacking)
            }
            .disposed(by: disposeBag)
    }
    
    private func presentPlaceAddMap() {
        let viewController = PlaceAddMapBuilder().build()
        viewController.presentableWriteView = self
        present(viewController, animated: true)
    }
    
    private func uploadDismiss(dto: VisitDTO) {
        presentableMainView?.dismissCompleteUpload(dto: dto)
        dismiss(animated: true)
    }
    
    private func noticeError(lacking: LackingInfo) {
        var message = ""
        switch lacking {
        case .upload:
            message = "업로드에 실패하였습니다."
        case .place:
            message = "장소를 선택해주세요."
        case .title:
            message = "제목을 입력해주세요."
        case .photo:
            message = "사진을 선택해주세요."
        }
        let alertView = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        self.present(alertView, animated: true)
    }
    
    private func attributeView() {
        searchTableView.dataSource = searchTableDataSource
        searchTableView.delegate = searchTableDataSource
        searchTableDataSource.tappedRelay = viewModel?.searchTableCellDidTapped
        searchTableView.alpha = 0
        searchTableView.backgroundColor = .systemGray5
        registerTapEvent()
    }
    
    private func registerTapEvent() {
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(buttonTapped)))
        imageView.isUserInteractionEnabled = true
    }
    
    @objc func buttonTapped(sender: UITapGestureRecognizer) {
        viewModel?.tappedAddImageButton.accept(value: ())
    }
    
    private func presentPhotoPicker() {
        let imageViewController = UIImagePickerController()
        delegate.imageRelay = viewModel?.postImageData
        imageViewController.delegate = delegate
        let alert = UIAlertController(title: "사진업로드", message: "방식을 선택해주세요.", preferredStyle: .alert)
        let takePhotoAction = UIAlertAction(title: "촬영하기", style: .default) { action in
            imageViewController.sourceType = .camera
            self.present(imageViewController, animated: true)
        }
        let photoAction = UIAlertAction(title: "가져오기", style: .default) { action in
            imageViewController.sourceType = .photoLibrary
            self.present(imageViewController, animated: true)
        }
        alert.addAction(takePhotoAction)
        alert.addAction(photoAction)
        present(alert, animated: false)
    }
}
extension WritePostViewController: WritePostViewPresentable {
    func didPopChildView() {
        viewModel?.didPopChildView.accept(value: ())
    }
}
