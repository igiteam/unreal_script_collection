class MOHAGameReplicationInfo extends GameReplicationInfo
    native
    config(Game)
    hidecategories(Navigation,Movement,Collision);

const MAX_REPLICATED_OBJECTIVES = 8;

struct native ServerOptionsInfo
{
    var bool bShowFriendlyNames;
    var bool bShowEnemyNames;
    var bool bShowFriendlyCompassBeads;
    var bool bShowEnemyCompassBeads;
    var bool bShowCompass;
    var bool bShowGrenadeIcon;
    var bool bShowHUD;
    var bool bShowText;
    var bool bShowStanceIndicator;
    var bool bShowHealthBar;
    var bool bShowHitIndicator;
    var bool bShowCrosshairs;
    var bool bShowScoreAndTimer;

    structdefaultproperties
    {
        bShowFriendlyNames=true
        bShowEnemyNames=true
        bShowFriendlyCompassBeads=true
        bShowEnemyCompassBeads=true
        bShowCompass=true
        bShowGrenadeIcon=true
        bShowHUD=true
        bShowText=true
        bShowStanceIndicator=true
        bShowHealthBar=true
        bShowHitIndicator=true
        bShowCrosshairs=true
        bShowScoreAndTimer=true
    }
};

var bool m_bUseSelectSpawnPointMenu;
var repnotify bool ConnectionLost;
var bool bDedicatedServerGame;
var bool bDirtyRoundStartTime;
var class<ScoreBoard> PostGameScoreBoardType;
var class<ScoreBoard> InGameScoreBoardType;
var repnotify int RoundStatus;
var repnotify MPObjective.EObjectiveState ObjectiveState[8];
var MOHAMultiplayerGameInfo.EUpgradesAllowedStatus UpgradesAllowed;
var array<MPObjective> ObjectiveArray;
var int AxisRoundsWon;
var int AlliedRoundsWon;
var int BestOfThisManyRounds;
var int m_iAxisSpecialUnitPoints;
var int m_iAlliedSpecialUnitPoints;
var const localized string RankRecruit;
var const localized string RankPrivate;
var const localized string RankPrivateFirstClass;
var const localized string RankCorporal;
var const localized string RankSergeant;
var const localized string RankStaffSergeant;
var const localized string RankSergeantFirstClass;
var const localized string RankMasterSergeant;
var const localized string RankFirstSergeant;
var const localized string RankSecondLieutenant;
var const localized string RankFirstLieutenant;
var const localized string RankCaptain;
var const localized string RankMajor;
var const localized string RankLieutenantColonel;
var const localized string RankColonel;
var const localized string RankBrigadierGeneral;
var const localized string RankMajorGeneral;
var const localized string RankLieutenantGeneral;
var const localized string RankGeneral;
var const localized string RankGeneralOfTheArmy;
var const localized string RankNoRank;
var const localized string TeamAxis;
var const localized string TeamAllies;
var array<MOHAPlayerReplicationInfo> RankedPRIs;
var private float m_fRoundStartTime;
var repnotify float m_fRoundElapsedTime;
var int DistinguishedUnitAwarded[2];
var int MeritoriousUnitAwarded[2];
var repnotify int LastRoundWinningTeam;
var config float TimeInPlane;
var config int SecondsBetweenRounds;
var config int SecondsAtEndOfMatch;
var ServerOptionsInfo ServerOptions;

