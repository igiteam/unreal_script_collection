class SPGorgonPawnPersistent extends SPPawn
    native
    config(Game);

enum eGorgonLiveStatus
{
    eGS_Alive,                      // 0
    eGS_Dying,                      // 1
    eGS_MAX                         // 2
};

enum eCurrentAction
{
    eAction_None,                   // 0
    eAction_JavelinAttack,          // 1
    eAction_BloodTickAttack,        // 2
    eAction_MAX                     // 3
};

struct native JavelinAnimTreeNotifies
{
    var bool ArmFinished;
    var bool AimFinished;
    var bool ThrowFinished;
    var bool DisarmFinished;

    structdefaultproperties
    {
        ArmFinished=false
        AimFinished=false
        ThrowFinished=false
        DisarmFinished=false
    }
};

struct native BloodTickAnimTreeNotifies
{
    var bool SlashFinished;

    structdefaultproperties
    {
        SlashFinished=false
    }
};

struct native AnimTreeEvents
{
    var JavelinAnimTreeNotifies Javelin;
    var BloodTickAnimTreeNotifies BloodTick;
    var bool DeathFinished;

    structdefaultproperties
    {
        Javelin=(ArmFinished=false,AimFinished=false,ThrowFinished=false,DisarmFinished=false)
        BloodTick=(SlashFinished=false)
        DeathFinished=false
    }
};

/** VARIABLE DECLARATIONS */
var(Squad) SPTeamInfoCreature.eSPSquad_Creature SquadAssignment;
var SPGorgonPawnPersistent.eGorgonLiveStatus eLiveStatus;
var SPGorgonPawnPersistent.eCurrentAction CurrentAction;
var SPGorgonPawnPersistent.eCurrentAction DesiredAction;
var AnimTreeEvents AnimEvents;
var SPJavelinPersistent AttachedJavelin;
var Actor targetActor;
var int BloodTickCount;
var class<Projectile> JavelinProjectileClass;

// Export USPGorgonPawnPersistent::execSocketNameToBoneName(FFrame&, void* const)
native function name SocketNameToBoneName(SkeletalMeshComponent smesh, name SName);

simulated function Tick(float DeltaTime)
{
    //return;    
}

function int GetSquadNameIndex()
{
    local int squadNameIdx;

    squadNameIdx = int(SquadAssignment);
    return squadNameIdx;
    //return ReturnValue;    
}

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
    SetMovementType(2);
    SetMovementPhysics();
    ClearAnimEvents();
    //return;    
}

