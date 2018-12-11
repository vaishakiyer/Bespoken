//
//  PersonalisationController.swift
//  Bespoken
//
//  Created by Vaishak.Iyer on 18/11/18.
//  Copyright © 2018 jagdish.bespoken. All rights reserved.
//

import UIKit
import Alamofire

class PersonalisationController: UIViewController {
    
    //MARK: Declare UIOutlets
    
    @IBOutlet weak var personalTable: UITableView!
    @IBOutlet weak var updateButton: UIButton!
    
    
    //MARK: Declare Variables
    
    var selectedSegIndex: Int? = 0
    var allPersonalisationQuestions : Questionnaire = myQuestions
    
    var tab0Questions : Questionnaire = []
    var tab1Questions : Questionnaire = []
    var tab2Questions : Questionnaire = []
    
    
    var updatedResponse: [PostAnswers] = []
    
    //MARK: ViewControl Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        // Do any additional setup after loading the view.
    }
    
    //MARK: Initialisation and UI Setup
    
    
    func setup(){
        
        getQuestionsAPI()
        sortIntoTabs()
        tableviewCustomisation()
        updateButton.roundCorners(corners: .allCorners, radius: 20)
        createNavbar()
        
        
    }
    func sortIntoTabs() {
        for i in allPersonalisationQuestions{
            switch i.tab{
            case 0:
                tab0Questions.append(i)
            case 1:
                tab1Questions.append(i)
            case 2:
                tab2Questions.append(i)
            default:
                print("Error")
                
            }
        }
    }
    
    func createNavbar(){
        self.navigationController?.navigationBar.isHidden = false
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
    
    @IBAction func updatePreferences(_ sender: Any) {
        print(self.updatedResponse)
        self.updatedResponse .removeAll()
        for i in tab0Questions + tab1Questions + tab2Questions {
            var answerId  : [String] = []
            for j in i.options!{
                if j.archived == true {
                    answerId.append(j.id!)
                }
            }
            if !answerId.isEmpty{
                var newAns = PostAnswers(question: i.id!)
                newAns.answers = answerId
                self.updatedResponse.append(newAns)
            }
        }
        self.postAnswersAPI()
        //        for i in tab1Questions{
        //            var answerId  : [String] = []
        //            for j in i.options!{
        //                if j.archived == true {
        //                    answerId.append(j.id!)
        //                }
        //            }
        //            if !answerId.isEmpty{
        //                var newAns = PostAnswers(question: i.id!)
        //                newAns.answers = answerId
        //                self.updatedResponse.append(newAns)
        //            }
        //        }
        //        for i in tab2Questions{
        //            var answerId  : [String] = []
        //            for j in i.options!{
        //                if j.archived == true {
        //                    answerId.append(j.id!)
        //                }
        //            }
        //            if !answerId.isEmpty{
        //                var newAns = PostAnswers(question: i.id!)
        //                newAns.answers = answerId
        //                self.updatedResponse.append(newAns)
        //            }
        //        }
    }
    @IBAction func segmentPressed(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            selectedSegIndex = 0
        case 1:
            selectedSegIndex = 1
        default:
            selectedSegIndex = 2
        }
        
        personalTable.reloadData()
    }
    
}

