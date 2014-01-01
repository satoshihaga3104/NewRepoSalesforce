/*
@Name            : UserDetailExtension
@Author          : Satoshi Haga
@Description     : Extension class for User Detail Page
@version         : First Create 2013/12/11 Satoshi Haga
*/
public with sharing class CampaignDetailExtension extends BaseController {

	/** Related campaign goods */
	public List<CampaignGoods__c> relatedgoods{set;get;}

	/** Constructor */
    public CampaignDetailExtension(ApexPages.StandardController controller) {
    	//Call constructor of super class
		super();

		relatedgoods = new CampaignGoodsDao().getRelatedGoods(controller.getRecord().Id);
	}

	/** Purchasing Method */
	public void purchaseOrder(){

		for(CampaignGoods__c camPaignGoods : relatedgoods){

			PurchaseTransaction__c purchase = new PurchaseTransaction__c();

			purchase.Goods__c = camPaignGoods.Goods__c;
			purchase.PuchasedBy__c = loginUsaerInfo.Id;
			purchase.PuchaseDate__c = date.today();
			purchase.PurchaseNumber__c = camPaignGoods.RedemptionAmount__c;
			purchase.Price__c = camPaignGoods.SpecialTotalAmount__c;
			purchase.PurchaseType__c = CommonConstants.SPECIAL_PURCHASE;

			insert purchase;

		}

		//Add Success Message
		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, CommonConstants.SUCCESS_SUBMIT_FIHISH_TRANSACTION, ''));


	}
}