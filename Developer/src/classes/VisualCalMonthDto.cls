public class VisualCalMonthDto {

	private List<VisualCalWeekDto> weeks;
	public Date firstDate; // always the first of the month

	public Date upperLeft{get;set;}
	public Date lowerRight{get;set;}

	public List<Date> getValidDateRange() {
		// return one date from the upper left, and one from the lower right
		List<Date> ret = new List<Date>();
		ret.add(upperLeft);
		ret.add(upperLeft.addDays(5*7) );
		return ret;
	}

	 //Japanese list of days of week.
	public List<String> dayOfWeek{set;get;}

	public List<String> getDayOfWeek() {
		return dayOfWeek;
	}


	public String getMonthName() {
		return DateTime.newInstance(firstDate.year(),firstdate.month(),firstdate.day()).format('MM');
	}

	public String getYearName() {
		return DateTime.newInstance(
		firstDate.year(),firstdate.month(),firstdate.day()).format('yyyy');
	}

	public String[] getWeekdayNames() {
		Date today = system.today().toStartOfWeek();
		DateTime dt = DateTime.newInstanceGmt(today.year(),today.month(),today.day());
		list<String> ret = new list<String>();
		for(Integer i = 0; i < 7;i++) {
			ret.add( dt.formatgmt('EEEE') );
			dt= dt.addDays(1);
		}
		return ret;
	}

	public Date getfirstDate() { return firstDate; }

	/**
	 * Constructor
	 */
	public VisualCalMonthDto( Date value ) {
		weeks = new List<VisualCalWeekDto>();
		firstDate = value.toStartOfMonth();
		upperLeft = firstDate.toStartOfWeek();
		lowerRight = upperLeft.addDays(5*7);

		Date tmp = upperLeft;
		for (Integer i = 0; i < 5; i++) {
			VisualCalWeekDto w = new VisualCalWeekDto(i+1,tmp,value.month());
			system.assert(w!=null);
			this.weeks.add( w );
			tmp = tmp.addDays(7);
		}

		//Assign each object for each day
		List<Event> ownEvents = new EventDao().getOwnEvetList(upperLeft, lowerRight);
		List<VisualMemo__c> ownMemos = new VisualMemoDao().getData(upperLeft, lowerRight);

        //Shorten event name
        for(Event event : ownEvents){
        	if(event.SUBJECT.length() >= 16){
        		event.SUBJECT = event.SUBJECT.substring(0,15) + '…';
        	}
        }

		for(VisualCalWeekDto week : weeks){
            for(VisualCalDayDto day : week.days){

            	/** Attach event list */
            	for(Event event : ownEvents){
            		Date startDate = date.newinstance(event.STARTDATETIME.year(), event.STARTDATETIME.month(), event.STARTDATETIME.day());
            		if(day.theDate.daysBetween(startDate) == 0){
						day.eventList.add(event);
            		}
            	}

            	/** Attach memo list */
            	for(VisualMemo__c memo : ownMemos){
            		if(day.theDate.daysBetween(memo.Day__c) == 0){
						day.memoList.add(memo);
            		}
            	}

            }
		}

	 	//Add Japanese list of days of week.
	 	dayOfWeek = new List<String>();
	 	dayOfWeek.add('Sun');
	 	dayOfWeek.add('Mon');
	 	dayOfWeek.add('Tue');
	 	dayOfWeek.add('Wed');
	 	dayOfWeek.add('Thr');
	 	dayOfWeek.add('Fri');
	 	dayOfWeek.add('Sat');

	}

	public void setEvents(List<Event> ev) {
		// merge these events into the proper day
		for(Event e:ev) {
			for(VisualCalWeekDto w:weeks) {
				for(VisualCalDayDto c: w.getDays() ) {
					if ( e.ActivityDate.isSameDay(c.theDate))  {
						// add this event to this calendar date
						c.eventsToday.add(new EventItem(e));
						// add only three events, then a More... label if there are more
					}
				}
			}
		}
	}

	public List<VisualCalWeekDto> getWeeks() {
		system.assert(weeks!=null,'could not create weeks list');
		return this.weeks;
	}

}