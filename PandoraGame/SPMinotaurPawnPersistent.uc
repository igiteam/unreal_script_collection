class SPMinotaurPawnPersistent extends SPBaseWerewolfPawnPersistent
    native
    config(Game);

struct native SPDirectMove
{
    var bool bShouldUse;
    var bool bUseDestination;
    var Vector Velocity;
    var Vector Destination;
    var float DesiredSpeed;
    var float Acceleration;

    structdefaultproperties
    {
        bShouldUse=false
        bUseDestination=false
        Velocity=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Destination=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        DesiredSpeed=0.0000000
        Acceleration=0.0000000
    }
};

var Actor m_ClubActor;
var Actor m_SavedClub;
var transient bool m_bFinishedThreatAnim;
var transient bool m_bFinishedDazedAnim;
var bool m_bClubThrowAnimDone;
var float FrontDamageMultiplier;
var float BackDamageMultiplier;
var int NoBipedalRageIndex;
var WWImpactParams chargeImpactEffect;
var SPDirectMove m_directMove;
var Actor m_clubThrowAt;
var Vector m_clubThrowAtOffset;
var name m_clubSocketName;
var transient SPBullChargeScreenScratch m_screenScratch;
var SPGameDifficultyTuneMinotaur m_MinotaurGDTuneData;

// Export USPMinotaurPawnPersistent::execAttachObject(FFrame&, void* const)
native function AttachObject(Actor pAttacher, name attachSocket, Vector pos, Rotator Rot, bool bUseCurrentLocation, bool bSoftAttach, optional name attachSocketSource);

// Export USPMinotaurPawnPersistent::execInitClub(FFrame&, void* const)
native function InitClub();

// Export USPMinotaurPawnPersistent::execBeginClubPhysics(FFrame&, void* const)
native function BeginClubPhysics();

function DBG_Msg(string Str)
{
    //return;    
}

simulated event bool CanRunInToWalls()
{
    return false;
    //return ReturnValue;    
}

event HitWall(Vector HitNormal, Actor Wall, PrimitiveComponent WallComp)
{
    local SPMinotaurAIController mcontroller;

    mcontroller = SPMinotaurAIController(Controller);
    DBG_Msg("HitWall");
    // End:0x51
    if(mcontroller != none)
    {
        mcontroller.HitWall(HitNormal, Wall, WallComp);
    }
    super(Pawn).HitWall(HitNormal, Wall, WallComp);
    //return;    
}

event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
    local SPMinotaurAIController mcontroller;

    mcontroller = SPMinotaurAIController(Controller);
    DBG_Msg("Touch");
    // End:0x56
    if(mcontroller != none)
    {
        mcontroller.Touch(Other, OtherComp, HitLocation, HitNormal);
        return;
    }
    super(Actor).Touch(Other, OtherComp, HitLocation, HitNormal);
    //return;    
}

event bool EncroachingOn(Actor Other)
{
    local SPMinotaurAIController mcontroller;

    mcontroller = SPMinotaurAIController(Controller);
    DBG_Msg("EncroachingOn");
    // End:0x4E
    if(mcontroller != none)
    {
        return mcontroller.EncroachingOn(Other);
    }
    return super(Pawn).EncroachingOn(Other);
    //return ReturnValue;    
}

event bool NotifyBumpLevel(Vector HitLocation, Vector HitNormal)
{
    local SPMinotaurAIController mcontroller;

    mcontroller = SPMinotaurAIController(Controller);
    DBG_Msg("NotifyBumpLevel");
    // End:0x55
    if(mcontroller != none)
    {
        return mcontroller.NotifyBumpLevel(HitLocation, HitNormal);
    }
    //return ReturnValue;    
}

simulated function DestroyHead()
{
    //return;    
}

function ChargeDirectlyMove(Vector Dest)
{
    m_directMove.bShouldUse = true;
    m_directMove.bUseDestination = true;
    m_directMove.Destination = Dest;
    m_directMove.Acceleration = AccelRate;
    m_directMove.DesiredSpeed = GetChargeSpeed();
    //return;    
}

