public virtual without sharing class DynamoDBClient  extends AWSClient{

	public DynamoDBClient(){
		this.setDefaultSettings();
		this.aas.serviceName = 'DynamoDB';
		this.aas.apiVersion = '20120810';
		this.aas.method = 'POST';
	}

	public DynamoDBClient(AWSAccessSettings aas){
		this.aas = aas;
	}

	public AWSAccessResult putItem(String requestBody){
		return this.send(this.createHttpRequest(requestBody, 'PutItem'));
	}

	public void batchGetItem(){}
	public void batchWriteItem(){}
	public void createTable(){}
	public void deleteItem(){}
	public void deleteTable(){}
	public void describeTable(){}
	public void getItem(){}
	public void listTables(){}
	public void query(){}
	public void scan(){}
	public void updateItem(){}
	public void updateTable(){}
}