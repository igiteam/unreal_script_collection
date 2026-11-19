class SkyBotControllerBase extends SkyAIController
    abstract
    native
    config(AI);

enum EBurstFireState
{
    BURSTFIRE_Ready,                // 0
    BURSTFIRE_Firing,               // 1
    BURSTFIRE_Paused,               // 2
    BURSTFIRE_MAX                   // 3
};

struct native s_BurstFireStruct
{
    var float MinTimeBetweenFiringBursts;
    var float MaxTimeBetweenFiringBursts;
    var float MinDurationOfFiringBurst;
    var float MaxDurationOfFiringBurst;

    structdefaultproperties
    {
        MinTimeBetweenFiringBursts=0.0000000
        MaxTimeBetweenFiringBursts=0.0000000
        MinDurationOfFiringBurst=0.0000000
        MaxDurationOfFiringBurst=0.0000000
    }
};

var transient Actor LastCanAttackActor;
var transient float LastCanAttackTime;
var transient bool bLastCanAttackResult;
var bool bIgnoreEnemyChange;
var bool bEnemyInfoValid;
var bool bEnemyAcquiredAndFaced;
var bool bEnemyIsVisible;
var transient bool bLockedEnemy;
var bool bSpawnedByKismet;
var bool bScriptedFrozen;
var bool bFireSuccess;
var bool bAlreadyInitialized;
var() bool bGodSight;
var bool bExecutingWhatToDoNext;
var Vector LastSeenPos;
var Vector LastSeeingPos;
var float LastSeenTime;
var float AcquireTime;
var float LoseEnemyCheckTime;
var float LastUnderFire;
var float ReactionTime;
var float FailedHuntTime;
var Pawn FailedHuntEnemy;
var float EnemyVisibilityTime;
var Actor VisibleEnemy;
var Actor ScriptedTarget;
var byte ScriptedFireMode;
var transient SkyBotControllerBase.EBurstFireState BurstFireState;
var transient Actor LockedEnemy;
var() int AcquisitionYawRate;
var SkySquadAI Squad;
var SkyBotControllerBase NextSquadMember;
var Vector DirectionHint;
var() float EnemyTooLongNoSeeTime;
var(BurstFireOpen) float MinTimeBetweenFiringBursts;
var(BurstFireOpen) float MaxTimeBetweenFiringBursts;
var(BurstFireOpen) float MinDurationOfFiringBurst;
var(BurstFireOpen) float MaxDurationOfFiringBurst;
var transient int InternalBurstStreamCounter;
var transient s_BurstFireStruct BurstFireInfo;
var transient Pawn CachedPlayerPawn;

// Export USkyBotControllerBase::execLatentWhatToDoNext(FFrame&, void* const)
native final latent function LatentWhatToDoNext();

// Export USkyBotControllerBase::execFindPredictedAimPoint(FFrame&, void* const)
native final function bool FindPredictedAimPoint(Actor theTarget, float projectileSpeed, out Vector retVector);

function WasKilledBy(Controller Other)
{
    //return;    
}

event Destroyed()
{
    // End:0x20
    if(Squad != none)
    {
        Squad.RemoveBot(self);
    }
    super.Destroyed();
    //return;    
}

simulated function OnIgnorePawn(SkySeqAct_IgnorePawn inAction)
{
    local int Idx;
    local Pawn NewTarget;

    // End:0x19
    if(inAction.IgnoreTargets.Length == 0)
    {        
    }
    else
    {
        Idx = 0;
        J0x20:

        // End:0x185 [Loop If]
        if(Idx < inAction.IgnoreTargets.Length)
        {
            // End:0x85
            if(inAction.IgnoreTargets[Idx].IsA('Pawn'))
            {
                NewTarget = Pawn(inAction.IgnoreTargets[Idx]);                
            }
            else
            {
                // End:0xDA
                if(inAction.IgnoreTargets[Idx].IsA('Controller'))
                {
                    NewTarget = Controller(inAction.IgnoreTargets[Idx]).Pawn;                    
                }
                else
                {
                    // End:0x12C
                    if(inAction.IgnoreTargets[Idx].IsA('SkyVehicleFactory'))
                    {
                        NewTarget = SkyVehicleFactory(inAction.IgnoreTargets[Idx]).ChildVehicle;
                    }
                }
            }
            // End:0x17B
            if(NewTarget != none)
            {
                // End:0x17B
                if(Squad != none)
                {
                    Squad.SetIgnorePawn(NewTarget, inAction.bIgnoreTarget, inAction.IgnoreDuration, true);
                }
            }
            ++Idx;
            // [Loop Continue]
            goto J0x20;
        }
    }
    //return;    
}

function Wander()
{
    //return;    
}

function SkyBotControllerInit()
{
    local SkyRosterEntry Chosen;
    local SkyTeamInfo BotTeam;

    // End:0x5A
    if((PlayerReplicationInfo == none) || PlayerReplicationInfo.Team == none)
    {
        BotTeam = SkyGame(WorldInfo.Game).GetBotTeam(int(GetTeamNum()));        
    }
    else
    {
        BotTeam = SkyGame(WorldInfo.Game).GetBotTeam(PlayerReplicationInfo.Team.TeamIndex);
    }
    Chosen = none;
    SkyGame(WorldInfo.Game).InitializeBot(self, BotTeam, Chosen);
    // End:0x10C
    if(PlayerReplicationInfo != none)
    {
        PlayerReplicationInfo.PlayerID = SkyGame(WorldInfo.Game).CurrentID++;
    }
    SkyGame(WorldInfo.Game).AddDefaultInventory(Pawn);
    GotoState('Start_State');
    //return;    
}

