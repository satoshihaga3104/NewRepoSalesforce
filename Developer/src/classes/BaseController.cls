/*
@Name            : BaseController
@Author          : Satoshi Haga
@Description     : Abstract controller class. Specfic controller (or extension) class extends this class
@version         : First Create 2013/12/11 Satoshi Haga
*/
public abstract class BaseController {

	/** Login Usaer */
	public ID loginUsaerId{set; get;}

	/** Related record on UserInformation__c */
	public UserInformation__c loginUsaerInfo{set; get;}

	/** Host URL */
	public String strHost{get; set;}

	/** Related Campaign */
	public Campaign__c relatedCampaign{get; set;}

	/** Related Campaign Goods */
	public List<CampaignGoods__c> relatedCampaignGoods{get; set;}

	/** Upper Limit Count */
	public Integer upperLimitCount{set; get;}

	/** Constructor */
	public BaseController(){

		/** initialize */
		init();
	}

	/** Initialize method */
	public void init(){

		//Set member variable
		loginUsaerId = UserInfo.getUserId();
		loginUsaerInfo = new UserInformationDao().getRelatedRecord(loginUsaerId);
		strHost = ApexPages.currentPage().getHeaders().get('Host');
		upperLimitCount = Integer.valueOf(CommonConstants.UPPER_LIMIT_COUNT);

		//If loginUsaerInfo is not set because of some reaason, return here.
		if(loginUsaerInfo == null){
			return;
		}

		//Get related campaign and goods
		if(loginUsaerInfo.Campaign__c != null){

			//Campaign
			relatedCampaign = (Campaign__c)new CampaignDao().getAllColumnData(loginUsaerInfo.Campaign__c);

			//Goods
			relatedCampaignGoods  = new CampaignGoodsDao().getRelatedGoods(loginUsaerInfo.Campaign__c);

		}

	}

	/** Page URL */

	/** ApprovalRequest URL_APROVAL_REQUEST*/
	public String getUrlApprovalRequest(){
		return CommonConstants.URL_APPROVAL_REQUEST;
	}

	/** MainView */
	public String getUrlMainView(){
		return CommonConstants.URL_MAIN_VIEW;
	}

	/** GoodsSearch */
	public String getUrlGoodsSearch(){
		return CommonConstants.URL_GOODS_SEARCH;
	}

	/** FriendsSearch */
	public String getUrlFriendsSearch(){
		return CommonConstants.URL_FRIENDS_SEARCH;
	}

	/** Inquiry */
	public String getUrlInquiry(){
		return CommonConstants.URL_INQUIRY;
	}

	/** MyProfile */
	public String getUrlMyProfile(){
		return '/' + (String)loginUsaerInfo.Id;
	}




	/** Paging Mehods */

	/** Move to GoodsSearch.page */
	public PageReference moveToGoodsSearch(){
		return Page.GoodsSearch;
	}

	/** Move to FriendSearch.page */
	public PageReference moveToFriendSearch(){
		return Page.FriendSearch;
	}

	/** Move to MainView.page */
	public PageReference moveToMainView(){
		return Page.MainView;
	}

	/** Move to My information page */
	public PageReference moveToMyPage(){
		return new PageReference('/' + loginUsaerInfo.Id);
	}

}