stock IsValidMailAddr(const addr[]) { // by Shinja (cred) https://forum.sa-mp.com/showthread.php?t=660870
    new len = strlen( addr ),
        atcount = ( 0 ), IsValid = false
    ;
    if( len < 5 ){
        IsValid = false;
        goto IsValidMailAddr__the_end;
    }
    for(new i, j=len; i<j; i++){
        if( addr[i] == '@' ) atcount ++;
        if( atcount > 1 ){
            IsValid = false;
            break;
        }

        if( ( addr[i] >= 'a' && addr[i] <= 'z' ) || ( addr[i] >= 'A' && addr[i] <= 'Z' ) || ( addr[i] == '.' ) || ( addr[i] == '_' ) || ( addr[i] == '-' ) )
            IsValid = true;
        else{
            if( ( addr[i] != '@' ) ){
                IsValid = false;
                break;
            }
        }

        if( i + 1 == len )
            if( ( ( addr[i] >= 'a' && addr[i] <= 'z' ) || ( addr[i] >= 'A' && addr[i] <= 'Z' ) ) && ( addr[i] != '.' ) )
                IsValid = true;
        if( i + 1 == len && addr[i] == '.' )
            IsValid = false;
    }
    IsValidMailAddr__the_end:
    return IsValid ? true : false;
}