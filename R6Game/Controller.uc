class Controller extends Actor
    abstract
    native
    nativereplication
    notplaceable
    hidecategories(lighting);

const LATENT_MOVETOWARD = 503;

var float m_fFocusCosHFOV;
var float m_fFocusCosVFOV;
var float m_fFocusMaxVisionDistance;
var float m_fPeripheralCosHFOV;
var float m_fPeripheralCosVFOV;
var float m_fPeripheralMaxVisionDistance;
var float m_fGunFOV;
var float m_fGunDistance;
var repnotify Pawn Pawn;
var repnotify PlayerReplicationInfo PlayerReplicationInfo;
var const int PlayerNum;
var const Controller NextController;
var float FOVAngle;
var bool bIsPlayer;
var bool bGodMode;
var bool bSoaking;
var bool bSlowerZAcquire;
var bool bForceStrafe;
var bool bNotifyPostLanded;
var bool m_bIsNoFellOutOfWorld;
var bool bNotifyApex;
var bool bAdvancedTactics;
var bool bCanDoSpecial;
var bool bAdjusting;
var bool bPreparingMove;
var const bool bLOSflag;
var bool bUsePlayerHearing;
var bool bNotifyFallingHitWall;
var bool bForceDesiredRotation;
var bool bPreciseDestination;
var bool m_bForceShowSelf;
var bool bSeeFriendly;
var input byte bFire;
var R6EngineEnums.EVisionMode m_SelectedVisionMode;
var float MinHitWall;
var ENavMesh CurrentNavMesh;
var int CurrentNavIndex;
var int CurrentZoneIndex;
var float MoveTimer;
var Actor MoveTarget;
var Vector Destination;
var Vector FocalPoint;
var Actor Focus;
var float FocusLead;
var Actor GoalList[4];
var Vector AdjustLoc;
var NavigationPoint StartSpot;
var Rotator m_rViewRotationDelta;
var array<NavigationPoint> RouteCache;
var ReachSpec CurrentPath;
var ReachSpec NextRoutePath;
var Vector CurrentPathDir;
var Actor RouteGoal;
var float RouteDist;
var float LastRouteFind;
var InterpActor PendingMover;
var float GroundPitchTime;
var Vector ViewX;
var Vector ViewY;
var Vector ViewZ;
var Pawn ShotTarget;
var const Actor LastFailedReach;
var const float FailedReachTime;
var const Vector FailedReachLocation;
var float SightCounter;
var float RespawnPredictionTime;
var Pawn Enemy;
var Actor Target;
var array<R6PickupableActor> m_pickupableItems;
var transient bool m_bFirstTimeInZone;
var R6SoundReplicationInfoAbstract m_PawnRepInfo;
var float m_fTimeBulletFizz;
var int m_iShowSelfLastTick;

replication
{
    // Pos:0x000
    if(bNetDirty && int(Role) == int(ROLE_Authority))
        Pawn, PlayerReplicationInfo, 
        m_PawnRepInfo;
}

// Export UController::execGetFireStartLocation(FFrame&, void* const)
native simulated function Vector GetFireStartLocation(bool bConsiderNearbyTarget);

// Export UController::execGetFireDirection(FFrame&, void* const)
native simulated function Vector GetFireDirection();

// Export UController::execDeadEvent(FFrame&, void* const)
native function DeadEvent();

// Export UController::execReviveEvent(FFrame&, void* const)
native function ReviveEvent(Controller Healer);

// Export UController::execIncapacitateEvent(FFrame&, void* const)
native function IncapacitateEvent();

event UpdateVisionMode(R6EngineEnums.EVisionMode EVisionMode, optional R6EngineEnums.EVisionModeAction eAction)
{
    return;
}

event ReturnFromInteractState()
{
    return;
}

function PropagateReturnFromInteractState()
{
    return;
}

function GotoInteractState()
{
    return;
}

event SelectVisionMode(R6EngineEnums.EVisionMode EVisionMode, optional R6EngineEnums.EVisionModeAction eAction)
{
    m_SelectedVisionMode = EVisionMode;
    return;
}

// Export UController::execGetVisionMode(FFrame&, void* const)
native simulated function R6EngineEnums.EVisionMode GetVisionMode();

