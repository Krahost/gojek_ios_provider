//
//  ViewExtension.swift
//  GoJekProvider
//
//  Created by Ansar on 20/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

enum Transition {
    
    case top
    case bottom
    case right
    case left
    
    var type: String {
        
        switch self {
        case .top:
            return CATransitionSubtype.fromBottom.rawValue
        case .bottom:
            return CATransitionSubtype.fromTop.rawValue
        case .right:
            return CATransitionSubtype.fromLeft.rawValue
        case .left:
            return CATransitionSubtype.fromRight.rawValue
        }
    }
}

//MARK: - ViewExtension

extension UIView {

    //Show view with animation
    
    func show(with transition: Transition, duration: CFTimeInterval = 0.5, completion: (()->())?) {
        
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = CATransitionType.push
        animation.subtype = CATransitionSubtype(rawValue: transition.type)
        animation.duration = duration
        
        self.layer.add(animation, forKey: CATransitionType.push.rawValue)
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            completion?()
        }
    }
    
    //Set view corner radius with given value
    func setCornerRadiuswithValue(value: CGFloat) {
        self.layer.cornerRadius = value
        self.layer.masksToBounds = true
    }
    
    func setCornerRadius() {
        self.layer.cornerRadius = self.frame.height/2
        self.clipsToBounds  =  true
    }
    
    func setBorderWith(color: UIColor, width: CGFloat) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
        self.layer.masksToBounds = true
    }
    
    func setOneSideCorner(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    //View Press animation
    
    func addPressAnimation(with duration: TimeInterval = 0.2, transform: CGAffineTransform = CGAffineTransform(scaleX: 0.95, y: 0.95)) {
        UIView.animate(withDuration: duration, animations: {
            self.transform = transform
        })
        { (bool) in
            UIView.animate(withDuration: duration, animations: {
                self.transform = .identity
            })
        }
    }
    
    //Top Half Corner in signin & signup
    
    func roundedTop(desiredCurve: CGFloat?) {
        
        let offset:CGFloat =  self.frame.width/(desiredCurve ?? 0.0)
        let bounds: CGRect = self.bounds
        let rectBounds: CGRect = CGRect(x: bounds.origin.x, y: bounds.origin.y, width: bounds.size.width, height: bounds.size.height / 2)
        let rectPath: UIBezierPath = UIBezierPath(rect: rectBounds)
        let ovalBounds: CGRect = CGRect(x:bounds.origin.x - offset / 2,y: bounds.origin.y, width : bounds.size.width + offset, height :bounds.size.height)
        let ovalPath: UIBezierPath = UIBezierPath(ovalIn: ovalBounds)
        rectPath.append(ovalPath)
        let maskLayer: CAShapeLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = rectPath.cgPath
        self.layer.mask = maskLayer
    }
    
    //Set view border
    func setBorder(width: Float, color: UIColor) {
        self.layer.borderWidth = CGFloat(width)
        self.layer.borderColor = color.cgColor
    }
    
    //Dashed Lines
    
    func addDashedBorder(strokeColor: UIColor, lineWidth: CGFloat, isBottomOnly: Bool) {
        self.layoutIfNeeded()
        let strokeColor = strokeColor.cgColor
        
        let shapeLayer: CAShapeLayer = CAShapeLayer()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: isBottomOnly ? 0 : frameSize.height)
        
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: isBottomOnly ? frameSize.height : frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = strokeColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        
        shapeLayer.lineDashPattern = isBottomOnly ? [3,2] : [5,5] // adjust to your liking
        shapeLayer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: isBottomOnly ? shapeRect.height : 0, width: shapeRect.width, height: isBottomOnly ? 0 : shapeRect.height), cornerRadius: self.layer.cornerRadius).cgPath
        
        self.layer.addSublayer(shapeLayer)
    }
    
    // Dismiss view from superview
    func dismissView(with duration: TimeInterval = 0.5, onCompletion completion: (()->Void)?){
        
        UIView.animate(withDuration: duration, animations: {
            self.frame.origin.y += self.frame.height

        }) { (_) in
            self.removeFromSuperview()
            completion?()
        }
    }
    
    func animateToggleAlpha() {
        UIView.animate(withDuration: 0.5) {
            self.alpha = self.alpha == 1 ? 0 : 1
        }
    }
    
    func addSingleLineDash(color: UIColor,width: CGFloat) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = width
        shapeLayer.lineDashPattern = [6,6]
        let path = CGMutablePath()
        path.addLines(between: [CGPoint(x: 0, y: 0),
                                CGPoint(x: self.frame.width, y: 0)])
        shapeLayer.path = path
        layer.addSublayer(shapeLayer)
    }
    
    //Dashed Lines
    func addDashLine(strokeColor: UIColor, lineWidth: CGFloat) {
        self.layoutIfNeeded()
        
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = strokeColor.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        
        shapeLayer.lineDashPattern = [15,5] // adjust to your liking
        shapeLayer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: shapeRect.width, height:shapeRect.height), cornerRadius: self.layer.cornerRadius).cgPath
        
        self.layer.addSublayer(shapeLayer)
    }
    
    func addShadow(radius: CGFloat,color:UIColor) {
        self.layer.cornerRadius = radius
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize.zero
        self.layer.masksToBounds = false
        self.clipsToBounds = false
        self.layer.shadowColor = color.cgColor
    }
    
    func adddropshadow(radius: CGFloat){
        // Shadow and Radius
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 1.0
        self.layer.masksToBounds = false
        self.layer.cornerRadius = radius
    }
    
    func setGradientBackground(colorTop: UIColor, colorBottom: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorBottom.cgColor, colorTop.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.locations = [0, 1]
        gradientLayer.frame = bounds
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func addTransparent(with view: UIView) {
        let transparentView = UIView(frame: self.frame)
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        transparentView.addSubview(view)
        self.addSubview(transparentView)
    }
    
    func addShadow(offset: CGSize, color: UIColor, radius: CGFloat, opacity: Float) {
        layer.masksToBounds = false
        layer.shadowOffset = offset
        layer.shadowColor = color.cgColor
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        
        let backgroundCGColor = backgroundColor?.cgColor
        backgroundColor = nil
        layer.backgroundColor =  backgroundCGColor
    }
}


//MARK: - RoundView

class RoundedView: UIView {
    
    var centerImageView: UIImageView!
    var centerImage: UIImage!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupView()
    }
    
    private func setupView() {
        if let image = centerImage {
            
            self.centerImageView = UIImageView()
            self.centerImageView.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(centerImageView)
            self.centerImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
            self.centerImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
            self.centerImageView.heightAnchor.constraint(equalToConstant: self.frame.height/2.5).isActive = true
            self.centerImageView.widthAnchor.constraint(equalToConstant: self.frame.height/2.5).isActive = true
            self.centerImageView.image = image
            self.centerImageView.isUserInteractionEnabled = true
            
            if CommonFunction.checkisRTL() {
                self.centerImageView.transform = self.centerImageView.transform.rotated(by: .pi)
            }
        }
        
        DispatchQueue.main.async {
            self.setCornerRadius()
        }
    }
    
    @IBInspectable
    var setCenterImage: UIImage! {
        didSet {
            centerImage = setCenterImage
        }
    }
    
 
}

class CircleView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.clipsToBounds = false
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.clipsToBounds = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.size.height / 2
    }
}

