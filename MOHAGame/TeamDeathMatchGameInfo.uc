class TeamDeathMatchGameInfo extends TeamGameInfo
    config(Game)
    hidecategories(Navigation,Movement,Collision);

function PostBeginPlay()
{
    local MOHAPlayerController PC;
    local MOHAPlayerReplicationInfo PRI;

    super(MOHAMultiplayerGameInfo).PostBeginPlay();
    // End:0x7F
    foreach WorldInfo.AllControllers(Class'MOHAPlayerController', PC)
    {
        PRI = MOHAPlayerReplicationInfo(PC.PlayerReplicationInfo);
        // End:0x7E
        if(PRI != none)
        {
            PRI.Deaths = 0.0000000;
            PRI.Kills = 0;
            PRI.Score = 0.0000000;
        }        
    }    
    //return;    
}

function RequestRespawn(MOHAMultiplayerController mpc)
{
    // End:0x35
    if(mpc != none)
    {
        mpc.GotoState('Dead');
        mpc.ServerPreReStartPlayer();
    }
    //return;    
}

function ProcessTimeRules()
{
    local MOHAMultiplayerController C;
    local Plasma P;

    P = Class'Plasma.Plasma'.static.GetPlasma();
    // End:0x97
    if((((P != none) && P.isRanked()) && MOHAGameReplicationInfo(GameReplicationInfo).RoundStatus != 4) && int(WorldInfo.NetMode) != int(NM_DedicatedServer))
    {
        // End:0x97
        if(ShouldEndDueToTeamQuit())
        {
            EndGame(none, "TeamQuit");
            return;
        }
    }
    // End:0x10E
    if(((bDisplayedTimeRunningOut == false) && GameReplicationInfo.RemainingTime <= 30) && MOHAGameReplicationInfo(GameReplicationInfo).RoundStatus == 0)
    {
        // End:0x105
        foreach WorldInfo.AllControllers(Class'MOHAMultiplayerController', C)
        {
            C.ClientShowTimeRunningOutMessage();            
        }        
        bDisplayedTimeRunningOut = true;
    }
    // End:0x2D7
    if((GameReplicationInfo.RemainingTime <= 0) && MOHAGameReplicationInfo(GameReplicationInfo).RoundStatus == 0)
    {
        // End:0x1B3
        if((MOHAGameReplicationInfo(GameReplicationInfo).Teams[0] != none) && MOHAGameReplicationInfo(GameReplicationInfo).Teams[0].Score > MOHAGameReplicationInfo(GameReplicationInfo).Teams[1].Score)
        {
            MOHAGameReplicationInfo(GameReplicationInfo).LastRoundWinningTeam = 0;            
        }
        else
        {
            // End:0x229
            if((MOHAGameReplicationInfo(GameReplicationInfo).Teams[0] != none) && MOHAGameReplicationInfo(GameReplicationInfo).Teams[1].Score > MOHAGameReplicationInfo(GameReplicationInfo).Teams[0].Score)
            {
                MOHAGameReplicationInfo(GameReplicationInfo).LastRoundWinningTeam = 1;                
            }
            else
            {
                GameReplicationInfo.RemainingTime = 0;
                // End:0x276
                if(bSuddenDeath == false)
                {
                    // End:0x275
                    foreach WorldInfo.AllControllers(Class'MOHAMultiplayerController', C)
                    {
                        C.ClientShowSuddenDeathMessage();                        
                    }                    
                }
                bSuddenDeath = true;
                return;
            }
        }
        // End:0x2B0
        foreach WorldInfo.AllControllers(Class'MOHAMultiplayerController', C)
        {
            C.ClientClearGameMessage();            
        }        
        bDisplayedTimeRunningOut = false;
        bSuddenDeath = false;
        EndGame(none, "TimeLimit");
    }
    //return;    
}

state StartingMatch
{
    event OnRoundStarted(bool success)
    {
        local MOHAMultiplayerController C;

        super.OnRoundStarted(success);
        GameReplicationInfo.RemainingTime = 60 * TimeLimit;
        GameReplicationInfo.ElapsedTime = 0;
        MOHAGameReplicationInfo(GameReplicationInfo).ResetRoundStartTime();
        MOHAGameReplicationInfo(GameReplicationInfo).RoundStatus = 0;
        // End:0xA4
        foreach WorldInfo.AllControllers(Class'MOHAMultiplayerController', C)
        {
            // End:0xA3
            if(!C.IsInState('WeaponSelect'))
            {
                RequestRespawn(C);
            }            
        }        
        //return;        
    }
    stop;    
}

defaultproperties
{
    ScoreBoardType=Class'MOHAScoreboard_DM'
    HUDType=Class'MOHAHUD_TDM'
    GameReplicationInfoClass=Class'TDMGameReplicationInfo'
}