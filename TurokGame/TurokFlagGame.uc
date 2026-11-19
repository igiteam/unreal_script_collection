class TurokFlagGame extends TurokTeamGame
    abstract
    native
    config(Game)
    hidecategories(Navigation,Movement,Collision);

var protected const config int CaptureFlagPoints;
var protected const config int ReturnFlagPoints;
var protected const config int ReturnFlagThenCapturePoints;
var protected const config float ReturnFlagScoreTime;
var protected const config int KillFlagCarrierPoints;
var protected const config int KillFlagCarrierHarmerPoints;
var protected const config int KillNearFlagPoints;
var protected const config int KillNearFlagCarrierPoints;
var protected const config int KillFlagCarrierThenCapturePoints;
var protected const config float KillFlagCarrierThenCaptureTime;
var protected config bool CapturedFlagAlwaysScores;
var protected config bool CarryFlagHome;
var protected config float MaxFlagDropTime;
var protected int mLastFlagInstigator;
var protected float mLastFlagReturnTime;
var protected float mLastEnemyCarrierKillTime;
var protected @NULL mFlagIndicators[2];
var protected transient @NULL mFlagBaseTeam0;
var protected transient @NULL mFlagBaseTeam1;

event InitGame(string Options, out string ErrorMessage)
{
    local string InOpt;

    super.InitGame(Options, ErrorMessage);
    InOpt = ParseOption(Options, "CarryFlagHome");
    // End:0x4E
    if(InOpt != "")
    {
        CarryFlagHome = bool(InOpt);
    }
    InOpt = ParseOption(Options, "MaxFlagDropTime");
    // End:0x99
    if(InOpt != "")
    {
        MaxFlagDropTime = FClamp(float(InOpt), 0.0000000, 180.0000000);
    }
    //return;    
}

function InitGameReplicationInfo()
{
    super.InitGameReplicationInfo();
    // End:0x29
    if(mFlagIndicators[0] == none)
    {
        mFlagIndicators[0] = __NFUN_278__(Class'TurokMPTeamFlagIndicator');
    }
    // End:0x4C
    if(mFlagIndicators[1] == none)
    {
        mFlagIndicators[1] = __NFUN_278__(Class'TurokMPTeamFlagIndicator');
    }
    //return;    
}

function Reset()
{
    super.Reset();
    ResetScoring();
    //return;    
}

event Destroyed()
{
    mFlagIndicators[0].Destroy();
    mFlagIndicators[0] = none;
    mFlagIndicators[1].Destroy();
    mFlagIndicators[1] = none;
    super(Actor).Destroyed();
    //return;    
}

function float GetInventoryRespawnTime(class<Class> InventoryClass)
{
    // End:0x16
    if(class<TurokMPTeamFlag>(InventoryClass) != none)
    {
        return MaxFlagDropTime;
    }
    return super(TurokMPGame).GetInventoryRespawnTime(InventoryClass);
    //return ReturnValue;    
}

function bool PickupQuery(@NULL Other, class<Class> ItemClass, @NULL Pickup)
{
    local @NULL Player, invMan, FlagBase;
    local class<Class> FlagClass;
    local @NULL Inv, vel;
    local int Num;

    FlagBase = TurokMPTeamFlagBase(Pickup);
    FlagClass = class<TurokMPTeamFlag>(ItemClass);
    // End:0x297
    if((FlagBase != none) || FlagClass != none)
    {
        Player = TurokPawnPlayer(Other);
        invMan = TurokInventoryManager(Other.InvManager);
        // End:0x295
        if((Player != none) && invMan != none)
        {
            // End:0x177
            if(FlagBase != none)
            {
                // End:0x172
                if(PickupBaseFlag(FlagClass, Player, invMan, FlagBase))
                {
                    // End:0x16F
                    foreach invMan.InventoryActors(Class'TurokMPObjectiveItem', Inv)
                    {
                        // DebugMode: 0
                        assert(++Num < 2);
                        // DebugMode: 0
                        assert(!Inv.IsA('TurokMPTeamFlag'));
                        vel = Vector(Player.GetViewRotation());
                        vel = ((vel * ((Player.Velocity Dot vel) + 500.0000000)) + (250.0000000 * VRand())) + vect(0.0000000, 0.0000000, 250.0000000);
                        Inv.DropFrom(Player.Location, vel);                        
                    }                    
                    return true;
                }
                return false;                
            }
            else
            {
                // End:0x290
                if(Pickup.IsA('TurokDroppedPickup') && FlagClass != none)
                {
                    // End:0x28E
                    if(PickupDroppedFlag(FlagClass, Player, invMan, TurokDroppedPickup(Pickup)))
                    {
                        // End:0x28B
                        foreach invMan.InventoryActors(Class'TurokMPObjectiveItem', Inv)
                        {
                            // DebugMode: 0
                            assert(++Num < 2);
                            // DebugMode: 0
                            assert(!Inv.IsA('TurokMPTeamFlag'));
                            vel = Vector(Player.GetViewRotation());
                            vel = ((vel * ((Player.Velocity Dot vel) + 500.0000000)) + (250.0000000 * VRand())) + vect(0.0000000, 0.0000000, 250.0000000);
                            Inv.DropFrom(Player.Location, vel);                            
                        }                        
                        return true;
                    }
                    return false;
                }
            }
            // DebugMode: 0
            assert(false);
        }
        return false;
    }
    return super(GameInfo).PickupQuery(Other, ItemClass, Pickup);
    //return ReturnValue;    
}

