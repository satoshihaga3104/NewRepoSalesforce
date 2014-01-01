/*
@Name            : BaseDao
@Author          : Satoshi Haga
@Description     : Abstract Dao class. Each dao class extends this class.
@version         : First Create 2013/12/11 Satoshi Haga
*/
public abstract class BaseDao {

	/*
 	  The type of custom object. This is used for sql statement
 	*/
	protected Schema.SObjecttype tp;

	/*
 	  The name of custom object. This is used for sql statement by subclass. So, the protected scope is required.
 	*/
	public String strTableName;

	/**
	 * Searching function. Execute query directly with the specific sql statement
	 * @param strSql sql statement
	 * @return Object  result of query
	 */
	public Object execute(String strSql){
		Object ret = database.query(strSql);

		return ret;

	}


	/**
	 * Constructor. Constractor must not be called with no argment . So, the private scope is not required
	 */
	private BaseDao(){

	}

	/**
	 * Constructor with functional name and Object Type.
	 * This is called with specifeid functional name by each sub class
	 * Don't call from outer class
	 * @param strFunctionalName functional name for logging
	 * @param tp 				the type of custom object
	 */
	protected BaseDao(Schema.SObjecttype tp){
		this.tp = tp;
		this.strTableName = tp.getDescribe().getName();
	}

	/**
	 * Searching function. Execute query with parametered criteria. Custom obeject is assigned by member valiable.
	 * All column are included autmatically.
	 * @param strWhere where statement
	 * @return Object  result of query
	 */
	public Object getAllColumnData(String strWhere){

		String strSql = '';
		if(strWhere != null && !''.equals(strWhere)){
			strSql = 'Select ' + getAllColumnString() + ' from ' + tp.getDescribe().getName() + ' where ' + strWhere;
		}else{
			strSql = 'Select ' + getAllColumnString() + ' from ' + tp.getDescribe().getName() ;
		}

		//execute query
		return execute(strSql);
	}

	/**
	 * Searching function. Execute query with no criteria. So, all data are gotten.All column are included autmatically.
	 * @return Object  result of query
	 */
	public Object getAllColumnData(){
		return getAllColumnData('');
	}

	/**
	 * Searching function. Execute query with ID. So, only spcified record is gotten by this function.All column are included autmatically.
	 * @param id Id of targetted record
	 * @return Object  result of query
	 */
	public Object getAllColumnData(ID id){
		ID pId = id;
		String strSql = '';
		strSql = 'Select ' + getAllColumnString() + ' from ' + tp.getDescribe().getName() + ' where ID = :pId';

		//Execute SOQL query with bind valiable 'pId'
		List<Object> obj = (List<Object>)database.query(strSql);

		if(obj == null || obj.size() == 0){
			return null;
		}
		return obj.get(0);
	}

	/**
	 * Searching function. Execute query with IDs. So, only spcified records is gotten by this function.All column are included autmatically.
	 * @param listId Id list of targetted records
	 * @return Object  result of query
	 */
	public Object getAllColumnData(List<ID> listId){
		List<ID> pId = listId;
		String strSql = '';
		strSql = 'Select ' + getAllColumnString() + ' from ' + tp.getDescribe().getName() + ' where ID IN :pId';

		//Execute SOQL query with bind valiable 'pId'
		Object obj = database.query(strSql);

		return obj;
	}

	/**
	 * Searching function. Execute query with parametered criteria. Criteria is given as map object, which have the list of parameter as key-value store
	 * @param 	param	Parameter list as key-value store
	 * @return 	Object	result of query
	 */
	public Object getValue(Map<String, String> param){

		String strSql = 'Select ' + getAllColumnString() + ' from ' + tp.getDescribe().getName();

		String joinString = ' where ';
		for(String strKey : param.keySet()){
			strSql = strSql + joinString + strKey + ' = \'' + (String)param.get(strKey) + '\'';
			joinString = ' AND ';
		}

		//Execute SOQL query with bind valiable 'pId'
		Object obj = (List<Object>)database.query(strSql);

		return obj;
	}

	/**
	 * Searching function. Execute query with parametered criteria. Criteria is given as map object, which have the list of parameter as key-value store
	 * @param 	param	Parameter list as key-value store
	 * @return 	Object	result of query
	 */

	/**
	 * Pick all column as String from custom object.
	 * @return 	String	all column String
	 */
	public String getAllColumnString(){
		String strSql = '';
		Map<String,Schema.sObjectField> fmap = tp.getDescribe().fields.getMap();
		for(String fn:fmap.keySet()){
			strSql = strSql + fn + ',';
		}
        strSql = strSql.substring(0,strSql.length()-1);

		return strSql;
	}

	/**
	 * Get name of targetted object
	 * @return 	String object name
	 */
	public String getObjectName(){
		if(tp == null)return null;

		return tp.getDescribe().getName();
	}


	/**
	 * Get object prefix of targetted object
	 * @return 	String object prefix
	 */
	public String getObjectPrefix(){
		if(tp == null)return null;

		return tp.getDescribe().getKeyPrefix();
	}

	/**
	 * Get URL of new window of targetted object
	 * @return 	String URL of new winodw
	 */
	public String getNewUrl(){
		if(tp == null)return null;

		return '/' + getObjectPrefix() + '/e';
	}

	/**
	 * Get URL of tab window of targetted object
	 * @return 	String URL of new winodw
	 */
	public String getTabUrl(){
		if(tp == null)return null;

		return '/' + getObjectPrefix() + '/o';
	}




}