simulated function GetBurstFireInfo(out s_BurstFireStruct burstInfo)
{
    burstInfo.MinTimeBetweenFiringBursts = MinTimeBetweenFiringBursts;
    burstInfo.MaxTimeBetweenFiringBursts = MaxTimeBetweenFiringBursts;
    burstInfo.MinDurationOfFiringBurst = MinDurationOfFiringBurst;
    burstInfo.MaxDurationOfFiringBurst = MaxDurationOfFiringBurst;
    //return;    
}

event PotShotStopFiring()
{
    StopFiring();
    //return;    
}

event StopFiring()
{
    bFire = 0;
    // End:0x27
    if(Pawn != none)
    {
        Pawn.StopFiring();
    }
    StopBurstFireForGood();
    //return;    
}

simulated function StopBurstFireForGood()
{
    ClearTimer('BurstFireReady');
    ClearTimer('BurstFireEnd');
    BurstFireState = 0;
    //return;    
}

function BurstFireReady()
{
    BurstFireState = 0;
    FireWeaponAt(Focus);
    //return;    
}

function BurstFireEnd()
{
    local float pauseDuration;
    local SkyGame GameInfo;

    GetBurstFireInfo(BurstFireInfo);
    pauseDuration = BurstFireInfo.MinTimeBetweenFiringBursts + (FRand() * (BurstFireInfo.MaxTimeBetweenFiringBursts - BurstFireInfo.MinTimeBetweenFiringBursts));
    SetTimer(0.0000100 + pauseDuration, false, 'BurstFireReady');
    BurstFireState = 2;
    bFire = 0;
    // End:0xCC
    if(Pawn != none)
    {
        GameInfo = SkyGame(WorldInfo.Game);
        // End:0xB8
        if(GameInfo != none)
        {
            GameInfo.ReleaseFirePermit(self);
        }
        Pawn.StopFiring();
    }
    //return;    
}

function bool FireWeaponAtHelper(Actor A)
{
    return WeaponFireAgain(false);
    //return ReturnValue;    
}

final function bool IsFiring()
{
    return (Pawn.IsFiring() || IsTimerActive('BurstFireReady')) || IsTimerActive('BurstFireEnd');
    //return ReturnValue;    
}

function bool FireWeaponAt(Actor A)
{
    local bool Success;
    local float burstDuration;
    local SkyGame GameInfo;

    GameInfo = SkyGame(WorldInfo.Game);
    // End:0x31
    if((CanAttack(A)) == false)
    {
        return false;
    }
    // End:0x137
    if((int(BurstFireState) == int(0)) || int(BurstFireState) == int(1))
    {
        // End:0xDB
        if(int(BurstFireState) == int(0))
        {
            StopFiring();
            GetBurstFireInfo(BurstFireInfo);
            burstDuration = BurstFireInfo.MinDurationOfFiringBurst + (FRand() * (BurstFireInfo.MaxDurationOfFiringBurst - BurstFireInfo.MinDurationOfFiringBurst));
            SetTimer(0.0000100 + burstDuration, false, 'BurstFireEnd');
            InternalBurstStreamCounter++;
        }
        Success = FireWeaponAtHelper(A);
        // End:0x12D
        if(Success == true)
        {
            BurstFireState = 1;
            // End:0x12A
            if(SkyPawn(A) != none)
            {
                SkyPawn(A).FiredUpon();
            }            
        }
        else
        {
            StopFiring();
        }
    }
    // End:0x160
    if(!Success && GameInfo != none)
    {
        GameInfo.ReleaseFirePermit(self);
    }
    return Success;
    //return ReturnValue;    
}

event SpawnedByKismet()
{
    bSpawnedByKismet = true;
    //return;    
}

function bool WeaponFireAgain(bool bFinishedFire)
{
    local Actor FireTarget;

    bFireSuccess = false;
    FireTarget = Enemy;
    // End:0x6B
    if((FireTarget != none) && !FireTarget.bDeleteMe)
    {
        // End:0x6B
        if((CanAttack(FireTarget)) == true)
        {
            bFireSuccess = Pawn.BotFire(bFinishedFire);
        }
    }
    // End:0x81
    if(bFireSuccess == false)
    {
        StopFiring();
    }
    return bFireSuccess;
    //return ReturnValue;    
}

// Export USkyBotControllerBase::execCanAttackNative(FFrame&, void* const)
native final function bool CanAttackNative(Actor Other);

function bool CanAttack(Actor Other)
{
    // End:0x38
    if((Other == LastCanAttackActor) && (WorldInfo.TimeSeconds - LastCanAttackTime) < 0.2500000)
    {
        return bLastCanAttackResult;
    }
    LastCanAttackActor = Other;
    LastCanAttackTime = WorldInfo.TimeSeconds;
    bLastCanAttackResult = CanAttackNative(Other);
    return bLastCanAttackResult;
    //return ReturnValue;    
}

simulated function float RateWeapon(Weapon W)
{
    local float Rating;

    // End:0x28
    if(W != none)
    {
        Rating = W.GetAIRating();        
    }
    else
    {
        Rating = 0.0000000;
    }
    return Rating;
    //return ReturnValue;    
}

