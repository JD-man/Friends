//
//  BaseActivityIndicator.swift
//  FriendWithSameHobby
//
//  Created by JD_MacMini on 2022/01/28.
//
import UIKit
import SnapKit

final class BaseActivityIndicator: UIView {
    static var shared = BaseActivityIndicator()
    
    private convenience init() {
        self.init(frame: UIScreen.main.bounds)
    }
    
    private var spinnerBehavior: UIDynamicItemBehavior?
    private var animator: UIDynamicAnimator?
    private var imageView: UIImageView?
    private var loaderImageName = ""
    
    private var container = UIView()
    
    func show() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            if self?.imageView == nil {
                self?.setUpView()
                DispatchQueue.main.async {
                    self?.showLoadingActivity()
                }
            }
        }
    }
    
    func hide() {
        DispatchQueue.main.async { [weak self] in
            self?.stopAnimation()
        }
    }
    
    private func setUpView() {
        center = CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY)
        autoresizingMask = [.flexibleTopMargin, .flexibleLeftMargin, .flexibleBottomMargin, .flexibleRightMargin]
        backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        
        // container config
        
        containerConfig()
        // image view config
        self.spinnerBehavior = UIDynamicItemBehavior(items: [imageViewConfig()])
        animator = UIDynamicAnimator(referenceView: self)
    }
    
    private func containerConfig() {
        addSubview(container)
        container.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(self)
            make.width.height.equalTo(100)
        }
        container.addCorner(rad: 10, borderColor: nil)
        container.backgroundColor = AssetsColors.gray2.color
    }
    
    private func imageViewConfig() -> UIImageView {
        let theImage = AssetsImages.friendsIcon.image.withTintColor(AssetsColors.green.color)
        imageView = UIImageView(image: theImage)
        guard let imageView = imageView else {
            return UIImageView()
        }
        addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: self.center.x - 20, y: self.center.y - 20, width: 40, height: 40)
        print(center)
        return imageView
    }
    
    private func showLoadingActivity() {
        startAnimation()
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        windowScene.windows.first?.addSubview(self)
        self.isUserInteractionEnabled = false
    }
    
    private func startAnimation() {
        guard let imageView = imageView,
              let spinnerBehavior = spinnerBehavior,
              let animator = animator else { return }
        
        if !animator.behaviors.contains(spinnerBehavior) {
            spinnerBehavior.addAngularVelocity(5.0, for: imageView)
            animator.addBehavior(spinnerBehavior)
        }
    }
    
    private func stopAnimation() {
        animator?.removeAllBehaviors()
        imageView?.removeFromSuperview()        
        imageView = nil
        container.removeFromSuperview()
        self.removeFromSuperview()
        //UIApplication.shared.endIgnoringInteractionEvents()
        self.isUserInteractionEnabled = true
    }
}
