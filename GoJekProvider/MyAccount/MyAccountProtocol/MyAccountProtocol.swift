//
//  MyAccountProtocol.swift
//  GoJekProvider
//
//  Created by apple on 28/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import Alamofire

var myAccountPresenterObject: MyAccountViewToMyAccountPresenterProtocol?

//MARK:- MyAccount Presenter to View

protocol MyAccountPresenterToMyAccountViewProtocol {
    
    func viewProfileDetail(profileEntity: ProfileEntity)
    func providerStatusUpdate(profileEntity: ProfileEntity)
    func updateProfileDetail(profileEntity: ProfileEntity)
    func changePasswordResponse(profileEntity: ProfileEntity)
    func updateCountryListSuccess(countryEntity: CountryEntity)
    func updateResetPasswordSuccess(resetPasswordEntity: ResetPasswordEntity)
    
    //Manage Document
    func updateAddDocumentSuccess(documentEntity: SuccessEntity)
    func updateAddPdfDocumentSuccess(documentEntity: SuccessEntity)
    
    //payment
    func addCardSuccess(addCardResponse: CardEntityResponse)
    func getCardResponse(getCardResponse: CardEntityResponse)
    func deleteCardSuccess(deleteCardResponse: CardEntityResponse)
    func addMoneyToWalletSuccess(walletSuccessResponse: AddAmountEntity)
    
    //Manage Service
    func getServiceSuccess(getServiceEntity: GetServiceEntity)
    func getAdminServiceSuccess(getAdminServiceEntity: GetAdminServiceEntity)
    func getRideTypeSuccess(getRideTypeEntity: GetRideTypeEntity)
    func getAddVehicleSuccess(getAddVehicleEntity: AddVehicleEntity)
    func getCategorySuccess(getCategoryEntity: GetCategoryEntity)
    func getSubCategorySuccess(getSubCategoryEntity: GetSubCategoryEntity)
    func getShopTypeSuccess(getShopTypeEntity: ShopTypeEntity)
    func getXuberServiceSuccess(getXuberServiceEntity: GetXuberServiceEntity)
    func getLogoutServiceSuccess(getLogoutServiceEntity: LogoutEntity)
    func updateLanguageServiceSuccess(updateLanguageEntity: LogoutEntity) 
    func getTransactionList(transactionEntity: TransactionEntity)
    
    func getBankTemplateList(bankTemplateEntity: BankTemplateEntity)
    func addBankDetailList(addBankEntity: LogoutEntity)
    func editBankDetailList(editBankEntity: LogoutEntity)
    
    func getEditVehicleSuccess(editVehicleEntity: AddVehicleEntity)
    
    func getEarningsSuccess(earningEntity: EarningEntity)
    func postAppSettingsResponse(baseEntity: BaseEntity)
    func sendOtpSuccess(sendOtpEntity:sendOtpEntity)
    func verifyOtpSuccess(verifyOtpEntity:VerifyOtpEntity)
    func qrCodeWalletTransferSuccess(successEntity: SuccessEntity)
    func getDeliveryTypeSuccess(getCourierTypeEntity: CourierTypeEntity)
}

extension MyAccountPresenterToMyAccountViewProtocol {
    
    var myAccountPresenter: MyAccountViewToMyAccountPresenterProtocol? {
        get {
            myAccountPresenterObject?.myAccountView = self
            return myAccountPresenterObject
        }
        set(newValue) {
            myAccountPresenterObject = newValue
        }
    }
    
    //payment
    func addCardSuccess(addCardResponse: CardEntityResponse) { return }
    func getCardResponse(getCardResponse: CardEntityResponse) { return }
    func deleteCardSuccess(deleteCardResponse: CardEntityResponse) { return }
    func addMoneyToWalletSuccess(walletSuccessResponse: AddAmountEntity) { return }
    
    func viewProfileDetail(profileEntity: ProfileEntity) { return }
    func providerStatusUpdate(profileEntity: ProfileEntity) { return }
    func updateProfileDetail(profileEntity: ProfileEntity) { return }
    func changePasswordResponse(profileEntity: ProfileEntity) { return }
    
    func updateCountryListSuccess(countryEntity: CountryEntity) { return }
    func updateResetPasswordSuccess(resetPasswordEntity: ResetPasswordEntity) { return }
    func updateAddDocumentSuccess(documentEntity: SuccessEntity) { return }
    func updateAddPdfDocumentSuccess(documentEntity: SuccessEntity) { return }
    