function LeaveVehicle()
{
    GotoState('LeavingVehicle');
    //return;    
}

simulated function DisplayDebug(HUD HUD, out float YL, out float YPos)
{
    super.DisplayDebug(HUD, YL, YPos);
    // End:0xCC
    if((((HUD.ShouldDisplayDebug('planeai') || HUD.ShouldDisplayDebug('splines')) || HUD.ShouldDisplayDebug('tethers')) || HUD.ShouldDisplayDebug('Gangs')) || HUD.ShouldDisplayDebug('planeaiCollision'))
    {
        DrawStateDebug(HUD);
    }
    //return;    
}

simulated function DrawStateDebug(HUD HUD)
{
    local Vector ScreenLoc, TempScreenLoc, TempOffset;
    local editinline SkyVehicleSim_CrimsonAircraft Sim;
    local SkyBotControllerBase SBC;
    local Color currentColor;

    SBC = self;
    ScreenLoc = HUD.Canvas.Project(SBC.Pawn.Location);
    ScreenLoc.X += float(50);
    ScreenLoc.Y -= float(100);
    // End:0x11A
    if(bDebug)
    {
        HUD.Canvas.SetDrawColor(255, 50, 50);
        HUD.Canvas.SetPos(ScreenLoc.X, ScreenLoc.Y);
        HUD.Canvas.DrawTextClipped("CURRENT DEBUG TARGET", false);
        ScreenLoc.Y -= float(15);
    }
    // End:0x1B6
    if((Vector(HUD.PlayerOwner.PlayerCamera.Rotation) Dot (Pawn.Location - HUD.PlayerOwner.PlayerCamera.Location)) > 0.0000000)
    {
        HUD.Canvas.SetDrawColor(255, 255, 255);
        currentColor = MakeColor(255, 255, 255);        
    }
    else
    {
        HUD.Canvas.SetDrawColor(255, 0, 0);
        currentColor = MakeColor(255, 0, 0);
    }
    HUD.Canvas.SetPos(ScreenLoc.X, ScreenLoc.Y);
    HUD.Canvas.DrawTextClipped("AIName: " $ string(SBC), false);
    ScreenLoc.Y -= float(15);
    HUD.Canvas.SetPos(ScreenLoc.X, ScreenLoc.Y);
    HUD.Canvas.DrawTextClipped("Pawn: " $ string(Pawn), false);
    ScreenLoc.Y -= float(15);
    HUD.Canvas.SetPos(ScreenLoc.X, ScreenLoc.Y);
    // End:0x41E
    if(SBC.GetStateName() == 'FlyingFlyBy')
    {
        HUD.Canvas.DrawTextClipped((((((((("STATE: " $ string(SBC.GetStateName())) $ " Count = ") $ string(SkyBotControllerPilot(SBC).P_FlyBy_Counter)) $ " BreakAway: ") $ string(SkyBotControllerPilot(SBC).bDoingFlyByBreakAway)) $ " bBreakingAwayRight: ") $ string(SkyBotControllerPilot(SBC).bBreakingAwayRight)) $ " Post: ") $ string(SkyBotControllerPilot(SBC).bDoingPostFlyBy), false);        
    }
    else
    {
        // End:0x48C
        if(SBC.GetStateName() == 'FlyingSpecialManeuver')
        {
            HUD.Canvas.DrawTextClipped(("STATE: " $ string(SBC.GetStateName())) @ string(SkyAirVehicle(Pawn).CurrentActiveSpecialManeuver), false);            
        }
        else
        {
            // End:0x511
            if(SBC.GetStateName() == 'FlyingPursuit')
            {
                HUD.Canvas.DrawTextClipped((("STATE: " $ string(SBC.GetStateName())) $ " bFireMode_Allow: ") $ string(SkyBotControllerPilot(SBC).bFireMode_Allow), false);                
            }
            else
            {
                // End:0x5AD
                if((SBC.GetStateName() == 'FlyingEvade') || SBC.GetStateName() == 'FlyingEvadeHijackMe')
                {
                    HUD.Canvas.DrawTextClipped((("STATE: " $ string(SBC.GetStateName())) $ " HardEvade: ") $ string(SkyBotControllerPilot(SBC).bDoingHardEvade), false);                    
                }
                else
                {
                    HUD.Canvas.DrawTextClipped("STATE: " $ string(SBC.GetStateName()), false);
                }
            }
        }
    }
    // End:0x6BA
    if(((Pawn != none) && Pawn.GangName != 'None') && HUD.ShouldDisplayDebug('Gangs'))
    {
        ScreenLoc.Y -= float(15);
        HUD.Canvas.SetPos(ScreenLoc.X, ScreenLoc.Y);
        HUD.Canvas.DrawTextClipped("Gang: " $ string(Pawn.GangName));
    }
    ScreenLoc.Y -= float(15);
    HUD.Canvas.SetPos(ScreenLoc.X, ScreenLoc.Y);
    // End:0x800
    if(SBC.Enemy != none)
    {
        // End:0x79E
        if(SBC.bLockedEnemy == true)
        {
            HUD.Canvas.DrawTextClipped((("LOCKED Enemy =" $ string(SBC.Enemy)) $ ", EnemyGang = ") $ string(Enemy.GangName), false);            
        }
        else
        {
            HUD.Canvas.DrawTextClipped((("Enemy =" $ string(SBC.Enemy)) $ ", EnemyGang = ") $ string(Enemy.GangName), false);
        }        
    }
    else
    {
        HUD.Canvas.DrawTextClipped("Enemy = None", false);
    }
    // End:0xE64
    if((SBC != none) && SBC.Pawn != none)
    {
        TempOffset = vect(0.0000000, 0.0000000, 20.0000000);
        TempScreenLoc = HUD.Canvas.Project((SBC.Pawn.Location + TempOffset) + (Vector(SBC.Rotation) * 10000.0000000));
        HUD.Canvas.SetPos(TempScreenLoc.X, TempScreenLoc.Y);
        HUD.Canvas.DrawTextClipped("Controller Rot");
        DrawDebugLine(SBC.Pawn.Location + TempOffset, (SBC.Pawn.Location + TempOffset) + (Vector(SBC.Rotation) * 10000.0000000), 0, 255, 0, false);
        TempScreenLoc = HUD.Canvas.Project(SBC.GetFocalPoint());
        HUD.Canvas.SetPos(TempScreenLoc.X, TempScreenLoc.Y);
        HUD.Canvas.DrawTextClipped("FocalPoint");
        TempOffset = vect(0.0000000, 0.0000000, 20.0000000);
        DrawDebugLine(SBC.Pawn.Location + TempOffset, SBC.GetFocalPoint(), 0, 0, 255, false);
        TempOffset = vect(0.0000000, 0.0000000, 100.0000000);
        TempScreenLoc = HUD.Canvas.Project((SBC.Pawn.Location + TempOffset) + (Vector(SBC.Pawn.DesiredRotation) * 1000.0000000));
        HUD.Canvas.SetPos(TempScreenLoc.X, TempScreenLoc.Y);
        HUD.Canvas.DrawTextClipped("Pawn Desired Rotation");
        DrawDebugLine(SBC.Pawn.Location + TempOffset, (SBC.Pawn.Location + TempOffset) + (Vector(SBC.Pawn.DesiredRotation) * 1000.0000000), 255, 255, 255, false);
        TempOffset = vect(0.0000000, 0.0000000, 33.0000000);
        TempScreenLoc = HUD.Canvas.Project((SBC.Pawn.Location + TempOffset) + (Vector(SBC.DesiredRotation) * 900.0000000));
        HUD.Canvas.SetPos(TempScreenLoc.X, TempScreenLoc.Y);
        HUD.Canvas.DrawTextClipped("Desired Look");
        DrawDebugLine(SBC.Pawn.Location + TempOffset, (SBC.Pawn.Location + TempOffset) + (Vector(SBC.DesiredRotation) * 900.0000000), 128, 128, 64, false);
        TempOffset = vect(0.0000000, 0.0000000, 10.0000000);
        TempScreenLoc = HUD.Canvas.Project((SBC.Pawn.Location + TempOffset) + (Vector(SBC.Pawn.Rotation) * 1000.0000000));
        TempScreenLoc.Y -= float(15);
        HUD.Canvas.SetPos(TempScreenLoc.X, TempScreenLoc.Y);
        HUD.Canvas.DrawTextClipped("Pawn Rotation");
        DrawDebugLine(SBC.Pawn.Location + TempOffset, (SBC.Pawn.Location + TempOffset) + (Vector(SBC.Pawn.Rotation) * 1000.0000000), 255, 0, 255, false);
    }
    // End:0x1C3F
    if(SkyBotControllerPilot(SBC) != none)
    {
        ScreenLoc.Y -= float(15);
        HUD.Canvas.SetPos(ScreenLoc.X, ScreenLoc.Y);
        HUD.Canvas.DrawTextClipped(("Speed: " $ string(VSize(SBC.Pawn.Velocity) * 0.0223693)) $ " MPH");
        ScreenLoc.Y -= float(15);
        HUD.Canvas.SetPos(ScreenLoc.X, ScreenLoc.Y);
        HUD.Canvas.DrawTextClipped("Throttle: " $ string(Vehicle(SBC.Pawn).Throttle));
        ScreenLoc.Y -= float(15);
        HUD.Canvas.SetPos(ScreenLoc.X, ScreenLoc.Y);
        HUD.Canvas.DrawTextClipped("bCollisionPredicted: " $ string(SkyBotControllerPilot(SBC).bCollisionPredicted));
        ScreenLoc.Y -= float(15);
        HUD.Canvas.SetPos(ScreenLoc.X, ScreenLoc.Y);
        HUD.Canvas.DrawTextClipped("CurrentCollisionPredictionStage: " $ string(SkyAirVehicle(Pawn).CurrentCollisionPredictionStage));
        ScreenLoc.Y -= float(15);
        HUD.Canvas.SetPos(ScreenLoc.X, ScreenLoc.Y);
        HUD.Canvas.DrawTextClipped("LastPredColl: " $ string(SkyBotControllerPilot(SBC).CollisionPredictionHitActor));
        ScreenLoc.Y -= float(15);
        HUD.Canvas.SetPos(ScreenLoc.X, ScreenLoc.Y);
        // End:0x121B
        if(SkyBotControllerPilot(SBC).bCurrentlyAutoCorrecting)
        {
            HUD.Canvas.SetDrawColor(255, 0, 0);
        }
        HUD.Canvas.DrawTextClipped("bCurrentlyAutoCorrecting: " $ string(SkyBotControllerPilot(SBC).bCurrentlyAutoCorrecting));
        HUD.Canvas.SetDrawColor(currentColor.R, currentColor.G, currentColor.B);
        ScreenLoc.Y -= float(15);
        HUD.Canvas.SetPos(ScreenLoc.X, ScreenLoc.Y);
        HUD.Canvas.DrawTextClipped("Focus: " $ string(SBC.Focus));
        // End:0x1683
        if(SkyBotControllerPilot(SBC).TetherActor != none)
        {
            // End:0x1680
            if(HUD.ShouldDisplayDebug('tethers'))
            {
                ScreenLoc.Y -= float(15);
                HUD.Canvas.SetPos(ScreenLoc.X, ScreenLoc.Y);
                HUD.Canvas.DrawTextClipped("Tether: " $ string(SkyBotControllerPilot(SBC).TetherActor));
                // End:0x1470
                if(SBC.Pawn != none)
                {
                    SBC.DrawDebugLine(SBC.Pawn.Location, SkyBotControllerPilot(SBC).TetherActor.Location, 255, 0, 255);
                }
                ScreenLoc.Y -= float(15);
                HUD.Canvas.SetPos(ScreenLoc.X, ScreenLoc.Y);
                HUD.Canvas.DrawTextClipped("TetherDistance: " $ string(SkyBotControllerPilot(SBC).TetherDistance));
                ScreenLoc.Y -= float(15);
                HUD.Canvas.SetPos(ScreenLoc.X, ScreenLoc.Y);
                HUD.Canvas.DrawTextClipped("TetherHeight: " $ string(SkyBotControllerPilot(SBC).TetherHeight));
                TempScreenLoc = HUD.Canvas.Project(SkyBotControllerPilot(SBC).TetherActor.Location);
                HUD.Canvas.SetPos(TempScreenLoc.X, TempScreenLoc.Y);
                HUD.Canvas.DrawTextClipped("Tether");
                DrawDebugLine(SBC.Pawn.Location, SkyBotControllerPilot(SBC).TetherActor.Location, 255, 0, 255, false);
            }            
        }
        else
        {
            HUD.Canvas.SetDrawColor(255, 0, 0);
            ScreenLoc.Y -= float(15);
            HUD.Canvas.SetPos(ScreenLoc.X, ScreenLoc.Y);
            HUD.Canvas.DrawTextClipped("Tether = NONE!!!");
            HUD.Canvas.SetDrawColor(255, 255, 255);
        }
        ScreenLoc.Y -= float(15);
        HUD.Canvas.SetPos(ScreenLoc.X, ScreenLoc.Y);
        HUD.Canvas.DrawTextClipped("Steering: " $ string(SkyAirVehicle(Pawn).Steering));
        ScreenLoc.Y -= float(15);
        HUD.Canvas.SetPos(ScreenLoc.X, ScreenLoc.Y);
        HUD.Canvas.DrawTextClipped("Rise: " $ string(SkyAirVehicle(Pawn).Rise));
        ScreenLoc.Y -= float(15);
        HUD.Canvas.SetPos(ScreenLoc.X, ScreenLoc.Y);
        HUD.Canvas.DrawTextClipped("BrakeScale: " $ string(SkyVehicleSim_CrimsonAircraft(SkyAirVehicle(Pawn).SimObj).BrakeScale));
        ScreenLoc.Y -= float(15);
        HUD.Canvas.SetPos(ScreenLoc.X, ScreenLoc.Y);
        HUD.Canvas.DrawTextClipped("bApplyingFullBrakeScale: " $ string(SkyBotControllerPilot(SBC).bApplyingFullBrakeScale));
        ScreenLoc.Y -= float(15);
        HUD.Canvas.SetPos(ScreenLoc.X, ScreenLoc.Y);
        HUD.Canvas.DrawTextClipped("Deceleration: " $ string(SkyVehicleSim_CrimsonAircraft(SkyAirVehicle(Pawn).SimObj).Deceleration));
        Sim = SkyVehicleSim_CrimsonAircraft(SkyAirVehicle(Pawn).SimObj);
        // End:0x1C3F
        if(Sim != none)
        {
            ScreenLoc.Y -= float(15);
            HUD.Canvas.SetPos(ScreenLoc.X, ScreenLoc.Y);
            HUD.Canvas.DrawTextClipped("ManeuverAcceleration: " $ string(Sim.ManeuverAcceleration));
            ScreenLoc.Y -= float(15);
            HUD.Canvas.SetPos(ScreenLoc.X, ScreenLoc.Y);
            HUD.Canvas.DrawTextClipped("ManeuverDeceleration: " $ string(Sim.ManeuverDeceleration));
            ScreenLoc.Y -= float(15);
            HUD.Canvas.SetPos(ScreenLoc.X, ScreenLoc.Y);
            HUD.Canvas.DrawTextClipped("ManeuverMaxRate: " $ string(Sim.ManeuverMaxRate));
        }
    }
    //return;    
}

