/*
@Name            : GoodsSearchController
@Author          : Satoshi Haga
@Description     : Controller class for Goods Search Function
@version         : First Create 2013/12/11 Satoshi Haga
*/
public   class GoodsSearchController extends BaseController {


	/** Search Criteria */
	public GoodsCriteria__c criteria{get; set;}

	/** Searching result */
	public List<Goods__c> listGoods{get; set;}

	/** Constructor */
	public GoodsSearchController(){

		super();

		listGoods = new List<Goods__c>();

		//Initialize criteria
		criteria = new GoodsCriteria__c();

	}

	/** Searching Method */
	public void search(){
		listGoods = new GoodsDao().getListDataByCriteria(criteria);

		//
	}

	/** Purchaing Method */
	public void purchaseOrder(){

		List<PurchaseTransaction__c> listPurchase = new List<PurchaseTransaction__c>();

		//For each selected-goods record, create purchase-order record.
		for( Goods__c goods : listGoods){

			if(goods.CheckStatus__c == true){
				//Create each purchase instance, and add this into the list.
				PurchaseTransaction__c req = new PurchaseTransaction__c();

				req.Goods__c = goods.Id;
				req.PuchasedBy__c = loginUsaerInfo.Id;
				req.PuchaseDate__c = date.today();
				req.PurchaseNumber__c = goods.PurchaseAmount__c;
				req.Price__c = goods.StandardPrice__c;
				req.PurchaseType__c = CommonConstants.NORMAL_PURCHASE;

				listPurchase.add(req);
			}
		}

		//Bulk-insert
		if(listPurchase.size() > 0){
			insert listPurchase;
		}

		//Refresh friend list by calling serch method
		search();

		//Add Success Message
		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, CommonConstants.SUCCESS_SUBMIT_FIHISH_TRANSACTION, ''));

	}

}