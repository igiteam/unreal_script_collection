class TurokRichPresenceLive extends TurokRichPresence
    native
    config(Game);

const INVALID_RICHPRESENCE_CONTROLLER_PORT = 255;

var private int mLocalUserNum;
var private int mPresenceMode;
var private array mContexts;
var private array mProperties;
var private bool mChanged;
var private float mLastTickUpdate;
var config float TickRate;

// Export UTurokRichPresenceLive::execGetWorldInfo(FFrame&, void* const)
private native final function @NULL GetWorldInfo();

// Export UTurokRichPresenceLive::execGetMapName(FFrame&, void* const)
private native final function string GetMapName();

private final event ScriptTick()
{
    local int PresenceMode;
    local @NULL TGRI, TTGRI, TPRI, P, localPawn, C;

    localPawn = none;
    // End:0x55
    if(TurokFEGame(GetWorldInfo().Game) != none)
    {
        // End:0x4B
        if(Class'Engine.Engine'.static.GetTurokNet().GetLobby() != none)
        {
            PresenceMode = 2;            
        }
        else
        {
            PresenceMode = 1;
        }        
    }
    else
    {
        // End:0xB4
        foreach GetWorldInfo().AllControllers(Class'Engine.PlayerController', C)
        {
            P = C.Pawn;
            // End:0xB3
            if((P != none) && P.IsLocallyControlled())
            {
                localPawn = P;
                // End:0xB4
                break;
            }            
        }        
        // End:0xC2
        if(localPawn == none)
        {
            return;
        }
        // End:0x133
        if(int(GetWorldInfo().NetMode) == int(NM_Standalone))
        {
            PresenceMode = 9;
            SetHealth(localPawn.Health);
            SetDifficulty(int(GetWorldInfo().Game.GameDifficulty));
            SetLevelName(GetMapName());            
        }
        else
        {
            // End:0x14A
            if(GetWorldInfo().GRI == none)
            {
                return;
            }
            TGRI = TurokMPGameReplicationInfo(GetWorldInfo().GRI);
            // End:0x171
            if(TGRI == none)
            {
                return;
            }
            TTGRI = TurokTeamGameReplicationInfo(GetWorldInfo().GRI);
            // End:0x1C8
            if((TTGRI != none) && (TTGRI.Teams[0] == none) || TTGRI.Teams[1] == none)
            {
                return;
            }
            TPRI = TurokMPPlayerReplicationInfo(localPawn.PlayerReplicationInfo);
            // End:0x1EE
            if(TPRI == none)
            {
                return;
            }
            // End:0x274
            if(TTGRI == none)
            {
                PresenceMode = 8;
                TGRI.ForceStatsRecalc();
                SetKillInfoForDeathmatch(TGRI.GetBestPlayer(none).Kills, TPRI.Kills, int(TPRI.Deaths), GetWorldInfo().GRI.GoalScore);                
            }
            else
            {
                // End:0x2D4
                if(TurokWarGameReplicationInfo(GetWorldInfo().GRI) != none)
                {
                    // End:0x2C9
                    if(TGRI.IsRankedGame())
                    {
                        PresenceMode = 11;
                        SetRank(int(TPRI.mRank));                        
                    }
                    else
                    {
                        PresenceMode = 12;
                    }                    
                }
                else
                {
                    // End:0x2F9
                    if(TurokCoopGameReplicationInfo(GetWorldInfo().GRI) != none)
                    {
                        PresenceMode = 5;                        
                    }
                    else
                    {
                        // End:0x4AC
                        if(TurokFlagGameReplicationInfo(GetWorldInfo().GRI) != none)
                        {
                            // End:0x435
                            if(GetWorldInfo().GRI.GameClass == Class'TurokCTFGame')
                            {
                                // End:0x370
                                if(TGRI.IsRankedGame())
                                {
                                    PresenceMode = 6;
                                    SetRank(int(TPRI.mRank));                                    
                                }
                                else
                                {
                                    PresenceMode = 7;
                                }
                                // End:0x432
                                if((int(localPawn.GetTeamNum()) != 255) && TTGRI.Teams[int(localPawn.GetTeamNum())] != none)
                                {
                                    SetScoreInfoForCtf(int(TTGRI.Teams[int(localPawn.GetTeamNum())].Score), int(TTGRI.Teams[((int(localPawn.GetTeamNum()) == 0) ? 1 : 0)].Score));
                                }                                
                            }
                            else
                            {
                                // End:0x470
                                if(TGRI.IsRankedGame())
                                {
                                    PresenceMode = 3;
                                    SetRank(int(TPRI.mRank));                                    
                                }
                                else
                                {
                                    PresenceMode = 4;
                                }
                                SetAreWeAssaultingForActf(int(TTGRI.mCurrPrimaryTeamIndex) == int(localPawn.GetTeamNum()));
                            }                            
                        }
                        else
                        {
                            PresenceMode = 10;
                            // End:0x5BA
                            if(((int(localPawn.GetTeamNum()) != 255) && TTGRI != none) && TTGRI.Teams[int(localPawn.GetTeamNum())] != none)
                            {
                                TTGRI.ForceStatsRecalc();
                                SetKillInfoForDeathmatch(int(TTGRI.GetBestTeam(none).Score), int(TTGRI.Teams[int(localPawn.GetTeamNum())].Score), TTGRI.mTeamStats[int(localPawn.GetTeamNum())].mDeaths, GetWorldInfo().GRI.GoalScore);
                            }
                        }
                    }
                }
            }
        }
    }
    SetGameMode(PresenceMode);
    //return;    
}

event SetUserNum(int Num)
{
    // End:0x2D
    if(mLocalUserNum != Num)
    {
        mChanged = true;
        ClearRichPresence(mLocalUserNum);
        mLocalUserNum = Num;
    }
    //return;    
}

