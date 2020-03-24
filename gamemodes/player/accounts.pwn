#include <YSI_Coding\y_hooks>

static 
    g_MysqlRaceCheck[MAX_PLAYERS],
    Timer: LoginTimer[MAX_PLAYERS];

hook OnPlayerConnect(playerid) {
    g_MysqlRaceCheck[playerid] ++;

    static const empty_player[pData];
	PlayerInfo[playerid] = empty_player;

    GetPlayerName(playerid, PlayerInfo[playerid][pName], MAX_PLAYER_NAME);
    if(Iter_Contains(Player, playerid)) Iter_Remove(Player, playerid);

    new query[100];
	mysql_format(gSQL, query, sizeof query, "SELECT * FROM `users` WHERE `username` = '%e' LIMIT 1", PlayerInfo[playerid][pName]);
	mysql_tquery(gSQL, query, "OnPlayerDataLoaded", "dd", playerid, g_MysqlRaceCheck[playerid]);

    return true;
}

hook OnPlayerDisconnect(playerid, reason) {
    g_MysqlRaceCheck[playerid] --;

    stop LoginTimer[playerid];

    return true;
}

timer LoginTime[SECONDS_TO_LOGIN * 1000](playerid) {
    Kick(playerid);
}   

function OnPlayerDataLoaded(playerid, rackcheck) {
    if(rackcheck != g_MysqlRaceCheck[playerid]) return Kick(playerid);

    new string[115];
	if(cache_num_rows() > 0) {  
        cache_get_field_content(0, "password", PlayerInfo[playerid][pPassword]);
        cache_get_field_content(0, "salt", PlayerInfo[playerid][pSalt]);
 
		format(string, sizeof string, "This account (%s) is registered. Please login by entering your password in the field below:", PlayerInfo[playerid][pName]); 
        Dialog_Show(playerid, DialogLogin, DIALOG_STYLE_PASSWORD, "Login", string, "Login", "Abort");
 
		LoginTimer[playerid] = defer LoginTime(playerid);
	} else {
		format(string, sizeof string, "Welcome %s, you can register by entering your password in the field below:", PlayerInfo[playerid][pName]); 
        Dialog_Show(playerid, DialogRegister, DIALOG_STYLE_PASSWORD, "Registration", string, "Register", "Abort");
	}

    return true;
}

Dialog:DialogLogin(playerid, response, listitem, inputtext[]) {
    if(!response) return Kick(playerid);

    new hashed_pass[65];
    SHA256_PassHash(inputtext, PlayerInfo[playerid][pSalt], hashed_pass, 65);

    if(strcmp(hashed_pass, PlayerInfo[playerid][pPassword]) == 0) {    
        LoadPlayerData(playerid, 1);

        stop LoginTimer[playerid]; 
    } else
        Dialog_Show(playerid, DialogLogin, DIALOG_STYLE_PASSWORD, "Login", "Wrong password!\nPlease enter your password in the field below:", "Login", "Abort");

    return true;
}

Dialog:DialogRegister(playerid, response, listitem, inputtext[]) {
    if (!response) return Kick(playerid);

    if (strlen(inputtext) <= 5) return Dialog_Show(playerid, DialogRegister, DIALOG_STYLE_PASSWORD, "Registration", "Your password must be longer than 5 characters!\nPlease enter your password in the field below:", "Register", "Abort");

    // 16 random characters from 33 to 126 (in ASCII) for the salt
    for (new i = 0; i < 16; i++) PlayerInfo[playerid][pSalt][i] = random(94) + 33;
    SHA256_PassHash(inputtext, PlayerInfo[playerid][pSalt], PlayerInfo[playerid][pPassword], 65);

    new query[221];
    mysql_format(gSQL, query, sizeof query, "INSERT INTO `users` (`username`, `password`, `salt`) VALUES ('%e', '%s', '%e')", PlayerInfo[playerid][pName], PlayerInfo[playerid][pPassword], PlayerInfo[playerid][pSalt]);
    mysql_tquery(gSQL, query, "RegisterQuerys", "dd", playerid, 4);
    
    return true;
} 

