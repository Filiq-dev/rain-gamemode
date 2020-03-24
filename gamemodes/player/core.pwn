


static hour, minute, seconds, year, month, day;
task GeneralServerTimer[1000]() {
    gettime(hour, minute, seconds); 
    getdate(year, month, day);

    new string[52];
    format(string, sizeof string, "%d/%s%d/%s%d", day, ((month < 10) ? ("0") : ("")), month, (year < 10) ? ("0") : (""), year);
    TextDrawSetString(Date, string);
    
    format(string, sizeof string, "%s%d:%s%d", (hour < 10) ? ("0") : (""), hour, (minute < 10) ? ("0") : (""), minute, (seconds < 10) ? ("0") : (""), seconds);
    TextDrawSetString(Time, string);
}