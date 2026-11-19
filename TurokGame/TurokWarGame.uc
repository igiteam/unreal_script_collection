class TurokWarGame extends TurokTeamGame
    native
    config(Game)
    hidecategories(Navigation,Movement,Collision);

var private array mCoreObjectives;
var private array mBombObjectives;
var private @NULL mObjectiveIndicators[2];
var private string mObjectiveStrings[2];
var private @NULL mObjectiveTargets[2];

function PreBeginPlay()
{
    local @NULL coreObj, bombObj;

    super.PreBeginPlay();
    // End:0x29
    foreach AllActors(Class'TurokMPObjectiveLocationPickup', coreObj)
    {
        mCoreObjectives[mCoreObjectives.Length] = coreObj;        
    }    
    // End:0x4D
    foreach AllActors(Class'TurokBombActionVolume', bombObj)
    {
        mBombObjectives[mBombObjectives.Length] = bombObj;        
    }    
    //return;    
}

event PostSaveGameRestore()
{
    super(TurokMPGame).PostSaveGameRestore();
    // End:0x3C
    if((mObjectiveTargets[0] != none) || mObjectiveStrings[0] != "")
    {
        SetWargameObjective(0, mObjectiveTargets[0], mObjectiveStrings[0]);
    }
    // End:0x72
    if((mObjectiveTargets[1] != none) || mObjectiveStrings[1] != "")
    {
        SetWargameObjective(1, mObjectiveTargets[1], mObjectiveStrings[1]);
    }
    //return;    
}

event InitGame(string Options, out string ErrorMessage)
{
    local @NULL GoalObj;
    local int NumGoals;

    super.InitGame(Options, ErrorMessage);
    // End:0x1E
    if(ErrorMessage != "")
    {
        return;
    }
    NumGoals = 0;
    // End:0x3D
    foreach AllActors(Class'TurokGoalInfo', GoalObj)
    {
        ++NumGoals;        
    }    
    GoalScore = NumGoals;
    //return;    
}

function InitGameReplicationInfo()
{
    local int I;

    super.InitGameReplicationInfo();
    I = 0;
    J0x0D:

    // End:0x4E [Loop If]
    if(I < 2)
    {
        // End:0x44
        if(mObjectiveIndicators[I] == none)
        {
            mObjectiveIndicators[I] = __NFUN_278__(Class'TurokMPObjectiveIndicator');
        }
        ++I;
        // [Loop Continue]
        goto J0x0D;
    }
    //return;    
}

function Reset()
{
    local int I;

    I = 0;
    J0x07:

    // End:0x62 [Loop If]
    if(I < 2)
    {
        // End:0x3D
        if(mObjectiveIndicators[I] != none)
        {
            mObjectiveIndicators[I].Deactivate();
        }
        mObjectiveStrings[I] = "";
        mObjectiveTargets[I] = none;
        ++I;
        // [Loop Continue]
        goto J0x07;
    }
    super.Reset();
    //return;    
}

event Destroyed()
{
    // End:0x1B
    if(mObjectiveIndicators[0] != none)
    {
        mObjectiveIndicators[0].Destroy();
    }
    mObjectiveIndicators[0] = none;
    // End:0x3F
    if(mObjectiveIndicators[1] != none)
    {
        mObjectiveIndicators[1].Destroy();
    }
    mObjectiveIndicators[1] = none;
    super(Actor).Destroyed();
    //return;    
}

function SetWargameObjective(int Team, @NULL tgt, string hashStr)
{
    local int hashID;

    // DebugMode: 0
    assert(mObjectiveIndicators[0] != none);
    // DebugMode: 0
    assert(mObjectiveIndicators[1] != none);
    // DebugMode: 0
    assert((Team == 0) || Team == 1);
    hashID = Class'TurokEngine.TurokUI'.static.GetEngine().GetLocalization().HashAHashString(hashStr);
    mObjectiveStrings[Team] = hashStr;
    mObjectiveTargets[Team] = tgt;
    mObjectiveIndicators[Team].Activate();
    mObjectiveIndicators[Team].SetStaticTarget(tgt, Team);
    mObjectiveIndicators[Team].SetObjectiveHashID(hashID);
    //return;    
}

function ScoreGoal(int TeamID, @NULL Scorer, @NULL goalInfo)
{
    local @NULL scoringTeam, scorerPRI, TGRI;

    // DebugMode: 0
    assert((TeamID >= 0) && TeamID < 2);
    TGRI = TurokTeamGameReplicationInfo(GameReplicationInfo);
    scoringTeam = TGRI.Teams[TeamID];
    // End:0x51
    if(scoringTeam == none)
    {
        return;
    }
    scorerPRI = none;
    // End:0x77
    if(Scorer != none)
    {
        scorerPRI = Scorer.PlayerReplicationInfo;
    }
    scoringTeam.Score += 1.0000000;
    scoringTeam.NetUpdateTime = WorldInfo.TimeSeconds - float(1);
    CheckTeamScore(scorerPRI, scoringTeam);
    //return;    
}

