//
//  Progressview.swift
//  GoJekProvider
//
//  Created by Rajes on 09/04/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

protocol ProgressViewDelegate: class {
    
    func finishedProgress()
}

class Progressview: UIView {
    
    //MARK: - LocalVariable
    let timeLeftShapeLayer = CAShapeLayer()
    let bgShapeLayer = CAShapeLayer()
    var timeLeft: TimeInterval?
    var endTime: Date?
    var timeLabel =  UILabel()
    var timer: Timer!
    let strokeIt = CABasicAnimation(keyPath: "strokeEnd")
    
    weak var delegate: ProgressViewDelegate?
    
    var timeLeftValue: Double? = 60 {
          didSet {
              simpleShape()
          }
      }
    
    
    private var persistentAnimations: [String: CAAnimation] = [:]
    private var persistentSpeed: Float = 0.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        simpleShape()
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        simpleShape()
        commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let circleRadius = frame.size.width / 2.5
        bgShapeLayer.path = UIBezierPath(arcCenter: CGPoint(x: frame.width/2 , y: frame.height/2), radius:
            circleRadius, startAngle: 270.degToRadians, endAngle: -90.degToRadians, clockwise: false).cgPath
        timeLeftShapeLayer.path = UIBezierPath(arcCenter: CGPoint(x: frame.width/2 , y: frame.height/2), radius:
            circleRadius, startAngle: 270.degToRadians, endAngle: -90.degToRadians, clockwise: false).cgPath
        timeLabel.frame = bounds
    }
    
    func commonInit() {
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: UIApplication.willEnterForegroundNotification, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func didBecomeActive() {
            strokeIt.fromValue = (timeLeft ?? 0.00) / 60
            strokeIt.duration = timeLeft ?? 0
            print("active \(Int(timeLeft ?? 0))")
            // add the animation to your timeLeftShapeLayer
            DispatchQueue.main.async {
            self.timeLeftShapeLayer.add(self.strokeIt, forKey: nil)
            }
    }
}

//MARK: - LocalMethod

extension Progressview {
    
    func simpleShape() {
        
        
        drawBgShape()
        drawTimeLeftShape()
        addTimeLabel()
        
        strokeIt.fromValue = 1
        strokeIt.toValue = 0
        strokeIt.duration = timeLeftValue ?? 60
        
        // add the animation to your timeLeftShapeLayer
        DispatchQueue.main.async {
            self.timeLeftShapeLayer.add(self.strokeIt, forKey: nil)
        }
        timeLeft = timeLeftValue ?? 60

        // define the future end time by adding the timeLeft to now Date()
        endTime = Date().addingTimeInterval(timeLeft!)
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    private func drawBgShape() {
        
        bgShapeLayer.path = UIBezierPath(arcCenter: CGPoint(x: frame.width/2 , y: frame.height/2), radius:
            100, startAngle: 270.degToRadians, endAngle: -90.degToRadians, clockwise: false).cgPath
        bgShapeLayer.strokeColor = UIColor.xuberColor.withAlphaComponent(0.2).cgColor
        bgShapeLayer.fillColor = UIColor.clear.cgColor
        bgShapeLayer.lineWidth = 2
        
        let layer = CAGradientLayer()
        layer.frame = bgShapeLayer.frame
        layer.colors = [UIColor.red.cgColor, UIColor.black.cgColor]
        bgShapeLayer.addSublayer(layer)
        self.layer.addSublayer(bgShapeLayer)
    }
    
    private func drawTimeLeftShape() {
        timeLeftShapeLayer.path = UIBezierPath(arcCenter: CGPoint(x: frame.width/2 , y: frame.height/2), radius:
            100, startAngle: 270.degToRadians, endAngle: -90.degToRadians, clockwise: false).cgPath
        timeLeftShapeLayer.strokeColor = UIColor.xuberColor.cgColor
        timeLeftShapeLayer.fillColor = UIColor.clear.cgColor
        timeLeftShapeLayer.lineCap = CAShapeLayerLineCap.round
        timeLeftShapeLayer.lineWidth = 8
        timeLeftShapeLayer.masksToBounds = false
        
        let layer = CAGradientLayer()
        layer.frame = timeLeftShapeLayer.frame
        layer.colors = [UIColor.xuberColor.cgColor, UIColor.white.cgColor]
        timeLeftShapeLayer.addSublayer(layer)
        self.layer.addSublayer(timeLeftShapeLayer)
    }
    
    private func addTimeLabel() {
        timeLabel.removeFromSuperview()
        timeLabel = UILabel(frame: CGRect(x: 0 ,y: (frame.height/2) - 25, width: 100, height: 50))
        timeLabel.font = .setCustomFont(name: .medium, size: .x18)
        timeLabel.textColor = .xuberColor
        timeLabel.textAlignment = .center
        timeLabel.text = timeLeft?.time
        addSubview(timeLabel)
    }
    
    func removeTimer() {
        if let _ = timer {
            timer.invalidate()
            timer = nil
        }
    }
}

//MARK: - IBAction

extension Progressview {
    
    @objc func updateTime() {
        if Int(timeLeft!) > 0 {
            timeLeft = endTime?.timeIntervalSinceNow ?? 0
            timeLabel.text = timeLeft?.time
        }
        else {
            timeLabel.text = "00:00"
            removeTimer()
            if let _ = delegate {
                delegate?.finishedProgress()
            }
        }
    }
}

//MARK: - TimeInterval

extension TimeInterval {
    
    var time: String {
        return String(format:"%02d:%02d", Int(self/60), Int(ceil(truncatingRemainder(dividingBy: 60))))
    }
}

