new 
    Text: Time,
    Text: Date;

hook OnGameModeInit() {

    Date = TextDrawCreate(542.000061, 8.960021,"--");
    TextDrawFont(Date,1);
    TextDrawLetterSize(Date,0.367999, 1.525333);
    TextDrawColor(Date,-16777279);
    TextDrawSetShadow(Date, 1);
	TextDrawSetOutline(Date, 1);

    Time = TextDrawCreate(553.200073, 22.400056,"--");
    TextDrawFont(Time,3);
    TextDrawLetterSize(Time,0.507999, 2.486044);
    TextDrawColor(Time,-16777279);
    TextDrawSetShadow(Time, 1);
	TextDrawSetOutline(Time, 1);
}