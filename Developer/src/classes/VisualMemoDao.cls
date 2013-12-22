/*
@Name            : VisualMemoDao
@Author          : Satoshi Haga
@Date            : July 1, 2013
@Description     : Data Access Class for VisualMemo__c
@version         : 07/01/2013 First Creation
*/
public class VisualMemoDao extends BaseDao{

	/**
	 * Constructor
	 */
	public VisualMemoDao(){
		super(new VisualMemo__c().getSObjectType());
	}

	/** Get data by day */
	public List<VisualMemo__c> getData(Date fromDate, Date toDate){

		Date paramFromDate = fromDate;
		Date paramToDate = toDate;

		String strSQL = 'select ' + getAllColumnString() + ' from ' + tp.getDescribe().getName() + ' where Day__c >= :paramFromDate and Day__c <= :paramToDate';

		Object obj = database.query(strSQL);
		if(obj == null) return null;

		List<VisualMemo__c> listResult = (List<VisualMemo__c>)obj;
		if(listResult.size() == 0) return null;

		return listResult;

	}


}