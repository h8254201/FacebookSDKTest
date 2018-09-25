//
//  ViewController.swift
//  testFB
//
//  Created by larvata_ios on 2018/9/12.
//  Copyright © 2018年 dishrank. All rights reserved.
//

import UIKit
import FBSDKPlacesKit
import SVProgressHUD

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var placesManager = FBSDKPlacesManager()
    var locManager = CLLocationManager()
    var cursorString = ""
    @IBOutlet weak var searchTermText: UITextField!
    @IBOutlet weak var dataTableView: UITableView!
    @IBOutlet weak var categorySwitch: UISwitch!
    var dataArray = Array<Dictionary<String,Any>>()

    override func viewDidLoad() {
        super.viewDidLoad()
        locManager.requestWhenInUseAuthorization()
        dataTableView.rowHeight = UITableViewAutomaticDimension
        dataTableView.estimatedRowHeight = 50
        dataTableView.delegate = self
        dataTableView.dataSource = self
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func next(_ sender: Any) {
        SVProgressHUD.show()
        
        var categories = [String]()
        if categorySwitch.isOn {
            categories = ["FOOD_BEVERAGE"]
        }
        if cursorString != "" {

            let graphRequest = placesManager.placeSearchRequest(for: locManager.location,
                                                                searchTerm: searchTermText.text,
                                                                categories: categories,
                                                                fields: [FBSDKPlacesFieldKeyPhone,
                                                                         FBSDKPlacesFieldKeyAbout,
                                                                         FBSDKPlacesFieldKeyName,
                                                                         FBSDKPlacesFieldKeyCoverPhoto,
                                                                         FBSDKPlacesFieldKeyLocation,
                                                                         FBSDKPlacesFieldKeyPlaceID,
                                                                         FBSDKPlacesFieldKeyCategories],
                                                                distance: 5000,
                                                                cursor: cursorString)

            _ = graphRequest?.start(completionHandler: { (connection, result, error) in
                if let resultDic = result as? Dictionary<String,Any> {
                    if let dataArray = resultDic["data"] as? Array<Dictionary<String,Any>> {
                        self.dataArray = dataArray
                        DispatchQueue.main.async {
                            self.dataTableView.reloadData()
                            SVProgressHUD.dismiss()
                        }
                        for data in dataArray {
                            let name = data["name"]
                            print(name)
                        }
                    }
                    if let paging = resultDic["paging"] as? Dictionary<String,Any>,
                        let cursors = paging["cursors"] as? Dictionary<String,Any>,
                        let cursorString = cursors["after"] as? String {
                        self.cursorString = cursorString
                    } else {
                        self.cursorString = ""
                    }
                }
            })


//            placesManager.generatePlaceSearchRequest(forSearchTerm: searchTermText.text,
//                                                     categories: categories,
//                                                     fields: [FBSDKPlacesFieldKeyPhone,
//                                                              FBSDKPlacesFieldKeyAbout,
//                                                              FBSDKPlacesFieldKeyName,
//                                                              FBSDKPlacesFieldKeyCoverPhoto,
//                                                              FBSDKPlacesFieldKeyLocation,
//                                                              FBSDKPlacesFieldKeyCategories],
//                                                     distance: 5000,
//                                                     cursor: cursorString) { (graphRequest, location, error) in
//                                                        if (graphRequest != nil) {
//                                                            _ = graphRequest?.start(completionHandler: { (connection, result, error
//                                                                ) in
//                                                                if let resultDic = result as? Dictionary<String,Any> {
//                                                                    if let dataArray = resultDic["data"] as? Array<Dictionary<String,Any>> {
//                                                                        self.dataArray = dataArray
//                                                                        DispatchQueue.main.async {
//                                                                            self.dataTableView.reloadData()
//                                                                            SVProgressHUD.dismiss()
//                                                                        }
//                                                                        for data in dataArray {
//                                                                            let name = data["name"] as! String
//                                                                            print(name)
//
//                                                                        }
//                                                                    }
//                                                                    if let paging = resultDic["paging"] as? Dictionary<String,Any>,
//                                                                        let cursors = paging["cursors"] as? Dictionary<String,Any>,
//                                                                        let cursorString = cursors["after"] as? String {
//                                                                        self.cursorString = cursorString
//                                                                    } else {
//                                                                        self.cursorString = ""
//                                                                    }
//                                                                }
//
//                                                            })
//                                                        }
//            }
        }
    }
    @IBAction func local(_ sender: Any) {
        searchTermText.endEditing(true)
        SVProgressHUD.show()


        var categories = [String]()
        if categorySwitch.isOn {
            categories = ["FOOD_BEVERAGE"]
        }

        let graphRequest = placesManager.placeSearchRequest(for: locManager.location,
                                                            searchTerm: searchTermText.text,
                                                            categories: categories,
                                                            fields: [FBSDKPlacesFieldKeyPhone,
                                                                     FBSDKPlacesFieldKeyAbout,
                                                                     FBSDKPlacesFieldKeyName,
                                                                     FBSDKPlacesFieldKeyCoverPhoto,
                                                                     FBSDKPlacesFieldKeyLocation,
                                                                     FBSDKPlacesFieldKeyCategories],
                                                            distance: 5000,
                                                            cursor: nil)

        _ = graphRequest?.start(completionHandler: { (connection, result, error) in
            if let resultDic = result as? Dictionary<String,Any> {
                if let dataArray = resultDic["data"] as? Array<Dictionary<String,Any>> {
                    self.dataArray = dataArray
                    DispatchQueue.main.async {
                        self.dataTableView.reloadData()
                        SVProgressHUD.dismiss()
                    }
                    for data in dataArray {
                        let name = data["name"] as! String
                        print(name)

                    }
                }
                if let paging = resultDic["paging"] as? Dictionary<String,Any>,
                    let cursors = paging["cursors"] as? Dictionary<String,Any>,
                    let cursorString = cursors["after"] as? String {
                    self.cursorString = cursorString
                } else {
                    self.cursorString = ""
                }
            }




        })


//        placesManager.generatePlaceSearchRequest(forSearchTerm: searchTermText.text,
//                                                 categories: categories,
//                                                 fields: [FBSDKPlacesFieldKeyPhone,
//                                                          FBSDKPlacesFieldKeyAbout,
//                                                          FBSDKPlacesFieldKeyName,
//                                                          FBSDKPlacesFieldKeyCoverPhoto,
//                                                          FBSDKPlacesFieldKeyLocation,
//                                                          FBSDKPlacesFieldKeyCategories],
//                                                 distance: 5000,
//                                                 cursor: nil) { (graphRequest, location, error) in
//                                                    if (graphRequest != nil) {
//                                                        _ = graphRequest?.start(completionHandler: { (connection, result, error
//                                                            ) in
//                                                            if let resultDic = result as? Dictionary<String,Any> {
//                                                                if let dataArray = resultDic["data"] as? Array<Dictionary<String,Any>> {
//                                                                    self.dataArray = dataArray
//                                                                    DispatchQueue.main.async {
//                                                                        self.dataTableView.reloadData()
//                                                                        SVProgressHUD.dismiss()
//                                                                    }
//                                                                    for data in dataArray {
//                                                                        let name = data["name"] as! String
//                                                                        print(name)
//
//                                                                    }
//                                                                }
//                                                                if let paging = resultDic["paging"] as? Dictionary<String,Any>,
//                                                                    let cursors = paging["cursors"] as? Dictionary<String,Any>,
//                                                                    let cursorString = cursors["after"] as? String {
//                                                                    self.cursorString = cursorString
//                                                                } else {
//                                                                    self.cursorString = ""
//                                                                }
//                                                            }
//
//                                                        })
//                                                    }
//        }
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DemoTableviewCell
        let dataDic = dataArray[indexPath.row]
        cell.categoriesText.text = ""
        cell.restNameLabel.text = dataDic["name"] as? String
        let categories = dataDic["category_list"] as? Array<Dictionary<String,Any>> ?? []
        for category in categories {
            cell.categoriesText.text = cell.categoriesText.text + "\n" + (category["name"] as! String)
        }
        return cell
    }
}

class DemoTableviewCell: UITableViewCell {
    @IBOutlet weak var restNameLabel: UILabel!
    @IBOutlet weak var categoriesText: UITextView!
}
