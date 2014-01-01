/*
@Name            : FriendRequestTriggerHandler
@Author          : Satoshi Haga
@Description     : Trigger executtion class.
@version         : First Create 2013/12/11 Satoshi Haga
*/
public with sharing class FriendRequestTriggerHandler {


	/**
	 * Trigger execution method. This is triggered before updation.
	 * @param old the list of old record
	 * @param updated the list of new record
	 * @param triggerMap the mapping file of new record
	 */
	public void OnBeforeUpdate(FriendRequest__c[] old, FriendRequest__c[] updated, Map<ID, FriendRequest__c> triggerMap){

		FriendDao friDao = new FriendDao();

		List<FriendRequest__c> listFriendReq = new List<FriendRequest__c>();

		for(FriendRequest__c oldReq : old){
			for(FriendRequest__c newReq : updated){

				if(oldReq.Id == newReq.Id
					&& '承認'.equals(newReq.ApprovalFlg__c) && !'承認'.equals(oldReq.ApprovalFlg__c)){

						//Accept request by this user
						listFriendReq.add(newReq);

					}
			}
		}

		//Bulk-insert the list into Friend
		//To advoid duplicate-insert, the function of FriendDao is called
		friDao.createRecordIfNotExisted(listFriendReq);

	}

}