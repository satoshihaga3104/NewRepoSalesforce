public with sharing class AccountPagination{
	
    private final Account acct;  

    public AccountPagination(
           ApexPages.StandardSetController controller) 
    {
           this.acct = (Account)controller.getRecord(); 
    }    
    
    public ApexPages.StandardSetController accountRecords{
        get {
            if(accountRecords == null){
                return new ApexPages.StandardSetController(Database.getQueryLocator([SELECT name FROM Account]));
            }
            return accountRecords;
        }
        private set;
    }
    public List<Account> getAccountPagination(){
    	
    	 return new AccountInnerClass().getAccountPagination();
         //return (List<Account>) accountRecords.getRecords();
         //return (List<Account>)new AccountDao().getAllColumnData();
         //return (List<Account>)new AccountIndependentDao().getAllColumnData();
    }
    
    /** Inner Class */
    public class AccountInnerClass{
    	public List<Account> getAccountPagination(){
    	
    	 return [select id, Name from Account];
    }
    }  
}