reliable client simulated event ActivateFlash(Actor effectInstigator, float fRetinaImprintOpacity, float fInterpolationSpeed, float fFullStrengthDuration, float fFadeDuration, int GrabFrameNbIteration, float GrabFrameBlurWidth, bool Negate, bool Desaturate)
{
    return;
}

reliable client simulated event ActivateDizziness(Actor effectInstigator, float fMotionBlurOpacity, float fInterpolationSpeed, float fFullStrengthDuration, float fFadeDuration)
{
    return;
}

reliable client simulated event ActivateVisionBlur(Actor effectInstigator, float fGaussianBlurOpacity, float fInterpolationSpeed, float fFullStrengthDuration, float fFadeDuration)
{
    return;
}

// Export UController::execLocalPlayerController(FFrame&, void* const)
native function bool LocalPlayerController();

// Export UController::execIsParentPlayerController(FFrame&, void* const)
native function bool IsParentPlayerController();

// Export UController::execIsChildPlayerController(FFrame&, void* const)
native function bool IsChildPlayerController();

// Export UController::execIsLocalParentPlayerController(FFrame&, void* const)
native function bool IsLocalParentPlayerController();

// Export UController::execIsLocalChildPlayerController(FFrame&, void* const)
native function bool IsLocalChildPlayerController();

// Export UController::execIsRemoteParentPlayerController(FFrame&, void* const)
native function bool IsRemoteParentPlayerController();

// Export UController::execIsRemoteChildPlayerController(FFrame&, void* const)
native function bool IsRemoteChildPlayerController();

// Export UController::execHandleWalkOverPickup(FFrame&, void* const)
native function HandleWalkOverPickup(R6PickupableActor pickupableItem);

// Export UController::execHandleWalkOutPickup(FFrame&, void* const)
native function HandleWalkOutPickup(R6PickupableActor pickupableItem);

event PostBeginPlay()
{
    PostBeginPlay();
    m_bFirstTimeInZone = true;
    // End:0x85
    if((!bDeleteMe && bIsPlayer) && int(WorldInfo.NetMode) != int(NM_Client))
    {
        PlayerReplicationInfo = __NFUN_278__(WorldInfo.Game.PlayerReplicationInfoClass, self,, vect(0.0000000, 0.0000000, 0.0000000), rot(0, 0, 0));
        InitPlayerReplicationInfo();
    }
    SightCounter = 0.2000000 * FRand();
    return;
}

reliable client simulated function ClientSetLocation(Vector NewLocation, Rotator NewRotation)
{
    SetRotation(NewRotation);
    // End:0x8C
    if((Rotation.Pitch > RotationRate.Pitch) && Rotation.Pitch < (65536 - RotationRate.Pitch))
    {
        // End:0x70
        if(Rotation.Pitch < 32768)
        {
            NewRotation.Pitch = RotationRate.Pitch;            
        }
        else
        {
            NewRotation.Pitch = 65536 - RotationRate.Pitch;
        }
    }
    // End:0xC7
    if(Pawn != none)
    {
        NewRotation.Roll = 0;
        Pawn.SetRotation(NewRotation, true);
        Pawn.SetLocation(NewLocation);
    }
    return;
}

reliable client simulated function ClientSetRotation(Rotator NewRotation)
{
    SetRotation(NewRotation);
    // End:0x3E
    if(Pawn != none)
    {
        NewRotation.Pitch = 0;
        NewRotation.Roll = 0;
        Pawn.SetRotation(NewRotation, true);
    }
    return;
}

simulated event ReplicatedEvent(name VarName)
{
    // End:0x23
    if(VarName == 'PlayerReplicationInfo')
    {
        PlayerReplicationInfo.ClientInitialize(self);        
    }
    else
    {
        ReplicatedEvent(VarName);
    }
    return;
}

