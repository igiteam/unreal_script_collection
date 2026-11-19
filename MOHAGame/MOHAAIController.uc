class MOHAAIController extends KynapseAIController
    native
    config(AI)
    hidecategories(Navigation)
    implements(MOHAControllerInterface);

const STIMULUS_LOD_TYPE_NONE = 0;
const STIMULUS_LOD_TYPE_AWAKE = 1;
const STIMULUS_LOD_TYPE_MID = 2;
const STIMULUS_LOD_TYPE_CLOSE = 3;
const STIMULUS_LOD_TYPE_LONG = 4;

enum EPlayerProximity
{
    PLAYER_PROXIMITY_NONE,          // 0
    PLAYER_PROXIMITY_UNKNOWN,       // 1
    PLAYER_PROXIMITY_FIRST_CONTACT_STANDING,// 2
    PLAYER_PROXIMITY_FIRST_CONTACT_NOT_STANDING,// 3
    PLAYER_PROXIMITY_SECOND_CONTACT,// 4
    PLAYER_PROXIMITY_MAX            // 5
};

var transient MOHAMountedGun MountedGun;
var MOHAGagNode GagNode;
var bool AiLod_IsAwake;
var bool AiLod_IsClose;
var bool AiLod_IsMid;
var bool AiLod_RenderedRecently;
var bool AiLod_IsLong;
var bool AiLod_ForceAnimatingNextFrame;
var const bool AiLod_ForceAnimatingThisFrame;
var bool bUsesCover;
var float AiLod_Distance;
var private native const Pointer AiLod_Island;
var Object QueuedOIRGotoObject;
var name QueuedOIRGotoActivity;
var Vector QueuedOIRGotoLocation;
var export editinline StimulusComponent Stimulus;
var MOHAAIController.EPlayerProximity PlayerProximity;
var float MinPlayerProximityTime;
var float MaxPlayerProximityTime;
var float fRotationPIDMin;
var float fRotationPIDMax;
var float fRotationPIDEngageRangeMin;
var float fRotationPIDEngageRangeMax;
var float fRotationPIDStrafeDistanceMult;
var MOHAAIPawn CachedAIPawn;

// Export UMOHAAIController::execGetSafeSubgoalPosition(FFrame&, void* const)
native final function Vector GetSafeSubgoalPosition();

// Export UMOHAAIController::execOnHomeStretchEntry(FFrame&, void* const)
native final function OnHomeStretchEntry();

// Export UMOHAAIController::execAddToAiLod(FFrame&, void* const)
native function AddToAiLod();

// Export UMOHAAIController::execRemoveFromAiLod(FFrame&, void* const)
native function RemoveFromAiLod();

// Export UMOHAAIController::execIsAwake(FFrame&, void* const)
native function bool IsAwake();

// Export UMOHAAIController::execIsAnimatedLOD(FFrame&, void* const)
native function bool IsAnimatedLOD();

// Export UMOHAAIController::execIsLongLOD(FFrame&, void* const)
native function bool IsLongLOD();

// Export UMOHAAIController::execIsMidLOD(FFrame&, void* const)
native function bool IsMidLOD();

// Export UMOHAAIController::execIsCloseLOD(FFrame&, void* const)
native function bool IsCloseLOD();

// Export UMOHAAIController::execActivityFinished(FFrame&, void* const)
native function ActivityFinished(name activity, name activityPose);

// Export UMOHAAIController::execActivityFailed(FFrame&, void* const)
native function ActivityFailed(name activity, name activityPose);

// Export UMOHAAIController::execActivityStarted(FFrame&, void* const)
native function ActivityStarted(name activity, name activityPose);

// Export UMOHAAIController::execUseVaultExit(FFrame&, void* const)
native function UseVaultExit();

// Export UMOHAAIController::execOverridePathablePosition(FFrame&, void* const)
native function bool OverridePathablePosition(out Vector PathablePos);

// Export UMOHAAIController::execIsNPCImmune(FFrame&, void* const)
native function bool IsNPCImmune();

