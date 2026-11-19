class Admin extends PlayerController
    config(Game)
    notplaceable
    hidecategories(lighting);

event PostBeginPlay()
{
    PostBeginPlay();
    AddCheats();
    return;
}

exec function Admin(string CommandLine)
{
    ServerAdmin(CommandLine);
    return;
}

reliable server function ServerAdmin(string CommandLine)
{
    local string Result;

    Result = ConsoleCommand(CommandLine);
    // End:0x2D
    if(Result != "")
    {
        ClientMessage(Result);
    }
    return;
}

exec function KickBan(string S)
{
    ServerKickBan(S);
    return;
}

reliable server function ServerKickBan(string S)
{
    WorldInfo.Game.KickBan(S);
    return;
}

exec function Say(string Msg)
{
    local PlayerController PC;

    // End:0x98
    if(Left(Msg, 1) == "#")
    {
        Msg = Right(Msg, Len(Msg) - 1);
        // End:0x95
        foreach WorldInfo.AllControllers(Class'PlayerController', PC)
        {
            PC.ClearProgressMessages();
            PC.SetProgressTime(6.0000000);
            PC.SetProgressMessage(0, Msg, MakeColor(byte(255), byte(255), byte(255), byte(255)));            
        }        
        return;
    }
    Say(Msg);
    return;
}

exec function Kick(string S)
{
    ServerKick(S);
    return;
}

reliable server function ServerKick(string S)
{
    WorldInfo.Game.Kick(S);
    return;
}

exec function PlayerList()
{
    return;
}

exec function RestartMap()
{
    ServerRestartMap();
    return;
}

reliable server function ServerRestartMap()
{
    ClientTravel("?restart", 2);
    return;
}

exec function Switch(string URL)
{
    ServerSwitch(URL);
    return;
}

reliable server function ServerSwitch(string URL)
{
    WorldInfo.ServerTravel(URL, false);
    return;
}