event SeeMonster(Pawn Seen)
{
    SeePlayer(Seen);
    //return;    
}

event SeePlayer(Pawn SeenPlayer)
{
    Medusa(SeenPlayer);
    Pawn.TriggerEventClass(Class'Engine.SeqEvent_AISeeEnemy', SeenPlayer);
    // End:0x3B
    if(bLockedEnemy)
    {
        return;
    }
    // End:0x4D
    if(SeenPlayer == Enemy)
    {        
    }
    else
    {
        // End:0x7A
        if((Squad != none) && Squad.SetEnemy(self, SeenPlayer))
        {            
        }
    }
    // End:0x89
    if(Enemy == SeenPlayer)
    {
    }
    //return;    
}

function SetEnemyInfo(bool bNewEnemyVisible)
{
    local SkyBotControllerBase B;

    // End:0x6F
    if(bNewEnemyVisible)
    {
        AcquireTime = WorldInfo.TimeSeconds;
        LastSeenTime = WorldInfo.TimeSeconds;
        LastSeenPos = Enemy.GetTargetLocation(self);
        LastSeeingPos = Pawn.Location;
        bEnemyInfoValid = true;        
    }
    else
    {
        LastSeenTime = -1000.0000000;
        bEnemyInfoValid = false;
        B = Squad.SquadMembers;
        J0x97:

        // End:0xEF [Loop If]
        if(B != none)
        {
            // End:0xD7
            if(B.Enemy == Enemy)
            {
                AcquireTime = FMax(AcquireTime, B.AcquireTime);
            }
            B = B.NextSquadMember;
            // [Loop Continue]
            goto J0x97;
        }
    }
    //return;    
}