event SetGameMode(int GameMode)
{
    // End:0x17
    if(mPresenceMode != GameMode)
    {
        mChanged = true;
    }
    mPresenceMode = GameMode;
    UpdateRichPresence();
    //return;    
}

event SetRank(int Rank)
{
    local @NULL Setting;

    Setting.Id = 7;
    Setting.ValueIndex = Rank - 1;
    SetContext(Setting);
    //return;    
}

event SetHealth(int Health)
{
    local @NULL Setting;
    local float healthPercentage;

    Setting.Id = 3;
    healthPercentage = 100.0000000 * (float(Health) / float(Class'TurokPawnPlayer'.default.mDefaultHealth));
    // End:0x5B
    if(healthPercentage > float(75))
    {
        Setting.ValueIndex = 4;        
    }
    else
    {
        // End:0x7E
        if(healthPercentage > float(50))
        {
            Setting.ValueIndex = 3;            
        }
        else
        {
            // End:0xA1
            if(healthPercentage > float(25))
            {
                Setting.ValueIndex = 2;                
            }
            else
            {
                // End:0xC2
                if(healthPercentage > float(1))
                {
                    Setting.ValueIndex = 1;                    
                }
                else
                {
                    Setting.ValueIndex = 0;
                }
            }
        }
    }
    SetContext(Setting);
    //return;    
}

event SetDifficulty(int difficulty)
{
    local @NULL Setting;

    Setting.Id = 4;
    Setting.ValueIndex = difficulty - 1;
    SetContext(Setting);
    //return;    
}

event SetLevelName(string LevelName)
{
    local int levelId;
    local @NULL Setting;

    levelId = int(Left(Repl(LevelName, "L", "", false), 2));
    Setting.Id = 5;
    Setting.ValueIndex = levelId;
    SetContext(Setting);
    //return;    
}

event SetKillInfoForDeathmatch(int winnerKills, int ownKills, int ownDeaths, int totalKillsNeeded)
{
    local @NULL Setting;

    Setting.Id = 6;
    Setting.ValueIndex = ((ownKills >= winnerKills) ? 0 : 1);
    // End:0x64
    if(Setting.ValueIndex == 0)
    {
        SetProperty(268435475, totalKillsNeeded - ownKills);        
    }
    else
    {
        SetProperty(268435475, winnerKills - ownKills);
    }
    SetProperty(268435477, ownKills);
    SetProperty(268435478, ownDeaths);
    SetContext(Setting);
    //return;    
}

event SetScoreInfoForCtf(int ownTeamScore, int opposingTeamScore)
{
    local @NULL Setting;
    local int scoreDif;

    Setting.Id = 9;
    scoreDif = ownTeamScore - opposingTeamScore;
    // End:0x47
    if(scoreDif < -4)
    {
        Setting.ValueIndex = 0;        
    }
    else
    {
        // End:0x6A
        if(scoreDif < -1)
        {
            Setting.ValueIndex = 1;            
        }
        else
        {
            // End:0x8E
            if(scoreDif == -1)
            {
                Setting.ValueIndex = 2;                
            }
            else
            {
                // End:0xAE
                if(scoreDif == 0)
                {
                    Setting.ValueIndex = 3;                    
                }
                else
                {
                    // End:0xCE
                    if(scoreDif == 1)
                    {
                        Setting.ValueIndex = 4;                        
                    }
                    else
                    {
                        // End:0xEF
                        if(scoreDif > 4)
                        {
                            Setting.ValueIndex = 5;                            
                        }
                        else
                        {
                            Setting.ValueIndex = 6;
                        }
                    }
                }
            }
        }
    }
    SetContext(Setting);
    SetProperty(268435480, ownTeamScore);
    SetProperty(268435481, opposingTeamScore);
    //return;    
}

event SetAreWeAssaultingForActf(bool assaulting)
{
    local @NULL Setting;

    Setting.Id = 8;
    Setting.ValueIndex = ((assaulting) ? 1 : 0);
    SetContext(Setting);
    //return;    
}

function (@NULL Setting)
{
    local int contextIndex;


    /* Statement decompilation error: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
        
    */
    // End:0x56
    /*@Error*/;
    // Failed to format nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 2 & Type:If Position:0x056
    // Failed to format remaining nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 2 & Type:If Position:0x056
}

// Export UTurokRichPresenceLive::execSetProperty(FFrame&, void* const)
private native final function SetProperty(int Property, int Value);

private final event UpdateRichPresence()
{
    local @NULL OnlineSub;

    OnlineSub = Class'Engine.GameEngine'.static.GetTurokOnlineSubsystem();
    // End:0x8B
    if(((mChanged && OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.PlayerInterfaceEx, OnlinePlayerInterfaceEx(none))) && mLocalUserNum != 255)
    {
        OnlineSub.PlayerInterfaceEx.SetRichPresence(byte(mLocalUserNum), mPresenceMode, mContexts, mProperties);
    }
    mChanged = false;
    //return;    
}

private final event ClearRichPresence(int UserNum)
{
    local @NULL OnlineSub;

    OnlineSub = Class'Engine.GameEngine'.static.GetTurokOnlineSubsystem();
    // End:0x7C
    if(((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.PlayerInterfaceEx, OnlinePlayerInterfaceEx(none))) && mLocalUserNum != 255)
    {
        OnlineSub.PlayerInterfaceEx.SetRichPresence(byte(UserNum), 0, mContexts, mProperties);
    }
    //return;    
}

defaultproperties
{
    mLocalUserNum=255
    mContexts=/* Array type was not detected. */
    mProperties=/* Array type was not detected. */
}