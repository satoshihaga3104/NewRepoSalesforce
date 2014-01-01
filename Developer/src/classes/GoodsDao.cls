/*
@Name            : GoodsDao
@Author          : Satoshi Haga
@Description     : Data Access Class for Goods__c
@version         : First Create 2013/12/11 Satoshi Haga
*/
public class GoodsDao extends BaseDao{


  /**
   * Constructor
   */
  public GoodsDao(){
    super(new Goods__c().getSObjectType());
  }

  /** Get list by criteria */
  public List<Goods__c> getListDataByCriteria(GoodsCriteria__c criteria){

  	//Declare member variables in order to use these in SOQL as binded variables
  	List<String> strCategoryList = CommonUtil.convertMultiPick(criteria.Category__c);
  	Decimal fromPrice = criteria.PriceFrom__c;
  	Decimal toPrice = criteria.PriceTo__c;
  	Date fromDate = criteria.StartDate__c;

  	//Create Query String
  	String strQuery = 'SELECT ' + getAllColumnString() + ' FROM ' + getObjectName() + ' ';
  	String strJoin = ' WHERE ';

  	if(strCategoryList != null && strCategoryList.size() > 0){
  		strQuery += strJoin + ' Category__c IN :strCategoryList ';
  		strJoin = ' AND ';
  	}

	if(fromPrice != null){
  		strQuery += strJoin + ' StandardPrice__c >= :fromPrice ';
  		strJoin = ' AND ';
	}

	if(toPrice != null){
  		strQuery += strJoin + ' StandardPrice__c <= :toPrice ';
  		strJoin = ' AND ';
	}

	if(fromDate != null){
  		strQuery += strJoin + ' StartDate__c >= :fromDate ';
  		strJoin = ' AND ';
	}

	//Execute SOQL
  	List<Goods__c> result = new List<Goods__c>();
  	for(Goods__c rec :  (List<Goods__c>)database.query(strQuery)){
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