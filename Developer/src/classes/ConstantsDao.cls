/*
@Name            : ConstantsDao
@Author          : Satoshi Haga
@Description     : Data Access Class for Campaign__c
@version         : First Create 2013/12/11 Satoshi Haga
*/
public with sharing class ConstantsDao extends BaseDao{

  /**
   * ConstantsDao
   */
  public ConstantsDao(){
    super(new Constants__c().getSObjectType());
  }

  /** Get ID of specific object */
  public ID getIdByKeyStrings(String key1, String key2){

  	String pKey1 = key1;
  	String pKey2 = key2;

  	String strSOQL = 'SELECT Id, Value__c FROM ' + getObjectName() + ' WHERE Key1__c = :pKey1 AND Key2__c = :pKey2';

  	List<Constants__c> listConst = (List<Constants__c>)database.query(strSOQL);

  	//Invalid Key
  	if(listConst == null || listConst.size() == 0){
  		return null;
  	}

  	//Convert from string to ID
  	ID ret = (ID)listConst.get(0).Value__c;

  	//Return
  	return ret;
  }

}