//
//  ViewController.swift
//  SavePhoto
//

import UIKit
import AVKit
import Photos

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var myImg: UIImageView!
    fileprivate var avpController: AVPlayerViewController!
    fileprivate var playerItem: AVPlayerItem!
    fileprivate var videoPlayer:AVPlayer!
    
    var checktype = "image"
    var videourl: URL!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func takePhotoandvideo(_ sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.mediaTypes = ["public.image", "public.movie"]
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        if let pickedImage = info[.originalImage] as? UIImage
        {
            myImg.isHidden=false;
            checktype = "image"
            myImg.contentMode = .scaleToFill
            myImg.image = pickedImage
        }
        else
        {
            if let nsURL = info[UIImagePickerController.InfoKey.mediaURL] as? NSURL
            {
                myImg.isHidden=true;
                checktype = "video"
                videourl = nsURL as URL
                let video = AVURLAsset(url: (nsURL as URL?)!)
                let avPlayerItem = AVPlayerItem(asset: video)
                self.videoPlayer = AVPlayer(playerItem: avPlayerItem)
                self.avpController = AVPlayerViewController()
                self.avpController.player?.rate = 1.0
                self.avpController.player = self.videoPlayer
                self.avpController.view.frame = self.myImg.bounds
                self.addChild(avpController)
                self.view.addSubview(avpController.view)
                videoPlayer.play()
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func savePhotoandvideo(_ sender: AnyObject) {
        
        if(checktype == "image")
        {
            let imageData = myImg.image!.pngData()
            let compresedImage = UIImage(data: imageData!)
            UIImageWriteToSavedPhotosAlbum(compresedImage!, nil, nil, nil)
            
            let alert = UIAlertController(title: "Saved", message: "Your image has been saved", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            
        }
        else{
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: self.videourl)
            }) { saved, error in
                if saved {
                    let alertController = UIAlertController(title: "Your video was successfully saved", message: nil, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
            
        }
       
        
    }
    
    
}