protected function bool PickupBaseFlag(class<Class> FlagClass, @NULL PlayerPawn, @NULL invMan, @NULL FlagBase)
{
    // DebugMode: 0
    assert(false);
    return false;
    //return ReturnValue;    
}

protected function bool PickupDroppedFlag(class<Class> FlagClass, @NULL PlayerPawn, @NULL invMan, @NULL DroppedItem)
{
    local @NULL DroppedFlag, DroppedFlagBase;

    DroppedFlag = TurokMPTeamFlag(DroppedItem.Inventory);
    // DebugMode: 0
    assert(DroppedFlag != none);
    DroppedFlagBase = DroppedFlag.GetFlagBase();
    // DebugMode: 0
    assert(DroppedFlagBase != none);
    // End:0xBA
    if(!CarryFlagHome && GameReplicationInfo.OnSameTeam(PlayerPawn, DroppedFlag))
    {
        DroppedItem.Destroy();
        DroppedFlagBase.FlagReturned(PlayerPawn);
        ScoreFlagReturn(TurokPlayerController(PlayerPawn.Controller));
        return false;
    }
    // End:0xDB
    if(invMan.FindInventoryType(Class'TurokMPTeamFlag', true) != none)
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

function UpdateFlagState(int TeamIndex, byte FlagState, @NULL Target)
{
    local @NULL FlagGRI;

    FlagGRI = TurokFlagGameReplicationInfo(GameReplicationInfo);
    // DebugMode: 0
    assert(FlagGRI != none);
    FlagGRI.SetCurFlagStatus(byte(TeamIndex), FlagState, Target);
    //return;    
}

final function UpdateFlagIndicator(@NULL Target, bool movingTarget, byte teamIndicatorID)
{
    // End:0x33
    if(movingTarget)
    {
        mFlagIndicators[int(teamIndicatorID)].SetMovingTarget(Target, int(teamIndicatorID));        
    }
    else
    {
        mFlagIndicators[int(teamIndicatorID)].SetStaticTarget(Target, int(teamIndicatorID));
    }
    //return;    
}

final function SetFlagBaseTeam0(@NULL B)
{
    mFlagBaseTeam0 = B;
    //return;    
}

final function SetFlagBaseTeam1(@NULL B)
{
    mFlagBaseTeam1 = B;
    //return;    
}

final function @NULL GetFlagBaseTeam0()
{
    return mFlagBaseTeam0;
    //return ReturnValue;    
}

final function @NULL GetFlagBaseTeam1()
{
    return mFlagBaseTeam1;
    //return ReturnValue;    
}

protected function ResetScoring()
{
    mLastFlagInstigator = -1;
    mLastFlagReturnTime = WorldInfo.TimeSeconds;
    mLastEnemyCarrierKillTime = WorldInfo.TimeSeconds;
    //return;    
}

protected function bool ScoreFlagCapture(@NULL Player)
{
    local @NULL PlayerTeam, InstigatorPRI, PRI, C;

    PlayerTeam = Player.PlayerReplicationInfo.Team;
    PlayerTeam.Score += 1.0000000;
    PlayerTeam.NetUpdateTime = WorldInfo.TimeSeconds - float(1);
    // End:0x223
    if(!CapturedFlagAlwaysScores)
    {
        InstigatorPRI = GameReplicationInfo.FindPlayerByID(mLastFlagInstigator);
        // End:0x223
        if((InstigatorPRI != none) && GameReplicationInfo.OnSameTeam(Player, InstigatorPRI.Owner))
        {
            // End:0x16B
            if((WorldInfo.TimeSeconds - mLastFlagReturnTime) < ReturnFlagScoreTime)
            {
                PRI = TurokMPPlayerReplicationInfo(InstigatorPRI);
                // DebugMode: 0
                assert(PRI != none);
                PRI.mActCount++;
                PRI.mActScore += ReturnFlagThenCapturePoints;
                PRI.Score += float(ReturnFlagThenCapturePoints);
                C = TurokPlayerController(PRI.Owner);
                // DebugMode: 0
                assert(C != none);
                C.RecordStat(121, 1.0000000, 1);
            }
            // End:0x223
            if((WorldInfo.TimeSeconds - mLastEnemyCarrierKillTime) < KillFlagCarrierThenCaptureTime)
            {
                PRI = TurokMPPlayerReplicationInfo(InstigatorPRI);
                // DebugMode: 0
                assert(PRI != none);
                PRI.mActCount++;
                PRI.mActScore += KillFlagCarrierThenCapturePoints;
                PRI.Score += float(KillFlagCarrierThenCapturePoints);
                C = TurokPlayerController(PRI.Owner);
                // DebugMode: 0
                assert(C != none);
                C.RecordStat(122, 1.0000000, 1);
            }
        }
    }
    PRI = TurokMPPlayerReplicationInfo(Player.PlayerReplicationInfo);
    // DebugMode: 0
    assert(PRI != none);
    PRI.mFlagCaps++;
    PRI.mActCount++;
    PRI.mActScore += CaptureFlagPoints;
    PRI.Score += float(CaptureFlagPoints);
    Player.RecordStat(115, 1.0000000, 1);
    return CheckScore(PRI);
    //return ReturnValue;    
}

protected function ScoreFlagReturn(@NULL Player)
{
    local @NULL PRI;

    mLastFlagReturnTime = WorldInfo.TimeSeconds;
    mLastFlagInstigator = Player.PlayerReplicationInfo.PlayerID;
    PRI = TurokMPPlayerReplicationInfo(Player.PlayerReplicationInfo);
    // DebugMode: 0
    assert(PRI != none);
    PRI.mActCount++;
    PRI.mActScore += ReturnFlagPoints;
    PRI.Score += float(ReturnFlagPoints);
    Player.RecordStat(116, 1.0000000, 1);
    //return;    
}

protected function ScoreFlagSteal(@NULL Player)
{
    //return;    
}

function Killed(@NULL Killer, @NULL KilledPlayer, @NULL KilledPawn, class<Class> DamageType)
{
    local int I, KillerTeamNum, KilledTeamNum;
    local @NULL C, Human, FlagPosition;
    local bool FlagPositionValid;
    local @NULL PRI, FGRI;

    // End:0x5B8
    if(((AllowKillScoreUpdate(DamageType)) && Killer != none) && Killer.PlayerReplicationInfo != none)
    {
        KillerTeamNum = int(Killer.GetTeamNum());
        KilledTeamNum = int(KilledPawn.GetTeamNum());
        // End:0x5B8
        if(KillerTeamNum != 255)
        {
            // End:0x15F
            if(((KilledPlayer.PlayerReplicationInfo != none) && KilledPlayer.PlayerReplicationInfo.bHasFlag) && GameReplicationInfo.OnSameTeam(Killer, KilledPlayer) == false)
            {
                mLastEnemyCarrierKillTime = WorldInfo.TimeSeconds;
                mLastFlagInstigator = Killer.PlayerReplicationInfo.PlayerID;
                PRI = TurokMPPlayerReplicationInfo(Killer.PlayerReplicationInfo);
                // DebugMode: 0
                assert(PRI != none);
                PRI.mActCount++;
                PRI.mActScore += KillFlagCarrierPoints;
                PRI.Score += float(KillFlagCarrierPoints);
            }
            // End:0x39D
            foreach WorldInfo.AllControllers(Class'Engine.Controller', C)
            {
                // End:0x39C
                if((Killer != C) && GameReplicationInfo.OnSameTeam(Killer, C))
                {
                    Human = TurokPawnHuman(C.Pawn);
                    // End:0x39C
                    if(Human != none)
                    {
                        // End:0x39C
                        if(class<TurokMPTeamFlag>(Human.GetAttachedInventoryItemClass()) != none)
                        {
                            I = 0;
                            J0x1F5:

                            // End:0x287 [Loop If]
                            if(I < Human.mHitByList.Length)
                            {
                                // End:0x27D
                                if(Human.mHitByList[I] == KilledPlayer)
                                {
                                    Killer.PlayerReplicationInfo.Score += float(KillFlagCarrierHarmerPoints);
                                    // End:0x27D
                                    if(TurokPlayerController(Killer) != none)
                                    {
                                        TurokPlayerController(Killer).RecordStat(119, 1.0000000, 1);
                                    }
                                }
                                I++;
                                // [Loop Continue]
                                goto J0x1F5;
                            }
                            // End:0x39C
                            if(((VSize(Killer.Pawn.Location - Human.Location) < MaxDistanceForProximityKillPoints) || VSize(KilledPawn.Location - Human.Location) < MaxDistanceForProximityKillPoints) && !GameReplicationInfo.OnSameTeam(Killer, KilledPlayer))
                            {
                                PRI = TurokMPPlayerReplicationInfo(Killer.PlayerReplicationInfo);
                                // DebugMode: 0
                                assert(PRI != none);
                                PRI.mActCount++;
                                PRI.mActScore += KillNearFlagCarrierPoints;
                                PRI.Score += float(KillNearFlagCarrierPoints);
                                // End:0x39C
                                if(TurokPlayerController(Killer) != none)
                                {
                                    TurokPlayerController(Killer).RecordStat(120, 1.0000000, 1);
                                }
                            }
                        }
                    }
                }                
            }            
            FGRI = TurokFlagGameReplicationInfo(GameReplicationInfo);
            FlagPositionValid = false;
            // End:0x48D
            if(((KillerTeamNum == 0) && FGRI.mCurFlagAtHomeStatus0) || (KillerTeamNum == 1) && FGRI.mCurFlagAtHomeStatus1)
            {
                // End:0x48A
                if((((KilledTeamNum != 255) && KilledPawn.IsA('TurokPawnPlayer')) && int(KilledPlayer.GetTeamNum()) != KillerTeamNum) && int(mFlagIndicators[KilledTeamNum].GetTeamNum()) == KilledTeamNum)
                {
                    FlagPosition = mFlagIndicators[KilledTeamNum].GetTargetPos();
                    FlagPositionValid = true;
                }                
            }
            else
            {
                // End:0x4CE
                if(int(FGRI.mFlagState[KillerTeamNum]) == int(3))
                {
                    FlagPosition = FGRI.mDroppedFlagLocation[KillerTeamNum];
                    FlagPositionValid = true;
                }
            }
            // End:0x5B8
            if((FlagPositionValid && VSize(Killer.Pawn.Location - FlagPosition) < MaxDistanceForProximityKillPoints) || VSize(KilledPawn.Location - FlagPosition) < MaxDistanceForProximityKillPoints)
            {
                PRI = TurokMPPlayerReplicationInfo(Killer.PlayerReplicationInfo);
                // DebugMode: 0
                assert(PRI != none);
                PRI.mActCount++;
                PRI.mActScore += KillNearFlagPoints;
                PRI.Score += float(KillNearFlagPoints);
                // End:0x5B8
                if(TurokPlayerController(Killer) != none)
                {
                    TurokPlayerController(Killer).RecordStat(117, 1.0000000, 1);
                }
            }
        }
    }
    super.Killed(Killer, KilledPlayer, KilledPawn, DamageType);
    //return;    
}

exec function NetPrintHostSettings()
{
    super.NetPrintHostSettings();
    //return;    
}

defaultproperties
{
    mLastFlagInstigator=-1
    GameReplicationInfoClass=Class'TurokFlagGameReplicationInfo'
}