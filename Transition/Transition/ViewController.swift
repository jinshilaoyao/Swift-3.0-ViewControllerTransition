//
//  ViewController.swift
//  Transition
//
//  Created by yesway on 16/9/26.
//  Copyright © 2016年 joker. All rights reserved.
//

import UIKit

enum AnimationType: Int {
    case Fade = 1                   //淡入淡出
    case Push = 2                    //推挤
    case Reveal = 3                   //揭开
    case MoveIn = 4                    //覆盖
    case Cube = 5                      //立方体
    case SuckEffect = 6                //吮吸
    case OglFlip = 7                   //翻转
    case RippleEffect = 8              //波纹
    case PageCurl = 9                  //翻页
    case PageUnCurl = 10                //反翻页
    case CameraIrisHollowOpen = 11      //开镜头
    case CameraIrisHollowClose = 12     //关镜头
    case CurlDown = 13                  //下翻页
    case CurlUp = 14                    //上翻页
    case FlipFromLeft = 15              //左翻转
    case FlipFromRight = 16             //右翻转
}

class ViewController: UIViewController {

    var subtype = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        addbgimageWith(imageName: "1")
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        transition(from: self, to: twoViewController(), duration: 0.5, options: .curveEaseIn, animations: {
            
            }) { (isSuccess) in
                
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func addbgimageWith(imageName: String) {
        view.backgroundColor = UIColor.init(patternImage: UIImage(named: imageName)!)
        
    }
    

    @IBAction func tapButton(_ sender: UIButton, forEvent event: UIEvent) {
        
        guard let type = AnimationType(rawValue: sender.tag) else {
            return
        }

        var subtypeString = ""
        
        switch subtype {
        case 0:
            subtypeString = kCATransitionFromLeft
            break
        case 1:
            subtypeString = kCATransitionFromRight
            break
        case 2:
            subtypeString = kCATransitionFromTop
            break
        case  3:
            subtypeString = kCATransitionFromBottom
            break
        default :
            subtypeString = ""
            break
        }
        
        subtype += 1
        if subtype > 3 {
            subtype = 0
        }
        
//        switch type {
//        case .Fade:
//            transition
//
//        }
    }
}

