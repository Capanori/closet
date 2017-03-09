//
//  tableViewController.swift
//  closet3
//
//  Created by KATSUNORI FUKUMOTO on 2017/03/09.
//  Copyright © 2017年 KATSUNORI FUKUMOTO. All rights reserved.
//

import UIKit

let sectionTitle = ["トップス","ボトムス"]
let section0 = ["コート","ジャケット","シャツ"]
let section1 = ["スラックス","チノパン","ジーンズ"]
let tableData = [section0,section1]



class tableViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myTableView = UITableView(frame: view.frame, style: .grouped)
        myTableView.delegate = self
        myTableView.dataSource = self
        view.addSubview(myTableView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionData = tableData[section]
        return sectionData.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        let sectionData = tableData[(indexPath as NSIndexPath).section]
        let cellData = sectionData[(indexPath as NSIndexPath).row]
        cell.textLabel?.text = cellData
        return cell
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitle.count
    }

        
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
            return sectionTitle[section]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let title = sectionTitle[indexPath.section]
        let sectionData = tableData[indexPath.section]
        let cellData = sectionData[indexPath.row]
        
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate //AppDelegateのインスタンスを取得
        appDelegate.message = cellData //appDelegateの変数を操作
        self.dismiss(animated: true, completion: nil)

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
