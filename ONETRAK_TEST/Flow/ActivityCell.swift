//
//  ActivityCell.swift
//  ONETRAK_TEST
//
//  Created by Maxim Tolstikov on 09/01/2019.
//  Copyright © 2019 Maxim Tolstikov. All rights reserved.
//

import UIKit

class ActivityCell: UITableViewCell {
    
    let goalText = "Goal reached!"
    
    @IBOutlet weak var goalView: UIView!
    @IBOutlet weak var heightGoalView: NSLayoutConstraint!
    @IBOutlet weak var dateLable: UILabel!
    @IBOutlet weak var allStepsLable: UILabel!
    @IBOutlet weak var targetStepsLable: UILabel!
    @IBOutlet weak var walkStepsLable: UILabel!
    @IBOutlet weak var aerobicStepsLable: UILabel!
    @IBOutlet weak var runStepsLable: UILabel!
    
    let walkLayer = CAShapeLayer()
    let aerobicLayer = CAShapeLayer()
    let runLayer = CAShapeLayer()
    lazy var lable: UILabel = {
        let lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.font = UIFont.italicSystemFont(ofSize: 16)
        lable.adjustsFontSizeToFitWidth = true
        return lable
    }()
    lazy var starImage: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var walkSteps = 0
    var aerobicSteps = 0
    var runSteps = 0
    var allSteps: Int {
        return walkSteps + aerobicSteps + runSteps
    }
    
    func configure(steps: Steps, dateFormater: DateFormatter, target: Int) {

        let date = Date(timeIntervalSince1970: TimeInterval(steps.date))
        let stringDate = dateFormater.string(from: date)
        dateLable.text = stringDate
        
        walkSteps = steps.walk
        aerobicSteps = steps.aerobic
        runSteps = steps.run
        
        walkStepsLable.text = String(walkSteps)
        aerobicStepsLable.text = String(aerobicSteps)
        runStepsLable.text = String(runSteps)
        allStepsLable.text = String(allSteps)
        targetStepsLable.text = String(target)
        
        progressSetup()
        
        if allSteps >= target {
            addGoalInfo()
        } else {
            heightGoalView.constant = 0
        }
    }
    
    private func progressSetup() {
        
        contentView.layer.addSublayer(walkLayer)
        contentView.layer.addSublayer(aerobicLayer)
        contentView.layer.addSublayer(runLayer)
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: contentView.bounds.minX + 16.0,
                              y: contentView.bounds.minY + 52.0))
        path.addLine(to: CGPoint(x: contentView.bounds.maxX - 16.0,
                                 y: contentView.bounds.minY + 52.0))
        walkLayer.path = path.cgPath
        aerobicLayer.path = path.cgPath
        runLayer.path = path.cgPath
        
        walkLayer.lineWidth = CGFloat(5)
        walkLayer.lineCap = .round
        walkLayer.fillColor = nil
        walkLayer.strokeStart = 0
        walkLayer.strokeEnd = 0
        walkLayer.frame = contentView.bounds
        walkLayer.strokeColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)

        aerobicLayer.lineWidth = CGFloat(5)
        aerobicLayer.lineCap = .round
        aerobicLayer.fillColor = nil
        aerobicLayer.strokeStart = 0
        aerobicLayer.strokeEnd = 0
        aerobicLayer.frame = contentView.bounds
        aerobicLayer.strokeColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        
        runLayer.lineWidth = CGFloat(5)
        runLayer.lineCap = .round
        runLayer.fillColor = nil
        runLayer.strokeStart = 0
        runLayer.strokeEnd = 0
        runLayer.frame = contentView.bounds
        runLayer.strokeColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
        
        animationProgress()
    }
    
    private func addGoalInfo() {
        
        heightGoalView.constant = CGFloat(30)
        
        goalView.addSubview(lable)
        goalView.addSubview(starImage)
        
        starImage.image = UIImage(named: "icon_star")
        starImage.leftAnchor
            .constraint(equalTo: goalView.rightAnchor, constant: -46)
            .isActive = true
        
        
        lable.text = goalText
        lable.leftAnchor
            .constraint(equalTo: goalView.leftAnchor, constant: 16)
            .isActive = true
        lable.centerXAnchor.constraint(equalTo: goalView.centerXAnchor)
            .isActive = true
        
        let layer = starImage.layer
        
        layer.removeAnimation(forKey: "rotate")
        
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.toValue = 270
        animation.duration = 1
        
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation.fillMode = CAMediaTimingFillMode.both
        animation.isRemovedOnCompletion = false
        
        layer.add(animation, forKey: "rotate")
    }
    
    // Здесь можно создать группу анимаций и запустить их по времени последовательно,
    // но мне такой эфект понравился больше. Да и пространство для кастомизации довольно
    // обширно.
    
    private func animationProgress() {
        
        let walkEnd = CGFloat(walkSteps) / CGFloat(allSteps)
        let aerobicEnd = (CGFloat(aerobicSteps) / CGFloat(allSteps)) + walkEnd
        
        animationWalk(end: walkEnd)
        animationAerobic(start: walkEnd, end: aerobicEnd)
        animationRun(start: aerobicEnd)
    }
    
    private func animationWalk(end: CGFloat) {
        walkLayer.removeAnimation(forKey: "strokeEnd")
        
        let walkAnimation = CABasicAnimation(keyPath: "strokeEnd")
        walkAnimation.toValue = (end * 100).rounded() / 100
        walkAnimation.duration = 1
        walkAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        walkAnimation.fillMode = CAMediaTimingFillMode.both
        walkAnimation.isRemovedOnCompletion = false
        
        walkLayer.add(walkAnimation, forKey: "strokeEnd")
    }
    
    private func animationAerobic(start: CGFloat, end: CGFloat) {
        aerobicLayer.removeAnimation(forKey: "strokeEnd")
        aerobicLayer.strokeStart = (start * 100).rounded() / 100
        
        let aerobicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        aerobicAnimation.toValue = (end * 100).rounded() / 100
        aerobicAnimation.duration = 1
        aerobicAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        aerobicAnimation.fillMode = CAMediaTimingFillMode.both
        aerobicAnimation.isRemovedOnCompletion = false
        
        aerobicLayer.add(aerobicAnimation, forKey: "strokeEnd")
    }
    
    private func animationRun(start: CGFloat) {
        runLayer.removeAnimation(forKey: "strokeEnd")
        runLayer.strokeStart = (start * 100).rounded() / 100
        
        let runAnimation = CABasicAnimation(keyPath: "strokeEnd")
        runAnimation.toValue = 1
        runAnimation.duration = 1
        runAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        runAnimation.fillMode = CAMediaTimingFillMode.both
        runAnimation.isRemovedOnCompletion = false
        
        runLayer.add(runAnimation, forKey: "strokeEnd")
    }

}