function LoseGoal(int TeamID, @NULL punisher)
{
    local @NULL loserTeam;

    // DebugMode: 0
    assert((TeamID >= 0) && TeamID < 2);
    loserTeam = GameReplicationInfo.Teams[TeamID];
    // End:0x41
    if(loserTeam == none)
    {
        return;
    }
    loserTeam.Score -= 1.0000000;
    loserTeam.NetUpdateTime = WorldInfo.TimeSeconds - float(1);
    //return;    
}

function ScoreObjectivePoints(@NULL ScoringPlayer, byte scoreType)
{
    local int Points;
    local @NULL TPC;

    TPC = TurokPlayerController(ScoringPlayer);
    // End:0x28F
    if(TPC != none)
    {
        Points = 0;
        switch(scoreType)
        {
            // End:0x3C
            case 4:
                Points = NPCHackPoints;
                // End:0x26F
                break;
            // End:0xAC
            case 1:
                Points = HackComputerPoints;
                TurokMPPlayerReplicationInfo(TPC.PlayerReplicationInfo).mActCount++;
                TurokMPPlayerReplicationInfo(TPC.PlayerReplicationInfo).mActScore += Points;
                TPC.RecordStat(114, 1.0000000, 1);
                // End:0x26F
                break;
            // End:0x11C
            case 2:
                Points = BombLocationPoints;
                TurokMPPlayerReplicationInfo(TPC.PlayerReplicationInfo).mActCount++;
                TurokMPPlayerReplicationInfo(TPC.PlayerReplicationInfo).mActScore += Points;
                TPC.RecordStat(111, 1.0000000, 1);
                // End:0x26F
                break;
            // End:0x18C
            case 3:
                Points = DefuseBombPoints;
                TurokMPPlayerReplicationInfo(TPC.PlayerReplicationInfo).mActCount++;
                TurokMPPlayerReplicationInfo(TPC.PlayerReplicationInfo).mActScore += Points;
                TPC.RecordStat(112, 1.0000000, 1);
                // End:0x26F
                break;
            // End:0x1FC
            case 6:
                Points = StealPowerCorePoints;
                TurokMPPlayerReplicationInfo(TPC.PlayerReplicationInfo).mActCount++;
                TurokMPPlayerReplicationInfo(TPC.PlayerReplicationInfo).mActScore += Points;
                TPC.RecordStat(124, 1.0000000, 1);
                // End:0x26F
                break;
            // End:0x26C
            case 5:
                Points = ReturnPowerCorePoints;
                TurokMPPlayerReplicationInfo(TPC.PlayerReplicationInfo).mActCount++;
                TurokMPPlayerReplicationInfo(TPC.PlayerReplicationInfo).mActScore += Points;
                TPC.RecordStat(123, 1.0000000, 1);
                // End:0x26F
                break;
            // End:0xFFFF
            default:
                break;
        }
        ScoringPlayer.PlayerReplicationInfo.Score += float(Points);
    }
    //return;    
}

