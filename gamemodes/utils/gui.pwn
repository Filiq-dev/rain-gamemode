new 
    Text: Time,
    Text: Date,
    Text: logo1,
    Text: logo2;

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

    logo1 = TextDrawCreate(577.500000, 426.562500, SERVER_NAME);
    TextDrawLetterSize(logo1, 0.380000, 1.250000);
    TextDrawAlignment(logo1, 1);
    TextDrawColor(logo1, -1);
    TextDrawSetShadow(logo1, 0);
    TextDrawSetOutline(logo1, 1);
    TextDrawBackgroundColor(logo1, 51);
    TextDrawFont(logo1, 2);
    TextDrawSetProportional(logo1, 1);

    #if defined BETA_SERVER
        logo2 = TextDrawCreate(566.000000, 437.062500, "~r~Beta~w~"SERVER_VERSION);
    #else 
        logo2 = TextDrawCreate(566.000000, 437.062500, SERVER_VERSION);
    #endif

    TextDrawLetterSize(logo2, 0.126999, 0.939375);
    TextDrawAlignment(logo2, 1);
    TextDrawColor(logo2, -1);
    TextDrawSetShadow(logo2, 0);
    TextDrawSetOutline(logo2, 1);
    TextDrawBackgroundColor(logo2, 51);
    TextDrawFont(logo2, 2);
    TextDrawSetProportional(logo2, 1);
}