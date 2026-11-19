class TurokCoopInfo extends TurokTeamInfo
    native
    hidecategories(Navigation,Movement,Collision);

function Initialize(int InitTeamIndex)
{
    TeamIndex = byte(InitTeamIndex);
    TeamColor = GetTeamColor();
    //return;    
}

event IncrementNumberOfLives(int NumLives)
{
    local @NULL CoopGI, TPC, TPRI;

    // DebugMode: 0
    assert(int(TeamIndex) == 0);
    super.IncrementNumberOfLives(NumLives);
    CoopGI = TurokCoopGame(WorldInfo.Game);
    // End:0x112
    foreach WorldInfo.AllControllers(Class'TurokPlayerController', TPC)
    {
        // End:0x5C
        if(mNumLives <= 0)
        {
            // End:0x112
            break;
        }
        // End:0x75
        if(TPC.bIsPlayer == false)
        {
            continue;            
        }
        TPRI = TurokMPPlayerReplicationInfo(TPC.PlayerReplicationInfo);
        // End:0x9D
        if(TPRI == none)
        {
            continue;            
        }
        // End:0xCD
        if(TPRI.bOutOfLives == true)
        {
            TPRI.bOutOfLives = false;
            DecrementNumberOfLives();
        }
        // End:0x111
        if((TPRI.bIsSpectator == true) && TPRI.bOnlySpectator == false)
        {
            CoopGI.StopSpectating(TPC);
        }        
    }    
    //return;    
}

function SetDefaultSpawnTarget()
{
    local @NULL currSpawnTarget;

    // End:0x0D
    if(mCurrentSpawnTarget != none)
    {
        return;
    }
    // End:0x5D
    foreach WorldInfo.AllNavigationPoints(Class'TurokMPTeamSpawnTarget', currSpawnTarget)
    {
        // End:0x5C
        if(int(TeamIndex) == int(currSpawnTarget.GetTeamNum()))
        {
            SetSpawnTarget(currSpawnTarget);
            // End:0x5D
            break;
        }        
    }    
    //return;    
}
