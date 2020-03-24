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
    mysql_tquery(gSQL, query, "OnPlayerRegister", "d", playerid);
    
    return true;
}

function OnPlayerRegister(playerid) { 
	PlayerInfo[playerid][pSQLID] = cache_insert_id();
    
    LoadPlayerData(playerid, 0);

	return 1;
}

function LoadPlayerData(playerid, login) {

    if(login == 1) {

    }

    if(!Iter_Contains(Player, playerid)) Iter_Add(Player, playerid);

    // SetSpawnInfo(playerid, NO_TEAM, 0, Player[playerid][X_Pos], Player[playerid][Y_Pos], Player[playerid][Z_Pos], Player[playerid][A_Pos], 0, 0, 0, 0, 0, 0);
    // SpawnPlayer(playerid); 

}