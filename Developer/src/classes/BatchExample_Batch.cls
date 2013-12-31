global with sharing class BatchExample_Batch
                    implements Database.Batchable<sObject>, Database.Stateful {
	private final Integer BATCH_SIZE = 100;
	private String param1;
	private Boolean isLastBatch = true;
	private Map<String,String> paramMap = new Map<String,String>{'Japanese' => '日本','English' => 'アメリカ'};

	/**
	* BatchExample_Batchを生成する。
	*
	* @param param1 言語
	* @param isLastBatch 最終処理であればtrue。初回実行時はfalse
	*/
	global BatchExample_Batch(String param1, Boolean isLastBatch){
		this.param1 = param1;
		this.isLastBatch = isLastBatch;
	}

	/**
	* バッチの開始処理。
	*/
	global Database.querylocator start(Database.BatchableContext BC){
		return Database.getQueryLocator('select id,Name from Contact ');
	}

	/**
	* バッチの処理（取得したContactのOtherCountryフィールドにparam1に応じた国名をセット）。
	*/
	global void execute(Database.BatchableContext BC, List<sObject> scope){
		List<Contact> contacts = new List<Contact>();
		for(sObject s : scope){
			Contact cont = (Contact)s;
			cont.Firstname = 'Haga';
			contacts.add(cont);
		}
		update contacts;
	}

	/**
	* バッチの終了処理。
	*/
	global void finish(Database.BatchableContext BC){
		if(this.isLastBatch){
			sendFinishMail();
			return;
		}
		param1 = 'English';
		BatchExample_Batch testBatch = new BatchExample_Batch(param1,true);
		Database.executeBatch(testBatch, BATCH_SIZE);
	}

	/**
	* バッチ終了時にメールを送付
	*/
	
	private void sendFinishMail(){
		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		String[] toAddresses = new String[] {'satoshi.haga@catalinamarketing.com'};
		mail.setToAddresses(toAddresses);
		mail.setSubject('バッチ処理完了');
		mail.setPlainTextBody('バッチ処理が完了しました。\n' + system.now());
		Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
	}
}