// Export UMOHAAIController::execGetActorEyesViewPoint(FFrame&, void* const)
native simulated function GetActorEyesViewPoint(out Vector out_Location, out Rotator out_Rotation);

// Export UMOHAAIController::execSetNextSubgoalPositions(FFrame&, void* const)
native function SetNextSubgoalPositions(Vector vCurrent, Vector vNext);

function int GetWeaponAmmoCount()
{
    // End:0x43
    if((Pawn != none) && Pawn.Weapon != none)
    {
        return EALAWeapon(Pawn.Weapon).GetAmmoInClip();
    }
    return 0;
    //return ReturnValue;    
}

event EnterStasis()
{
    local MOHAAIPawn AIPawn;

    AIPawn = MOHAAIPawn(Pawn);
    // End:0x4C
    if(AIPawn != none)
    {
        // End:0x4C
        if(AIPawn.CurrentWeaponAttachment != none)
        {
            AIPawn.CurrentWeaponAttachment.StopFiring(true);
        }
    }
    // End:0x82
    if(MOHAPawn(Pawn) != none)
    {
        MOHAPawn(Pawn).AxonObserver.NotifyObservers('EnteredStasis');
    }
    //return;    
}

event SetGrenadeThrowVelocity(Vector vPos)
{
    local MOHAAIPawn AIPawn;

    AIPawn = MOHAAIPawn(Pawn);
    // End:0x2F
    if(AIPawn != none)
    {
        AIPawn.GrenadeThrowVelocity = vPos;
    }
    //return;    
}

event PrintToAILog(string output)
{
    local MOHAAIPawn MOHAPawn;

    // End:0x33
    if(MOHAPawn(Pawn) != none)
    {
        MOHAPawn = MOHAAIPawn(MOHAPawn(Pawn).GetPawnBody());
    }
    // End:0x56
    if(MOHAPawn != none)
    {
        MOHAPawn.PrintToAILog(output);
    }
    //return;    
}

event ReturnToSpawner()
{
    // End:0x28
    if(MOHAPawn(Pawn) != none)
    {
        MOHAPawn(Pawn).ReturnToSpawner();
    }
    //return;    
}

event bool KillMeImHere()
{
    // End:0x29
    if(MOHAPawn(Pawn) != none)
    {
        return MOHAPawn(Pawn).KillMeImHere();
    }
    return false;
    //return ReturnValue;    
}

function SetMountedGun(MOHAMountedGun gun)
{
    MountedGun = gun;
    //return;    
}

event OnKynapseTeamChange()
{
    //return;    
}

function OnFriendlyGrenade(out StimulusListenerSubscription Listener, out StimulusSenderSubscription Sender)
{
    local int Team;

    Team = 2;
    Sender.Owner.GetStimuliSenderParamInt('GrenadeThrown', 'Team', Team);
    // End:0x4D
    if(Team == TeamIndex)
    {
        FriendlyJustThrewGrenade();
    }
    //return;    
}

event Possess(Pawn inPawn, bool bVehicleTransition)
{
    local MOHAAIPawn MOHAAIPawn;
    local MOHAPawn MOHAPawn;

    super.Possess(inPawn, bVehicleTransition);
    // End:0x1A0
    if(Pawn != none)
    {
        MOHAPawn = MOHAPawn(Pawn);
        // End:0x5C
        if(MOHAPawn != none)
        {
            Stimulus.SetProxyActor(MOHAPawn.GetPawnBody());            
        }
        else
        {
            Stimulus.SetProxyActor(Pawn);
        }
        // End:0xC0
        if(TeamIndex == 0)
        {
            Stimulus.AttachSender('PlayerPresenceCC', 'PlayerPresenceCC', vect(0.0000000, 0.0000000, 0.0000000), rot(0, 0, 0),, 4);
        }
        Stimulus.AttachListener('TeamDeath', 'TeamDeath', OnTeamDeath, vect(0.0000000, 0.0000000, 0.0000000), rot(0, 0, 0),, 4);
        Stimulus.AttachListener('NearbyExplosion', 'NearbyExplosion', OnNearbyExplosion, vect(0.0000000, 0.0000000, 0.0000000), rot(0, 0, 0),, 4);
        Stimulus.AttachListener('GrenadeThrown', 'GrenadeThrown', OnFriendlyGrenade, vect(0.0000000, 0.0000000, 0.0000000), rot(0, 0, 0));
    }
    MOHAAIPawn = MOHAAIPawn(inPawn);
    // End:0x20F
    if(MOHAAIPawn != none)
    {
        LeashVolume = MOHAAIPawn.LeashVolume;
        fLeashRadius = MOHAAIPawn.fLeashRadius;
        vLeashHome = MOHAAIPawn.vLeashHome;
        SetActivityFailed(MOHAAIPawn.ActiveOIR);
    }
    AddToAiLod();
    //return;    
}

