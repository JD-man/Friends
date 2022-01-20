//
//  PhoneAuthViewController.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/18.
//

import UIKit
import RxSwift
import RxCocoa

class PhoneAuthViewController: UIViewController {
    
    let testLabel: UILabel = {
        let label = UILabel()        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AssetsColors.success.color
    }
}
