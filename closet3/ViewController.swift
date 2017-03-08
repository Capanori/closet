//
//  ViewController.swift
//  closet3
//
//  Created by KATSUNORI FUKUMOTO on 2017/03/08.
//  Copyright © 2017年 KATSUNORI FUKUMOTO. All rights reserved.
//

import UIKit
import Photos
import AVFoundation



class ViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // セッション.
    var mySession : AVCaptureSession!
    // デバイス.
    var myDevice : AVCaptureDevice!
    // 画像のアウトプット.
    var myImageOutput: AVCaptureStillImageOutput!
    
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
            }
    
    @IBAction func Cammera(_ sender: Any) {
        // セッションの作成.
        mySession = AVCaptureSession()
        
        // デバイス一覧の取得.
        let devices = AVCaptureDevice.devices()
        
        // バックカメラをmyDeviceに格納.
        for device in devices! {
            if((device as AnyObject).position == AVCaptureDevicePosition.back){
                myDevice = device as! AVCaptureDevice
            }
        }
        
        // バックカメラからVideoInputを取得.
        let videoInput = try! AVCaptureDeviceInput.init(device: myDevice)
        // セッションに追加.
        mySession.addInput(videoInput)
        
        // 出力先を生成.
        myImageOutput = AVCaptureStillImageOutput()
        
        // セッションに追加.
        mySession.addOutput(myImageOutput)
        
        // 画像を表示するレイヤーを生成.
        let myVideoLayer = AVCaptureVideoPreviewLayer.init(session: mySession)
        myVideoLayer?.frame = self.view.bounds
        myVideoLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        
        // Viewに追加.
        self.view.layer.addSublayer(myVideoLayer!)
        
        // セッション開始.
        mySession.startRunning()
        
        // UIボタンを作成.
        let myButton = UIButton(frame: CGRect(x: 0, y: 0, width: 120, height: 50))
        myButton.backgroundColor = UIColor.red
        myButton.layer.masksToBounds = true
        myButton.setTitle("撮影", for: .normal)
        myButton.layer.cornerRadius = 20.0
        myButton.layer.position = CGPoint(x: self.view.bounds.width/2, y:self.view.bounds.height-50)
        myButton.addTarget(self, action: #selector(onClickMyButton), for: .touchUpInside)
        
        // UIボタンをViewに追加.
        self.view.addSubview(myButton);
    }
    // ボタンイベント.
    func onClickMyButton(sender: UIButton){
        
        // ビデオ出力に接続.
        // let myVideoConnection = myImageOutput.connectionWithMediaType(AVMediaTypeVideo)
        let myVideoConnection = myImageOutput.connection(withMediaType: AVMediaTypeVideo)
        
        // 接続から画像を取得.
        self.myImageOutput.captureStillImageAsynchronously(from: myVideoConnection, completionHandler: {(imageDataBuffer, error) in
            if let e = error {
                print(e.localizedDescription)
                return
            }
            // 取得したImageのDataBufferをJpegに変換.
            let myImageData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: imageDataBuffer!, previewPhotoSampleBuffer: nil)
            // JpegからUIIMageを作成.
            let myImage = UIImage(data: myImageData!)
            // アルバムに追加.
            UIImageWriteToSavedPhotosAlbum(myImage!, nil, nil, nil)
        })
        
        self.dismiss(animated: true, completion: nil);
    }
    
    @IBAction func Album(_ sender: Any) {
        // フォトライブラリが使用可能か？
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            
            // フォトライブラリの選択画面を表示
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.present(picker, animated: true, completion: nil)
        }
    }
    // 写真選択時に呼ばれる
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        picker.dismiss(animated: true, completion: nil)
        
        // オリジナル写真データの取得
        if info[UIImagePickerControllerOriginalImage] != nil {
            if let photo: UIImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
                self.dismiss(animated: true, completion: nil)
                
                
                if let photoData = UIImagePNGRepresentation(photo) {
                    
                    // 保存ディレクトリ: Documents/Photo/
                    let fileManager = FileManager.default
                    let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
                    let directoryName = "test"  // 作成するディレクトリ名
                    let createPath = documentsPath + "/" + directoryName    // 作成するディレクトリ名を含んだフルパス
                    if !fileManager.fileExists(atPath: createPath) {
                        do {
                            try fileManager.createDirectory(atPath: createPath, withIntermediateDirectories: true, attributes: nil)
                        }
                        catch {
                            print("Unable to create directory: \(error)")
                        }
                    }
                    
                    // ファイル名: 現在日時.png
                    let photoName:String = "\(NSDate().description).png"
                    let path = (createPath as NSString).appendingPathComponent(photoName)
                    
                    // 保存
                    do{
                        try photoData.write(to: URL(fileURLWithPath: path), options: .atomic)
                        // 写真表示
                        print("success")
                        
                    }catch{
                        // 保存エラー
                        print("error writing file: \(path)")
                        
                        
                    }
                }
            }
        }
        
        // 写真選択画面を閉じる
        picker.dismiss(animated: true, completion: nil)
    }

    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