function EnemyChanged(bool bNewEnemyVisible)
{
    bEnemyAcquiredAndFaced = false;
    SetEnemyInfo(bNewEnemyVisible);
    //return;    
}

function Reset()
{
    super(AIController).Reset();
    LastSeenTime = 0.0000000;
    bEnemyAcquiredAndFaced = false;
    // End:0x32
    if(Pawn == none)
    {
        GotoState('Dead');
    }
    //return;    
}

function Possess(Pawn aPawn, bool bVehicleTransition)
{
    super.Possess(aPawn, bVehicleTransition);
    // End:0x7D
    if((aPawn != none) && SkyInventoryManager(aPawn.InvManager) != none)
    {
        SkyInventoryManager(aPawn.InvManager).AllAmmo();
        SkyInventoryManager(aPawn.InvManager).bInfiniteAmmo = true;
    }
    // End:0x9B
    if(bAlreadyInitialized == false)
    {
        SkyBotControllerInit();
        bAlreadyInitialized = true;
    }
    Enable('NotifyBump');
    // End:0xEF
    if((SkyAirVehicle(Pawn) != none) && !SkyAirVehicle(Pawn).HasWheelsOnGround())
    {
        SkyAirVehicle(Pawn).ForceFlying();
    }
    //return;    
}

function FightEnemy()
{
    //return;    
}