function OnPossess(SeqAct_Possess inAction)
{
    local Pawn OldPawn;
    local Vehicle V;

    V = Vehicle(Pawn);
    // End:0x40
    if(inAction.bTryToLeaveVehicle && V != none)
    {
        V.DriverLeave(true);
    }
    // End:0xF0
    if(inAction.PawnToPossess != none)
    {
        V = Vehicle(inAction.PawnToPossess);
        // End:0x9D
        if((Pawn != none) && V != none)
        {
            V.TryToDrive(Pawn);            
        }
        else
        {
            OldPawn = Pawn;
            UnPossess();
            Possess(inAction.PawnToPossess, false);
            // End:0xF0
            if(inAction.bKillOldPawn && OldPawn != none)
            {
                OldPawn.Destroy();
            }
        }
    }
    return;
}

event Possess(Pawn inPawn, bool bVehicleTransition)
{
    inPawn.PossessedBy(self, bVehicleTransition);
    Pawn = inPawn;
    // End:0xAA
    if(PlayerReplicationInfo != none)
    {
        // End:0x8B
        if(Pawn.IsA('Vehicle') && Vehicle(Pawn).Driver != none)
        {
            PlayerReplicationInfo.bIsFemale = Vehicle(Pawn).Driver.bIsFemale;            
        }
        else
        {
            PlayerReplicationInfo.bIsFemale = Pawn.bIsFemale;
        }
    }
    FocalPoint = Pawn.Location + (float(512) * Vector(Pawn.Rotation));
    Restart(bVehicleTransition);
    // End:0x101
    if(Pawn.Weapon == none)
    {
        ClientSwitchToBestWeapon();
    }
    return;
}

event UnPossess()
{
    // End:0x22
    if(Pawn != none)
    {
        Pawn.UnPossessed();
        Pawn = none;
    }
    return;
}

function PawnDied(Pawn inPawn)
{
    local int idx;

    // End:0x11
    if(inPawn != Pawn)
    {
        return;
    }
    idx = 0;
    J0x18:

    // End:0x5A [Loop If]
    if(idx < LatentActions.Length)
    {
        // End:0x50
        if(LatentActions[idx] != none)
        {
            LatentActions[idx].AbortFor(self);
        }
        idx++;
        // [Loop Continue]
        goto J0x18;
    }
    LatentActions.Length = 0;
    // End:0x8F
    if(Pawn != none)
    {
        SetLocation(Pawn.Location);
        Pawn.UnPossessed();
    }
    Pawn = none;
    // End:0xB7
    if(bIsPlayer)
    {
        // End:0xB4
        if(!GamePlayEndedState())
        {
            GotoState('Dead');
        }        
    }
    else
    {
        // End:0xDB
        if(Pawn != none)
        {
            SetLocation(Pawn.Location);
            UnPossess();
        }
        Destroy();
    }
    return;
}

// Export UController::execGamePlayEndedState(FFrame&, void* const)
native final function bool GamePlayEndedState();

event NotifyPostLanded()
{
    return;
}

simulated event Destroyed()
{
    // End:0xAF
    if(int(Role) == int(ROLE_Authority))
    {
        // End:0x49
        if(bIsPlayer && WorldInfo.Game != none)
        {
            WorldInfo.Game.Logout(self);
        }
        // End:0xAF
        if(PlayerReplicationInfo != none)
        {
            // End:0x98
            if(!PlayerReplicationInfo.bOnlySpectator && PlayerReplicationInfo.Team != none)
            {
                PlayerReplicationInfo.Team.RemoveFromTeam(self);
            }
            PlayerReplicationInfo.HasLeftGame();
            PlayerReplicationInfo = none;
        }
    }
    // End:0xCD
    if(m_PawnRepInfo != none)
    {
        m_PawnRepInfo.Destroy();
        m_PawnRepInfo = none;
    }
    Destroyed();
    return;
}

function Restart(bool bVehicleTransition)
{
    Pawn.Restart();
    // End:0x22
    if(!bVehicleTransition)
    {
        Enemy = none;
    }
    return;
}

// Export UController::execBeyondFogDistance(FFrame&, void* const)
native final function bool BeyondFogDistance(Vector ViewPoint, Vector OtherPoint);

// Export UController::execNotifyTakeHit(FFrame&, void* const)
native function NotifyTakeHit(Controller InstigatedBy, Vector HitSourceLocation, Vector HitLocation, int Damage, class<DamageType> DamageType, Vector Momentum);

