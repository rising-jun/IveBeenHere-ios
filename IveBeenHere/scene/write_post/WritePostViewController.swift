//
//  WritePostViewController.swift
//  IveBeenHere
//
//  Created by 김동준 on 2022/08/24.
//

import UIKit

final class WritePostViewController: UIViewController {
    static let id = String(describing: WritePostViewController.self)
    private let searchBarDelegate = LocationSearchBarDelegate()
    var viewModel: WriteViewModel? {
        didSet { binding() }
    }
    
    static func instance() -> WritePostViewController {
        return WritePostViewController(nibName: id, bundle: nil)
    }
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var locationSearchBar: UISearchBar!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var contentText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationSearchBar.delegate = searchBarDelegate
    }
}

extension WritePostViewController {
    private func binding() {
        searchBarDelegate.searchBarChangeObserver = viewModel?.searchBarDidEditing
    }
}