replication
{
    // Pos:0x000
    if(bNetDirty && int(Role) == int(ROLE_Authority)
        AlliedRoundsWon, AxisRoundsWon, 
        ConnectionLost, LastRoundWinningTeam, 
        ObjectiveState, RoundStatus;

    // Pos:0x018
    if(bNetInitial && int(Role) == int(ROLE_Authority)
        BestOfThisManyRounds, SecondsAtEndOfMatch, 
        SecondsBetweenRounds, UpgradesAllowed, 
        bDedicatedServerGame, m_fRoundElapsedTime;

    // Pos:0x030
    if((bNetInitial || bNetDirty) && int(Role) == int(ROLE_Authority)
        ServerOptions;
}

// Export UMOHAGameReplicationInfo::execResetRoundStartTime(FFrame&, void* const)
native final function ResetRoundStartTime();

// Export UMOHAGameReplicationInfo::execGetMapFilename(FFrame&, void* const)
native final function string GetMapFilename();

// Export UMOHAGameReplicationInfo::execGetRemainingTimeByState(FFrame&, void* const)
native function int GetRemainingTimeByState();

simulated function string GetMapAbbr()
{
    local string MapName;

    MapName = "" $ GetMapFilename();
    // End:0x43
    if(InStr(MapName, ".umap") != -1)
    {
        MapName = Left(MapName, InStr(MapName, ".umap"));
    }
    // End:0x70
    if(InStr(MapName, "_P") != -1)
    {
        MapName = Left(MapName, InStr(MapName, "_P"));
    }
    // End:0x9F
    if(InStr(MapName, "_") != -1)
    {
        MapName = Mid(MapName, InStr(MapName, "_") + 1);
    }
    switch(MapName)
    {
        // End:0xB8
        case "Remagen":
            return "REM";
        // End:0xC5
        case "TH":
            return "HNT";
        // End:0xD2
        case "DV":
            return "VIL";
        // End:0xDA
        case "Nep":
        // End:0xE2
        case "Hus":
        // End:0xF2
        case "Ava":
            return Caps(MapName);
        // End:0xFFFF
        default:
            return "???";
            break;
    }
    //return ReturnValue;    
}

simulated function string GetModeAbbr()
{
    return "??";
    //return ReturnValue;    
}

simulated function EndGame()
{
    bMatchIsOver = true;
    //return;    
}

simulated function PostBeginPlay()
{
    local MPObjective mpObj;

    super.PostBeginPlay();
    // End:0x26
    foreach DynamicActors(Class'MPObjective', mpObj)
    {
        AddObjective(mpObj);        
    }    
    //return;    
}

// Export UMOHAGameReplicationInfo::execGetWinningTeam(FFrame&, void* const)
native function int GetWinningTeam();

simulated function bool InOrder(PlayerReplicationInfo P1, PlayerReplicationInfo P2)
{
    // End:0x23
    if(P1.Score < P2.Score)
    {
        return false;
    }
    // End:0x12C
    if(P1.Score == P2.Score)
    {
        // End:0x67
        if(P1.Deaths > P2.Deaths)
        {
            return false;
        }
        // End:0x12C
        if(P1.Deaths == P2.Deaths)
        {
            // End:0xB9
            if(int(MOHAPlayerReplicationInfo(P1).m_eMilitaryRank) < int(MOHAPlayerReplicationInfo(P2).m_eMilitaryRank))
            {
                return false;
            }
            // End:0x12C
            if(int(MOHAPlayerReplicationInfo(P1).m_eMilitaryRank) == int(MOHAPlayerReplicationInfo(P2).m_eMilitaryRank))
            {
                // End:0x12C
                if((PlayerController(P2.Owner) != none) && LocalPlayer(PlayerController(P2.Owner).Player) != none)
                {
                    return false;
                }
            }
        }
    }
    return true;
    //return ReturnValue;    
}

simulated function Timer()
{
    // End:0x20
    if(int(WorldInfo.NetMode) == int(NM_Client))
    {
        ElapsedTime++;
    }
    //return;    
}

simulated event bool IsTeamNameSingular(int TeamIndex)
{
    // End:0x0D
    if(TeamIndex == 1)
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

simulated event string GetTeamName(int TeamIndex)
{
    switch(TeamIndex)
    {
        // End:0x11
        case 0:
            return TeamAllies;
        // End:0x1B
        case 1:
            return TeamAxis;
        // End:0xFFFF
        default:
            return "Not Found";
            break;
    }
    //return ReturnValue;    
}

simulated function Color GetTeamColor(int TeamID)
{
    local Color PawnColor;

    switch(TeamID)
    {
        // End:0x5D
        case 0:
            PawnColor.R = 0;
            PawnColor.G = 0;
            PawnColor.B = byte(255);
            PawnColor.A = byte(255);
            return PawnColor;
        // End:0xB3
        case 1:
            PawnColor.R = byte(255);
            PawnColor.G = 0;
            PawnColor.B = 0;
            PawnColor.A = byte(255);
            return PawnColor;
        // End:0x10E
        case 255:
            PawnColor.R = byte(255);
            PawnColor.G = byte(255);
            PawnColor.B = byte(255);
            PawnColor.A = byte(255);
            return PawnColor;
        // End:0xFFFF
        default:
            PawnColor.R = 0;
            PawnColor.G = byte(255);
            PawnColor.B = 0;
            PawnColor.A = byte(255);
            return PawnColor;
            break;
    }
    //return ReturnValue;    
}

simulated event string GetMilitaryRank(int RankIndex)
{
    switch(RankIndex)
    {
        // End:0x11
        case 0:
            return RankRecruit;
        // End:0x1B
        case 1:
            return RankPrivate;
        // End:0x26
        case 2:
            return RankPrivateFirstClass;
        // End:0x31
        case 3:
            return RankCorporal;
        // End:0x3C
        case 4:
            return RankSergeant;
        // End:0x47
        case 5:
            return RankStaffSergeant;
        // End:0x52
        case 6:
            return RankSergeantFirstClass;
        // End:0x5D
        case 7:
            return RankMasterSergeant;
        // End:0x68
        case 8:
            return RankFirstSergeant;
        // End:0x73
        case 9:
            return RankSecondLieutenant;
        // End:0x7E
        case 10:
            return RankFirstLieutenant;
        // End:0x89
        case 11:
            return RankCaptain;
        // End:0x94
        case 12:
            return RankMajor;
        // End:0x9F
        case 13:
            return RankLieutenantColonel;
        // End:0xAA
        case 14:
            return RankColonel;
        // End:0xB5
        case 15:
            return RankBrigadierGeneral;
        // End:0xC0
        case 16:
            return RankMajorGeneral;
        // End:0xCB
        case 17:
            return RankLieutenantGeneral;
        // End:0xD6
        case 18:
            return RankGeneral;
        // End:0xE1
        case 19:
            return RankGeneralOfTheArmy;
        // End:0xFFFF
        default:
            return RankNoRank;
            break;
    }
    //return ReturnValue;    
}

simulated function AddObjective(MPObjective mpObj)
{
    local int I;

    I = 0;
    J0x07:

    // End:0x38 [Loop If]
    if(I < ObjectiveArray.Length)
    {
        // End:0x2E
        if(ObjectiveArray[I] == mpObj)
        {
            return;
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    I = ObjectiveArray.Length;
    ObjectiveArray[I] = mpObj;
    ObjectiveState[I] = mpObj.ObjectiveState;
    mpObj.m_iGRIIndex = I;
    SortObjectiveArray();
    return;
    //return;    
}

simulated function RemoveObjective(MPObjective mpObj)
{
    local int I;

    I = 0;
    J0x07:

    // End:0x4A [Loop If]
    if(I < ObjectiveArray.Length)
    {
        // End:0x40
        if(ObjectiveArray[I] == mpObj)
        {
            ObjectiveArray.Remove(I, 1);
            SortObjectiveArray();
            return;
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

// Export UMOHAGameReplicationInfo::execSortObjectiveArray(FFrame&, void* const)
native final function SortObjectiveArray();

function UpdateObjective(MPObjective mpObj)
{
    // End:0x4E
    if((mpObj.m_iGRIIndex >= 0) && mpObj.m_iGRIIndex < 8)
    {
        ObjectiveState[mpObj.m_iGRIIndex] = mpObj.ObjectiveState;
    }
    //return;    
}

simulated event ReplicatedEvent(name VarName)
{
    local int I;

    // End:0x84
    if(VarName == 'ObjectiveState')
    {
        I = 8;
        // End:0x37
        if(I > ObjectiveArray.Length)
        {
            I = ObjectiveArray.Length;
        }
        I = I - 1;
        J0x45:

        // End:0x7F [Loop If]
        if(I >= 0)
        {
            ObjectiveArray[I].ChangeState(ObjectiveState[I], true);
            I--;
            // [Loop Continue]
            goto J0x45;
        }
        return;        
    }
    else
    {
        super.ReplicatedEvent(VarName);
    }
    //return;    
}

defaultproperties
{
    bDirtyRoundStartTime=true
    PostGameScoreBoardType=Class'MOHAScoreboard_AB'
    InGameScoreBoardType=Class'MOHAScoreboard_AB'
    RoundStatus=4
    BestOfThisManyRounds=1
    RankRecruit="Recruit"
    RankPrivate="Private"
    RankPrivateFirstClass="Private First Class"
    RankCorporal="Corporal"
    RankSergeant="Sergeant"
    RankStaffSergeant="Staff Sergeant"
    RankSergeantFirstClass="Sergeant First Class"
    RankMasterSergeant="Master Sergeant"
    RankFirstSergeant="First Sergeant"
    RankSecondLieutenant="Second Lieutenant"
    RankFirstLieutenant="First Lieutenant"
    RankCaptain="Captain"
    RankMajor="Major"
    RankLieutenantColonel="Lieutenant Colonel"
    RankColonel="Colonel"
    RankBrigadierGeneral="Brigadier General"
    RankMajorGeneral="Major General"
    RankLieutenantGeneral="Lieutenant General"
    RankGeneral="General"
    RankGeneralOfTheArmy="General of the Army"
    RankNoRank="NO RANK"
    TeamAxis="Axis"
    TeamAllies="Allies"
    TimeInPlane=12.5000000
    SecondsBetweenRounds=15
    SecondsAtEndOfMatch=30
    ServerOptions=(bShowFriendlyNames=true,bShowEnemyNames=true,bShowFriendlyCompassBeads=true,bShowEnemyCompassBeads=true,bShowCompass=true,bShowGrenadeIcon=true,bShowHUD=true,bShowText=true,bShowStanceIndicator=true,bShowHealthBar=true,bShowHitIndicator=true,bShowCrosshairs=true,bShowScoreAndTimer=true)
    GameClass=Class'MOHAMultiplayerGameInfo'
    bMatchHasBegun=true
    NetUpdateFrequency=5.0000000
    fDeferredNetUpdateFrequency=5.0000000
}