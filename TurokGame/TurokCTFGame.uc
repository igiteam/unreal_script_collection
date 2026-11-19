class TurokCTFGame extends TurokFlagGame
    native
    config(Game)
    hidecategories(Navigation,Movement,Collision);

var protected config float ScoredFlagRespawnTime;

event InitGame(string Options, out string ErrorMessage)
{
    local string InOpt;

    super.InitGame(Options, ErrorMessage);
    InOpt = ParseOption(Options, "CapturedFlagAlwaysScores");
    // End:0x59
    if(InOpt != "")
    {
        CapturedFlagAlwaysScores = bool(InOpt);
    }
    InOpt = ParseOption(Options, "ScoredFlagRespawnTime");
    // End:0xAA
    if(InOpt != "")
    {
        ScoredFlagRespawnTime = FClamp(float(InOpt), 0.0000000, 5.0000000);
    }
    //return;    
}

function InitGameReplicationInfo()
{
    super.InitGameReplicationInfo();
    mFlagIndicators[0].Activate();
    mFlagIndicators[1].Activate();
    //return;    
}

protected function bool PickupBaseFlag(class<Class> FlagClass, @NULL PlayerPawn, @NULL invMan, @NULL FlagBase)
{
    local @NULL CarriedFlag, CarriedFlagBase;

    // End:0x171
    if(GameReplicationInfo.OnSameTeam(PlayerPawn, FlagBase))
    {
        CarriedFlag = TurokMPTeamFlag(invMan.FindInventoryType(Class'TurokMPTeamFlag', true));
        // End:0x16E
        if(CarriedFlag != none)
        {
            // End:0xA7
            if(GameReplicationInfo.OnSameTeam(FlagBase, CarriedFlag))
            {
                FlagBase.FlagReturned(PlayerPawn);
                ScoreFlagReturn(TurokPlayerController(PlayerPawn.Controller));                
            }
            else
            {
                // End:0x100
                if(CapturedFlagAlwaysScores || FlagBase.IsPickupEnabled())
                {
                    FlagBase.FlagCaptured(PlayerPawn);
                    ScoreFlagCapture(TurokPlayerController(PlayerPawn.Controller));                    
                }
                else
                {
                    return false;
                }
            }
            CarriedFlagBase = TurokMPTeamFlagBase(CarriedFlag.ReleaseFactory());
            // End:0x14A
            if(CarriedFlagBase != none)
            {
                CarriedFlagBase.FlagRespawn(ScoredFlagRespawnTime);
                CarriedFlagBase = none;
            }
            invMan.DropFromInventory(CarriedFlag);
            CarriedFlag.Destroy();
        }        
    }
    else
    {
        // End:0x1DF
        if((invMan.FindInventoryType(Class'TurokMPTeamFlag', true) == none) && FlagBase.IsPickupEnabled())
        {
            FlagBase.FlagStolen(PlayerPawn);
            ScoreFlagSteal(TurokPlayerController(PlayerPawn.Controller));
            return true;
        }
    }
    return false;
    //return ReturnValue;    
}

function UpdateFlagState(int flagTeamIndex, byte FlagState, @NULL Target)
{
    local byte enemyTeamIndex;

    super.UpdateFlagState(flagTeamIndex, FlagState, Target);
    switch(flagTeamIndex)
    {
        // End:0x2B
        case 0:
            enemyTeamIndex = 1;
            // End:0x42
            break;
        // End:0x3A
        case 1:
            enemyTeamIndex = 0;
            // End:0x42
            break;
        // End:0xFFFF
        default:
            // DebugMode: 0
            assert(false);
            break;
    }
    switch(FlagState)
    {
        // End:0x7A
        case 3:
            // DebugMode: 0
            assert(Target.IsA('TurokDroppedFlagPickup'));
            UpdateFlagIndicator(Target, true, enemyTeamIndex);
            // End:0x178
            break;
        // End:0xCC
        case 0:
            // DebugMode: 0
            assert(Target.IsA('TurokCTFBase') && int(Target.GetTeamNum()) == flagTeamIndex);
            UpdateFlagIndicator(Target, false, enemyTeamIndex);
            // End:0x178
            break;
        // End:0x11E
        case 1:
            // DebugMode: 0
            assert(Target.IsA('TurokCTFBase') && int(Target.GetTeamNum()) == flagTeamIndex);
            UpdateFlagIndicator(Target, false, enemyTeamIndex);
            // End:0x178
            break;
        // End:0x170
        case 2:
            // DebugMode: 0
            assert(Target.IsA('TurokCTFBase') && int(Target.GetTeamNum()) != flagTeamIndex);
            UpdateFlagIndicator(Target, false, enemyTeamIndex);
            // End:0x178
            break;
        // End:0xFFFF
        default:
            // DebugMode: 0
            assert(false);
            break;
    }
    //return;    
}

exec function NetPrintHostSettings()
{
    super.NetPrintHostSettings();
    //return;    
}

defaultproperties
{
    HUDType=Class'TurokCTFHud'
}