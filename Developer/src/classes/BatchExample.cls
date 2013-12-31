public with sharing class BatchExample {
  // バッチサイズの指定
  private final Integer BATCH_SIZE = 100;
  // 実行ボタン
  public PageReference execute() {
    String param1 = 'Japanese';
      BatchExample_Batch testBatch = new BatchExample_Batch(param1,false);
      Database.executeBatch(testBatch, BATCH_SIZE);
      return null;
  }
}