    //Manage Service
    func getServiceSuccess(getServiceEntity: GetServiceEntity) { return }
    func getAdminServiceSuccess(getAdminServiceEntity: GetAdminServiceEntity) { return }
    func getRideTypeSuccess(getRideTypeEntity: GetRideTypeEntity) { return }
    func getAddVehicleSuccess(getAddVehicleEntity: AddVehicleEntity) { return }
    func getCategorySuccess(getCategoryEntity: GetCategoryEntity) { return }
    func getSubCategorySuccess(getSubCategoryEntity: GetSubCategoryEntity) { return }
    func getShopTypeSuccess(getShopTypeEntity: ShopTypeEntity) { return }
    func getXuberServiceSuccess(getXuberServiceEntity: GetXuberServiceEntity) { return }
    func getLogoutServiceSuccess(getLogoutServiceEntity: LogoutEntity) { return }
    func updateLanguageServiceSuccess(updateLanguageEntity: LogoutEntity) { return }
    func getTransactionList(transactionEntity: TransactionEntity) { return }
    func getDeliveryTypeSuccess(getCourierTypeEntity: CourierTypeEntity){return}
    func getBankTemplateList(bankTemplateEntity: BankTemplateEntity) { return }
    func addBankDetailList(addBankEntity: LogoutEntity) { return }
    func getEditVehicleSuccess(editVehicleEntity: AddVehicleEntity) { return }
    func editBankDetailList(editBankEntity: LogoutEntity) { return }
    func getEarningsSuccess(earningEntity: EarningEntity) { return }
    
    func postAppSettingsResponse(baseEntity: BaseEntity) { return }
    func sendOtpSuccess(sendOtpEntity:sendOtpEntity) { return }
    func verifyOtpSuccess(verifyOtpEntity:VerifyOtpEntity) { return }
    func qrCodeWalletTransferSuccess(successEntity: SuccessEntity) { return }
}

//MARK:- MyAccount interactor to presenter

protocol MyAccountInteractorToMyAccountPresenterProtocol {
    
    //Payment
    func addCardSuccess(addCardResponse: CardEntityResponse)
    func getCardResponse(getCardResponse: CardEntityResponse)
    func deleteCardSuccess(deleteCardResponse: CardEntityResponse)
    func addMoneyToWalletSuccess(walletSuccessResponse: AddAmountEntity)
    
    func viewProfileDetail(profileEntity: ProfileEntity)
    func providerStatusUpdate(profileEntity: ProfileEntity)
    func updateProfileDetail(profileEntity: ProfileEntity)
    func changePasswordResponse(profileEntity: ProfileEntity)
    
    func updateCountryListSuccess(countryEntity: CountryEntity)
    func updateResetPasswordSuccess(resetPasswordEntity: ResetPasswordEntity)
    func updateAddDocumentSuccess(documentEntity: SuccessEntity)
    
    //Manage Service
    func getServiceSuccess(getServiceEntity: GetServiceEntity)
    func getAdminServiceSuccess(getAdminServiceEntity: GetAdminServiceEntity)
    func getRideTypeSuccess(getRideTypeEntity: GetRideTypeEntity)
    func getAddVehicleSuccess(getAddVehicleEntity: AddVehicleEntity)
    func getEditVehicleSuccess(editVehicleEntity: AddVehicleEntity)
    func getCategorySuccess(getCategoryEntity: GetCategoryEntity)
    func getSubCategorySuccess(getSubCategoryEntity: GetSubCategoryEntity)
    func getShopTypeSuccess(getShopTypeEntity: ShopTypeEntity)
    func getDeliveryTypeSuccess(getCourierTypeEntity: CourierTypeEntity)
    func getXuberServiceSuccess(getXuberServiceEntity: GetXuberServiceEntity)
    func getLogoutServiceSuccess(getLogoutServiceEntity: LogoutEntity)
    func updateLanguageServiceSuccess(updateLanguageEntity: LogoutEntity)
    func getTransactionList(transactionEntity: TransactionEntity)
    
    func getBankTemplateList(bankTemplateEntity: BankTemplateEntity)
    func addBankDetailList(addBankEntity: LogoutEntity)
    func editBankDetailList(editBankEntity: LogoutEntity)
    func getEarningsSuccess(earningEntity: EarningEntity)
    