event UnPossess()
{
    RemoveFromAiLod();
    Stimulus.SetProxyActor(none);
    super(Controller).UnPossess();
    //return;    
}

function StimulusComponent GetStimulusComponent()
{
    return Stimulus;
    //return ReturnValue;    
}

function OnTeamDeath(out StimulusListenerSubscription Listener, out StimulusSenderSubscription Sender)
{
    local int SenderTeam;
    local float visDot;
    local Vector EyeDirection, ListenerToSenderDirection;
    local MOHAAIPawn ListenerPawn;

    Sender.Owner.GetStimuliSenderParamInt('TeamDeath', 'Team', SenderTeam);
    // End:0x41
    if(TeamIndex != SenderTeam)
    {
        return;
    }
    ListenerPawn = MOHAAIPawn(Pawn);
    // End:0x5E
    if(ListenerPawn == none)
    {
        return;
    }
    EyeDirection = Vector(ListenerPawn.GetViewRotation());
    ListenerToSenderDirection = Normal(Sender.Owner.GetSpatialActor().Location - ListenerPawn.Location);
    visDot = ListenerToSenderDirection Dot EyeDirection;
    // End:0xDA
    if(visDot < 0.0000000)
    {
        return;
    }
    SendCCStimulus("AllyDeath", Sender.Owner.GetSpatialActor());
    //return;    
}

function OnNearbyExplosion(out StimulusListenerSubscription Listener, out StimulusSenderSubscription Sender)
{
    local int timeInt;

    timeInt = int(WorldInfo.TimeSeconds);
    switch(float(timeInt) % float(5))
    {
        // End:0x2D
        case 0.0000000:
        // End:0x35
        case 1.0000000:
        // End:0x6E
        case 2.0000000:
            SendCCStimulus("Cough", Sender.Owner.GetSpatialActor());
            // End:0x154
            break;
        // End:0xE2
        case 3.0000000:
            SendCCStimulus("ExplosionStatement", Sender.Owner.GetSpatialActor());
            SendCCStimulus("Cough", Sender.Owner.GetSpatialActor());
            // End:0x154
            break;
        // End:0x151
        case 4.0000000:
            SendCCStimulus("ExplosionCall", Sender.Owner.GetSpatialActor());
            SendCCStimulus("Cough", Sender.Owner.GetSpatialActor());
            // End:0x154
            break;
        // End:0xFFFF
        default:
            break;
    }
    //return;    
}

function OnActivityFailed(name activity, name activityPose)
{
    ActivityFailed(activity, activityPose);
    //return;    
}

function SetActivityFailed(OirInstance oir)
{
    oir.SetActivityFailed(OnActivityFailed);
    //return;    
}

simulated function Rotator GetAdjustedAimFor(Weapon W, Vector StartFireLoc)
{
    local MOHAAIPawn NPC;

    // End:0x56
    if((MountedGun != none) && MountedGun.GetIsMounted())
    {
        NPC = MOHAAIPawn(MountedGun.Gunner);
        // End:0x56
        if(NPC != none)
        {
            return NPC.AbsoluteAimRot;
        }
    }
    return super(Controller).GetAdjustedAimFor(W, StartFireLoc);
    //return ReturnValue;    
}