function InitPlayerReplicationInfo()
{
    // End:0x33
    if(PlayerReplicationInfo.PlayerName == "")
    {
        PlayerReplicationInfo.SetPlayerName(Class'GameInfo'.default.DefaultPlayerName);
    }
    return;
}

simulated function byte GetTeamNum()
{
    // End:0x26
    if((PlayerReplicationInfo == none) || PlayerReplicationInfo.Team == none)
    {
        return byte(255);
    }
    return byte(PlayerReplicationInfo.Team.TeamIndex);
    return;
}

reliable server event ServerRestartPlayer()
{
    // End:0x2D
    if((int(WorldInfo.NetMode) != int(NM_Client)) && Pawn != none)
    {
        ServerGivePawn();
    }
    return;
}

function ServerGivePawn()
{
    return;
}

function SetCharacter(string inCharacter)
{
    return;
}

function GameHasEnded(optional Actor EndGameFocus, optional bool bIsWinner)
{
    GotoState('RoundEnded');
    return;
}

function NotifyKilled(Controller Killer, Controller Killed, Pawn KilledPawn)
{
    // End:0x25
    if(Pawn != none)
    {
        Pawn.TriggerEventClass(Class'SeqEvent_SeeDeath', KilledPawn);
    }
    // End:0x3B
    if(Enemy == KilledPawn)
    {
        Enemy = none;
    }
    return;
}

function NotifyProjLanded(Projectile Proj)
{
    // End:0x32
    if((Proj != none) && Pawn != none)
    {
        Pawn.TriggerEventClass(Class'SeqEvent_ProjectileLanded', Proj);
    }
    return;
}

event float RatePickup(Actor PickupHolder, class<Inventory> inPickup)
{
    return;
}

event PickUpWeapon(R6PickupableActor pPickup)
{
    return;
}

function bool FireWeaponAt(Actor inActor)
{
    return;
}

function StopFiring()
{
    bFire = 0;
    // End:0x23
    if(Pawn != none)
    {
        Pawn.StopFiring();
    }
    return;
}

function RoundHasEnded(optional Actor EndRoundFocus)
{
    GotoState('RoundEnded');
    return;
}

function HandlePickup(Inventory Inv)
{
    return;
}

function Rotator GetAdjustedAimFor(Inventory W, Vector StartFireLoc)
{
    // End:0x1C
    if(Pawn != none)
    {
        return Pawn.GetBaseAimRotation();
    }
    return Rotation;
    return;
}

function InstantWarnTarget(Actor InTarget, Weapon FiredWeapon, Vector FireDir)
{
    local float Dist;

    // End:0xE3
    if(((FiredWeapon != none) && Pawn(InTarget) != none) && Pawn(InTarget).Controller != none)
    {
        Dist = VSize(Pawn.Location - InTarget.Location);
        // End:0x9F
        if(VSize((FireDir * Dist) - InTarget.Location) < Pawn(InTarget).CylinderComponent.CollisionRadius)
        {
            return;
        }
        // End:0xE1
        if(FRand() < FiredWeapon.WarnTargetPct)
        {
            Pawn(InTarget).Controller.ReceiveWarning(Pawn, -1.0000000, FireDir);
        }
        return;
    }
    return;
}

function ReceiveWarning(Pawn shooter, float projSpeed, Vector FireDir)
{
    return;
}

function ReceiveProjectileWarning(Projectile Proj)
{
    return;
}

exec function SwitchToBestWeapon()
{
    // End:0x23
    if((Pawn == none) || Pawn.InvManager == none)
    {
        return;
    }
    Pawn.InvManager.SwitchToBestWeapon();
    return;
}

reliable client simulated function ClientSwitchToBestWeapon()
{
    SwitchToBestWeapon();
    return;
}

function NotifyChangedWeapon(Weapon PrevWeapon, Weapon NewWeapon)
{
    return;
}

// Export UController::execLineOfSightTo(FFrame&, void* const)
native(514) final function bool LineOfSightTo(Actor other, optional Vector chkLocation);

// Export UController::execCanSee(FFrame&, void* const)
native(533) final function bool CanSee(Pawn other);

