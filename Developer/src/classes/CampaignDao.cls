/*
@Name            : CampaignDao
@Author          : Satoshi Haga
@Description     : Data Access Class for Campaign__c
@version         : First Create 2013/12/11 Satoshi Haga
*/
public class CampaignDao extends BaseDao{


  /**
   * Constructor
   */
  public CampaignDao(){
    super(new Campaign__c().getSObjectType());
  }


}