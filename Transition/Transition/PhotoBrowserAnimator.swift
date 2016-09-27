//
//  PhotoBrowserAnimator.swift
//  Transition
//
//  Created by yesway on 16/9/26.
//  Copyright © 2016年 joker. All rights reserved.
//

import UIKit

// MARK: - 展现动画协议
protocol PhotoBrowserPresentDelegate: NSObjectProtocol {
    
    /// 指定 indexPath 对应的 imageView，用来做动画效果
    func imageViewForPresent(indexPath: NSIndexPath) -> UIImageView
    
    /// 动画转场的起始位置
    func photoBrowserPresentFromRect(indexPath: NSIndexPath) -> CGRect
    
    /// 动画转场的目标位置
    func photoBrowserPresentToRect(indexPath: NSIndexPath) -> CGRect
}

// MARK: - 解除动画协议
protocol PhotoBrowserDismissDelegate: NSObjectProtocol {
    
    /// 解除转场的图像视图（包含起始位置）
    func imageViewForDismiss() -> UIImageView
    /// 解除转场的图像索引
    func indexPathForDismiss() -> NSIndexPath
}

class PhotoBrowserAnimator: NSObject, UIViewControllerTransitioningDelegate {
    
    fileprivate var isPresented = false
    
//    /// 展现代理
    weak var presentDelegate: PhotoBrowserPresentDelegate?
    /// 解除代理
    weak var dismissDelegate: PhotoBrowserDismissDelegate?
    
    /// 动画图像的索引
    var indexPath: NSIndexPath?
    
    
    /// 设置代理相关属性 － 让代码放在合适的位置
    ///
    /// - parameter presentDelegate: 展现代理对象
    /// - parameter indexPath:       图像索引
    func setDelegateParams(presentDelegate: PhotoBrowserPresentDelegate,
                           indexPath: NSIndexPath,
                           dismissDelegate: PhotoBrowserDismissDelegate) {
        
        self.presentDelegate = presentDelegate
        self.dismissDelegate = dismissDelegate
        self.indexPath = indexPath
    }

    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        isPresented = true
        
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = false
        return self
    }
}
extension PhotoBrowserAnimator: UIViewControllerAnimatedTransitioning {
    // This is used for percent driven interactive transitions, as well as for
    // container controllers that have companion animations that might need to
    // synchronize with the main animation.
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    /// 实现具体的动画效果 - 一旦实现了此方法，所有的动画代码都交由程序员负责
    ///
    /// - parameter transitionContext: 转场动画的上下文 － 提供动画所需要的素材
    /**
     1. 容器视图 － 会将 Modal 要展现的视图包装在容器视图中
     存放的视图要显示－必须自己指定大小！不会通过自动布局填满屏幕
     2. viewControllerForKey: fromVC / toVC
     3. viewForKey: fromView / toView
     4. completeTransition: 无论转场是否被取消，都必须调用
     否则，系统不做其他事件处理！
     */
    
    // This method can only  be a nop if the transition is interactive and not a percentDriven interactive transition.
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let fromVC = transitionContext.viewController(forKey: .from)
        print(fromVC)
        
        let toVC = transitionContext.viewController(forKey: .to)
        print(toVC)
        
        let fromView = transitionContext.view(forKey: .from)
        print(fromView)
        
        let toView = transitionContext.view(forKey: .to)
        print(toView)
        
        isPresented ? presentAnimation(transitionContext: transitionContext) : dismissAnimation(transitionContext: transitionContext)
    }
    
    private func presentAnimation(transitionContext: UIViewControllerContextTransitioning) {
        
        
//        let toView = transitionContext.view(forKey: .to)
//        toView?.alpha = 0.0
//        
//        transitionContext.containerView.addSubview(toView!)
//        UIView.animate(withDuration: 0.5, animations: {
//            toView?.alpha = 1.0
//        }) { (isCompeletion) in
//            transitionContext.completeTransition(true)
//            
//        }
        
        // 判断参数是否存在
        guard let presentDelegate = presentDelegate, let indexPath = indexPath else {
            return
        }
        
        // 1. 目标视图
        // 1> 获取 modal 要展现的控制器的根视图
        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
        // 2> 将视图添加到容器视图中
        transitionContext.containerView.addSubview(toView)
        
        // 2. 获取目标控制器 - 照片查看控制器
        //        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as! twoViewController
        // 隐藏 collectionView
        //        toVC.collectionView.hidden = true
        
        // 3. 图像视图
        let iv = presentDelegate.imageViewForPresent(indexPath: indexPath)
        // 1> 指定图像视图位置
        iv.frame = presentDelegate.photoBrowserPresentFromRect(indexPath: indexPath)
        
        // 2> 将图像视图添加到容器视图
        transitionContext.containerView.addSubview(iv)
        
        toView.alpha = 0
        
        // 4. 开始动画
        UIView.animate(withDuration: transitionDuration(using: transitionContext),
                       animations: { () -> Void in
                        
                        iv.frame = presentDelegate.photoBrowserPresentToRect(indexPath: indexPath)
                        iv.alpha = 0.0
                        toView.alpha = 1
                        
        }) { (_) -> Void in
            
            // 将图像视图删除
            iv.removeFromSuperview()
            // 显示目标视图控制器的 collectioView
            //            toVC.collectionView.hidden = false
            // 告诉系统转场动画完成
            transitionContext.completeTransition(true)
        }

        
        
    }
    
    private func dismissAnimation(transitionContext: UIViewControllerContextTransitioning) {
        
        
//        let fromView = transitionContext.view(forKey: .from)
//        UIView.animate(withDuration: 0.5, animations: {
//            fromView?.alpha = 0.0
//        }) { (isCompeletion) in
//            fromView?.removeFromSuperview()
//            transitionContext.completeTransition(true)
//            
//        }
        
        // guard let 会把属性变成局部变量，后续的闭包中不需要 self，也不需要考虑解包！
        guard let presentDelegate = presentDelegate,
            let dismissDelegate = dismissDelegate else {
                return
        }
        //
        // 1. 获取要 dismiss 的控制器的视图
        let fromView = transitionContext.view(forKey: .from)
        fromView?.removeFromSuperview()
        //
        // 2. 获取图像视图
        let iv = dismissDelegate.imageViewForDismiss()
        // 添加到容器视图
        transitionContext.containerView.addSubview(iv)
          
        // 3. 获取dismiss的indexPath
        let indexPath = dismissDelegate.indexPathForDismiss()
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext),
                       animations: { () -> Void in
                        
                        // 让 iv 运动到目标位置
                        iv.frame = presentDelegate.photoBrowserPresentFromRect(indexPath: indexPath)
                        
        }) { (_) -> Void in
            
            // 将 iv 从父视图中删除
            iv.removeFromSuperview()
            // 告诉系统动画完成
            transitionContext.completeTransition(true)
        }

    }
    
}
