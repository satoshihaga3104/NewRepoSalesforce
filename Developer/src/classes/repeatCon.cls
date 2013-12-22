global with sharing class repeatCon {


    @RemoteAction
    global static void updateSchedule(String[] arrayNewTask) {

        List<Event> listEvent = new List<Event>();
        //Update each task
        for (String newTask : arrayNewTask){
        	if(newTask != null && !''.equals(newTask)){

				//Get id and date from parameter string
				String[] idAndDate = newTask.split(',',0);
        		ID taskId = Id.valueOf(idAndDate[0]);
				Date taskDate = Date.valueOf(idAndDate[1]);

				//Change date of task which have this id.
				Event targetEvent = (Event)new EventDao().getAllColumnData(taskId);
				if(targetEvent != null){
					targetEvent.StartDateTime = taskDate;
					targetEvent.EndDateTime = taskDate;
					targetEvent.ActivityDate = taskDate;
					targetEvent.ActivityDateTime = taskDate;
					targetEvent.DurationInMinutes = 0;
					//Insert this into the list
					listEvent.add(targetEvent);
				}


        	}

        }

        //Update data
        if(listEvent.size() > 0){
        	update listEvent;
        }

    }


  public void next() {
    addMonth(1);
  }

  public void prev() {
    addMonth(-1);
  }

	public PageReference moveTaskPage(){

		String formattedDay = ApexPages.currentPage().getParameters().get('formattedDay');

		PageReference taskPage = new PageReference(new EventDao().getNewUrl() + '?evt4=' + formattedDay);

		return taskPage;
	}


  public repeatCon() {

   Date d = system.today();  // default to today
   Integer mo = d.month();
   String m_param = System.currentPageReference().getParameters().get('mo');
   String y_param = System.currentPageReference().getParameters().get('yr');

   // allow a month to be passed in on the url as mo=10
   if (m_param != null) {
        Integer mi = Integer.valueOf(m_param);
        if (mi > 0 && mi <= 12) {
          d = Date.newInstance(d.year(),mi,d.day());
        }
   }
   // and year as yr=2008
   if (y_param != null) {
        Integer yr = Integer.valueOf(y_param);
        d = Date.newInstance(yr, d.month(), d.day());
   }

   setMonth(d);
  }

  public List<VisualCalWeekDto> getWeeks() {
    return month.getWeeks();
  }

  public List<String> getDayOfWeek() {
    return month.getDayOfWeek();
  }

  public VisualCalMonthDto getMonth() { return month; }

  public String getMemoUrl(){
  	return new VisualMemoDao().getNewUrl();
  }


  private void setMonth(Date d) {
    month = new VisualCalMonthDto(d);
    system.assert(month != null);

    Date[] da = month.getValidDateRange();  // gather events that fall in this month
    events = [ select id,subject,description,activitydate,activitydatetime,DurationInMinutes
        from Event
        where activitydate >= :da[0] AND activityDate <= :da[1]
        order by activitydatetime];

    month.setEvents(events);  // merge those events into the month class
  }

  private void addMonth(Integer val) {
    Date d = month.getFirstDate();
    d = d.addMonths(val);
    setMonth(d);
  }

  private List<Event> events;
  private VisualCalMonthDto month;
}