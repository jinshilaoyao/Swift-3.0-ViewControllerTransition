//
//  twoViewController.swift
//  Transition
//
//  Created by yesway on 16/9/26.
//  Copyright © 2016年 joker. All rights reserved.
//

import UIKit


extension UIButton: PhotoBrowserPresentDelegate {
    /// 指定 indexPath 对应的 imageView，用来做动画效果
    func imageViewForPresent(indexPath: NSIndexPath) -> UIImageView {
        return self.imageView!
    }
    
    /// 动画转场的起始位置
    func photoBrowserPresentFromRect(indexPath: NSIndexPath) -> CGRect {
//        let rect = self.convertRect(self.frame, toCoordinateSpace: UIApplication.sharedApplication.keyWindow!)
        
        let rect = convert(self.frame, to: UIApplication.shared.keyWindow)
        
        return rect
    }
    
    /// 动画转场的目标位置
    func photoBrowserPresentToRect(indexPath: NSIndexPath) -> CGRect {
        return CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
    }
}

class twoViewController: UIViewController {
    
    private lazy var photoBrowserAnimatopr = PhotoBrowserAnimator()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func tapTransition(_ sender: UIButton, forEvent event: UIEvent) {
        
        let three = threeViewController()
        
        three.modalPresentationStyle = .custom
        
        three.transitioningDelegate = photoBrowserAnimatopr
        
        photoBrowserAnimatopr.setDelegateParams(presentDelegate: sender, indexPath: NSIndexPath(index: 1), dismissDelegate: three)
        
        present(three, animated: true, completion: nil)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
