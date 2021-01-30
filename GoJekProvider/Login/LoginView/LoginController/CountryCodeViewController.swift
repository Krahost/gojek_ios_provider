//
//  CountryCodeViewController.swift
//  GoJekProvider
//
//  Created by apple on 19/03/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

enum PickerType: String {
    
    case countryCode = "CountryCode"
    case countryList = "CountryList"
    case stateList = "StateList"
    case cityList = "CityList"
}

class CountryCodeViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - LocalVariable
    private var filterCountryCodeList = [Country]() {
        didSet {
            if filterCountryCodeList.count == 0 {
                tableView.setBackgroundImageAndTitle(imageName: LoginConstant.searchImage, title: LoginConstant.countryCodeSearchError, tintColor: .lightGray)
            } else {
                tableView.backgroundView = nil
            }
        }
    }
    
    var filterCountryListEntity = [CountryData]() {
        didSet {
            if filterCountryListEntity.count == 0 {
                tableView.setBackgroundImageAndTitle(imageName: LoginConstant.searchImage, title: LoginConstant.countrySearchError, tintColor: .lightGray)
            }else{
                tableView.backgroundView = nil
            }
        }
    }
    
    var filterCityListEntity = [CityData]() {
        didSet {
            if filterCityListEntity.count == 0 {
                tableView.setBackgroundImageAndTitle(imageName: LoginConstant.searchImage, title: LoginConstant.citySearchError, tintColor: .lightGray)
            }else{
                tableView.backgroundView = nil
            }
        }
    }
    
    var isSearch = false
    var pickerType: PickerType = .countryList
    var cityListEntity: [CityData] = []
    var countryListEntity: [CountryData] = []
    private var countryCodeList: [Country] = []
    
    //Closure
    var countryCode: ((Country)->Void)?
    var selectedCountry: ((CountryData)->Void)?
    var selectedCity: ((CityData)->Void)?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        var navItem = UINavigationItem(title: "")
        if pickerType == .countryCode {
            navItem = UINavigationItem(title: LoginConstant.chooseCountryCode.localized)
        }else if pickerType == .stateList {
            navItem = UINavigationItem(title: LoginConstant.chooseState.localized)
        } else if pickerType == .cityList {
            navItem = UINavigationItem(title: LoginConstant.chooseCity.localized)
        } else{
            navItem = UINavigationItem(title: LoginConstant.chooseCountry.localized)
        }
        
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.setCustomFont(name: .medium, size: .x22)]
        let leftBarButton = UIBarButtonItem.init(image: UIImage.init(named: Constant.back), style: .plain, target: self, action: #selector(onbackButtonAction))
        navItem.leftBarButtonItem = leftBarButton
        navigationBar.setItems([navItem], animated: false)
        navigationBar.tintColor = .black
        
        tableView.register(nibName: LoginConstant.CountryListCell)
        countryCodeList = AppUtils.shared.getCountries()
    }
    
    @objc func onbackButtonAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
}

//MARK: - UITableViewDataSource

extension CountryCodeViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if pickerType == .countryCode {
            if checkSearchBarActive() {
                return filterCountryCodeList.count
            }
            return countryCodeList.count
        }else if pickerType == .cityList {
            if checkSearchBarActive() {
                return filterCityListEntity.count
            }
            return cityListEntity.count
        } else{
            if checkSearchBarActive() {
                return filterCountryListEntity.count
            }
            return countryListEntity.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LoginConstant.CountryListCell, for: indexPath) as! CountryListCell
        cell.countryNameLabel.textAlignment = .center
        if pickerType == .countryCode  {
            if isSearch {
                cell.set(values: filterCountryCodeList[indexPath.row])
                cell.countryNameLabel.textAlignment = .left
            }else{
                cell.set(values: countryCodeList[indexPath.row])
                cell.countryNameLabel.textAlignment = .left
            }
        }else if pickerType == .cityList  {
            if isSearch {
                cell.countryNameLabel.text = filterCityListEntity[indexPath.row].city_name
                cell.countryImageView.isHidden = true
            }else{
                cell.countryNameLabel.text = cityListEntity[indexPath.row].city_name
                cell.countryImageView.isHidden = true
            }
        } else{
            if isSearch {
                cell.countryNameLabel.text = filterCountryListEntity[indexPath.row].country_name
                cell.countryImageView.isHidden = true
            }else{
                cell.countryNameLabel.text = countryListEntity[indexPath.row].country_name
                cell.countryImageView.isHidden = true
            }
        }
        
        return cell
    }
}

//MARK: - UITableViewDelegate

extension CountryCodeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if pickerType == .countryCode {
            if countryCodeList.count>indexPath.row {
                if isSearch {
                    countryCode?(filterCountryCodeList[indexPath.row])
                    
                }else{
                    countryCode?(countryCodeList[indexPath.row])
                    
                }
                dismiss(animated: true, completion: nil)
            }
        }else if pickerType == .cityList {
            if cityListEntity.count>indexPath.row {
                if isSearch {
                    selectedCity?(filterCityListEntity[indexPath.row])
                    
                }else{
                    selectedCity?(cityListEntity[indexPath.row])
                    
                }
                dismiss(animated: true, completion: nil)
            }
        }else{
            if countryListEntity.count>indexPath.row {
                if isSearch {
                    selectedCountry?(filterCountryListEntity[indexPath.row])
                    
                }else{
                    selectedCountry?(countryListEntity[indexPath.row])
                    
                }
                dismiss(animated: true, completion: nil)
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

//MARK: - UISearchBarDelegate

extension CountryCodeViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        if pickerType == .countryCode {
            filterCountryCodeList = countryCodeList.filter({ ($0.name+$0.code+$0.dial_code).lowercased().contains(searchText.lowercased())})
            tableView.reloadData()
        }
        else if pickerType == .cityList {
            filterCityListEntity = cityListEntity.filter({ ($0.city_name ?? String.Empty).lowercased().contains(searchText.lowercased())})
            tableView.reloadData()
        }
        else{
            filterCountryListEntity = countryListEntity.filter({ ($0.country_name ?? String.Empty).lowercased().contains(searchText.lowercased())})
            tableView.reloadData()
        }
    }
    func checkSearchBarActive() -> Bool {
        if searchBar.isFirstResponder && searchBar.text != "" {
            
            isSearch = true
            return true
        }else {
            isSearch = false
            return false
        }
    }
    
}