// Export UController::execPickTarget(FFrame&, void* const)
native(531) final function Pawn PickTarget(class<Pawn> TargetClass, out float bestAim, out float bestDist, Vector FireDir, Vector projStart, float MaxRange);

event HearNoise(float Loudness, Actor NoiseMaker, optional name NoiseType)
{
    return;
}

event SeePlayer(Pawn Seen)
{
    return;
}

event SeeMonster(Pawn Seen)
{
    return;
}

event EnemyNotVisible()
{
    return;
}

// Export UController::execMoveTo(FFrame&, void* const)
native(500) final latent function MoveTo(Vector NewDestination, optional Actor ViewFocus, optional bool bShouldWalk);

// Export UController::execMoveToward(FFrame&, void* const)
native(502) final latent function MoveToward(Actor NewTarget, optional Actor ViewFocus, optional float DestinationOffset, optional bool bUseStrafing, optional bool bShouldWalk);

event SetupSpecialPathAbilities()
{
    return;
}

// Export UController::execFinishRotation(FFrame&, void* const)
native(508) final latent function FinishRotation();

// Export UController::execFindPathTo(FFrame&, void* const)
native(518) final function Actor FindPathTo(Vector aPoint);

// Export UController::execFindPathToward(FFrame&, void* const)
native(517) final function Actor FindPathToward(Actor anActor, optional bool bWeightDetours);

// Export UController::execFindPathTowardNearest(FFrame&, void* const)
native final function Actor FindPathTowardNearest(class<NavigationPoint> GoalClass, optional bool bWeightDetours);

// Export UController::execFindRandomDest(FFrame&, void* const)
native(525) final function NavigationPoint FindRandomDest();

// Export UController::execFindPathToIntercept(FFrame&, void* const)
native final function Actor FindPathToIntercept(Pawn P, Actor InRouteGoal, optional bool bWeightDetours);

// Export UController::execPointReachable(FFrame&, void* const)
native(521) final function bool PointReachable(Vector aPoint);

// Export UController::execActorReachable(FFrame&, void* const)
native(520) final function bool ActorReachable(Actor anActor);

// Export UController::execPickWallAdjust(FFrame&, void* const)
native(526) final function bool PickWallAdjust(Vector HitNormal);

// Export UController::execWaitForLanding(FFrame&, void* const)
native(527) final latent function WaitForLanding(optional float waitDuration);

event LongFall()
{
    return;
}

// Export UController::execEndClimbLadder(FFrame&, void* const)
native function EndClimbLadder();

event MayFall()
{
    return;
}

event bool AllowDetourTo(NavigationPoint N)
{
    return true;
    return;
}

function WaitForMover(InterpActor M)
{
    PendingMover = M;
    M.bMonitorMover = true;
    bPreparingMove = true;
    Pawn.Acceleration = vect(0.0000000, 0.0000000, 0.0000000);
    return;
}

event bool MoverFinished()
{
    // End:0x55
    if(((Pawn == none) || PendingMover.MyMarker == none) || PendingMover.MyMarker.ProceedWithMove(Pawn))
    {
        PendingMover = none;
        bPreparingMove = false;
        return true;
    }
    return false;
    return;
}

function UnderLift(LiftCenter Lift)
{
    return;
}

// Export UController::execGetFOVAngle(FFrame&, void* const)
native function float GetFOVAngle(optional bool bSpecialFirstPerson);

// Export UController::execGetPlayerViewPoint(FFrame&, void* const)
native function GetPlayerViewPoint(out Vector out_Location, out Rotator out_Rotation);

// Export UController::execGetPlayerViewPointWithModifiers(FFrame&, void* const)
native function GetPlayerViewPointWithModifiers(out Vector vLoc, out Rotator rRot, out float fViewMatrixOffset);

simulated event GetActorEyesViewPoint(out Vector out_Location, out Rotator out_Rotation)
{
    // End:0x28
    if(Pawn != none)
    {
        Pawn.GetActorEyesViewPoint(out_Location, out_Rotation);        
    }
    else
    {
        out_Location = Location;
        out_Rotation = Rotation;
    }
    return;
}

