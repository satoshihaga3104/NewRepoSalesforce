/*
@Name            : ContactDao
@Author          : Satoshi Haga
@Date            : July 1, 2013
@Description     : Data Access Class for Contact
@version         : 07/01/2013 First Creation
*/
public class ContactDao extends BaseDao{

	/**
	 * Constructor
	 */
	public ContactDao(){
		super(new Contact().getSObjectType());
	}

	/** Searching Method by email */
	public List<Contact> getContactByEmail(String strEmail){
		Map<String, String> param = new Map<String, String>();
		param.put('Email', strEmail);
		
		List<Contact> retList = (List<Contact>)getValue(param);
		
		if(retList == null || retList.size() == 0){
			return null;
		}
		
		return retList;
	}

}