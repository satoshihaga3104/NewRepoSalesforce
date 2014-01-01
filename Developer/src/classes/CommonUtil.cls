/*
@Name            : CommonUtil
@Author          : Satoshi Haga
@Description     : Utility Class
@version         : First Create 2013/12/11 Satoshi Haga
*/
public   class CommonUtil {


  /**
   * Separate string to list object
   * @param pString     data source.
   * @param List<String>   List of String
   */
  public static List<String> convertMultiPick(String pString){

  	if(pString == null || ''.equals(pString)){
  		return null;
  	}
    String[] aryMultiPick = pString.split(';');
    List<String> listStr = new List<String>();

    for(String strPickValue : aryMultiPick){
      listStr.add(strPickValue);
    }

    return listStr;
  }

}