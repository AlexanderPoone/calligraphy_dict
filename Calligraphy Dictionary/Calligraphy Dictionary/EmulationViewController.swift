//
//  EmulationViewController.swift
//  Calligraphy Dictionary
//
//  Created by Victor Poon on 10/12/2019.
//  Copyright © 2019 SoftFeta. All rights reserved.
//

import UIKit

extension UIView {
  func addDashedBorder() {
    let color = UIColor.red.cgColor

    let shapeLayer:CAShapeLayer = CAShapeLayer()
    let frameSize = self.frame.size
    let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)

    shapeLayer.bounds = shapeRect
    shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
    shapeLayer.fillColor = UIColor.clear.cgColor
    shapeLayer.strokeColor = color
    shapeLayer.lineWidth = 2
    shapeLayer.lineJoin = CAShapeLayerLineJoin.round
    shapeLayer.lineDashPattern = [6,3]
    shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 5).cgPath

    self.layer.addSublayer(shapeLayer)
    }
}

class EmulationViewController: UIViewController {

    private let mTemplates = ["恭喜發財", "鴻禧", "心想事成", "身體健康", "萬事如意", "主恩常在", "家庭福滿門"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
    // 虛線 drag and drop delegate
    // 下面已星collection view (right arrow, left arrow)
        
    }

}