function AdjustView(float DeltaTime)
{
    local PlayerController PC;
    local bool bViewTarget;

    // End:0x72
    if(Pawn.bUpdateEyeheight)
    {
        // End:0x52
        foreach WorldInfo.AllControllers(Class'PlayerController', PC)
        {
            // End:0x51
            if(PC.ViewTarget == Pawn)
            {
                bViewTarget = true;
                // End:0x52
                break;
            }            
        }        
        // End:0x6F
        if(!bViewTarget)
        {
            Pawn.bUpdateEyeheight = false;
        }        
    }
    else
    {
        Pawn.EyeHeight = Pawn.BaseEyeHeight;
    }
    return;
}

function bool WantsSmoothedView()
{
    return ((Pawn != none) && !Pawn.bJustLanded) && (int(Pawn.Physics) == int(1)) || int(Pawn.Physics) == int(8);
    return;
}

event NotifyPhysicsVolumeChange(PhysicsVolume NewVolume)
{
    return;
}

event bool NotifyHeadVolumeChange(PhysicsVolume NewVolume)
{
    return;
}

event bool NotifyLanded(Vector HitNormal)
{
    return;
}

event bool NotifyHitWall(Vector HitNormal, Actor Wall)
{
    return;
}

event NotifyFallingHitWall(Vector HitNormal, Actor Wall)
{
    return;
}

event bool NotifyBump(Actor other, PrimitiveComponent pComponent, Vector HitNormal)
{
    return;
}

event NotifyJumpApex()
{
    return;
}

event NotifyMissedJump()
{
    return;
}

// Export UController::execInLatentExecution(FFrame&, void* const)
native final function bool InLatentExecution(int LatentActionNumber);

// Export UController::execStopLatentExecution(FFrame&, void* const)
native final function StopLatentExecution();

function DisplayDebug(HUD HUD, out float out_YL, out float out_YPos)
{
    local Canvas Canvas;

    Canvas = HUD.Canvas;
    // End:0xB0
    if(Pawn == none)
    {
        // End:0x54
        if(PlayerReplicationInfo == none)
        {
            Canvas.__NFUN_465__("NO PLAYERREPLICATIONINFO", false);            
        }
        else
        {
            PlayerReplicationInfo.DisplayDebug(HUD, out_YL, out_YPos);
        }
        out_YPos += out_YL;
        Canvas.SetPos(4.0000000, out_YPos);
        DisplayDebug(HUD, out_YL, out_YPos);
        return;
    }
    Canvas.SetDrawColor(byte(255), 0, 0);
    Canvas.__NFUN_465__((("CONTROLLER " $ (GetItemName(string(self)))) $ " Pawn ") $ (GetItemName(string(Pawn))));
    out_YPos += out_YL;
    Canvas.SetPos(4.0000000, out_YPos);
    // End:0x1E6
    if(HUD.ShouldDisplayDebug("AI"))
    {
        // End:0x191
        if(Enemy != none)
        {
            Canvas.__NFUN_465__((("     STATE: " $ string(GetStateName())) $ " Enemy ") $ Enemy.GetHumanReadableName(), false);            
        }
        else
        {
            Canvas.__NFUN_465__(("     STATE: " $ string(GetStateName())) $ " NO Enemy ", false);
        }
        out_YPos += out_YL;
        Canvas.SetPos(4.0000000, out_YPos);
    }
    return;
}

simulated function string GetHumanReadableName()
{
    // End:0x1D
    if(PlayerReplicationInfo != none)
    {
        return PlayerReplicationInfo.PlayerName;        
    }
    else
    {
        return GetItemName(string(self));
    }
    return;
}

function OnTeleport(SeqAct_Teleport Action)
{
    local array<Object> objVars;
    local int idx;
    local Actor destActor;
    local Controller C;

    // End:0x23
    if(Pawn != none)
    {
        Pawn.OnTeleport(Action);        
    }
    else
    {
        OnTeleport(Action);
    }
    Action.GetObjectVars(objVars, "Destination");
    idx = 0;
    J0x57:

    // End:0xD9 [Loop If]
    if((idx < objVars.Length) && destActor == none)
    {
        destActor = Actor(objVars[idx]);
        C = Controller(destActor);
        // End:0xCF
        if((C != none) && C.Pawn != none)
        {
            destActor = C.Pawn;
        }
        idx++;
        // [Loop Continue]
        goto J0x57;
    }
    // End:0x139
    if((destActor != none) && Action.bUpdateRotation)
    {
        FocalPoint = destActor.Location + (1000.0000000 * Vector(destActor.Rotation));
        DesiredRotation = destActor.Rotation;
    }
    return;
}

