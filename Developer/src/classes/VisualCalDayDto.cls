public class VisualCalDayDto {

		public Date 		theDate;
		public List<EventItem> 	eventsToday; // list of events for this date
		public Integer 		month, dayOfWeek;
		public String 		formatedDate; // for the formated time
		private String 		cssclass = 'calActive';

		public Date 		getDate() { return theDate; }
		public Integer 		getDayOfMonth() { return theDate.day(); }
		public String 		getDayOfMonth2() {
			if ( theDate.day() <= 9 )
				return '0'+theDate.day();
			return String.valueof( theDate.day());
		}
		public Integer getDayOfYear() { return theDate.dayOfYear(); }
		public List<EventItem> 	getDayAgenda() { return eventsToday; }
		public String 		getFormatedDate() { return formatedDate; }
		public Integer 		getDayNumber() { return dayOfWeek; }
		public List<EventItem> 	getEventsToday() { return eventsToday; }
		public String 		getCSSName() { 	return cssclass; }

		/** Event List */
		public List<Event> eventList{get;set;}

		/** Memo List */
		public List<VisualMemo__c> memoList{get;set;}

		/** Day Object */


		/** Getter method */
		public String getFormattedDay(){
			Datetime theDatetime = theDate;
			return theDatetime.format('yyyy', 'JST') + '/' + theDatetime.format('MM', 'JST') + '/' + theDatetime.format('dd ', 'JST');
		}

		public String getDayYyyyMmDd(){
			Datetime theDatetime = theDate;
			return theDatetime.format('yyyy', 'JST')  + '-' + theDatetime.format('MM', 'JST') + '-' + theDatetime.format('dd ', 'JST');
		}

		public String getTaskUrl(){
			Datetime theDatetime = theDate;
			return '/00U/e?evt4=' + theDatetime.format('yyyy', 'JST') + '/' + theDatetime.format('MM', 'JST') + '/' + theDatetime.format('dd ', 'JST');
		}


		public VisualCalDayDto(Date value,Integer vmonth) {

			eventList = new List<Event>();
			memoList = new List<VisualMemo__c>();

			theDate=value; month=vmonth;
			formatedDate = '12 21 08';// time range..
			//9:00 AM - 1:00 PM
			eventsToday = new List<EventItem>();
			// three possible Inactive,Today,Active
			if ( theDate.daysBetween(System.today()) == 0 ) cssclass ='calToday';
			// define inactive, is the date in the month?
			if ( theDate.month() != month) cssclass = 'calInactive';
		}

}