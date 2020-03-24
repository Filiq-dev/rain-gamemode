enum {
    DATABASE_ERROR
}

function CloseServer(error) {
    switch(error) {
        case DATABASE_ERROR: {
            print("Conexiunea cu baza de date nu s-a putut realiza, server-ul se va inchide.");
        }
    }

    #if defined DEBUG
        defer closeServer();
    #endif

    return true;
}

timer closeServer[5000]() {
    SendRconCommand("exit");
}