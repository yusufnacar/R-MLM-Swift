//
//  WatermarkViewController.swift
//  R-MLM
//
//  Created by GTMAC15 on 4.07.2022.
//

import UIKit
import AVFoundation



class WatermarkViewController: UIViewController , Storyboarded  {
  
    
// MARK: - VARIABLES
    weak var coordinator : MainCoordinator?
    var shot : Shot?
    var videoUrl : URL?
    var player: AVPlayer?
    
    
    
    // MARK: - DEFINE UI

    let videoViewContainer : UIView = {
        let videoView = UIView()
        videoView.backgroundColor = .white
        videoView.frame = CGRect(x: 0, y: 0, width:UIScreen.main.bounds.width * 0.7 , height: UIScreen.main.bounds.height)

        
        videoView.translatesAutoresizingMaskIntoConstraints = false
        videoView.clipsToBounds = true
        return videoView
    }()
    
    let infoViewContainer : UIView = {
        let info = UIView()
        info.backgroundColor = .white
        info.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width * 0.3 , height: UIScreen.main.bounds.height)

        
        info.translatesAutoresizingMaskIntoConstraints = false
        info.clipsToBounds = true
        return info
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
    

    let segmentLabel : ShotInfoElementView = ShotInfoElementView(frame: CGRect(x: 0, y: 0, width: 200, height: 200), unit: "", header: "Segment")
    let shotPosXLabel : ShotInfoElementView = ShotInfoElementView(frame: CGRect(x: 0, y: 0, width: 200, height: 200), unit: "KM/S", header: "Shot Pos X" )
    let shotPosYLabel : ShotInfoElementView = ShotInfoElementView(frame: CGRect(x: 0, y: 0, width: 200, height: 200), unit: "KM/S", header: "Shot Pos Y")


    override func viewDidLoad() {
        super.viewDidLoad()
        setValues()
        configureUI()
        configureConstraint()
        initializeVideoPlayerWithVideo()
    }

}


// MARK: - Configure UI
extension WatermarkViewController {
    
    func configureConstraint() {
        
        NSLayoutConstraint.activate([
            videoViewContainer.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            videoViewContainer.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.7),
            videoViewContainer.heightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.heightAnchor),
            
            
            
            infoViewContainer.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            infoViewContainer.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.3),
            infoViewContainer.heightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.heightAnchor),
            infoViewContainer.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor),
            
            
            
            
            pointView.centerXAnchor.constraint(equalTo: infoViewContainer.centerXAnchor),
            pointView.topAnchor.constraint(equalTo: infoViewContainer.topAnchor, constant: infoViewContainer.frame.height * 0.1),
            pointView.widthAnchor.constraint(equalToConstant:70),
            pointView.heightAnchor.constraint(equalToConstant:70),
            
            pointLabel.centerXAnchor.constraint(equalTo: pointView.centerXAnchor),
            pointLabel.centerYAnchor.constraint(equalTo: pointView.centerYAnchor),
            
            segmentLabel.centerXAnchor.constraint(equalTo: infoViewContainer.centerXAnchor),
            segmentLabel.topAnchor.constraint(equalTo: pointView.bottomAnchor, constant: infoViewContainer.frame.height * 0.05),
            segmentLabel.widthAnchor.constraint(equalToConstant:infoViewContainer.frame.width * 0.95),
            segmentLabel.heightAnchor.constraint(equalToConstant:infoViewContainer.frame.height * 0.11),
            
            shotPosXLabel.centerXAnchor.constraint(equalTo: infoViewContainer.centerXAnchor),
            shotPosXLabel.topAnchor.constraint(equalTo: segmentLabel.bottomAnchor, constant: infoViewContainer.frame.height * 0.05),
            shotPosXLabel.widthAnchor.constraint(equalToConstant:infoViewContainer.frame.width * 0.95),
            shotPosXLabel.heightAnchor.constraint(equalToConstant:infoViewContainer.frame.height * 0.11),
            
            shotPosYLabel.centerXAnchor.constraint(equalTo: infoViewContainer.centerXAnchor),
            shotPosYLabel.topAnchor.constraint(equalTo: shotPosXLabel.bottomAnchor, constant: infoViewContainer.frame.height * 0.05),
            shotPosYLabel.widthAnchor.constraint(equalToConstant:infoViewContainer.frame.width * 0.95),
            shotPosYLabel.heightAnchor.constraint(equalToConstant:infoViewContainer.frame.height * 0.11),

        ])
    }
    
    func configureUI() {
        
        
        
        self.view.addSubview(videoViewContainer)
        self.view.addSubview(infoViewContainer)
        pointView.addSubview(pointLabel)
        infoViewContainer.addSubview(pointView)
        
        infoViewContainer.addSubview(segmentLabel)
        segmentLabel.translatesAutoresizingMaskIntoConstraints = false
        
        infoViewContainer.addSubview(shotPosXLabel)
        shotPosXLabel.translatesAutoresizingMaskIntoConstraints = false
        
        infoViewContainer.addSubview(shotPosYLabel)
        shotPosYLabel.translatesAutoresizingMaskIntoConstraints = false
        
        infoViewContainer.backgroundColor = UIColor(hex: "#2A2A2AFF")
        videoViewContainer.backgroundColor = .gray
        

    }
}


// MARK: - Set Values

extension WatermarkViewController {
    func setValues() {
        pointLabel.text = String(shot?.point ?? 0)
        let shotPosX = Double(round(10 * (shot?.shotPosX ?? 0)) / 10)
        let shotPosY = Double(round(10 * (shot?.shotPosY ?? 0)) / 10)
        segmentLabel.valueLabel.text =  String(shot?.segment ?? 0)
        shotPosXLabel.valueLabel.text = String(shotPosX)
        shotPosYLabel.valueLabel.text = String(shotPosY)
    }
}


// MARK: - Player
extension WatermarkViewController {
    func initializeVideoPlayerWithVideo() {
        self.player = AVPlayer(url: videoUrl!)
        let layer: AVPlayerLayer = AVPlayerLayer(player: player)
        layer.frame = videoViewContainer.bounds
        layer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoViewContainer.layer.addSublayer(layer)
        player?.play()
    }
}


