//
//  NoticeView.swift
//  IveBeenHere
//
//  Created by 김동준 on 2022/08/23.
//

import UIKit

final class NoticeViewController: UIViewController {
    var loginButtonTapped: PublishRelay<Void>?
    static let id = String(describing: NoticeViewController.self)
    @IBOutlet weak var kakaoLoginButton: UIButton!
    @IBOutlet weak var noticeMessageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewAttribute()
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        loginButtonTapped?.accept(value: ())
        self.dismiss(animated: true)
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    deinit {
        loginButtonTapped = nil
    }
}
private extension NoticeViewController {
    func viewAttribute() {
        kakaoLoginButton.titleLabel?.numberOfLines = 1
        kakaoLoginButton.titleLabel?.adjustsFontSizeToFitWidth = true
        noticeMessageLabel.numberOfLines = 1
        noticeMessageLabel.adjustsFontSizeToFitWidth = true
    }
}