    func postAppSettingsResponse(baseEntity: BaseEntity)
    func sendOtpSuccess(sendOtpEntity:sendOtpEntity)
    func verifyOtpSuccess(verifyOtpEntity:VerifyOtpEntity)
    func qrCodeWalletTransferSuccess(successEntity: SuccessEntity)
}


//MARK:- MyAccount presenter to Interactor

protocol MyAccountPresenterToMyAccountInteractorProtocol {
    
    var myAccountPresenter: MyAccountInteractorToMyAccountPresenterProtocol? {get set}
    
    // payment
    func getCard()
    func deleteCard(cardID:Int)
    func addCard(param: Parameters)
    func addMoneyToWallet(param: Parameters)
    
    func getProfileDetail()
    func updateProfileDetail(param: Parameters, imageData: [String : Data]?)
    func changePassword(param: Parameters)
    
    func countryListDetail(param: Parameters)
    func resetPasswordDetail(param: Parameters)
    func addDocumentDetail(param: Parameters, uploadData: [String : Data]?, isTypePDF: Bool)
    
    func getServiceDetail()
    func getAdminServiceDetail()
    func getRideTypeDetail()
    func AddVehicleDetail(param: Parameters,imageData:  [String:Data]?)
    func getCategoryDetail()
    func getSubCategoryDetail(param: Parameters)
    func getShopTypeDetail()
    func getXuberServiceDetail(param: Parameters)
    func getLogoutDetail()
    func updateLanguageDetail(param: Parameters)
    func getTransactionList(param: Parameters,ishideLoader: Bool)
    func getDeliveryTypeDetail()
    func providerStatusUpdate(id: Int, param: Parameters)
    func getBankTemplateList()
    func addBankDetailList(param: Parameters)
    func editBankDetailList(param: Parameters)
    
    func EditVehicleDetail(param: Parameters, imageData: [String : Data]?)
    func EarningDetail(providerId: String)
    
    func postAppSettings(param: Parameters)
    func sendOtp(param: Parameters)
    func verifyOtp(param: Parameters)
    func qrCodeWalletTransfer(param: Parameters)
}

//MARK:- Account View to presenter

protocol MyAccountViewToMyAccountPresenterProtocol {
    
    var myAccountView: MyAccountPresenterToMyAccountViewProtocol? {get set}
    var myAccountInterector: MyAccountPresenterToMyAccountInteractorProtocol? {get set}
    var myAccountRouter: MyAccountPresenterToMyAccountRouterProtocol? {get set}
    
    //payment
    func addCard(param: Parameters)
    func getCard()
    func deleteCard(cardID:Int)
    func addMoneyToWallet(param: Parameters)
    
    func getProfileDetail()
    func updateProfileDetail(param: Parameters, imageData: [String : Data]?)
    func changePassword(param: Parameters)
    
    func countryListDetail(param: Parameters)
    func resetPasswordDetail(param: Parameters)
    func addDocumentDetail(param: Parameters, uploadData: [String : Data]?, isTypePDF: Bool)
    
    func getServiceDetail()
    func getAdminServiceDetail()
    func getRideTypeDetail()
    func AddVehicleDetail(param: Parameters,imageData:  [String:Data]?)
    func getCategoryDetail()
    func getSubCategoryDetail(param: Parameters)
    func getShopTypeDetail()
    func getDeliveryTypeDetail()
    func providerStatusUpdate(id: Int, param: Parameters)
    func getXuberServiceDetail(param: Parameters)
    func getLogoutDetail()
    func updateLanguageDetail(param: Parameters)
    func getTransactionList(param: Parameters,ishideLoader: Bool)
    func getBankTemplateList()
    func addBankDetailList(param: Parameters)
    func editBankDetailList(param: Parameters)
    
    func EditVehicleDetail(param: Parameters, imageData: [String : Data]?)
    func EarningDetail(providerId: String)
    
    func postAppSettings(param: Parameters)
    func sendOtp(param: Parameters)
    func verifyOtp(param: Parameters)
    func qrCodeWalletTransfer(param: Parameters)
}

//MARK:- MyAccount presenter to router

protocol MyAccountPresenterToMyAccountRouterProtocol {
    
    static func createMyAccountModule() -> UIViewController
}
