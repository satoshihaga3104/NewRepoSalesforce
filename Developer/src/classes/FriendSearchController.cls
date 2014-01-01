/*
@Name            : FriendSearchController
@Author          : Satoshi Haga
@Description     : Controller class for Friend Search Function
@version         : First Create 2013/12/11 Satoshi Haga
*/
public   class FriendSearchController extends BaseController {


	/** Search Criteria */
	public UserInformationCriteria__c criteria{get; set;}

	/** Searching result */
	public List<UserInformation__c> listUser{get; set;}

	/** Constructor */
	public FriendSearchController(){

		super();

		listUser = new List<UserInformation__c>();

		//Initialize criteria
		criteria = new UserInformationCriteria__c();

		//Set user's district to the criteria
		criteria.DistrictName__c = loginUsaerInfo.DistrictName__c;

	}

	/** Searching Method */
	public void search(){

		FriendRequestDao friDao = new FriendRequestDao();

		listUser = new UserInformationDao().getListDataByCriteria(criteria);

		//If there is no data, return here
		if(listUser == null || listUser.size() == 0){
			listUser = new List<UserInformation__c>();
			return ;
		}


		List<UserInformation__c> ret = new List<UserInformation__c>();
		for(UserInformation__c user : listUser){

			//exclude my record
			if(loginUsaerInfo.Id != user.Id){
				ret.add(user);
			}

			//Check current status
			FriendRequest__c latestReq = friDao.getLatestStatus(loginUsaerInfo.Id, user.Id);

			if(latestReq != null){
				if(latestReq.ApprovalFlg__c == null || ''.equals(latestReq.ApprovalFlg__c)){
					//Not commited yet
					user.FriendStatus__c = '友達申請中です';
				}

				if('承認'.equals(latestReq.ApprovalFlg__c)){
					//Already commited
					user.FriendStatus__c = '既にお友達です';
				}
			}
		}

		//Re-asign member list
		listUser = ret;
	}


	/** Send Friend Request */
	public void submitRequest(){

		List<FriendRequest__c> listRequest = new List<FriendRequest__c>();

		//For each selected-user record, create request record.
		//Then request-email is sent by workflow rule
		for( UserInformation__c requestedUser : listUser){

			if(requestedUser.CheckStatus__c == true){
				//Create each request instance, and add this into the list.
				FriendRequest__c req = new FriendRequest__c();

				req.RequestingUserInformation__c = loginUsaerInfo.Id;
				req.RequestingUser__c = loginUsaerId;
				req.RelatedUserInformation__c = requestedUser.Id;
				req.RequestedUserLookUp__c = requestedUser.RelatedUser__c;
				req.RequestedTime__c = System.now();


				listRequest.add(req);
			}
		}

		//Bulk-insert
		if(listRequest.size() > 0){
			insert listRequest;
		}

		//Refresh friend list by calling serch method
		search();

		//Add Success Message
		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, CommonConstants.SUCCESS_SUBMIT_FRIEND_REQUEST, ''));
	}


}