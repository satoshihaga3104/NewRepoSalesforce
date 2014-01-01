/*
@Name            : CampaignGoodsDao
@Author          : Satoshi Haga
@Description     : Data Access Class for CampaignGoods__c
@version         : First Create 2013/12/11 Satoshi Haga
*/
public with sharing class CampaignGoodsDao extends BaseDao{

  /**
   * Constructor
   */
  public CampaignGoodsDao(){
    super(new CampaignGoods__c().getSObjectType());
  }

  	/** Get id list of related goods*/
	public List<CampaignGoods__c> getRelatedGoods(ID campaignId){

		//Create soql string
		ID pId = campaignId;
		String strQuery = 'SELECT ' + getAllColumnString() + ' FROM ' + getObjectName() + ' WHERE Campaign__c = :pId';

		//Execute SOQL
		List<CampaignGoods__c> listCampaignGoods = (List<CampaignGoods__c>)database.query(strQuery);

		if(listCampaignGoods == null || listCampaignGoods.size() == 0){
			//Invalid Id
			return null;
		}

		//Return
		return listCampaignGoods;
	}

}