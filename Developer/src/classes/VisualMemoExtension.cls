/**
@Name            : VisualMemoExtension
@Author          : Satoshi Haga
@Date            : Aug 8, 2013
@Description     : Extension class for VisalMemo
@version         : 08/08/2013 First Creation
*/
public class VisualMemoExtension {

	public String strObjectName { get; set; }

	public ID id;
	public String strDay{ get; set; }

	public VisualMemo__c visualMemo{ get; set; }



	/**
	 * Constructor
	 * @param stdController this is gotten by salesforce standard framwwork when accessing each page.
	 */
	public VisualMemoExtension(ApexPages.StandardController stdController) {

		strObjectName = stdController.getRecord().getSObjectType().getDescribe().getName();


		id = apexpages.currentPage().getParameters().get('Id');
		if(id != null){
			visualMemo = (VisualMemo__c)new VisualMemoDao().getAllColumnData(id);
		}

		strDay = apexpages.currentPage().getParameters().get('calendarDay');
		if(strDay != null) strDay = strDay.substring(0, 4) + '/' + strDay.substring(5, 7) +  '/' +  strDay.substring(8, 10);
	}

}