/*
@Name            : UserDetailExtension
@Author          : Satoshi Haga
@Description     : Extension class for User Detail Page
@version         : First Create 2013/12/11 Satoshi Haga
*/
public   class GoodsDetailExtension extends BaseController {

	/** Target goods */
	public Goods__c goods{set;get;}

	/** Constructor */
    public GoodsDetailExtension(ApexPages.StandardController controller) {

    	//Call constructor of super class
		super();

		//Save target instance as member variable
		goods = (Goods__c)controller.getRecord();
	}

	/** Purchaing Method */
	public void purchaseOrder(){

		PurchaseTransaction__c purchase = new PurchaseTransaction__c();

		purchase.Goods__c = goods.Id;
		purchase.PuchasedBy__c = loginUsaerInfo.Id;
		purchase.PuchaseDate__c = date.today();
		purchase.PurchaseNumber__c = goods.PurchaseAmount__c;
		purchase.Price__c = goods.StandardPrice__c;
		purchase.PurchaseType__c = CommonConstants.NORMAL_PURCHASE;

		//Add it into database.
		insert purchase;

		//Add Success Message
		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, CommonConstants.SUCCESS_SUBMIT_FIHISH_TRANSACTION, ''));

	}


}