Dialog:DialogEmail(playerid, response, listitem, inputtext[]) {
    if(!response) return Dialog_Show(playerid, DialogEmail, DIALOG_STYLE_INPUT, "Email", "Introducerea unui email este obligatorie!", "Continua", "");

    new len = strlen(inputtext);
    if(len > 250)
        return Dialog_Show(playerid, DialogEmail, DIALOG_STYLE_INPUT, "Email", "Email-ul introdus de tine este prea mare, te rugam sa introduci altul.", "Continua", "");

    if(IsValidMailAddr(inputtext)) {
        new email_escape[251];
        mysql_escape_string(inputtext, email_escape);
        format(PlayerInfo[playerid][pEmail], len+5, email_escape);

        new query[100];
        mysql_format(gSQL, query, sizeof query, "UPDATE `users` SET `Email` = '%s' WHERE `id` = '%d'", email_escape, PlayerInfo[playerid][pSQLID]);
        mysql_tquery(gSQL, query, "RegisterQuerys", "dd", playerid, 1);
    }
    else Dialog_Show(playerid, DialogEmail, DIALOG_STYLE_INPUT, "Email", "Email-ul introdus de tine este invalid!", "Continua", "");

    return true;
}

Dialog:DialogAge(playerid, response, listitem, inputtext[]) {
    if(!response) return Dialog_Show(playerid, DialogAge, DIALOG_STYLE_INPUT, "Varsta", "Te rugam sa iti introduci varsta ta.", "Continua", "");

    new age = strval(inputtext);
    
    PlayerInfo[playerid][pAge] = age;

    new query[100];
    mysql_format(gSQL, query, sizeof query, "UPDATE `users` SET `Age` = '%d' WHERE `id` = '%d'", age, PlayerInfo[playerid][pSQLID]);
    mysql_tquery(gSQL, query, "RegisterQuerys", "dd", playerid, 2);

    return true;
}

Dialog:DialogSex(playerid, response, listitem, inputtext[]) {
    PlayerInfo[playerid][pSex] = response;

    new query[100];
    mysql_format(gSQL, query, sizeof query, "UPDATE `users` SET `Sex` = '%d' WHERE `id` = '%d'", response, PlayerInfo[playerid][pSQLID]);
    mysql_tquery(gSQL, query, "RegisterQuerys", "dd", playerid, 3);

    return true;
}

function FinishRegister(playerid) {
    // StartTutorial(playerid);
    LoadPlayerData(playerid, 0); // de pus la sfarsitul tutorialului
}

function RegisterQuerys(playerid, step) {
    if(Iter_Contains(Player, playerid)) {
        switch(step) {
            case 1: // update email in db
                Dialog_Show(playerid, DialogAge, DIALOG_STYLE_INPUT, "Varsta", "Te rugam sa iti introduci varsta ta.", "Continua", "");
            case 2:
                Dialog_Show(playerid, DialogSex, DIALOG_STYLE_MSGBOX, "Sex", "Te rugam sa iti alegi sex-ul.", "Baiat", "Fata");
            case 3:
                FinishRegister(playerid);
            
            case 4: {
                PlayerInfo[playerid][pSQLID] = cache_insert_id();
     
                if(!Iter_Contains(Player, playerid)) Iter_Add(Player, playerid); 

                Dialog_Show(playerid, DialogEmail, DIALOG_STYLE_INPUT, "Email", "Pentru a putea sa iti resetezi parola in caz ca o uiti, te rugam sa introduci un mail.", "Continua", "");
            }
        }
    }
}

function LoadPlayerData(playerid, login) {

    if(login == 1) {
        cache_get_field_content(0, "email", PlayerInfo[playerid][pEmail]);
        cache_get_field_content(0, "username", PlayerInfo[playerid][pUsername]);
    }

    if(!Iter_Contains(Player, playerid)) Iter_Add(Player, playerid); 

    TextDrawShowForPlayer(playerid, Date);
    TextDrawShowForPlayer(playerid, Time);

    va_SendClientMessage(playerid, COLOR_WHITE, "SERVER: Welcome "EMBED_SERVER_COLOR"%s.", PlayerName(playerid));

    SetSpawnInfo(playerid, NO_TEAM, 0, 1568.2250,-1693.5483,5.8906,177.0983, 0, 0, 0, 0, 0, 0);
    SpawnPlayer(playerid);  
} 