function Killed(@NULL Killer, @NULL KilledPlayer, @NULL KilledPawn, class<Class> DamageType)
{
    local int I, J, TeamNum;
    local @NULL C, Human;
    local class<Class> carriedItemClass;
    local @NULL coreObj, bombObj, PRI, TPC;

    // End:0x70B
    if(((AllowKillScoreUpdate(DamageType)) && Killer != none) && Killer.PlayerReplicationInfo != none)
    {
        Human = TurokPawnPlayer(KilledPawn);
        // End:0x1D0
        if((Human != none) && !GameReplicationInfo.OnSameTeam(Killer, KilledPlayer))
        {
            carriedItemClass = class<TurokMPObjectiveItem>(Human.GetAttachedInventoryItemClass());
            // End:0x1D0
            if((carriedItemClass != none) && carriedItemClass.default.ScorePointsForKillingCarrier)
            {
                Killer.PlayerReplicationInfo.Score += float(KillObjectiveCarrierPoints);
                PRI = TurokMPPlayerReplicationInfo(Killer.PlayerReplicationInfo);
                TPC = TurokPlayerController(Killer);
                // End:0x165
                if(((TPC != none) && PRI != none) && ClassIsChildOf(carriedItemClass, Class'TurokMPObjectiveItemPowerCoreNative'))
                {
                    TPC.RecordStat(125, 1.0000000, 1);
                    PRI.mActScore += KillObjectiveCarrierPoints;
                    PRI.mActCount++;
                }
                // End:0x1D0
                if(((TPC != none) && PRI != none) && ClassIsChildOf(carriedItemClass, Class'TurokBombNative'))
                {
                    TPC.RecordStat(113, 1.0000000, 1);
                    PRI.mActScore += KillObjectiveCarrierPoints;
                    PRI.mActCount++;
                }
            }
        }
        // End:0x479
        foreach WorldInfo.AllControllers(Class'Engine.Controller', C)
        {
            // End:0x478
            if((Killer != C) && GameReplicationInfo.OnSameTeam(Killer, C))
            {
                Human = TurokPawnPlayer(C.Pawn);
                // End:0x478
                if(Human != none)
                {
                    carriedItemClass = class<TurokMPObjectiveItem>(Human.GetAttachedInventoryItemClass());
                    // End:0x478
                    if(carriedItemClass != none)
                    {
                        I = 0;
                        J0x271:

                        // End:0x354 [Loop If]
                        if(I < Human.mHitByList.Length)
                        {
                            // End:0x34A
                            if(Human.mHitByList[I] == KilledPlayer)
                            {
                                Killer.PlayerReplicationInfo.Score += float(KillObjectiveHarmerPoints);
                                PRI = TurokMPPlayerReplicationInfo(Killer.PlayerReplicationInfo);
                                TPC = TurokPlayerController(Killer);
                                // End:0x34A
                                if((TPC != none) && PRI != none)
                                {
                                    TPC.RecordStat(126, 1.0000000, 1);
                                    PRI.mActScore += KillObjectiveHarmerPoints;
                                    PRI.mActCount++;
                                }
                            }
                            I++;
                            // [Loop Continue]
                            goto J0x271;
                        }
                        // End:0x478
                        if(((Killer.Pawn != none) && VSize(Killer.Pawn.Location - Human.Location) < MaxDistanceForProximityKillPoints) || (KilledPawn != none) && VSize(KilledPawn.Location - Human.Location) < MaxDistanceForProximityKillPoints)
                        {
                            Killer.PlayerReplicationInfo.Score += float(KillNearObjectiveCarrierPoints);
                            PRI = TurokMPPlayerReplicationInfo(Killer.PlayerReplicationInfo);
                            TPC = TurokPlayerController(Killer);
                            // End:0x478
                            if((TPC != none) && PRI != none)
                            {
                                TPC.RecordStat(127, 1.0000000, 1);
                                PRI.mActScore += KillNearObjectiveCarrierPoints;
                                PRI.mActCount++;
                            }
                        }
                    }
                }
            }            
        }        
        // End:0x70B
        if(Killer.Pawn != none)
        {
            TeamNum = int(Killer.GetTeamNum());
            I = 0;
            J0x4B0:

            // End:0x578 [Loop If]
            if(I < mCoreObjectives.Length)
            {
                coreObj = mCoreObjectives[I];
                // End:0x56E
                if((coreObj.IsPickupEnabled() && coreObj.GetCaptorTeamIndex() == TeamNum) && (VSize(Killer.Pawn.Location - coreObj.Location) < MaxDistanceForProximityKillPoints) || VSize(KilledPawn.Location - coreObj.Location) < MaxDistanceForProximityKillPoints)
                {
                    ++J;
                }
                ++I;
                // [Loop Continue]
                goto J0x4B0;
            }
            I = 0;
            J0x57F:

            // End:0x649 [Loop If]
            if(I < mBombObjectives.Length)
            {
                bombObj = mBombObjectives[I];
                // End:0x63F
                if((bombObj.GetIsBombPlanted() && int(bombObj.GetTeamNum()) == TeamNum) && (VSize(Killer.Pawn.Location - bombObj.Location) < MaxDistanceForProximityKillPoints) || VSize(KilledPawn.Location - bombObj.Location) < MaxDistanceForProximityKillPoints)
                {
                    ++J;
                }
                ++I;
                // [Loop Continue]
                goto J0x57F;
            }
            // End:0x70B
            if(J > 0)
            {
                Killer.PlayerReplicationInfo.Score += float(KillNearObjectivePoints * J);
                PRI = TurokMPPlayerReplicationInfo(Killer.PlayerReplicationInfo);
                TPC = TurokPlayerController(Killer);
                // End:0x70B
                if((TPC != none) && PRI != none)
                {
                    TPC.RecordStat(128, float(J), 1);
                    PRI.mActScore += (KillNearObjectivePoints * J);
                    PRI.mActCount += J;
                }
            }
        }
    }
    super.Killed(Killer, KilledPlayer, KilledPawn, DamageType);
    //return;    
}

function bool PickupQuery(@NULL pwn, class<Class> ItemClass, @NULL Pickup)
{
    local @NULL powerCore;

    // End:0x61
    if(Pickup.IsA('TurokDroppedPowerCorePickup'))
    {
        powerCore = TurokMPObjectiveItemPowerCoreNative(TurokDroppedPowerCorePickup(Pickup).Inventory);
        // End:0x61
        if((powerCore != none) && !powerCore.CanBePickedUp(pwn))
        {
            return true;
        }
    }
    return super(GameInfo).PickupQuery(pwn, ItemClass, Pickup);
    //return ReturnValue;    
}

protected function OnTimeOut()
{
    local @NULL currGoalInfo;

    // End:0x24
    foreach AllActors(Class'TurokGoalInfo', currGoalInfo)
    {
        currGoalInfo.OnGameTimeOut();        
    }    
    super(TurokMPGame).OnTimeOut();
    //return;    
}

defaultproperties
{
    HUDType=Class'TurokWarGameHud'
    GameReplicationInfoClass=Class'TurokWarGameReplicationInfo'
}