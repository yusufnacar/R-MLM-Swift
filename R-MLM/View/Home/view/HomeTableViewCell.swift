//
//  HomeTableViewCell.swift
//  R-MLM
//
//  Created by GTMAC15 on 3.07.2022.
//

import Foundation
import UIKit

protocol HomeViewCellProtocol : AnyObject {
    func didPressPlayButton(_ row : Int)
}

class HomeTableViewCell : UITableViewCell {
    
    weak var delegate : HomeViewCellProtocol?
    
    
    class var identifier: String { return String(describing: self) }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        configureConstraint()
        playButton.addTarget(self, action: #selector(didPressed), for: .touchUpInside)

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let backView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    let containerView:UIView = {
        let container = UIView()
        container.contentMode = .scaleAspectFill
        container.translatesAutoresizingMaskIntoConstraints = false
        container.clipsToBounds = true
        return container
    }()

    let stackView: UIView = {
        let stack = UIView()
        stack.contentMode = .scaleAspectFill
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.clipsToBounds = true
        return stack
    }()
    
    
    let segmentLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let pointView: UIView = {
        let pointView = UIView()
        pointView.contentMode = .scaleAspectFill
        pointView.translatesAutoresizingMaskIntoConstraints = false
        pointView.layer.cornerRadius = 35
        pointView.backgroundColor = .purple
        pointView.clipsToBounds = true
        return pointView
    }()
    
    let pointLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let isSuccesLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    let segmentHeaderLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = "Segment"
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    
    let playButton:UIButton = {
        let button = UIButton()
        let img = UIImage(systemName: "play.circle")?.withRenderingMode(.alwaysTemplate)
        button.setImage(img, for: .normal)
        button.layer.cornerRadius = 5.0
        button.layer.borderWidth = 1.0
        button.backgroundColor = UIColor(hex: "#2A2A2AFF")
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    
    
    
    
    @objc func didPressed() {
        delegate?.didPressPlayButton(playButton.tag)
    }
    
    
}

extension HomeTableViewCell {
    func configureUI() {
        backView.layer.borderWidth = 1.0
        backView.layer.cornerRadius = 5.0
        
        
        contentView.addSubview(backView)
    
        backView.addSubview(pointView)
        backView.addSubview(stackView)
        backView.addSubview(playButton)
        pointView.addSubview(pointLabel)
        
        stackView.addSubview(segmentHeaderLabel)
        stackView.addSubview(segmentLabel)
        stackView.addSubview(isSuccesLabel)
    }
    
    func configureConstraint() {
        backView.widthAnchor.constraint(equalTo: contentView.widthAnchor , multiplier: 0.9).isActive = true
        backView.heightAnchor.constraint(equalTo: contentView.heightAnchor , multiplier: 0.9).isActive = true
        backView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive=true
        backView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive=true
        
        pointView.centerYAnchor.constraint(equalTo:self.backView.centerYAnchor).isActive = true
        pointView.leadingAnchor.constraint(equalTo:self.backView.leadingAnchor, constant:10).isActive = true
        pointView.widthAnchor.constraint(equalToConstant:70).isActive = true
        pointView.heightAnchor.constraint(equalToConstant:70).isActive = true
        
        
        stackView.centerYAnchor.constraint(equalTo:self.backView.centerYAnchor).isActive = true
        stackView.centerXAnchor.constraint(equalTo:self.backView.centerXAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: backView.widthAnchor , multiplier: 0.4).isActive = true
        stackView.heightAnchor.constraint(equalToConstant:150).isActive = true
        
        
        pointLabel.centerXAnchor.constraint(equalTo: pointView.centerXAnchor).isActive = true
        pointLabel.centerYAnchor.constraint(equalTo: pointView.centerYAnchor).isActive = true

        segmentHeaderLabel.topAnchor.constraint(equalTo:self.stackView.topAnchor).isActive = true
        segmentHeaderLabel.leadingAnchor.constraint(equalTo:self.stackView.leadingAnchor).isActive = true
        segmentHeaderLabel.trailingAnchor.constraint(equalTo:self.stackView.trailingAnchor).isActive = true
        
        segmentLabel.topAnchor.constraint(equalTo:self.segmentHeaderLabel.bottomAnchor).isActive = true
        segmentLabel.leadingAnchor.constraint(equalTo:self.stackView.leadingAnchor).isActive = true
        segmentLabel.topAnchor.constraint(equalTo:self.segmentHeaderLabel.bottomAnchor).isActive = true
        segmentLabel.leadingAnchor.constraint(equalTo:self.stackView.leadingAnchor).isActive = true
        
        
        isSuccesLabel.topAnchor.constraint(equalTo: segmentLabel.topAnchor, constant: 30).isActive = true
        isSuccesLabel.bottomAnchor.constraint(equalTo: stackView.bottomAnchor).isActive = true
        
        playButton.widthAnchor.constraint(equalToConstant:60).isActive = true
        playButton.heightAnchor.constraint(equalToConstant:60).isActive = true
        playButton.trailingAnchor.constraint(equalTo:self.backView.trailingAnchor, constant:-20).isActive = true
        playButton.centerYAnchor.constraint(equalTo:self.backView.centerYAnchor).isActive = true
    }
}

extension HomeTableViewCell {
    func setShotsData(shot : Shot) {
        self.segmentLabel.text = String(shot.segment )
        self.pointLabel.text = String(shot.point )
        self.isSuccesLabel.text = shot.inOut == true ? "Succesful" : "Failed"
        self.isSuccesLabel.textColor = shot.inOut == true ? UIColor.systemGreen : UIColor.red
    }
}



