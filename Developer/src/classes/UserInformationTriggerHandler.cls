/*
@Name            : UserInformationTriggerHandler
@Author          : Satoshi Haga
@Description     : Trigger executtion class. This class assign appropriate district to user.
@version         : First Create 2013/12/11 Satoshi Haga
*/
public class UserInformationTriggerHandler{


	/**
	 * Trigger execution method. This is triggered before insertion.
	 * @param newReqs the list of new record
	 */
	public void OnBeforeInsert(UserInformation__c[] newReqs){

		//Synchronize district with zip-code
		for(UserInformation__c userInfo : newReqs){
			//Set appropriate district to each user information record.
			if(userInfo.ZipCode__c != null && !''.equals(userInfo.ZipCode__c)){
				DistrictDao dao = new DistrictDao();
				DistrictMaster__c district = dao.getDistrict(userInfo.ZipCode__c);

				//When inappropriate zip-code, skip this record.
				if(district == null){
					continue;
				}

				//Set district to this record
				userInfo.District__c = district.Id;
			}
		}

		//Insert initial cost into PurchaseTransaction__c
		PurchaseTransaction__c purchase = new PurchaseTransaction__c();

		purchase.PuchasedBy__c = new UserInformationDao().getRelatedRecord(UserInfo.getUserId()).Id;
		purchase.PuchaseDate__c = date.today();
		purchase.Price__c = CommonConstants.PRICE_INITIAL_COST;
		purchase.PurchaseType__c = CommonConstants.INITIAL_COST;

		//Add it into database.
		insert purchase;

	}

	/**
	 * Trigger execution method. This is triggered before updation.
	 * @param old the list of old record
	 * @param updated the list of new record
	 * @param triggerMap the mapping file of new record
	 */
	public void OnBeforeUpdate(UserInformation__c[] old, UserInformation__c[] updated, Map<ID, UserInformation__c> triggerMap){


		for(UserInformation__c oldUser : old){
			for(UserInformation__c newUser : updated){

				//Re-assign district only when zip-code is changed.
				if(oldUser.Id == newUser.Id
					&& newUser.ZipCode__c != null && !newUser.ZipCode__c.equals(oldUser.ZipCode__c)){

						//Get district data by new zip code
						DistrictDao dao = new DistrictDao();
						DistrictMaster__c district = dao.getDistrict(newUser.ZipCode__c);

						//When inappropriate zip-code, skip this record.
						if(district == null){
							continue;
						}

						//Set district to this record
						newUser.District__c = district.Id;
				}
			}
		}
	}


}