function OnToggleGodMode(SeqAct_ToggleGodMode inAction)
{
    // End:0x24
    if(inAction.InputLinks[0].bHasImpulse)
    {
        bGodMode = true;        
    }
    else
    {
        // End:0x48
        if(inAction.InputLinks[1].bHasImpulse)
        {
            bGodMode = false;            
        }
        else
        {
            bGodMode = !bGodMode;
        }
    }
    return;
}

simulated function NotifyCoverDisabled(CoverLink Link, int SlotIdx)
{
    return;
}

simulated function NotifyCoverAdjusted()
{
    return;
}

function NotifyNearMiss(Pawn shooter, Weapon ShootersWeapon, Vector ClosestPoint)
{
    return;
}

function OnCauseDamage(SeqAct_CauseDamage Action)
{
    // End:0x20
    if(Pawn != none)
    {
        Pawn.OnCauseDamage(Action);
    }
    return;
}

function NotifyAddInventory(Inventory NewItem)
{
    return;
}

simulated function OnToggleHidden(SeqAct_ToggleHidden Action)
{
    // End:0x20
    if(Pawn != none)
    {
        Pawn.OnToggleHidden(Action);
    }
    return;
}

simulated function SetWeaponSound(class<Weapon> WeaponClass)
{
    LogInternal(("SetWeaponSound - Pawn" @ string(Pawn.Name)) @ string(WeaponClass),, 16);
    // End:0xB1
    if((Pawn != none) && m_PawnRepInfo != none)
    {
        LogInternal("SetWeaponSound - WeaponClass" @ string(WeaponClass.Name),, 16);
        // End:0xB1
        if((WeaponClass != none) && m_PawnRepInfo != none)
        {
            m_PawnRepInfo.AssignSound(WeaponClass);
        }
    }
    return;
}

event bool IsInCombat()
{
    return;
}

function ResetOriginalData()
{
    ResetOriginalData();
    m_pickupableItems.Remove(0, m_pickupableItems.Length);
    CurrentNavIndex = -1;
    CurrentZoneIndex = -1;
    return;
}

reliable client simulated function ClientSetSwitchOnInteraction()
{
    return;
}

event bool IsDedicatedServerController()
{
    return false;
    return;
}

state Dead
{
    ignores KilledBy;

    function PawnDied(Pawn P)
    {
        // End:0x35
        if(int(WorldInfo.NetMode) != int(NM_Client))
        {
            WarnInternal(string(self) @ "Pawndied while dead");
        }
        return;
    }

    reliable server event ServerRestartPlayer()
    {
        // End:0x1B
        if(int(WorldInfo.NetMode) == int(NM_Client))
        {
            return;
        }
        // End:0x2D
        if(Pawn != none)
        {
            UnPossess();
        }
        WorldInfo.Game.RestartPlayer(self);
        return;
    }
    stop;
}

state RoundEnded
{
    ignores KilledBy, TakeDamage, ReceiveWarning;

    function BeginState(name PreviousStateName)
    {
        // End:0x32
        if(Pawn != none)
        {
            Pawn.TurnOff();
            Pawn.UnPossessed();
            Pawn = none;
        }
        // End:0x40
        if(!bIsPlayer)
        {
            Destroy();
        }
        return;
    }
    stop;
}

defaultproperties
{
    FOVAngle=90.0000000
    bSlowerZAcquire=true
    MinHitWall=-1.0000000
    CurrentNavIndex=-1
    CurrentZoneIndex=-1
    m_bFirstTimeInZone=true
    bHidden=true
    bOnlyRelevantToOwner=true
    bHiddenEd=true
    RotationRate=(Pitch=3072,Yaw=30000,Roll=2048)
}