/*
@Name            : ApproveRequestController
@Author          : Satoshi Haga
@Description     : Controller class for Approve Request Page
@version         : First Create 2013/12/11 Satoshi Haga
*/
public with sharing class ApproveRequestController extends BaseController {

	/** Related Approval requests */
	public List<FriendRequest__c> listApprovalRequest{set;get;}

	/** Constructor */
	public ApproveRequestController(){
		super();

		//Set non-approved friend list
		listApprovalRequest = new FriendRequestDao().getNonApprovedList(loginUsaerInfo.Id);
	}

	/** Subimt Action */
	public void submitRequest(){
		update listApprovalRequest;

		//initialize
		init();

		//Add Success Message
		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, CommonConstants.SUCCESS_GENERAL, ''));


	}


}