function ChargeDirectlyStop(float maxDist)
{
    local float Speed;

    // End:0x17
    if(maxDist < float(1))
    {
        EndDirectMove();
    }
    Speed = VSize(m_directMove.Velocity);
    m_directMove.bShouldUse = true;
    m_directMove.bUseDestination = false;
    m_directMove.Acceleration = (Speed * Speed) / (float(2) * maxDist);
    m_directMove.DesiredSpeed = 0.0000000;
    //return;    
}

function EndDirectMove()
{
    // End:0x3A
    if(m_directMove.bShouldUse)
    {
        Velocity = vect(0.0000000, 0.0000000, 0.0000000);
        Acceleration = vect(0.0000000, 0.0000000, 0.0000000);
    }
    m_directMove.bShouldUse = false;
    m_directMove.bUseDestination = false;
    //return;    
}

function Vector DirectMoveVelocity()
{
    // End:0x28
    if(m_directMove.bShouldUse)
    {
        return m_directMove.Velocity;        
    }
    else
    {
        return Velocity;
    }
    //return ReturnValue;    
}

function StartDirectMove()
{
    m_directMove.bShouldUse = true;
    m_directMove.bUseDestination = false;
    m_directMove.Velocity = Velocity;
    m_directMove.Acceleration = AccelRate;
    m_directMove.DesiredSpeed = VSize(Velocity);
    //return;    
}

simulated event SPTuneDataPawn GetMyTuneData()
{
    return Class'SPTuneManager'.default.Data[int(Class'PandoraGameInfo'.static.GetGameDifficulty())].Minotaur;
    //return ReturnValue;    
}

simulated event SPGameDifficultyTune GetMyGDData()
{
    return Class'SPTuneManager'.default.Difficulty.MinotaurGD;
    //return ReturnValue;    
}

simulated function PreBeginPlay()
{
    m_MinotaurGDTuneData = SPGameDifficultyTuneMinotaur(GetMyGDData());
    super.PreBeginPlay();
    //return;    
}

event bool HasClub()
{
    return m_ClubActor != none;
    //return ReturnValue;    
}

function DetachClub()
{
    BeginClubPhysics();
    m_SavedClub = m_ClubActor;
    SetTimer(5.0000000, false, 'DestroySavedClub');
    m_ClubActor = none;
    //return;    
}

simulated function Tick(float DeltaTime)
{
    ServerTick_SPMinotaurPawnPersistent(DeltaTime);
    super.Tick(DeltaTime);
    //return;    
}

final k2override function ServerTick_SPMinotaurPawnPersistent(float DeltaTime)
{
    local editinline SPActorDestructComponent kDestructComponent;

    // End:0x52
    if(m_ClubActor != none)
    {
        kDestructComponent = SPActorDestructComponent(m_ClubActor.GetActorDestructComponent());
        // End:0x52
        if((kDestructComponent != none) && kDestructComponent.HitPoints <= 0)
        {
            DetachClub();
        }
    }
    //return;    
}

function OnBeginDeath()
{
    // End:0x15
    if(m_ClubActor != none)
    {
        BeginClubPhysics();
    }
    //return;    
}

simulated function SetWalkMovementType(bool biped)
{
    local SPMinotaurAIController mcontroller;

    mcontroller = SPMinotaurAIController(Controller);
    // End:0x70
    if(mcontroller != none)
    {
        // End:0x43
        if(mcontroller.IsCharging())
        {
            SetMovementType(17);
            return;            
        }
        else
        {
            // End:0x70
            if(mcontroller.UseWalk())
            {
                m_bIsBiped = true;
                SetMovementType(6);
                return;
            }
        }
    }
    super.SetWalkMovementType(biped);
    //return;    
}

function float GetChargeSpeed()
{
    return m_movementTypeInfo[7].GroundSpeed;
    //return ReturnValue;    
}

