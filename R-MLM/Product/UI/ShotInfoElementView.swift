//
//  ShotInfoElementView.swift
//  R-MLM
//
//  Created by GTMAC15 on 6.07.2022.
//

import Foundation
import UIKit


class ShotInfoElementView : UIView {
    
    let valueLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let headerLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let unitLabel:UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 9)
        label.transform = CGAffineTransform(rotationAngle: .pi/2)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    
    func configureUI() {
        
        
        self.addSubview(valueLabel)
        self.addSubview(headerLabel)
        self.addSubview(unitLabel)
        NSLayoutConstraint.activate([

            
            valueLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            valueLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor ),

            valueLabel.rightAnchor.constraint(equalTo: unitLabel.leftAnchor),


            headerLabel.topAnchor.constraint(equalTo: valueLabel.bottomAnchor),
            headerLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),


            unitLabel.rightAnchor.constraint(equalTo: self.rightAnchor),
            unitLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: self.frame.height * 0.2),
            unitLabel.leftAnchor.constraint(equalTo: valueLabel.rightAnchor),
            

        ])
        
    }
    
     init(frame: CGRect , unit : String? , header : String?) {
         super.init(frame: frame)
         unitLabel.text = unit ?? ""
         headerLabel.text = header ?? ""
         configureUI()
         
         
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