simulated function Rotator GetPostAdjustedAimFor(Weapon W, Vector StartFireLoc, Rotator DesiredAimRot, Rotator PostAdjustAimRot)
{
    return super.GetPostAdjustedAimFor(W, StartFireLoc, DesiredAimRot, PostAdjustAimRot);
    //return ReturnValue;    
}

function MOHAMountedGun GetMountedGun()
{
    return MountedGun;
    //return ReturnValue;    
}

function NotifyTakeHit(Controller InstigatedBy, Vector HitLocation, int Damage, class<DamageType> DamageType, Vector Momentum, optional Actor DamageCauser)
{
    // End:0x13
    if(ClassIsChildOf(DamageType, Class'MOHAExplosiveDamageType'))
    {
        return;
    }
    // End:0x25
    if(ClassIsChildOf(DamageType, Class'MOHAMeleeDamageType'))
    {
        return;
    }
    // End:0xFA
    if(InstigatedBy.IsA('MOHAPlayerController'))
    {
        // End:0xAA
        if(TeamIndex != 0)
        {
            MOHAPlayerController(InstigatedBy).OnWeaponHit(EALAWeapon(InstigatedBy.Pawn.Weapon).WeaponType, MOHAAIPawn(Pawn).LastHitRigdBodyBoneName, MOHAAIPawn(Pawn), DamageType, false);            
        }
        else
        {
            MOHAPlayerController(InstigatedBy).playerStats.OnHitAlly(EALAWeapon(InstigatedBy.Pawn.Weapon).WeaponType, MOHAAIPawn(Pawn));
        }
    }
    //return;    
}

event name SetNextOIRData(Object oirOwner, name ActivityName, bool bForceUseOIR, optional float TransitionRateScale = 1.0000000, optional name forcePose, optional bool bSetInPlace = false)
{
    local name activityPose;
    local OIROwnerInterface oirInt;
    local MOHAAIPawn MOHAPawn;

    activityPose = 'None';
    oirInt = OIROwnerInterface(oirOwner);
    // End:0x82
    if(NotEqual_InterfaceInterface(oirInt, OIROwnerInterface(none)))
    {
        // End:0x63
        if(forcePose != 'None')
        {
            activityPose = forcePose;            
        }
        else
        {
            activityPose = oirInt.GetActivityPose(ActivityName);
        }
    }
    // End:0xB5
    if(MOHAPawn(Pawn) != none)
    {
        MOHAPawn = MOHAAIPawn(MOHAPawn(Pawn).GetPawnBody());
    }
    // End:0xF3
    if(MOHAPawn != none)
    {
        MOHAPawn.SetNextOIRData(oirOwner, ActivityName, activityPose, bForceUseOIR, TransitionRateScale, bSetInPlace);
    }
    return activityPose;
    //return ReturnValue;    
}

event SetNextFixedFireOIRData(Vector Position, name ActivityName, optional bool bSetInPlace = false)
{
    local MOHAAIPawn MOHAPawn;

    // End:0x38
    if(MOHAPawn(Pawn) != none)
    {
        MOHAPawn = MOHAAIPawn(MOHAPawn(Pawn).GetPawnBody());
    }
    // End:0x66
    if(MOHAPawn != none)
    {
        MOHAPawn.SetNextFixedFireOIRData(Position, ActivityName, bSetInPlace);
    }
    //return;    
}

function QueueNextGotoFixedFireOIR(Vector Position, name ActivityName)
{
    local MOHAAIPawn MOHAPawn;

    // End:0x33
    if(MOHAPawn(Pawn) != none)
    {
        MOHAPawn = MOHAAIPawn(MOHAPawn(Pawn).GetPawnBody());
    }
    // End:0x7F
    if(MOHAPawn != none)
    {
        QueuedOIRGotoLocation = Position;
        MOHAPawn.UpdateFixedFireOIR(Position);
        QueueNextGotoOIR(MOHAPawn.FFImpl, ActivityName);
    }
    //return;    
}

