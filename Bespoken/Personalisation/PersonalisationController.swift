//
//  PersonalisationController.swift
//  Bespoken
//
//  Created by Vaishak.Iyer on 18/11/18.
//  Copyright © 2018 jagdish.bespoken. All rights reserved.
//

import UIKit

class PersonalisationController: UIViewController {

    //MARK: Declare UIOutlets
    
    @IBOutlet weak var personalTable: UITableView!
    @IBOutlet weak var updateButton: UIButton!
    
    
    //MARK: Declare Variables
    
    var dummyArray = [String]()
    var selectedSegIndex: Int? = 0
    
    //MARK: ViewControl Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        // Do any additional setup after loading the view.
    }
    
    //MARK: Initialisation and UI Setup
    
    func setup(){
        
        dummyArray = ["THE STYLE I LIKE MOST","MY BODY TYPE IS","I VALUE"]
        tableviewCustomisation()
        updateButton.roundCorners(corners: .allCorners, radius: 20)
        
    }
    
    func tableviewCustomisation(){
        
        personalTable.delegate = self
        personalTable.dataSource = self
        
        personalTable.register(UINib(nibName: "PersonalisationCell", bundle: nil), forCellReuseIdentifier: "PersonalisationCell")
        personalTable.register(UINib(nibName: "PersonalisationHeader", bundle: nil), forCellReuseIdentifier: "PersonalisationHeader")
        
        personalTable.tableFooterView = UIView()
        
        Helper.dropShadowOnTableView(table: personalTable)
        
        
        
    }
    
    // MARK: - Segment Action

    @IBAction func segmentPressed(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            selectedSegIndex = 0
            dummyArray = ["THE STYLE I LIKE MOST","MY BODY TYPE IS","I VALUE"]
            break
        case 1:
            selectedSegIndex = 1
            dummyArray = ["BODY SHAPE","BODY PREFERENCES","PERSONALITY"]
            break
        default:
            selectedSegIndex = 2
            dummyArray = ["MY OCCASION DRESSING OPTIONS ARE"]
        }
        
        personalTable.reloadData()
    }
    
}

extension PersonalisationController: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dummyArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if selectedSegIndex == 2{
            return 350
        }else{
        return 170
        }
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableCell(withIdentifier: "PersonalisationHeader") as? PersonalisationHeader
        headerView?.sectionTitle.text = dummyArray[section]
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PersonalisationCell") as? PersonalisationCell
        cell?.segmentIndex = selectedSegIndex
        cell?.selectionStyle = .none
        if selectedSegIndex == 2{
            cell?.dummyArray = ["WEDDING PARTY","BRIDAL TROUSSEAU","COCKTAIL","SEASONAL","RESORT","DAY DATE"]
        }else{
            cell?.dummyArray = ["SENSUAL","ELEGANT","SOPHISTICATED","CREATIVE","IDEAL HOURGLASS"]
        }
        
        return cell!
    }
    
}

