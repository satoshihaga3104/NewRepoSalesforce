public without sharing class AccountIndependentDao {

	public List<Account> getAllColumnData(){
		return [select id,name from Account];
	}
	
}