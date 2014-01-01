/*
@Name            : FriendRequestTrigger
@Author          : Satoshi Haga
@Description     : Trigger object.
@version         : First Create 2013/12/11 Satoshi Haga
*/
trigger FriendRequestTrigger on FriendRequest__c (before update) {

	/** Trigger Execution Class */
    FriendRequestTriggerHandler handler = new FriendRequestTriggerHandler();


	if(Trigger.isUpdate && Trigger.isBefore){

      	/** Before Update */
		handler.OnBeforeUpdate(Trigger.old, Trigger.new, Trigger.newMap);

    }


}