function DoRangedAttackOn(Actor A)
{
    //return;    
}

function Pawn FindPlayerPawn()
{
    local SkyPlayerController ControllerIter;

    // End:0x44
    foreach WorldInfo.AllControllers(Class'SkyPlayerController', ControllerIter)
    {
        // End:0x43
        if(ControllerIter.Pawn != none)
        {            
            return ControllerIter.Pawn;
        }        
    }    
    return none;
    //return ReturnValue;    
}

event SetPlayerAsEnemy()
{
    local Pawn myEnemy;

    myEnemy = FindPlayerPawn();
    // End:0x34
    if(Squad != none)
    {
        Squad.AddEnemy(myEnemy);
    }
    Enemy = myEnemy;
    //return;    
}

simulated function OnGodSight(SkySeqAct_GodSight inAction)
{
    bGodSight = inAction.bGodSight;
    //return;    
}

function Restart(bool bVehicleTransition)
{
    // End:0x1A
    if(!bVehicleTransition)
    {
        super(Controller).Restart(bVehicleTransition);        
    }
    else
    {
        // End:0x39
        if(Pawn != none)
        {
            Pawn.Restart();
        }
    }
    //return;    
}

event WhatToDoNext()
{
    // End:0x0F
    if(bExecutingWhatToDoNext)
    {
        ScriptTrace();
    }
    // End:0x1C
    if(Pawn == none)
    {
        return;
    }
    // End:0xD1
    if(((Enemy == none) || Enemy.bDeleteMe) || (Pawn(Enemy) != none) && Pawn(Enemy).Health <= 0)
    {
        // End:0xD1
        if((Focus == none) || (Pawn(Focus) != none) && Pawn(Focus).Health <= 0)
        {
            StopFiring();
            // End:0xD1
            if((Pawn == none) || Pawn.Health <= 0)
            {
                return;
            }
        }
    }
    //return;    
}

protected event ExecuteWhatToDoNext()
{
    //return;    
}

function Vector GetDirectionHint()
{
    local Vector Result;

    Result = DirectionHint;
    DirectionHint = vect(0.0000000, 0.0000000, 0.0000000);
    return Result;
    //return ReturnValue;    
}

function NotifyTakeHit(Controller InstigatedBy, Vector HitLocation, int Damage, class<DamageType> DamageType, Vector Momentum)
{
    LastUnderFire = WorldInfo.TimeSeconds;
    super(Controller).NotifyTakeHit(InstigatedBy, HitLocation, Damage, DamageType, Momentum);
    // End:0x6F
    if((InstigatedBy != none) && InstigatedBy.Pawn != none)
    {
        SeePlayer(InstigatedBy.Pawn);
    }
    //return;    
}

function NotifyKilled(Controller Killer, Controller Killed, Pawn KilledPawn)
{
    Squad.NotifyKilled(Killer, Killed, KilledPawn);
    //return;    
}

