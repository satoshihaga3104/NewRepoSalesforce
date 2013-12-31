global class ReadOnlySample2 {
	
  	@ReadOnly
  	webservice static void executeReadOnly() {
    	//レコードを全件取得
    	List<Account> accs = [SELECT Name FROM Account];
  	}

}