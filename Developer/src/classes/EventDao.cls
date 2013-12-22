/*
@Name            : EventDao
@Author          : Satoshi Haga
@Date            : July 1, 2013
@Description     : Data Access Class for Event
@version         : 07/01/2013 First Creation
*/
public class EventDao extends BaseDao{

	/**
	 * Constructor
	 */
	public EventDao(){
		super(new Event().getSObjectType());
	}


	/**
	 * Getting own event
	 * @param criteria criteria for searching
	 * @return List<ID>  the ld list of ConstarcCycle
	 */
	 public List<Event> getOwnEvetList(Date fromDate, Date toDate){

		//Parameter
		Id currentId = UserInfo.getUserId();
		Datetime fromDatetime = fromDate;
		Datetime toDatetime = toDate;


	 	String strSql = '';
	 	strSql = 'SELECT ' + getAllColumnString() + ' FROM ' + tp.getDescribe().getName() + ' WHERE OWNERID = :currentId AND ((CREATEDDATE >= :fromDatetime AND CREATEDDATE <= :toDatetime) OR (STARTDATETIME >= :fromDatetime AND STARTDATETIME <= :toDatetime) OR (ENDDATETIME >= :fromDatetime AND ENDDATETIME <= :toDatetime) )';

	 	return (List<Event>)database.query(strSql);
	 }


}