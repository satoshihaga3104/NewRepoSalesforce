global  with sharing class InquiryEmailHandler implements Messaging.InboundEmailHandler {
	 // 電子メール到着時に呼び出されるメソッド
	 // 引数： email 受信した電子メールデータ
	 //  envelope 受信した電子メールのエンベロープ
	 global Messaging.InboundEmailResult handleInboundEmail(
			 Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
			
			// 戻り値インスタンス生成
			Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
			
			// デバッグメッセージ用文字列変数
			String myErr;
		
			   // メール本文を格納する文字列変数
			   String theBody = email.plainTextBody != null ? email.plainTextBody : email.htmlBody; 
			
			
 			   	// 既存顧客担当者を紐づける
			   	Contact contact;
			   	List<Contact> listContact = new ContactDao().getContactByEmail(email.fromAddress);
			   	
				if(listContact == null || listContact.size() == 0){
					//新規取引先担当者。Unknownに紐づける
					contact = new Contact();
					contact.AccountId = new AccountDao().getUnknownAccount().Id;
					contact.FirstName = email.fromName;
					contact.Email = email.fromAddress;
					//登録
					insert contact;
				}else{
					contact = listContact.get(0);
				}

				//問い合わせレコードの作成
				Inquiry__c inquiry = new Inquiry__c();
				inquiry.Title__c = email.subject;
				inquiry.Description__c = theBody;
				inquiry.Contact__c = contact.Id;
				inquiry.Email__c = email.fromAddress;
				inquiry.OwnerId = contact.OwnerId != null ? contact.OwnerId : UserInfo.getUserId();
				insert inquiry;
				
			   // バイナリorテキスト添付ファイル群を格納するリストを
			   // 新規生成
			   List<Attachment> attachments = new List<Attachment>();
			   // バイナリ添付ファイル群が存在する場合
			   if (email.binaryAttachments != null){
				    // バイナリ添付ファイルデータループ
				    for (Messaging.InboundEmail.BinaryAttachment emailAttachment: email.binaryAttachments){
					
					     // 新規添付ファイル格納オブジェクト生成
					     Attachment attachment = new Attachment();
					     attachment.parentId = inquiry.id;
					     attachment.body = emailAttachment.body;
					     attachment.name = emailAttachment.fileName;

					     // リストへ追加
					     attachments.add(attachment);
				    }
			   }
			
			   // テキスト添付ファイル群が存在する場合
			   if (email.textAttachments != null){
				    // テキスト添付ファイルデータループ
				    for (Messaging.InboundEmail.TextAttachment emailAttachment:email.textAttachments){
					     
					     // 新規添付ファイル格納オブジェクト生成
					     Attachment attachment = new Attachment();
					     attachment.parentId = inquiry.id;
					     attachment.body = blob.valueOf(emailAttachment.body);
					     attachment.name = emailAttachment.fileName; 

					     // リストへ追加
					     attachments.add(attachment);
				    }
			   }
			
			   // 格納対象となる添付ファイルが存在する場合
			   if (attachments.size() > 0){
					// 添付ファイル新規追加
					insert attachments;
			   }
			
			  // 正常終了の場合、生成したままの戻り値オブジェクトを返却
			  return result;
	}
}