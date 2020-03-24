new 
   gSQL = -1; 

enum pData {
    pSQLID,
    pName[MAX_PLAYER_NAME],
    pUsername[MAX_PLAYER_NAME],
    pPassword[65],
    pSalt[17],
    pEmail[256],
    pAge,
    pSex
}
new PlayerInfo[MAX_PLAYERS][pData];

#define PlayerName(%0) PlayerInfo[%0][pName]