//
//  threeViewController.swift
//  Transition
//
//  Created by yesway on 16/9/26.
//  Copyright © 2016年 joker. All rights reserved.
//

import UIKit

class threeViewController: UIViewController {

    var imageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = UIImage(named: "1")
        // Do any additional setup after loading the view.
        imageView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        view.addSubview(imageView)
        
        view.backgroundColor = #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: true, completion: nil)
    }

}
extension threeViewController: PhotoBrowserDismissDelegate {
    /// 解除转场的图像视图（包含起始位置）
    func imageViewForDismiss() -> UIImageView {
        return imageView
    }
    /// 解除转场的图像索引
    func indexPathForDismiss() -> NSIndexPath {
        return NSIndexPath(index: 1)
    }
}
