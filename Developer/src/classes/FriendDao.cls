/*
@Name            : FriendDao
@Author          : Satoshi Haga
@Description     : Data Access Class for Friend__c
@version         : First Create 2013/12/11 Satoshi Haga
*/
public with sharing class FriendDao extends BaseDao{

  	/**
   	* Constructor
   	*/
  	public FriendDao(){
    	super(new Friend__c().getSObjectType());
  	}

	/** Creating Method. This method creates a record only when not existing */
	public void createRecordIfNotExisted(List<FriendRequest__c> listApprovedRequest){

		//To avoid gabana-limit, only add into the list in loop.
		//Bulk-insert after that.
		List<Friend__c> listAdd = new List<Friend__c>();

		for(FriendRequest__c  approvedRequest :  listApprovedRequest){

			ID pId1 = approvedRequest.RequestingUserInformation__c;
			ID pId2 = approvedRequest.RelatedUserInformation__c;

			List<Friend__c> check1 = [select id from Friend__c where Friend__c = :pId1 AND User__c = :pId2];
			List<Friend__c> check2 = [select id from Friend__c where Friend__c = :pId2 AND User__c = :pId1];

			//insert record only when there is no data having the same information
			if(check1 == null || check1.size() == 0){

				Friend__c newRec = new Friend__c();
				newRec.Friend__c = pId1;
				newRec.User__c = pId2;

				listAdd.add(newRec);
			}

			//insert record only when there is no data having the same information
			if(check2 == null || check2.size() == 0){

				Friend__c newRec = new Friend__c();
				newRec.Friend__c = pId2;
				newRec.User__c = pId1;

				listAdd.add(newRec);
			}
		}

		//Bulk-insert
		insert listAdd;

	}


}