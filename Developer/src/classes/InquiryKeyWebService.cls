global class InquiryKeyWebService {

	webService static Boolean submitInInquiryCreation(Inquiry__c inquiry){

		insert inquiry;
		
		return true;
	}
}