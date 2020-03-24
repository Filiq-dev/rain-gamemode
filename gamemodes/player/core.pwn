enum pData {
    pSQLID,
    pName[MAX_PLAYER_NAME],
    pUsername[MAX_PLAYER_NAME],
    pPassword[65],
    pSalt[17],
    pEmail[256]
}
new PlayerInfo[MAX_PLAYERS][pData];