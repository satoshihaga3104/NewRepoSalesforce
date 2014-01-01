/*
@Name            : UserInformationTrigger
@Author          : Satoshi Haga
@Description     : Trigger object. This object assign appropriate district to user.
@version         : First Create 2013/12/11 Satoshi Haga
*/
trigger UserInformationTrigger on UserInformation__c (before insert, before update) {

	/** Trigger Execution Class */
    UserInformationTriggerHandler handler = new UserInformationTriggerHandler();


    if(Trigger.isInsert && Trigger.isBefore){

      	/** Before Insert */
        handler.OnBeforeInsert(Trigger.new);

    }else if(Trigger.isUpdate && Trigger.isBefore){

      	/** Before Update */
		handler.OnBeforeUpdate(Trigger.old, Trigger.new, Trigger.newMap);

    }


}