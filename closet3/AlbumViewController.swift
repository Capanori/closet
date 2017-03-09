//
//  AlbumViewController.swift
//  closet3
//
//  Created by KATSUNORI FUKUMOTO on 2017/03/10.
//  Copyright © 2017年 KATSUNORI FUKUMOTO. All rights reserved.
//

import UIKit
import Photos


class AlbumViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // フォトライブラリが使用可能か？
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            
            // フォトライブラリの選択画面を表示
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.present(picker, animated: true, completion: nil)
        }
        
        //写真選択時に呼ばれる
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
            picker.dismiss(animated: true, completion: nil)
            
            print("aaaaaa")
            
            // オリジナル写真データの取得
            if info[UIImagePickerControllerOriginalImage] != nil {
                if let photo: UIImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
                    self.dismiss(animated: true, completion: nil)
                    
                    print("bbbbbbb")

                    
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
                        
                        print("cccccc")

                        
                        
                        // ファイル名:
                        let photoName:String = "cloth1.png"
                        let path = (createPath as NSString).appendingPathComponent(photoName)
                        
                        // 保存
                        do{
                            try photoData.write(to: URL(fileURLWithPath: path), options: .atomic)
                            // 写真表示
                            print("success")
                            
                            let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate //AppDelegateのインスタンスを取得
                            appDelegate.image = photo //appDelegateの変数を操作
                            
                            
                            
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

    }
    
  

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
