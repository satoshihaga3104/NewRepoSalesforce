/*
@Name            : UserDetailExtension
@Author          : Satoshi Haga
@Description     : Extension class for User Detail Page
@version         : First Create 2013/12/11 Satoshi Haga
*/
public   class UserDetailExtension extends BaseController {


	/** Usaer id */
	public ID usaerId{set; get;}

	/** Related record on UserInformation__c */
	public UserInformation__c userInfo{set; get;}

	/** Check if my page or not */
	public Boolean isOwnPage{set;get;}

	/** Profile Picture */
	public Document profilePicture { get; set; }

	/** Standard Controller */
	ApexPages.StandardController con;

	/** Constructor */
    public UserDetailExtension(ApexPages.StandardController controller) {

		super();

		//Save controller instance in order to override publisher action
		con = controller;

		//Save record id as member variable
		usaerId = controller.getRecord().Id;

		//Get whole data related with ID
		UserInformationDao dao = new UserInformationDao();
	    userInfo = (UserInformation__c)dao.getAllColumnData(usaerId);

		//Set other member variable
		strHost = ApexPages.currentPage().getHeaders().get('Host');

		//Check whether this is user's own page or not
		if(usaerId == loginUsaerInfo.Id){
			isOwnPage = true;
		}else{
			isOwnPage = false;
		}

		//Initiaize document
		profilePicture = new Document();

	}

	/** Over */
	public PageReference save(){

		//Get record user updated on window
		userInfo = (UserInformation__c)con.getRecord();

		//If user updates the picture on client side, save this file
		if(profilePicture.body != null){
			//upload file, and save id as profile picture
		    profilePicture.AuthorId = loginUsaerId;
    		profilePicture.FolderId = new ConstantsDao().getIdByKeyStrings('DocumentFolder', 'UserProfile');
    		profilePicture.Name = 'profile picture of '+ loginUsaerInfo.Name;

			//Upload file
      		insert profilePicture;

 			//Save id as user's profile image
 			userInfo.PictureID__c = profilePicture.Id;

 	   		//clear the viewstate
      		profilePicture.body = null; // clears the viewstate
      		profilePicture = new Document();
		}

		//Save the change
		update userInfo;

		//Return this page
		return new PageReference('/' + (String)loginUsaerInfo.Id);
	}


	/** Send Friend Request */
	public void submitRequest(){

		//Create rewuest record
		FriendRequest__c request = new FriendRequest__c();

		request.RequestingUserInformation__c = loginUsaerInfo.Id;
		request.RequestingUser__c = loginUsaerId;
		request.RelatedUserInformation__c = userInfo.Id;
		request.RequestedUserLookUp__c = userInfo.RelatedUser__c;
		request.RequestedTime__c = System.now();

		//Insert it into database.
		insert request;

		//Add Success Message
		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, CommonConstants.SUCCESS_SUBMIT_FRIEND_REQUEST, ''));
	}


}