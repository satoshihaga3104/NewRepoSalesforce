public class VisualCalWeekDto {

	 public List<VisualCalDayDto> days;
	 public Integer weekNumber;
	 public Date startingDate; // the date that the first of this week is on
	 // so sunday of this week

	 public List<VisualCalDayDto> getDays() { return this.days; }

	 public VisualCalWeekDto () {
	 	days = new List<VisualCalDayDto>();
	 }
	 public VisualCalWeekDto(Integer value,Date sunday,Integer month) {
	 	this();
	 	weekNumber = value;
	 	startingDate = sunday;
	 	Date tmp = startingDate;
	 	for (Integer i = 0; i < 7; i++) {
	 		VisualCalDayDto d = new VisualCalDayDto( tmp,month );
	 		tmp = tmp.addDays(1);
	 		d.dayOfWeek = i+1;
	 	//	system.debug(d);
	 		days.add(d);
	 	}

	 }
	 public Integer getWeekNumber() { return this.weekNumber;}
	 public Date getStartingDate() { return this.startingDate;}

}