function bool LostContact(float maxTime)
{
    // End:0x0D
    if(Enemy == none)
    {
        return true;
    }
    // End:0x53
    if((Pawn(Enemy) != none) && Pawn(Enemy).IsInvisible())
    {
        maxTime = FMax(2.0000000, maxTime - float(2));
    }
    // End:0x7C
    if((WorldInfo.TimeSeconds - FMax(LastSeenTime, AcquireTime)) > maxTime)
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

function bool LoseEnemy()
{
    // End:0x0D
    if(Enemy == none)
    {
        return true;
    }
    // End:0x77
    if(Pawn(Enemy) != none)
    {
        // End:0x77
        if(((Pawn(Enemy).Health > 0) && Pawn(Enemy).Controller != none) && LoseEnemyCheckTime > (WorldInfo.TimeSeconds - 0.2000000))
        {
            return false;
        }
    }
    LoseEnemyCheckTime = WorldInfo.TimeSeconds;
    // End:0xA6
    if(Squad.LostEnemy(self))
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

function OnAIFreeze(SkySeqAct_AIFreeze FreezeAction)
{
    // End:0x51
    if(FreezeAction.InputLinks[0].bHasImpulse)
    {
        PushState(((FreezeAction.bAllowWeaponFiring) ? 'FrozenMovement' : 'Frozen'));        
    }
    else
    {
        FreezeAction.ScriptLog(string(self) @ "received unfreeze request while not frozen");
    }
    //return;    
}

function StopMovement()
{
    local Vehicle V;

    Pawn.Acceleration = vect(0.0000000, 0.0000000, 0.0000000);
    V = Vehicle(Pawn);
    // End:0x77
    if(V != none)
    {
        V.Steering = 0.0000000;
        V.Throttle = 0.0000000;
        V.Rise = 0.0000000;
    }
    //return;    
}

function ApplyFlash(float flength)
{
    // End:0x3F
    if(!IsInState('FlashBanged'))
    {
        PushState('FlashBanged');
        SetTimer(0.0000100 + flength, false, 'RecoveredFromFlashBang');        
    }
    else
    {
        SetTimer(0.0000100 + float(Max(int(flength), int(GetTimerCount('RecoveredFromFlashBang')))), false, 'RecoveredFromFlashBang');
    }
    //return;    
}

function Actor FaceActor(float StrafingModifier)
{
    // End:0x11
    if(Focus != none)
    {
        return Focus;
    }
    return Enemy;
    //return ReturnValue;    
}

final function bool HasAnyEnemies()
{
    local int I;

    // End:0x48
    if(Squad != none)
    {
        I = 0;
        J0x12:

        // End:0x45 [Loop If]
        if(I < 8)
        {
            // End:0x3B
            if(Squad.Enemies[I] != none)
            {
                return true;
            }
            I++;
            // [Loop Continue]
            goto J0x12;
        }        
    }
    else
    {
        // End:0x55
        if(Enemy != none)
        {
            return true;
        }
    }
    return false;
    //return ReturnValue;    
}

function Medusa(Pawn SeenPlayer)
{
    // End:0x43
    if(SkyPawn(SeenPlayer) != none)
    {
        // End:0x43
        if(SkyPawn(SeenPlayer).bMedusa)
        {
            Pawn.KilledBy(SeenPlayer);
            return;
        }
    }
    //return;    
}

simulated function LockEnemy(Actor newEnemy)
{
    // End:0x6D
    if(((Pawn(newEnemy) != none) && Pawn(newEnemy).DrivenVehicle != none) && Pawn(newEnemy).DrivenVehicle.bDriving == true)
    {
        newEnemy = Pawn(newEnemy).DrivenVehicle;
    }
    // End:0x91
    if(Squad != none)
    {
        Squad.AddEnemy(newEnemy);
    }
    Enemy = newEnemy;
    bLockedEnemy = true;
    LockedEnemy = Enemy;
    //return;    
}

simulated function ClearLockedEnemy()
{
    Enemy = none;
    bLockedEnemy = false;
    LockedEnemy = none;
    Focus = none;
    // End:0x5F
    if(Squad != none)
    {
        // End:0x5F
        if(!Squad.MustKeepEnemy(Enemy))
        {
            Squad.RemoveEnemy(Enemy);
        }
    }
    GotoState('FlyingStakeOut');
    //return;    
}

state Dead
{
    ignores ReceiveWarning, ExecuteWhatToDoNext, WhatToDoNext, Timer;

    function EndState(name NextStateName)
    {
        super(Object).EndState(NextStateName);
        //return;        
    }

    function PushedState()
    {
        super(Object).PushedState();
        //return;        
    }

    function PoppedState()
    {
        super(Object).PoppedState();
        //return;        
    }

    function ContinuedState()
    {
        super(Object).ContinuedState();
        //return;        
    }

    function PausedState()
    {
        super(Object).PausedState();
        //return;        
    }

    function EnemyChanged(bool bNewEnemyVisible)
    {
        //return;        
    }

    function BeginState(name PreviousStateName)
    {
        // End:0x0E
        if(bSpawnedByKismet)
        {
            Destroy();
            return;
        }
        PendingMover = none;
        Enemy = none;
        StopFiring();
        bPreparingMove = false;
        RouteGoal = none;
        MoveTarget = none;
        //return;        
    }
MPStart:

    GotoState('RoundEnded');
    stop;        
}

state RoundEnded
{
    ignores KilledBy, TakeDamage, ReceiveWarning, ExecuteWhatToDoNext, SwitchToBestWeapon, Timer;

    function WhatToDoNext()
    {
        ScriptTrace();
        //return;        
    }

    function EnemyChanged(bool bNewEnemyVisible)
    {
        //return;        
    }

    function EndState(name NextStateName)
    {
        super(Object).EndState(NextStateName);
        //return;        
    }

    function PushedState()
    {
        super(Object).PushedState();
        //return;        
    }

    function PoppedState()
    {
        super(Object).PoppedState();
        //return;        
    }

    function ContinuedState()
    {
        super(Object).ContinuedState();
        //return;        
    }

    function PausedState()
    {
        super(Object).PausedState();
        //return;        
    }

    function BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        //return;        
    }
    stop;    
}

state Frozen
{
    ignores WhatToDoNext, ExecuteWhatToDoNext, NotifyTakeHit;

    event SeePlayer(Pawn SeenPlayer)
    {
        global.SeePlayer(SeenPlayer);
        //return;        
    }

    function OnAIFreeze(SkySeqAct_AIFreeze FreezeAction)
    {
        // End:0x2A
        if(FreezeAction.InputLinks[1].bHasImpulse)
        {
            PopState();            
        }
        else
        {
            FreezeAction.ScriptLog(string(self) @ "received freeze request while already frozen");
        }
        //return;        
    }

    event PushedState()
    {
        StopMovement();
        bScriptedFrozen = true;
        StopFiring();
        Focus = none;
        //return;        
    }

    event PoppedState()
    {
        bScriptedFrozen = false;
        super(Object).PoppedState();
        //return;        
    }
    stop;    
}

state FrozenMovement
{
    function WhatToDoNext()
    {
        // End:0x19
        if(Enemy != none)
        {
            Focus = Enemy;            
        }
        else
        {
            Enemy = none;
            StopFiring();
        }
        //return;        
    }

    function OnAIFreeze(SkySeqAct_AIFreeze FreezeAction)
    {
        // End:0x2A
        if(FreezeAction.InputLinks[1].bHasImpulse)
        {
            PopState();            
        }
        else
        {
            FreezeAction.ScriptLog(string(self) @ "received freeze request while already frozen");
        }
        //return;        
    }

    event PushedState()
    {
        StopMovement();
        bScriptedFrozen = true;
        //return;        
    }

    event PoppedState()
    {
        bScriptedFrozen = false;
        super(Object).PoppedState();
        //return;        
    }
    stop;    
}

state ScriptedRouteMove
{
    function BeginState(name PreviousStateName)
    {
        super(Object).BeginState(PreviousStateName);
        //return;        
    }

    function EndState(name NextStateName)
    {
        super(Object).EndState(NextStateName);
        //return;        
    }

    function PushedState()
    {
        super(Object).PushedState();
        //return;        
    }

    function PoppedState()
    {
        super.PoppedState();
        //return;        
    }

    function ContinuedState()
    {
        super(Object).ContinuedState();
        //return;        
    }

    function PausedState()
    {
        super(Object).PausedState();
        //return;        
    }
    stop;    
}

state FlashBanged
{
    ignores WhatToDoNext;

    function RecoveredFromFlashBang()
    {
        PopState();
        //return;        
    }

    function EndState(name NextStateName)
    {
        ClearTimer('RecoveredFromFlashBang');
        //return;        
    }
    stop;    
}

state EnteringVehicle
{Begin:

    // End:0xC8
    if((Vehicle(RouteGoal) != none) && Vehicle(Pawn) == none)
    {
        // End:0x5B
        if(Vehicle(RouteGoal).TryToDrive(Pawn))
        {
            Squad.BotEnteredVehicle(self);            
        }
        else
        {
            // End:0xC8
            if(ActorReachable(RouteGoal))
            {
                MoveToward(RouteGoal, FaceActor(1.0000000),, true);
                // End:0xC8
                if((Vehicle(Pawn) == none) && Vehicle(RouteGoal).TryToDrive(Pawn))
                {
                    Squad.BotEnteredVehicle(self);
                }
            }
        }
    }
    LatentWhatToDoNext();
    stop;        
}

state LeavingVehicle
{
    function TryLeavingVehicle()
    {
        local Vehicle V;

        V = Vehicle(Pawn);
        // End:0x7A
        if(V != none)
        {
            V.DriverLeave(false);
            // End:0x7A
            if(Vehicle(Pawn) == none)
            {
                // End:0x7A
                if(int(Pawn.Physics) == int(2))
                {
                    Pawn.Velocity.Z = 0.0000000;
                }
            }
        }
        //return;        
    }
Begin:

    TryLeavingVehicle();
    // End:0x37
    if(Vehicle(Pawn) != none)
    {
        FindRandomDest();
        // End:0x37
        if(RouteCache.Length > 0)
        {
            MoveToward(RouteCache[0]);
        }
    }
    LatentWhatToDoNext();
    stop;            
}

state FrozenInputLocked
{
    ignores WhatToDoNext, NotifyTakeHit;

    function bool FireWeaponAt(Actor A)
    {
        return false;
        //return ReturnValue;        
    }
    J0x00:
    // End:0x1B [Loop If]
    if((IsMoveInputLocked()) == true)
    {
        Sleep(0.1000000);
        // [Loop Continue]
        goto J0x00;
    }
    PopState();
    stop;        
}
