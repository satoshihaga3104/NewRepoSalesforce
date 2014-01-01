/*
@Name            : DistrictDao
@Author          : Satoshi Haga
@Description     : Data Access Class for DistrictMaster__c
@version         : First Create 2013/12/11 Satoshi Haga
*/
public class DistrictDao extends BaseDao{

	/**
	* Constructor
	*/
	public DistrictDao(){
    	super(new DistrictMaster__c().getSObjectType());
	}

	/** Get appropriate district by zip-code */
	public DistrictMaster__c getDistrict(String strZipCode){

		Map<String, String> param = new Map<String, String>();
		param.put('ZipCode__c', strZipCode);

		List<DistrictMaster__c> listDistrict = (List<DistrictMaster__c>)getValue(param);

		//If parameter is invalid code, rerun null value
		if(listDistrict == null || listDistrict.size() == 0){
			return null;
		}

		//Return district record
		return listDistrict.get(0);

	}

}