k2override event ServerOnlyTakeDamage(float DamageAmount, Controller EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    // End:0x13
    if(DamageType == Class'SPDamageTypeBloodTickExplosion')
    {
        return;
    }
    super.ServerOnlyTakeDamage(DamageAmount, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
    //return;    
}

function AnimTreeEventDeathFinished()
{
    AnimEvents.DeathFinished = true;
    //return;    
}

function ClearAnimEvents()
{
    AnimEvents.DeathFinished = false;
    ClearJavelinAnimEvents();
    ClearBloodTickAnimEvents();
    //return;    
}

simulated function name LiveOrDeadMCB(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
{
    switch(eLiveStatus)
    {
        // End:0x1A
        case 1:
            return 'Dead';
            // End:0x2A
            break;
        // End:0xFFFF
        default:
            return 'Live';
            break;
    }    
    // Failed to format nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x02A
    //return ReturnValue;
    // Failed to format nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x02A    
    // Failed to format nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x02A
    // Failed to format remaining nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x02A
}

simulated function name UpperbodyMCB(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
{
    return 'Nothing';
    //return ReturnValue;    
}

function Disarm()
{
    DesiredAction = 0;
    //return;    
}

function ClearJavelinAnimEvents()
{
    AnimEvents.Javelin.ArmFinished = false;
    AnimEvents.Javelin.AimFinished = false;
    AnimEvents.Javelin.ThrowFinished = false;
    AnimEvents.Javelin.DisarmFinished = false;
    //return;    
}

event JavelinArmFinished()
{
    AnimEvents.Javelin.ArmFinished = true;
    //return;    
}

event JavelinDisarmFinished()
{
    AnimEvents.Javelin.DisarmFinished = true;
    //return;    
}

event JavelinAimFinished()
{
    AnimEvents.Javelin.AimFinished = true;
    //return;    
}

event JavelinThrowFinished()
{
    AnimEvents.Javelin.ThrowFinished = true;
    //return;    
}

event AttachJavelin()
{
    CreateInHandJavelin();
    //return;    
}

event DisarmJavelin()
{
    DestroyInHandJavelin();
    //return;    
}

event ThrowJavelin()
{
    LaunchInHandJavelin();
    //return;    
}

simulated function name JavelinAttackMCB(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
{
    return 'Nothing';
    //return ReturnValue;    
}

function GetRightHandAttachInfo(out Vector SocketLocation, out Rotator SocketRotation)
{
    local bool HavePosition;
    local editinline SkeletalMeshComponent SkelMesh;

    SkelMesh = GetSkeletalMeshComponent();
    HavePosition = SkelMesh.GetSocketWorldLocationAndRotation('JavelinAttachRight', SocketLocation, SocketRotation);
    // End:0x5A
    if(!HavePosition)
    {
        SocketLocation = Location;
        SocketRotation = Rotation;        
    }
    //return;    
}

function AttachJavelinToRightHand()
{
    local editinline SkeletalMeshComponent SkelMesh;
    local name BoneName;

    SkelMesh = GetSkeletalMeshComponent();
    // End:0x59
    if(SkelMesh != none)
    {
        BoneName = SocketNameToBoneName(SkelMesh, 'JavelinAttachRight');
        AttachedJavelin.SetBase(self,, SkelMesh, BoneName, true);        
    }
    //return;    
}

function DetachJavelin()
{
    AttachedJavelin.SetBase(none);
    AttachedJavelin.SetPhysics(2);
    //return;    
}

function CreateInHandJavelin()
{
    local Vector SocketLocation;
    local Rotator SocketRotation;

    GetRightHandAttachInfo(SocketLocation, SocketRotation);
    AttachedJavelin = SPJavelinPersistent(Spawn(JavelinProjectileClass,,, SocketLocation, SocketRotation));
    AttachedJavelin.SetPhysics(0);
    AttachJavelinToRightHand();
    //return;    
}

function DestroyInHandJavelin()
{
    DetachJavelin();
    AttachedJavelin.Destroy();
    AttachedJavelin = none;
    //return;    
}

function LaunchInHandJavelin()
{
    DetachJavelin();
    AttachedJavelin.firedBy = self;
    AttachedJavelin.SetTargetActor(targetActor);
    AttachedJavelin.SetPhysics(6);
    //return;    
}

function ArmJavelin()
{
    DesiredAction = 1;
    //return;    
}

function bool IsJavelinReady()
{
    return false;
    //return ReturnValue;    
}

function FireJavelin(Actor NewTarget)
{
    // End:0x31
    if((IsJavelinReady()) == true)
    {
        targetActor = NewTarget;
        GotoState('Javelin_Fire', 'Begin', true, false);
    }
    //return;    
}

function ClearBloodTickAnimEvents()
{
    AnimEvents.BloodTick.SlashFinished = false;
    //return;    
}

simulated function name BloodTickAttackMCB(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
{
    return 'Slash';
    //return ReturnValue;    
}

function bool IsBloodTickReady()
{
    return false;
    //return ReturnValue;    
}

function ArmBloodTicks()
{
    DesiredAction = 2;
    //return;    
}

function BloodTickSlashFinished()
{
    AnimEvents.BloodTick.SlashFinished = true;
    //return;    
}

function AnimNotifyBloodTickSpawn()
{
    //return;    
}

function FireBloodTicks(Actor NewTarget, int Count)
{
    //return;    
}

state GorgonPawnState
{
    function BeginState(name PreviousStateName)
    {
        //return;        
    }

    event PushedState()
    {
        //return;        
    }

    function ContinuedState()
    {
        //return;        
    }

    event PoppedState()
    {
        //return;        
    }

    function EndState(name NextStateName)
    {
        //return;        
    }
    stop;    
}

auto state Action extends GorgonPawnState
{
    simulated function float MovementActionPCB(SPAnimGenericPartialNode Node, array<float> childWeights, int NumChildren, out int bResetChildOut)
    {
        childWeights[1] = 0.0000000;
        return 1.0000000;
        //return ReturnValue;        
    }

    simulated function name UpperbodyMCB(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
    {
        return 'Nothing';
        //return ReturnValue;        
    }

    simulated function name JavelinAttackMCB(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
    {
        return 'Nothing';
        //return ReturnValue;        
    }

    function SelectAction()
    {
        switch(DesiredAction)
        {
            // End:0x26
            case 1:
                GotoState('Javelin_Arm', 'Begin', true, false);
                // End:0x47
                break;
            // End:0x41
            case 2:
                GotoState('BloodTick_Attack', 'Begin', true, false);
            // End:0xFFFF
            default:
                // End:0x47
                break;
                break;
        }
        //return;        
    }
    J0x00:
    // End:0x19 [Loop If]
    if(true)
    {
        Sleep(0.1250000);
        SelectAction();
        // [Loop Continue]
        goto J0x00;
    }
    stop;            
}

state Javelin_Attack extends Action
{
    function BeginState(name PreviousStateName)
    {
        ClearJavelinAnimEvents();
        //return;        
    }

    simulated function name UpperbodyMCB(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
    {
        return 'Javelin_Attack';
        //return ReturnValue;        
    }

    simulated function float MovementActionPCB(SPAnimGenericPartialNode Node, array<float> childWeights, int NumChildren, out int bResetChildOut)
    {
        childWeights[1] = 1.0000000;
        return 1.0000000;
        //return ReturnValue;        
    }

    function EndState(name NextStateName)
    {
        ClearJavelinAnimEvents();
        //return;        
    }
    stop;    
}

state Javelin_Arm extends Javelin_Attack
{
    function BeginState(name PreviousStateName)
    {
        //return;        
    }

    simulated function name JavelinAttackMCB(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
    {
        return 'Arm';
        //return ReturnValue;        
    }
    J0x00:
    // End:0x2D [Loop If]
    if(AnimEvents.Javelin.ArmFinished == false)
    {
        Sleep(0.0100000);
        // [Loop Continue]
        goto J0x00;
    }
    // End:0x56
    if(int(DesiredAction) == int(1))
    {
        GotoState('Javelin_Aim', 'Begin', true, false);        
    }
    else
    {
        GotoState('Javelin_Disarm', 'Begin', true, false);
    }
    stop;                
}

state Javelin_Aim extends Javelin_Attack
{
    function BeginState(name PreviousStateName)
    {
        //return;        
    }

    simulated function name JavelinAttackMCB(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
    {
        return 'Aim';
        //return ReturnValue;        
    }

    function bool IsJavelinReady()
    {
        // End:0x27
        if(AnimEvents.Javelin.AimFinished == true)
        {
            return true;            
        }
        else
        {
            return false;
        }
        //return ReturnValue;        
    }
    J0x00:
    // End:0x2D [Loop If]
    if(AnimEvents.Javelin.AimFinished == false)
    {
        Sleep(0.0100000);
        // [Loop Continue]
        goto J0x00;
    }
    J0x2D:

    // End:0x62 [Loop If]
    if(true)
    {
        // End:0x57
        if(int(DesiredAction) != int(1))
        {
            GotoState('Javelin_Disarm', 'Begin', true, false);
        }
        Sleep(0.0100000);
        // [Loop Continue]
        goto J0x2D;
    }
    stop;        
}

state Javelin_Disarm extends Javelin_Attack
{
    simulated function name JavelinAttackMCB(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
    {
        return 'Disarm';
        //return ReturnValue;        
    }
    J0x00:
    // End:0x2D [Loop If]
    if(AnimEvents.Javelin.DisarmFinished == false)
    {
        Sleep(0.0100000);
        // [Loop Continue]
        goto J0x00;
    }
    GotoState('Action', 'Begin', true, false);
    stop;                    
}

state Javelin_Fire extends Javelin_Attack
{
    simulated function name JavelinAttackMCB(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
    {
        return 'Throw';
        //return ReturnValue;        
    }
    J0x00:
    // End:0x2D [Loop If]
    if(AnimEvents.Javelin.ThrowFinished == false)
    {
        Sleep(0.0100000);
        // [Loop Continue]
        goto J0x00;
    }
    // End:0x45
    if(int(DesiredAction) == int(1))
    {
        DesiredAction = 0;
    }
    GotoState('Action', 'Begin', true, false);
    stop;                    
}

state BloodTick_Attack
{
    function EndState(name NextStateName)
    {
        ClearBloodTickAnimEvents();
        //return;        
    }

    simulated function float MovementActionPCB(SPAnimGenericPartialNode Node, array<float> childWeights, int NumChildren, out int bResetChildOut)
    {
        childWeights[1] = 1.0000000;
        return 1.0000000;
        //return ReturnValue;        
    }

    simulated function name UpperbodyMCB(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
    {
        return 'Nothing';
        //return ReturnValue;        
    }

    function bool IsBloodTickReady()
    {
        return true;
        //return ReturnValue;        
    }

    function FireBloodTicks(Actor NewTarget, int Count)
    {
        targetActor = NewTarget;
        BloodTickCount = Count;
        GotoState('BloodTick_Fire', 'Begin', true, false);
        //return;        
    }
    J0x00:
    // End:0x1B [Loop If]
    if(int(DesiredAction) == int(2))
    {
        Sleep(0.0100000);
        // [Loop Continue]
        goto J0x00;
    }
    GotoState('Action', 'Begin', true, false);
    stop;            
}

state BloodTick_Fire extends BloodTick_Attack
{
    function AnimNotifyBloodTickSpawn()
    {
        // End:0x24
        if(BloodTickCount > 0)
        {
            SpawnTicks(Pawn(targetActor), BloodTickCount);
        }
        //return;        
    }

    simulated function name UpperbodyMCB(SPAnimGenericFunctionMonitorNode Node, out int bResetChildOut)
    {
        return 'BloodTick_Attack';
        //return ReturnValue;        
    }

    function SpawnTicks(Pawn Enemy, int NumTicks)
    {
        local SPBloodTickManager Manager;
        local BTSpawnInfo SpawnInfo;
        local int Available;
        local float Angle, angleMax, angleStep;
        local int I;
        local Vector Offset, AxisX, AxisY, AxisZ;

        Manager = Class'SPBloodTickManager'.static.Get(self);
        Available = Manager.AvailableForSpawn();
        // End:0x4B
        if(NumTicks > Available)
        {
            NumTicks = Available;
        }
        Angle = -2.3561940;
        angleMax = 2.3561940;
        angleStep = (angleMax - Angle) / float(NumTicks);
        GetAxes(Rotation, AxisX, AxisY, AxisZ);
        I = 0;
        J0x99:

        // End:0x224 [Loop If]
        if(I < NumTicks)
        {
            Offset.X = (AxisX.X * Cos(Angle)) - (AxisX.Y * Sin(Angle));
            Offset.Y = (AxisX.X * Sin(Angle)) + (AxisX.Y * Cos(Angle));
            Offset.Z = 0.0000000;
            Offset = Offset * 150.0000000;
            Offset.Z = -64.0000000;
            SpawnInfo.Location = Location + Offset;
            SpawnInfo.Rotation = Rotation;
            SpawnInfo.PreferredEnemy = Enemy;
            SpawnInfo.delay = (float(I) * 0.2500000) + (FRand() * 0.2500000);
            SpawnInfo.Owner = self;
            Manager.RequestSpawn(SpawnInfo);
            Angle += angleStep;
            ++I;
            // [Loop Continue]
            goto J0x99;
        }
        //return;        
    }
    J0x00:
    // End:0x2C [Loop If]
    if(!AnimEvents.BloodTick.SlashFinished)
    {
        Sleep(0.0100000);
        // [Loop Continue]
        goto J0x00;
    }
    GotoState('BloodTick_Attack', 'Begin', true, false);
    stop;        
}

state Dying
{
    function BeginState(name PreviousStateName)
    {
        DetachJavelin();
        //return;        
    }

    event PushedState()
    {
        super(Object).PushedState();
        //return;        
    }

    function ContinuedState()
    {
        //return;        
    }

    event PoppedState()
    {
        super.PoppedState();
        //return;        
    }

    function EndState(name NextStateName)
    {
        super.EndState(NextStateName);
        //return;        
    }

    k2override event ServerOnlyTakeDamage(float DamageAmount, Controller EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
    {
        // End:0x13
        if(DamageType == Class'SPDamageTypeBloodTickExplosion')
        {
            return;
        }
        // End:0xDB
        if(int(Physics) != int(10))
        {
            SetPhysics(2);
            // End:0x6B
            if((int(Physics) == int(0)) && Momentum.Z < float(0))
            {
                Momentum.Z *= float(-1);
            }
            Velocity += ((float(3) * Momentum) / (Mass + float(200)));
            // End:0xA0
            if(DamageType == none)
            {
                DamageType = Class'Engine.DamageType';
            }
            DamageAmount = float(FloatingPointAdjustDamage(DamageAmount));
            DamageAmount *= DamageType.default.GibModifier;
            Health -= int(DamageAmount);
        }
        //return;        
    }

    simulated function SetMovementPhysics()
    {
        // End:0x16
        if(int(Physics) != int(10))
        {
            super(SPPawn).SetMovementPhysics();
        }
        //return;        
    }

    function StartDying()
    {
        local SPGorgonAIController MyController;

        // End:0x33
        if(bTearOff && int(WorldInfo.NetMode) == int(NM_DedicatedServer))
        {
            LifeSpan = 2.0000000;            
        }
        else
        {
            SetTimer(5.0000000, false);
        }
        SetCollision(true, false);
        MyController = SPGorgonAIController(Controller);
        // End:0x76
        if(MyController != none)
        {
            MyController.NotifyDying();            
        }
        else
        {
            // End:0xAF
            if(Controller != none)
            {
                // End:0xA2
                if(Controller.bIsPlayer)
                {
                    DetachFromController();                    
                }
                else
                {
                    Controller.Destroy();
                }
            }
        }
        //return;        
    }

    function EndDying()
    {
        local int I;
        local SPGorgonAIController MyController;

        MyController = SPGorgonAIController(Controller);
        // End:0x5D
        if(MyController != none)
        {
            MyController.NotifyDied();
            // End:0x50
            if(Controller.bIsPlayer)
            {
                DetachFromController();                
            }
            else
            {
                Controller.Destroy();
            }
        }
        I = 0;
        J0x64:

        // End:0xA9 [Loop If]
        if(I < Attached.Length)
        {
            // End:0x9F
            if(Attached[I] != none)
            {
                Attached[I].PawnBaseDied();
            }
            I++;
            // [Loop Continue]
            goto J0x64;
        }
        //return;        
    }

    function bool IsRagdollDeath()
    {
        return false;
        //return ReturnValue;        
    }
Begin:

    StartDying();
    Sleep(0.1000000);
    // End:0x53
    if((IsRagdollDeath()) == false)
    {
        eLiveStatus = 1;
        Sleep(0.0010000);
        J0x32:

        // End:0x53 [Loop If]
        if(!AnimEvents.DeathFinished)
        {
            Sleep(0.1000000);
            // [Loop Continue]
            goto J0x32;
        }
    }
    // End:0x68
    if(int(Physics) != int(10))
    {
        SetPhysics(2);
    }
    SetNovodexBoundingVolume(false);
    m_bEnablePhysicsPushing = false;
    AttemptPhysAnimState_Ragdoll(true);
    EndDying();
    // End:0xA6
    if((IsRagdollDeath()) == true)
    {
        SetDyingImpulse();
    }
    stop;        
}
