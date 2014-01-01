/*
@Name            : FriendRequestDao
@Author          : Satoshi Haga
@Description     : Data Access Class for FriendRequest__c
@version         : First Create 2013/12/11 Satoshi Haga
*/
public with sharing class FriendRequestDao extends BaseDao{

  /**
   * Constructor
   */
  public FriendRequestDao(){
    super(new FriendRequest__c().getSObjectType());
  }


	/** Get non-approved list of friends */
	public List<FriendRequest__c> getNonApprovedList(Id userId){

		ID pId = userId;

		//Create SOQL string
		String strQuery = 'SELECT ' + getAllColumnString() + ' FROM ' + getObjectName() + ' ';
		strQuery += 'WHERE ApprovalFlg__c = \'\' AND RelatedUserInformation__c = :pId';

		//Execute
		List<FriendRequest__c> ret = database.query(strQuery);

		//If there is not non-approved list, return empty list
		if(ret == null || ret.size() == 0){
			return new List<FriendRequest__c>();
		}

		//Return
		return ret;
	}

	/** Get Latest Status */
	public FriendRequest__c getLatestStatus(ID userID, ID friendID){

		//Initialize member variable
		ID pUserID = userID;
		ID pFriendID = friendID;

		//Create SOQL string
		String strQuery = 'SELECT ' + getAllColumnString() + ' FROM ' + getObjectName() + ' ';
		strQuery += ' WHERE ApprovalFlg__c <> \'拒否\'';
		strQuery += ' AND RequestingUserInformation__c = :pUserID ';
		strQuery += ' AND RelatedUserInformation__c = :pFriendID ';
		strQuery += ' ORDER BY RequestedTime__c DESC LIMIT 1 ';

		//Execute
		List<FriendRequest__c> ret = database.query(strQuery);

		//If there is not non-approved list, return null value
		if(ret == null || ret.size() == 0){

			return null;

		}

		//Return
		return ret.get(0);
	}


}