simulated function name ChargeActionTypeNodeAnimMCB(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
{
    bResetChildOut = 0;
    m_bResetAction = true;
    return 'Run';
    //return ReturnValue;    
}

simulated function name ChargeCommitActionTypeNodeAnimMCB(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
{
    Node.m_overrideBlendTime = 0.2500000;
    bResetChildOut = 0;
    return 'HeadUp';
    //return ReturnValue;    
}

k2override event ServerOnlyTakeDamage(float InDamageAmount, Controller EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    local Vector hitDirection, facing;

    hitDirection = Normal(Location - HitLocation);
    facing = Vector(Rotation);
    // End:0x48
    if((hitDirection Dot facing) < 0.0000000)
    {
        InDamageAmount *= FrontDamageMultiplier;        
    }
    else
    {
        InDamageAmount *= BackDamageMultiplier;
    }
    super.ServerOnlyTakeDamage(InDamageAmount, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
    //return;    
}

function PlayLocalizedShake(ScreenShakeStruct ShakeParams, Vector pos, float Radius)
{
    local PlayerController PC;

    // End:0x3C
    foreach LocalPlayerControllers(Class'Engine.PlayerController', PC)
    {
        PandoraPlayerController(PC).PlayLocalizedShake(ShakeParams, pos, Radius);        
    }    
    //return;    
}

function PlayImpactEffect(WWImpactParams Params, Vector pos)
{
    PlayLocalizedShake(Params.ShakeParams, pos, Params.ShakeRadius);
    //return;    
}

function PlayChargeImpactEffect(Vector pos)
{
    PlayImpactEffect(chargeImpactEffect, pos);
    //return;    
}

function bool ThrowClubFinished()
{
    return m_bClubThrowAnimDone;
    //return ReturnValue;    
}

function name BipedWalkHeadPosNodeAnimMCB(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
{
    local SPMinotaurAIController MyController;

    MyController = SPMinotaurAIController(Controller);
    // End:0x54
    if(MyController != none)
    {
        // End:0x54
        if(MyController.HeadDownToBustThroughDestructible())
        {
            Node.m_overrideBlendTime = 0.1250000;
            bResetChildOut = 0;
            return 'HeadDown';
        }
    }
    Node.m_overrideBlendTime = 0.1500000;
    bResetChildOut = 0;
    return 'HeadUp';
    //return ReturnValue;    
}

event HitByDamagePulse(const out Vector Origin, float normalizedStrength, class<DamageType> DamageType)
{
    local SPMinotaurAIController MyController;

    // End:0x14
    if(!ClassIsChildOf(DamageType, Class'SPDamageTypeAnimusPulse'))
    {
        return;
    }
    MyController = SPMinotaurAIController(Controller);
    // End:0x43
    if(MyController != none)
    {
        MyController.HitByAnimusPulse();
    }
    super(SPPawn).HitByDamagePulse(Origin, normalizedStrength, DamageType);
    //return;    
}

function ThreatAnimDone()
{
    //return;    
}

function DazedAnimDone()
{
    //return;    
}

function PrepareCharge()
{
    //return;    
}

function StartChargeRun()
{
    //return;    
}

function StartCommitedChargeRun()
{
    //return;    
}

function StartChargeBrake()
{
    //return;    
}

function StartDazed()
{
    //return;    
}

function bool IsDoneThreatning()
{
    return true;
    //return ReturnValue;    
}

function bool IsDazed()
{
    //return ReturnValue;    
}

function CancelAction()
{
    //return;    
}

function StartThrowClub(Actor throwAt, Vector Offset)
{
    m_clubThrowAt = throwAt;
    m_clubThrowAtOffset = Offset;
    // End:0x2F
    if(Health > 0)
    {
        GotoState('throwClub');
    }
    //return;    
}

function DestroySavedClub()
{
    m_SavedClub.SetHidden(true);
    m_SavedClub.Destroy();
    m_SavedClub = none;
    //return;    
}

event NotifyThrowClub()
{
    //return;    
}

simulated function float DamageAmount(SPPawn.EHSDamageValidationType DamageType)
{
    // End:0x37
    if(int(DamageType) == int(9))
    {
        return m_MinotaurGDTuneData.GetValue(m_MinotaurGDTuneData.BiteDamage);        
    }
    else
    {
        return super.DamageAmount(DamageType);
    }
    //return ReturnValue;    
}

simulated event StartFootStepEffects(FeetDown FeetDown, AnimNotify_Footstep.eFeetDownImpactStrength FeetDownImpactStrength, optional SPPhysicalMaterial DefaultPhysMat)
{
    local PlayerController PC;

    switch(FeetDownImpactStrength)
    {
        // End:0x44
        case 0:
            // End:0x40
            foreach LocalPlayerControllers(Class'Engine.PlayerController', PC)
            {
                PlayImpactEffect(m_MinotaurGDTuneData.LowFootstepEffects, Location);                
            }            
            // End:0xBD
            break;
        // End:0x7F
        case 1:
            // End:0x7B
            foreach LocalPlayerControllers(Class'Engine.PlayerController', PC)
            {
                PlayImpactEffect(m_MinotaurGDTuneData.MediumFootstepEffects, Location);                
            }            
            // End:0xBD
            break;
        // End:0xBA
        case 2:
            // End:0xB6
            foreach LocalPlayerControllers(Class'Engine.PlayerController', PC)
            {
                PlayImpactEffect(m_MinotaurGDTuneData.HighFootstepEffects, Location);                
            }            
            // End:0xBD
            break;
        // End:0xFFFF
        default:
            break;
    }
    super(SPPawn).StartFootStepEffects(FeetDown, FeetDownImpactStrength, DefaultPhysMat);
    //return;    
}

simulated function InitDamage()
{
    InitDynDamageSystem(64.0000000);
    //return;    
}

auto state defaultAction
{
    function CancelAction()
    {
        // End:0x19
        if(Health > 0)
        {
            GotoState('defaultAction');
        }
        SetAnimActionState(0, true);
        SetAnimUpperBodyState(0, true);
        SetAnimMeleeDodgeState(0, true);
        //return;        
    }

    function PrepareCharge()
    {
        // End:0x19
        if(Health > 0)
        {
            GotoState('prepCharge');
        }
        //return;        
    }

    function StartChargeRun()
    {
        // End:0x19
        if(Health > 0)
        {
            GotoState('chargeRun');
        }
        //return;        
    }

    function StartCommitedChargeRun()
    {
        // End:0x19
        if(Health > 0)
        {
            GotoState('chargeCommitedRun');
        }
        //return;        
    }

    function StartChargeBrake()
    {
        // End:0x19
        if(Health > 0)
        {
            GotoState('chargeBrake');
        }
        //return;        
    }

    function StartDazed()
    {
        // End:0x19
        if(Health > 0)
        {
            GotoState('initDazed');
        }
        //return;        
    }
Begin:

    m_bFinishedThreatAnim = false;
    J0x08:

    // End:0x17 [Loop If]
    if(true)
    {
        Sleep(0.2000000);
        // [Loop Continue]
        goto J0x08;
    }
    stop;                    
}

state throwClub extends defaultAction
{
    function BeginState(name PreviousStateName)
    {
        // End:0x1B
        if((HasClub()) == false)
        {
            m_bClubThrowAnimDone = true;            
        }
        else
        {
            m_bClubThrowAnimDone = false;
        }
        SetAnimActionState(63, true);
        SetTimer(8.0000000, false, 'ExitAnyway');
        //return;        
    }

    function EndState(name NextStateName)
    {
        ClearTimer('ExitAnyway');
        //return;        
    }

    event PausedState()
    {
        ClearTimer('ExitAnyway');
        //return;        
    }

    function ContinuedState()
    {
        SetTimer(8.0000000, false, 'ExitAnyway');
        //return;        
    }

    function ExitAnyway()
    {
        ThrowClubAtEnemy();
        m_bClubThrowAnimDone = true;
        ClearTimer('ExitAnyway');
        //return;        
    }

    event NotifyThrowClub()
    {
        ThrowClubAtEnemy();
        ClearTimer('ExitAnyway');
        SetTimer(1.0000000, false, 'ExitAnyway');
        //return;        
    }

    function ThrowClubAtEnemy()
    {
        local int NumSolutions;
        local Vector InitVelocity1, InitVelocity2;
        local float FlightTime1, FlightTime2;
        local Vector clubStartPos;
        local Rotator clubRotation;
        local Actor club;
        local Vector impulseOffset, Impulse;
        local editinline SkeletalMeshComponent clubMesh;
        local Box BoundingBox;
        local Vector TargetLocation;
        local float clubSpeed;
        local Vector TargetVelocity;
        local SPPawn SPPawn;

        // End:0x12
        if((HasClub()) == false)
        {
            return;
        }
        clubSpeed = 5000.0000000;
        // End:0x5A
        if((Mesh == none) || Mesh.GetSocketWorldLocationAndRotation(m_clubSocketName, clubStartPos, clubRotation) == false)
        {
            clubStartPos = Location;
        }
        // End:0x150
        if(m_clubThrowAt != none)
        {
            TargetLocation = m_clubThrowAt.Location + m_clubThrowAtOffset;
            NumSolutions = CalcTrajInitVelGivenSpeed(clubStartPos, TargetLocation, -9.8000000 * float(100), clubSpeed, InitVelocity1, FlightTime1, InitVelocity2, FlightTime2);
            // End:0x14D
            if(NumSolutions > 0)
            {
                // End:0xEB
                if(NumSolutions > 1)
                {
                    // End:0xEB
                    if(FlightTime2 < FlightTime1)
                    {
                        FlightTime1 = FlightTime2;
                    }
                }
                SPPawn = SPPawn(m_clubThrowAt);
                // End:0x11E
                if(SPPawn != none)
                {
                    TargetVelocity = SPPawn.m_amortizedVelocity;                    
                }
                else
                {
                    TargetVelocity = m_clubThrowAt.Velocity;
                }
                TargetLocation += ((FlightTime1 * TargetVelocity) * 0.7000000);
            }            
        }
        else
        {
            TargetLocation = m_clubThrowAtOffset;
        }
        NumSolutions = CalcTrajInitVelGivenSpeed(clubStartPos, TargetLocation, -9.8000000 * float(100), clubSpeed, InitVelocity1, FlightTime1, InitVelocity2, FlightTime2);
        club = m_ClubActor;
        // End:0x1D6
        if(NumSolutions > 1)
        {
            // End:0x1C8
            if(FlightTime1 < FlightTime2)
            {
                Impulse = InitVelocity1;                
            }
            else
            {
                Impulse = InitVelocity2;
            }            
        }
        else
        {
            // End:0x1EF
            if(NumSolutions > 0)
            {
                Impulse = InitVelocity1;                
            }
            else
            {
                Impulse = Normal(TargetLocation - Location);
                // End:0x230
                if((Impulse Dot Vector(Rotation)) > 0.7070000)
                {
                    Impulse = Impulse * clubSpeed;                    
                }
                else
                {
                    Impulse = Vector(Rotation) * clubSpeed;
                }
            }
        }
        club.Acceleration = vect(0.0000000, 0.0000000, 0.0000000);
        DetachClub();
        clubMesh = club.GetSkeletalMeshComponent();
        club.GetComponentsBoundingBox(BoundingBox);
        impulseOffset.X = RandRange(BoundingBox.Min.X, BoundingBox.Max.X);
        impulseOffset.Y = RandRange(BoundingBox.Min.Y, BoundingBox.Max.Y);
        impulseOffset.Z = RandRange(BoundingBox.Min.Z, BoundingBox.Max.Z);
        clubMesh.AddImpulse(Impulse, impulseOffset * float(100),, true, 10.0000000, 50.0000000, self);
        //return;        
    }

    simulated function ActionFinished()
    {
        // End:0x24
        if(int(GetActionState()) == int(63))
        {
            ClearAction();
            m_bClubThrowAnimDone = true;
        }
        //return;        
    }
Begin:

    Sleep(0.0100000);
    J0x08:

    // End:0x2F [Loop If]
    if((int(GetActionState()) == int(63)) && m_bClubThrowAnimDone)
    {
        Sleep(0.0100000);
        // [Loop Continue]
        goto J0x08;
    }
    stop;                    
}

state Charge extends defaultAction
{    stop;    
}

state prepCharge extends Charge
{
    function BeginState(name PreviousStateName)
    {
        m_bFinishedThreatAnim = false;
        //return;        
    }

    function EndState(name PreviousStateName)
    {
        m_bFinishedThreatAnim = false;
        CancelAction();
        //return;        
    }

    function bool IsDoneThreatning()
    {
        return m_bFinishedThreatAnim;
        //return ReturnValue;        
    }
Begin:

    // End:0x2E
    if(Health > 0)
    {
        Velocity = vect(0.0000000, 0.0000000, 0.0000000);
        PushState('chargeThreaten');
    }
    J0x2E:

    // End:0x3D [Loop If]
    if(true)
    {
        Sleep(0.2000000);
        // [Loop Continue]
        goto J0x2E;
    }
    stop;            
}

state chargeThreaten extends Charge
{
    function ThreatAnimDone()
    {
        m_bFinishedThreatAnim = true;
        // End:0x1A
        if(Health > 0)
        {
            PopState();
        }
        //return;        
    }

    function PushedState()
    {
        Velocity = vect(0.0000000, 0.0000000, 0.0000000);
        SetTimer(RandRange(0.2500000, 1.0000000), false, 'ThreatAnimDone');
        //return;        
    }

    function PoppedState()
    {
        ClearTimer('ThreatAnimDone');
        //return;        
    }

    simulated function name ChargeActionTypeNodeAnimMCB(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
    {
        Node.m_overrideBlendTime = 0.2500000;
        bResetChildOut = 0;
        return 'Threaten';
        //return ReturnValue;        
    }
    J0x00:
    // End:0x0F [Loop If]
    if(true)
    {
        Sleep(0.2000000);
        // [Loop Continue]
        goto J0x00;
    }
    stop;                    
}

state chargeRun extends Charge
{
    simulated function name ChargeActionTypeNodeAnimMCB(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
    {
        Node.m_overrideBlendTime = 0.2500000;
        bResetChildOut = 0;
        return 'Run';
        //return ReturnValue;        
    }
Begin:

    m_bFinishedThreatAnim = false;
    // End:0x23
    if(Health > 0)
    {
        PushState('chargeThreaten');
    }
    m_bFinishedThreatAnim = true;
    J0x2B:

    // End:0x3A [Loop If]
    if(true)
    {
        Sleep(0.2000000);
        // [Loop Continue]
        goto J0x2B;
    }
    stop;        
}

state chargeCommitedRun extends chargeRun
{
    simulated function name ChargeCommitActionTypeNodeAnimMCB(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
    {
        Node.m_overrideBlendTime = 0.2000000;
        bResetChildOut = 0;
        return 'HeadDown';
        //return ReturnValue;        
    }

    simulated event bool CanRunInToWalls()
    {
        return true;
        //return ReturnValue;        
    }
    J0x00:
    // End:0x0F [Loop If]
    if(true)
    {
        Sleep(0.2000000);
        // [Loop Continue]
        goto J0x00;
    }
    stop;                    
}

state chargeBrake extends Charge
{
    simulated function name ChargeCommitActionTypeNodeAnimMCB(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
    {
        Node.m_overrideBlendTime = 0.2500000;
        bResetChildOut = 0;
        return 'HeadUp';
        //return ReturnValue;        
    }

    simulated function name ChargeRunAnimMCB(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
    {
        Node.m_overrideBlendTime = 0.2500000;
        bResetChildOut = 0;
        return 'Brake';
        //return ReturnValue;        
    }
    J0x00:
    // End:0x0F [Loop If]
    if(true)
    {
        Sleep(0.2000000);
        // [Loop Continue]
        goto J0x00;
    }
    stop;                    
}

state initDazed extends defaultAction
{
    function BeginState(name PreviousStateName)
    {
        m_bFinishedDazedAnim = false;
        SetAnimActionState(62, true);
        //return;        
    }

    function EndState(name PreviousStateName)
    {
        m_bFinishedDazedAnim = false;
        //return;        
    }

    function bool IsDazed()
    {
        return !m_bFinishedDazedAnim;
        //return ReturnValue;        
    }
Begin:

    // End:0x1B
    if(Health > 0)
    {
        PushState('dazed');
    }
    J0x1B:

    // End:0x2A [Loop If]
    if(true)
    {
        Sleep(0.2000000);
        // [Loop Continue]
        goto J0x1B;
    }
    stop;        
}

state dazed extends initDazed
{
    function PushedState()
    {
        SetTimer(RandRange(1.5000000, 2.0000000), false, 'DazedAnimDone');
        //return;        
    }

    function PoppedState()
    {
        ClearTimer('DazedAnimDone');
        //return;        
    }

    function DazedAnimDone()
    {
        m_bFinishedDazedAnim = true;
        // End:0x20
        if(float(Health) > 0.0000000)
        {
            PopState();
        }
        //return;        
    }

    simulated function name ChargeActionTypeNodeAnimMCB(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
    {
        Node.m_overrideBlendTime = 0.2500000;
        bResetChildOut = 0;
        return 'dazed';
        //return ReturnValue;        
    }
    J0x00:
    // End:0x0F [Loop If]
    if(true)
    {
        Sleep(0.2000000);
        // [Loop Continue]
        goto J0x00;
    }
    stop;                    
}
