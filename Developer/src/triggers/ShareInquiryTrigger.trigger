trigger ShareInquiryTrigger on Inquiry__c (after insert, after update) {

	Inquiry__c obj = Trigger.new.get(0);
	
	Inquiry__Share inquiryShare = new Inquiry__Share();
	inquiryShare.ParentId = obj.Id;
	
	User sampleUser = [select id, Name from User where name = 'サンプル太郎'];
	
	inquiryShare.UserOrGroupId  = sampleUser.Id;
	
	inquiryShare.AccessLevel = 'Read';
   	
   	inquiryShare.RowCause = Schema.Inquiry__Share.RowCause.Manual;

	insert inquiryShare;
}