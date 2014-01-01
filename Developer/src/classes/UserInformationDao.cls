/*
@Name            : UserInformationDao
@Author          : Satoshi Haga
@Description     : Data Access Class for UserInformation__c
@version         : First Create 2013/12/11 Satoshi Haga
*/

public class UserInformationDao extends BaseDao{


  /**
   * Constructor
   */
  public UserInformationDao(){
    super(new UserInformation__c().getSObjectType());
  }

  /** Get one record related with parametered id */
  public UserInformation__c getRelatedRecord(Id pId){
	Map<String, String> param1 = new Map<String, String>();
	param1.put('RelatedUser__c', (String)pId);


	List<UserInformation__c> listUser = (List<UserInformation__c>)getValue(param1);

	if(listUser == null || listUser.size() == 0) {
		//Invalid user id
		return null;
	}

	//Return
	return listUser.get(0);
  }

  /** Get list by criteria */
  public List<UserInformation__c> getListDataByCriteria(UserInformationCriteria__c criteria){

  	//If criteria doesn't have dstrict-value becuase of some reason, return here with no value
  	if(criteria.DistrictName__c == null){
  		return null;
  	}
  	String pDistrictName = criteria.DistrictName__c;

  	//Declare member variables in order to use these in SOQL as binded variables
  	List<String> strJobList = CommonUtil.convertMultiPick(criteria.JobStatusList__c);
  	Integer fromAge ;
  	Integer toAge ;
	String strMarrige = criteria.Marriage__c;
	String strSex = criteria.Sex__c;
	Boolean hasChild;

	If('いる'.equals(criteria.HasChildrenList__c)){
		hasChild = true;
	}

	If('いない'.equals(criteria.HasChildrenList__c)){
		hasChild = false;
	}

  	//Create Query String
  	String strQuery = 'SELECT ' + getAllColumnString() + ' FROM ' + getObjectName() + ' ';
  	String strJoin = ' WHERE ';

  	if(strJobList != null && strJobList.size() > 0){
  		strQuery += strJoin + ' JobStatus__c IN :strJobList ';
  		strJoin = ' AND ';
  	}

	if(criteria.AgeFrom__c != null && !''.equals(criteria.AgeFrom__c)){
		fromAge = Integer.valueOf(criteria.AgeFrom__c);
  		strQuery += strJoin + ' Age__c >= :fromAge ';
  		strJoin = ' AND ';
	}

	if(criteria.AgeTo__c != null && !''.equals(criteria.AgeTo__c)){
		toAge = Integer.valueOf(criteria.AgeTo__c);
  		strQuery += strJoin + ' Age__c <= :toAge ';
  		strJoin = ' AND ';
	}

	if(strMarrige != null && !''.equals(strMarrige)){
  		strQuery += strJoin + ' Marriage__c = :strMarrige ';
  		strJoin = ' AND ';
	}

	if(strSex != null && !''.equals(strSex)){
  		strQuery += strJoin + ' Sex__c = :strSex ';
  		strJoin = ' AND ';
	}


	if(hasChild == true){
  		strQuery += strJoin + ' ChildCount__c > 0 ';
  		strJoin = ' AND ';
	}

	if(hasChild == false){
  		strQuery += strJoin + ' ChildCount__c = 0 ';
  		strJoin = ' AND ';
	}

	//District
  	strQuery += strJoin + ' DistrictName__c = :pDistrictName ';
  	strJoin = ' AND ';


	//Upper limit
	strQuery += ' LIMIT ' + CommonConstants.UPPER_LIMIT_COUNT;

	//Execute SOQL
  	List<UserInformation__c> result = new List<UserInformation__c>();
  	for(UserInformation__c rec :  (List<UserInformation__c>)database.query(strQuery)){
  		result.add(rec);
  	}

	//If there is no data, return null value;
	if(result == null || result.size() == 0){
		return null;
	}

	//Return
	return result;

  }


}