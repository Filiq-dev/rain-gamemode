#include <YSI_Coding\y_hooks>
hook OnGameModeInit() {
    new oldtick = GetTickCount();

    mysql_log(LOG_ALL, LOG_TYPE_HTML);
    
    gSQL = mysql_connect("localhost", "root", "rain-sql", "");

    if(gSQL == -1 || mysql_errno(gSQL) != 0)
        return CloseServer(DATABASE_ERROR);

    printf("Am incarcat cu succes baza de date in %d ms.", (GetTickCount() - oldtick));

    return true;
}

hook OnGameModeExit() {
    mysql_close(gSQL);
}