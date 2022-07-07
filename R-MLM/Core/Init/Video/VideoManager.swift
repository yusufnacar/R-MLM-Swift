//
//  VideoManager.swift
//  R-MLM
//
//  Created by GTMAC15 on 5.07.2022.
//

import Foundation
import UIKit
import MobileCoreServices




import UIKit
import MobileCoreServices

protocol VideoServiceDelegate {
    func videoDidFinishSaving( url: URL? , error : Error? )
    
}

class VideoService: NSObject {
    
    var delegate: VideoServiceDelegate?
    var id : String?
    
    static let instance = VideoService()
    private override init() {}
    
}

extension VideoService {
    
    private func isVideoRecordingAvailable() -> Bool {
        let front = UIImagePickerController.isCameraDeviceAvailable(.front)
        let rear = UIImagePickerController.isCameraDeviceAvailable(.rear)
        if !front || !rear {
            return false
        }
        guard let media = UIImagePickerController.availableMediaTypes(for: .camera) else {
            return false
        }
        return media.contains(kUTTypeMovie as String)
    }
    
    private func setupVideoRecordingPicker() -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.videoQuality = .typeMedium
        picker.mediaTypes = [kUTTypeMovie as String]
        picker.delegate = self
        return picker
    }
    
    func launchVideoRecorder(in vc: UIViewController, id : String? ,  completion: (() -> ())?) {
        guard isVideoRecordingAvailable() else {
            return }
        
        self.id = id
        let picker = setupVideoRecordingPicker()
        
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone {
            vc.present(picker, animated: true) {
                completion?()
            }
        }
    }
    
    
    private func saveVideo(at mediaUrl: String) {
        let compatible = UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(mediaUrl)
        if compatible {
            UISaveVideoAtPathToSavedPhotosAlbum(mediaUrl, self, #selector(video(videoPath:didFinishSavingWithError:contextInfo:)), nil)
            
        }
    }
    
    @objc func video(videoPath: NSString, didFinishSavingWithError error: NSError?, contextInfo info: AnyObject) {
        
        let videoURL = URL(fileURLWithPath: videoPath as String)
        self.delegate?.videoDidFinishSaving(url: videoURL , error: error)
    }
}

extension VideoService: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {        
        picker.dismiss(animated: true) {

            guard let mediaURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL else { return }

            if let data = NSData(contentsOf: mediaURL) {

                let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
                let documentDirectory = paths[0]
                let docURL = URL(string: documentDirectory)!
                let dataPath = docURL.appendingPathComponent("/mlm")

                if !FileManager.default.fileExists(atPath: dataPath.absoluteString) {
                    do {
                        try FileManager.default.createDirectory(atPath: dataPath.absoluteString, withIntermediateDirectories: true, attributes: nil)
                        //                        self.directoryURL = dataPath
                        print("Directory created successfully-\(dataPath.path)")
                    } catch let error as NSError{
                        print("error creating directory -\(error.localizedDescription)");
                    }
                }


                let outputPath = "\(dataPath.path)/\(self.id ?? "NotFound").MOV"
                data.write(toFile: outputPath, atomically: true)
                self.saveVideo(at: outputPath)


            }

        }

    }
    
}