function QueueNextGotoOIR(Object oirOwner, name ActivityName)
{
    QueuedOIRGotoObject = oirOwner;
    QueuedOIRGotoActivity = ActivityName;
    //return;    
}

event ExecuteNextOIRGoto(Vector subGoalPos)
{
    local MOHAAIPawn MOHAPawn;

    // End:0x33
    if(MOHAPawn(Pawn) != none)
    {
        MOHAPawn = MOHAAIPawn(MOHAPawn(Pawn).GetPawnBody());
    }
    // End:0x52
    if(MOHAPawn != none)
    {
        MOHAPawn.vFirstGotoSubgoalPos = subGoalPos;
    }
    // End:0x7B
    if(FixedFireOIRImpl(QueuedOIRGotoObject) != none)
    {
        MOHAPawn.UpdateFixedFireOIR(QueuedOIRGotoLocation);
    }
    SetNextOIRData(QueuedOIRGotoObject, QueuedOIRGotoActivity, false);
    //return;    
}

event Vector GetPathablePosition()
{
    local MOHAAIPawn MOHAPawn;

    // End:0x33
    if(MOHAPawn(Pawn) != none)
    {
        MOHAPawn = MOHAAIPawn(MOHAPawn(Pawn).GetPawnBody());
    }
    // End:0x52
    if(MOHAPawn != none)
    {
        return MOHAPawn.GetPathablePosition();
    }
    return Pawn.Location;
    //return ReturnValue;    
}

function BURST_TYPE GetShortBurst()
{
    return EALAWeapon(Pawn.Weapon).GetShortBurst();
    //return ReturnValue;    
}

function BURST_TYPE GetLongBurst()
{
    return EALAWeapon(Pawn.Weapon).GetLongBurst();
    //return ReturnValue;    
}

function BURST_TYPE GetVeryLongBurst()
{
    return EALAWeapon(Pawn.Weapon).GetVeryLongBurst();
    //return ReturnValue;    
}

function BURST_TYPE GetWildBurst()
{
    return EALAWeapon(Pawn.Weapon).GetWildBurst();
    //return ReturnValue;    
}

function BURST_TYPE GetSuppressingBurst()
{
    return EALAWeapon(Pawn.Weapon).GetSuppressingBurst();
    //return ReturnValue;    
}

function NotifyWeaponFired(Weapon iWeap, byte FireMode)
{
    super.NotifyWeaponFired(iWeap, FireMode);
    // End:0x46
    if(MOHAPawn(Pawn) != none)
    {
        MOHAPawn(Pawn).AxonObserver.NotifyObservers('NotifyWeaponFired');
    }
    //return;    
}

function NotifyWeaponFinishedFiring(Weapon iWeap, byte FireMode)
{
    //return;    
}

function bool IsSniperController()
{
    return false;
    //return ReturnValue;    
}

function UseGagNode(MOHAGagNode NewGagNode)
{
    GagNode = NewGagNode;
    GagNode.PawnArrived();
    //return;    
}

function ClearGagNode()
{
    // End:0x25
    if(GagNode != none)
    {
        GagNode.UnMount();
        GagNode = none;
    }
    //return;    
}

function MOHAGagNode GetGagNode()
{
    return GagNode;
    //return ReturnValue;    
}

function bool CanPerformGag()
{
    return (GetGagNode()) == none;
    //return ReturnValue;    
}

function SetNewAlternateCoverNode(KynapseCoverNode newNode, name initialActivity)
{
    // End:0x1F
    if((newNode == none) || MOHAAIPawn(Pawn) == none)
    {
        return;
    }
    // End:0x46
    if(MOHAAIPawn(Pawn).IsNewOIR(OIROwnerInterface(newNode)))
    {
        return;
    }
    SetNextOIRData(OIROwnerInterface(newNode), initialActivity, false);
    SetCurrentCoverNode(newNode);
    //return;    
}

