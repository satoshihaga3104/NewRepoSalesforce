/*
@Name            : MainViewController
@Author          : Satoshi Haga
@Description     : Controller class for Main View
@version         : First Create 2013/12/11 Satoshi Haga
*/
public   class MainViewController extends BaseController {


	/** Related campaign record */
	public Campaign__c campaign {set; get;}


	/** Constructor */
	public MainViewController(){

		//Execute constructor of super class
		super();

		//Get campaign record only when user has campaign record
		if(loginUsaerInfo != null && loginUsaerInfo.Campaign__c != null){

			CampaignDao dao = new CampaignDao();
			campaign = (Campaign__c)dao.getAllColumnData(loginUsaerInfo.Campaign__c);
		}


	}


}