extension PersonalisationController: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        switch selectedSegIndex {
        case 0:
            return tab0Questions.count
        case 1:
            return tab1Questions.count
        case 2:
            return tab2Questions.count
        default:
            print("Error in number of sections")
            return 0
        }
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
        switch selectedSegIndex {
        case 0:
            headerView?.sectionTitle.text = tab0Questions[section].title?.uppercased()
        case 1:
            headerView?.sectionTitle.text = tab1Questions[section].title?.uppercased()
        case 2:
            headerView?.sectionTitle.text = tab2Questions[section].title?.uppercased()
        default:
            print("error")
        }
        return headerView
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PersonalisationCell") as? PersonalisationCell
        cell?.segmentIndex = selectedSegIndex
        cell?.selectionStyle = .none
        cell?.delegate = self
        switch selectedSegIndex {
        case 0:
            cell?.answerOptions = self.tab0Questions[indexPath.section].options!
            cell?.question = self.tab0Questions[indexPath.row]
        case 1:
            cell?.answerOptions = self.tab1Questions[indexPath.item].options!
            cell?.question = self.tab1Questions[indexPath.row]
        case 2:
            cell?.answerOptions = self.tab2Questions[indexPath.row].options!
            cell?.question = self.tab2Questions[indexPath.row]
        default:
            print("Error")
        }
        return cell!
    }
    
}
//MARK : - API Calls
extension PersonalisationController {
    func getQuestionsAPI() {
        
        
        Alamofire.request(Router.getQuestions()).responseJSON { (response) in
            switch response.result{
            case .success( _):
                let allQuestions = try? JSONDecoder().decode(Questionnaire.self, from: response.data!)
                myQuestions = allQuestions!
                break
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func postAnswersAPI(){
        
        BSLoader.showLoading("", disableUI: true, image: "Group 376")
        
        var mainDictArr = [NSDictionary]()
        
        for values in updatedResponse{
            
            let tempDict = NSMutableDictionary()
            tempDict["question"] = values.question
            tempDict["answer"] = values.answers
            mainDictArr.append(tempDict)
        }
        
        Alamofire.request(Router.updateUser(answers: mainDictArr)).responseJSON(completionHandler: { (response) in
            
            BSLoader.hide()
            
            switch response.result{
            case.success(let JSON):
                print(JSON)
                
                guard let status = (JSON as? NSDictionary)?.value(forKeyPath: "data.result") as? String else {return}
                
                if status == "success"{
                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                    let nextVC = storyBoard.instantiateViewController(withIdentifier: "TinderSwipeControllerViewController") as? TinderSwipeControllerViewController
                    nextVC?.controlFLow = FlowAnalysis(rawValue: "F1Brand")
                    self.navigationController?.pushViewController(nextVC!, animated: true)
                }else{
                    self.showAlert(message: "Could not update your preferences")
                }
                
            case .failure(let error):
                print(error)
            }
            
        })
        
        
    }
}
extension PersonalisationController : optionsDelegate{
    func didSelectAll(tab: Int, forQuestion: QuestionnaireElement, options: [Option], sender: UITableViewCell) {
        guard let tappedIndex = personalTable.indexPath(for: sender ) else {
            return
        }
        for (index,value) in (tab2Questions[tappedIndex.section].options?.enumerated())!{
            tab2Questions[tappedIndex.section].options?[index].archived = true
        }
        self.personalTable.reloadData()
        
    }
    
    
    
    
    func didSelectOption(forQuestion: QuestionnaireElement, selectedOption: Option, sender: UITableViewCell,tab : Int) {
        
        guard let tappedIndex = personalTable.indexPath(for: sender ) else {
            return
        }
        switch tab {
        case 0:
            for (index,value) in (tab0Questions[tappedIndex.section].options?.enumerated())!{
                if value.id == selectedOption.id{
                    if value.archived == true{
                        tab0Questions[tappedIndex.section].options?[index].archived = false
                    }
                    else {
                        tab0Questions[tappedIndex.section].options?[index].archived = true
                        
                    }
                    break
                }
            }
        case 1:
            for (index,value) in (tab1Questions[tappedIndex.item].options?.enumerated())!{
                if value.id == selectedOption.id{
                    if value.archived == true{
                        tab1Questions[tappedIndex.item].options?[index].archived = false
                    }
                    else {
                        tab1Questions[tappedIndex.item].options?[index].archived = true
                    }
                    break
                }
            }
        case 2:
            for (index,value) in (tab2Questions[tappedIndex.item].options?.enumerated())!{
                
                if value.id == selectedOption.id{
                    if value.archived == true{
                        tab2Questions[tappedIndex.item].options?[index].archived = false
                    }
                }
                else {
                    tab2Questions[tappedIndex.item].options?[index].archived = true
                }
                break
            }
            
            
            
        default:
            print("Error")
        }
        
        self.personalTable.reloadData()
    }
    
}
