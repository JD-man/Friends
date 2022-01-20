//
//  OnboardingViewController.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/20.
//

import UIKit
import SnapKit

class OnboardingViewController: UIViewController {
    
    let pageImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = AssetsImages.onboardingImg1.image
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.backgroundColor = .systemGreen
        pageControl.numberOfPages = 3
        return pageControl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewConfig()
    }
    
    private func viewConfig() {
        view.backgroundColor = .systemBackground
        [pageImageView, pageControl]
            .forEach { view.addSubview($0) }
        
        pageImageView.snp.makeConstraints { make in
            make.width.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(pageImageView.snp.width)
            make.centerY.equalTo(view.safeAreaLayoutGuide)
        }
        
        pageControl.snp.makeConstraints { make in
            make.top.equalTo(pageImageView.snp.bottom).offset(30)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(50)
        }
    }
    
    private func binding() {
        
    }
}
