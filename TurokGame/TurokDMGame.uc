class TurokDMGame extends TurokMPGame
    native
    config(Game)
    hidecategories(Navigation,Movement,Collision);

function float RatePlayerStart(@NULL P, byte Team, @NULL Player)
{
    local @NULL ps, ST;

    ps = TurokMPPlayerStart(P);
    // End:0x57
    if(ps != none)
    {
        ST = ps.GetSpawnTarget();
        // End:0x57
        if((ST != none) && TurokMPFreeForAllSpawnTarget(ST) == none)
        {
            return 0.0000000;
        }
    }
    return super.RatePlayerStart(P, Team, Player);
    //return ReturnValue;    
}

function bool CheckScore(@NULL Scorer)
{
    local int I, S;

    // End:0x82
    if(GoalScore > 0)
    {
        S = GameReplicationInfo.PRIArray.Length;
        I = 0;
        J0x27:

        // End:0x82 [Loop If]
        if(I < S)
        {
            // End:0x78
            if(GameReplicationInfo.PRIArray[I].Score >= float(GoalScore))
            {
                EndGame(none, "scorelimit");
                return true;
            }
            ++I;
            // [Loop Continue]
            goto J0x27;
        }
    }
    return false;
    //return ReturnValue;    
}

protected function bool CheckLives()
{
    local @NULL lastManStanding, PRI;
    local int playersWithSomeLivesRemaining, playersWithZeroLivesRemaining, I;

    // End:0xD8
    if(MaxLives > 0)
    {
        I = 0;
        J0x12:

        // End:0x7D [Loop If]
        if(I < GameReplicationInfo.PRIArray.Length)
        {
            PRI = GameReplicationInfo.PRIArray[I];
            // End:0x61
            if(PRI.bOutOfLives)
            {
                ++playersWithZeroLivesRemaining;
                // [Explicit Continue]
                goto J0x73;
            }
            lastManStanding = PRI;
            ++playersWithSomeLivesRemaining;
            J0x73:

            ++I;
            // [Loop Continue]
            goto J0x12;
        }
        // End:0xA4
        if(playersWithSomeLivesRemaining == 0)
        {
            EndGame(none, "scorelimit");
            return true;            
        }
        else
        {
            // End:0xD8
            if((playersWithSomeLivesRemaining == 1) && playersWithZeroLivesRemaining >= 1)
            {
                EndGame(lastManStanding, "lifelimit");
                return true;
            }
        }
    }
    return false;
    //return ReturnValue;    
}

defaultproperties
{
    HUDType=Class'TurokDMHud'
}