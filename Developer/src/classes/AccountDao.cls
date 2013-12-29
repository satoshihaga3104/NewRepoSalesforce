/*
@Name            : EventDao
@Author          : Satoshi Haga
@Date            : July 1, 2013
@Description     : Data Access Class for Event
@version         : 07/01/2013 First Creation
*/
public class AccountDao extends BaseDao{

	/**
	 * Constructor
	 */
	public AccountDao(){
		super(new Account().getSObjectType());
	}

	/** Searching Method by Name */
	public List<Account> getAccountByName(String strName){
		Map<String, String> param = new Map<String, String>();
		param.put('Name', strName);
		
		List<Account> retList = (List<Account>)getValue(param);
		
		if(retList == null || retList.size() == 0){
			return null;
		}
		
		return retList;
	}


	/** Searching Unknown Account */
	public Account getUnknownAccount(){

		List<Account> retList = getAccountByName('Unknown');
		
		return retList.get(0);
	}
	
	
}