event OnChoosePlayerAsTarget(Controller PC)
{
    local MOHAPlayerController MOHAPC;
    local Vector vDirToTarget;

    // End:0x3E
    if(CurrentAffordanceNode != none)
    {
        MOHAPC = MOHAPlayerController(PC);
        // End:0x3E
        if(MOHAPC != none)
        {
            MOHAPC.AddEngagedAffordance(CurrentAffordanceNode);
        }
    }
    vDirToTarget = PC.Pawn.Location - Pawn.Location;
    vDirToTarget = Normal(vDirToTarget);
    // End:0xB2
    if(vDirToTarget.Z > 0.7000000)
    {
        SendCCStimulus("EnemySpottedAbove");        
    }
    else
    {
        SendCCStimulus("PlayerTargeted");
    }
    //return;    
}

function SendCCStimulus(string StimulusTypeName, optional Actor SourceActor)
{
    // End:0x9F
    if(((MOHAPawn(Pawn) != none) && MOHAPawn(Pawn).GetPawnBody() != none) && CCPerformerPawn(MOHAPawn(Pawn).GetPawnBody()) != none)
    {
        CCPerformerPawn(MOHAPawn(Pawn).GetPawnBody()).OnCCStimulus("MOHA_CC.Stimuli." $ StimulusTypeName, SourceActor);
    }
    //return;    
}

function SendCCStimulusByType(CCStimulusType StimulusType, optional Actor SourceActor)
{
    // End:0x8B
    if(((MOHAPawn(Pawn) != none) && MOHAPawn(Pawn).GetPawnBody() != none) && CCPerformerPawn(MOHAPawn(Pawn).GetPawnBody()) != none)
    {
        CCPerformerPawn(MOHAPawn(Pawn).GetPawnBody()).OnCCStimulusByType(StimulusType, SourceActor);
    }
    //return;    
}

function bool ShouldTakeScreenshotsForDebug()
{
    return false;
    //return ReturnValue;    
}

event NavoirInterrupted(Vector vFallBackPos)
{
    local MOHAAIPawn maip;

    maip = MOHAAIPawn(Pawn);
    // End:0x1D
    if(maip == none)
    {
        return;
    }
    SetNextFixedFireOIRData(vFallBackPos, 'Aim');
    //return;    
}

defaultproperties
{
    AiLod_IsAwake=true
    AiLod_IsClose=true
    AiLod_IsMid=true
    AiLod_RenderedRecently=true
    AiLod_IsLong=true
    bUsesCover=true
    // Reference: StimulusComponent'Default__MOHAAIController.Stimulus0'
    begin object name=Stimulus0 class=Class'EAKynapse.StimulusComponent'
    end object
    Stimulus=Stimulus0
    MinPlayerProximityTime=5.0000000
    MaxPlayerProximityTime=7.0000000
    fRotationPIDMin=0.8000000
    fRotationPIDMax=6.0000000
    fRotationPIDEngageRangeMin=200.0000000
    fRotationPIDEngageRangeMax=1500.0000000
    fRotationPIDStrafeDistanceMult=1000.0000000
    // Reference: KynapseEntityComponent'Default__MOHAAIController.KynapseEnt0'
    begin object name=KynapseEnt0
    end object
    KynEntityComponent=KynapseEnt0
    // Reference: AxonBrainStateStack'Default__MOHAAIController.ABSS0'
    begin object name=ABSS0 class=Class'EAKynapse.AxonBrainStateStack'
    end object
    ABSS=ABSS0
    SquadClass=Class'MOHASquad'
    // Reference: BurstFireManager'Default__MOHAAIController.BurstFireMan0'
    begin object name=BurstFireMan0
    end object
    BurstMan=BurstFireMan0
    // Reference: AccuracyManager'Default__MOHAAIController.AccuracyMan0'
    begin object name=AccuracyMan0
    end object
    AccuracyMan=AccuracyMan0
    WanderBrainStateClass=Class'CoverWanderBrainState'
    // Reference: SpriteComponent'Default__MOHAAIController.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
    Components[1]=KynapseEnt0
    Components[2]=Stimulus0
    ActorType=4
}