//
//  PulsingView.swift
//  Momento
//
//  Created by Shadin Hussein on 3/4/23.
//

import UIKit

class PulsingView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    //values to create pulse
//    let pulseRed = CGFloat(184.0 / 255.0)
//    let pulseGreen = CGFloat(72.0 / 255.0)
//    let pulseBlue = CGFloat(119.0 / 255.0)
//    let pulseAlpha =CGFloat(119.0 / 255.0)
    
    init() {
        super.init(frame: .zero)
        layer.addSublayer(pulsingLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var animationGroup: CAAnimationGroup = {
           let animationGroup = CAAnimationGroup()
           animationGroup.animations = [expandingAnimation,
                                        fadingAnimation]
           animationGroup.duration = 1.5
           animationGroup.repeatCount = .infinity
           return animationGroup
       }()
       
       private lazy var fadingAnimation: CABasicAnimation = {
           let fadingAnimation = CABasicAnimation(keyPath: "opacity")
           fadingAnimation.fromValue = 1
           fadingAnimation.toValue = 0
           return fadingAnimation
       }()
       
       private lazy var expandingAnimation: CABasicAnimation = {
           let expandingAnimation = CABasicAnimation(keyPath: "transform.scale")
           expandingAnimation.fromValue = 1
           expandingAnimation.toValue = 1.4
           return expandingAnimation
       }()
    
    private let pulsingLayer: CAShapeLayer = circleLayer(color: Constants.pulsingColor)
    
    private static func circleLayer(color:CGColor) -> CAShapeLayer {
        let circleLayer = CAShapeLayer()
        circleLayer.path = Constants.bezierPat.cgPath
        circleLayer.lineWidth = 25
        circleLayer.strokeColor = color
        circleLayer.fillColor = UIColor.clear.cgColor
        
        return circleLayer
    }
    
    private enum Constants {
        static let bezierPat: UIBezierPath = .init(arcCenter: CGPoint.zero, radius: 100, startAngle: -(CGFloat.pi / 2), endAngle: -(CGFloat.pi / 2) + (2 * CGFloat.pi), clockwise: true)
        
        static let pulsingColor: CGColor = UIColor(red: CGFloat(184.0 / 255.0), green: CGFloat(72.0 / 255.0), blue:CGFloat(119.0 / 255.0), alpha: CGFloat(119.0 / 255.0)) as! CGColor
    
    }

}
