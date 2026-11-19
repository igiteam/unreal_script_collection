class SkyPawn_Archon extends SkyPawn_Boss
    native
    config(Game);

enum EStumbleState
{
    Stumble_None,                   // 0
    Stumble_Begin,                  // 1
    Stumble_Loop,                   // 2
    Stumble_Recover,                // 3
    Stumble_Max                     // 4
};

enum EStumbleType
{
    StumbleType_Front,              // 0
    StumbleType_LeftLeg,            // 1
    StumbleType_RightLeg,           // 2
    StumbleType_BothLegs,           // 3
    StumbleType_AllLegs,            // 4
    StumbleType_MAX                 // 5
};

enum EJumpState
{
    Jump_None,                      // 0
    Jump_Horizontal,                // 1
    Jump_Vertical,                  // 2
    Jump_MAX                        // 3
};

enum EVerticalTransition
{
    VerticalTransition_None,        // 0
    VerticalTransition_GroundToWallConvex,// 1
    VerticalTransition_GroundToWallConcave,// 2
    VerticalTransition_WallToGroundConvex,// 3
    VerticalTransition_WallToGroundConcave,// 4
    VerticalTransition_MAX          // 5
};

struct native SMachineGun
{
    var() SkyWeaponMounted Archetype;
    var() name Socket;
    var() bool bMirror;
    var() name ValidGripId;
    var SkyWeaponMounted Weapon;

    structdefaultproperties
    {
        Archetype=none
        Socket="None"
        bMirror=false
        ValidGripId="None"
        Weapon=none
    }
};

var(Weapon) array<SMachineGun> MachineGuns;
var(Sounds) editconst export editinline AudioComponent TurbineSound;
var transient int CurrentMGFireIndex;
var(FootDamage) float FootstepDamageRadius;
var(FootDamage) float FootstepDamageAmount;
var(FootDamage) class<DamageType> FootstepDamageType;
var(Movement) float MinTurnAngle;
var(Movement) float MaxTurnAngle;
var(Movement) float MinTurnSpeed;
var(Movement) float PathAlignDotMin;
var transient float MinTurnAngleCos;
var transient float MaxTurnAngleCos;
var() InteractionAnimInfo StumbleAnim;
var transient bool bBeganGripped;
var() name NoseCannonGripPointId;
var transient SkyPawn_Archon.EStumbleState StumbleState;
var transient SkyPawn_Archon.EStumbleType StumbleType;
var transient SkyPawn_Archon.EJumpState JumpState;
var transient SkyPawn_Archon.EVerticalTransition VerticalTransitionState;
var() float StumbleTime;
var() float BeamRegenTime;
var() float DeathDelayTime;
var transient Actor TransitionGoalActor;
var transient Rotator CurrentPawnOrientation;
var transient float CurrentDirectionAngle;
var transient SkyVehicle PlayerVehicle;
var transient Vector PlayerVehicleLocPrev;
var transient Vector PlayerVehicleLocCurr;
var() name FlyUnderCheckBoneName;
var() name FlyUnderCheckFrontRightBoneName;
var() name FlyUnderCheckFrontLeftBoneName;
var() name FlyUnderCheckBackRightBoneName;
var() name FlyUnderCheckBackLeftBoneName;
var() float FlyUnderCheckRadius;

// Export USkyPawn_Archon::execIsVerticalTransitioning(FFrame&, void* const)
native final function bool IsVerticalTransitioning();

// Export USkyPawn_Archon::execIsJumping(FFrame&, void* const)
native final function bool IsJumping();

event Landed(Vector HitNormal, Actor FloorActor)
{
    // End:0x28
    if(int(JumpState) == int(1))
    {
        JumpState = 0;
        super(SkyPawn).Landed(HitNormal, FloorActor);
    }
    //return;    
}

// Export USkyPawn_Archon::execNoseCannonHasBeenDestroyed(FFrame&, void* const)
native function bool NoseCannonHasBeenDestroyed();

event DestroyNoseCannon()
{
    local SkyWeaponBase W;

    W = SkyWeaponBase(Weapon);
    // End:0x2F
    if(W != none)
    {
        W.DisableWeapon();
    }
    //return;    
}

event BeginStumble(SkyPawn_Archon.EStumbleType Type)
{
    StumbleState = 1;
    StumbleType = Type;
    SetTimer(StumbleTime, false, 'TimerEndStumble');
    //return;    
}

event OnStumbleAnimEnd()
{
    RegenerateBeamWeapon();
    StumbleState = 0;
    //return;    
}

simulated function TimerEndStumble()
{
    // End:0x34
    if((int(StumbleState) == int(2)) || int(StumbleState) == int(1))
    {
        StumbleState = 3;
        ResetWeakpoints();
    }
    //return;    
}

simulated function RegenerateBeamWeapon()
{
    // End:0x29
    if(SkyWeaponBeam(Weapon) != none)
    {
        SkyWeaponBeam(Weapon).EnableWeapon();
    }
    //return;    
}

simulated function DisplayDebug(HUD HUD, out float out_YL, out float out_YPos)
{
    local int I;

    super(SkyPawn).DisplayDebug(HUD, out_YL, out_YPos);
    I = 0;
    J0x1C:

    // End:0x6A [Loop If]
    if(I < MachineGuns.Length)
    {
        MachineGuns[I].Weapon.DisplayDebug(HUD, out_YL, out_YPos);
        ++I;
        // [Loop Continue]
        goto J0x1C;
    }
    //return;    
}

// Export USkyPawn_Archon::execGetWeaponStartTraceLocation(FFrame&, void* const)
native simulated function Vector GetWeaponStartTraceLocation(optional Weapon CurrentWeapon);

simulated event SetFootSkelControlProfile(int Profile, optional bool bDisable = false)
{
    local int I;
    local AnimTree Tree;
    local SkySkelControl_FootPlacementProfiles SkelNode;

    Tree = AnimTree(Mesh.Animations);
    I = 0;
    J0x26:

    // End:0xB1 [Loop If]
    if(I < Tree.SkelControlLists.Length)
    {
        SkelNode = SkySkelControl_FootPlacementProfiles(Tree.SkelControlLists[I].ControlHead);
        // End:0xA7
        if(SkelNode != none)
        {
            SkelNode.SetProfile(Profile);
            SkelNode.SetSkelControlActive(!bDisable);
        }
        ++I;
        // [Loop Continue]
        goto J0x26;
    }
    //return;    
}

simulated function PostBeginPlay()
{
    local int I, CurNode;
    local SkyAnimNodeAimOffset OffsetNode;

    I = 0;
    J0x07:

    // End:0x2A3 [Loop If]
    if(I < MachineGuns.Length)
    {
        // End:0x299
        if(MachineGuns[I].Archetype != none)
        {
            MachineGuns[I].Weapon = Spawn(MachineGuns[I].Archetype.Class, self,,,, MachineGuns[I].Archetype);
            // End:0x299
            if(MachineGuns[I].Weapon != none)
            {
                // End:0x1B1
                if(MachineGuns[I].Socket != 'None')
                {
                    MachineGuns[I].Weapon.AttachToPawnAndSocket(self, MachineGuns[I].Socket);
                    MachineGuns[I].Weapon.SetOwner(self);
                    MachineGuns[I].Weapon.ValidGripId = MachineGuns[I].ValidGripId;
                    // End:0x18E
                    if(I == 0)
                    {
                        MachineGuns[I].Weapon.bAllowFire = true;                        
                    }
                    else
                    {
                        MachineGuns[I].Weapon.bAllowFire = false;
                    }
                }
                MachineGuns[I].Weapon.SkeletalMeshComponent.SetShadowParent(Mesh);
                // End:0x299
                if(MachineGuns[I].bMirror)
                {
                    CurNode = 0;
                    J0x202:

                    // End:0x299 [Loop If]
                    if(CurNode < MachineGuns[I].Weapon.SkeletalMeshComponent.AnimTickArray.Length)
                    {
                        OffsetNode = SkyAnimNodeAimOffset(MachineGuns[I].Weapon.SkeletalMeshComponent.AnimTickArray[CurNode]);
                        // End:0x28F
                        if(OffsetNode != none)
                        {
                            OffsetNode.bMirrorAim = true;
                        }
                        ++CurNode;
                        // [Loop Continue]
                        goto J0x202;
                    }
                }
            }
        }
        ++I;
        // [Loop Continue]
        goto J0x07;
    }
    TurbineSound.Play();
    MinTurnAngleCos = Cos(MinTurnAngle * 0.0174530);
    MaxTurnAngleCos = Cos(MaxTurnAngle * 0.0174530);
    super.PostBeginPlay();
    //return;    
}

function bool MGCanFire(SkyWeaponMounted TestWeapon)
{
    local int I, startCheckIndex;

    startCheckIndex = CurrentMGFireIndex;
    J0x0B:

    // End:0x67 [Loop If]
    if(!MachineGuns[CurrentMGFireIndex].Weapon.CanHitTarget())
    {
        ++CurrentMGFireIndex;
        // End:0x53
        if(CurrentMGFireIndex >= MachineGuns.Length)
        {
            CurrentMGFireIndex = 0;
        }
        // End:0x64
        if(startCheckIndex == CurrentMGFireIndex)
        {
            return false;
        }
        // [Loop Continue]
        goto J0x0B;
    }
    I = 0;
    J0x6E:

    // End:0xDC [Loop If]
    if(I < MachineGuns.Length)
    {
        // End:0xD2
        if(MachineGuns[I].Weapon == TestWeapon)
        {
            // End:0xD0
            if(CurrentMGFireIndex == I)
            {
                ++CurrentMGFireIndex;
                // End:0xCB
                if(CurrentMGFireIndex >= MachineGuns.Length)
                {
                    CurrentMGFireIndex = 0;
                }
                return true;
                // [Explicit Continue]
                goto J0xD2;
            }
            return false;
        }
        J0xD2:

        ++I;
        // [Loop Continue]
        goto J0x6E;
    }
    return false;
    //return ReturnValue;    
}

function gibbedBy(Actor Other)
{
    //return;    
}

simulated function ResetWeakpoints()
{
    local int I;

    // End:0x73
    if(Health > 0)
    {
        I = 0;
        J0x12:

        // End:0x68 [Loop If]
        if(I < WeakPoints.Length)
        {
            WeakPoints[I].Health = SkyPawn_Archon(ObjectArchetype).WeakPoints[I].Health;
            ++I;
            // [Loop Continue]
            goto J0x12;
        }
        EndEffectVisualEffect(self);
    }
    //return;    
}

function bool Died(Controller Killer, class<DamageType> DamageType, Vector HitLocation)
{
    local int I;

    I = 0;
    J0x07:

    // End:0x73 [Loop If]
    if(I < MachineGuns.Length)
    {
        // End:0x69
        if(MachineGuns[I].Weapon != none)
        {
            MachineGuns[I].Weapon.Destroy();
            MachineGuns[I].Weapon = none;
        }
        ++I;
        // [Loop Continue]
        goto J0x07;
    }
    TurbineSound.Stop();
    I = 0;
    J0x8A:

    // End:0xC0 [Loop If]
    if(I < WeakPoints.Length)
    {
        WeakPoints[I].Health = 0.0000000;
        ++I;
        // [Loop Continue]
        goto J0x8A;
    }
    DestroyNoseCannon();
    return super(SkyPawn).Died(Killer, DamageType, HitLocation);
    //return ReturnValue;    
}

// Export USkyPawn_Archon::execShouldUpdatePawnRotation(FFrame&, void* const)
native function bool ShouldUpdatePawnRotation();

// Export USkyPawn_Archon::execUpdateYawRotationSpeed(FFrame&, void* const)
native function UpdateYawRotationSpeed(float DeltaTime);

simulated event BotLaunchJump()
{
    // End:0x55
    if(int(JumpState) == int(1))
    {
        SuggestCustomJumpVelocity(Velocity, TransitionGoalActor.Location, Location, JumpSpeed, JumpZ);
        Acceleration = vect(0.0000000, 0.0000000, 0.0000000);
        SetPhysics(2);
    }
    //return;    
}

simulated function SpawnFootstepEffect(Vector SpawnLocation, Rotator SpawnRotation, FootstepImpact Effect)
{
    super(SkyPawn).SpawnFootstepEffect(SpawnLocation, SpawnRotation, Effect);
    HurtRadius(FootstepDamageAmount, FootstepDamageRadius, 0.0000000, FootstepDamageType, 0.0000000, SpawnLocation);
    //return;    
}

// Export USkyPawn_Archon::execOnWeakPointDestroyed(FFrame&, void* const)
native function OnWeakPointDestroyed(int Index, Actor EventInstigator);

simulated function SetShieldMaterial(float Value)
{
    // End:0x2D
    if(MatInstConst != none)
    {
        MatInstConst.SetScalarParameterValue('boss_shield_feedback', Value);
    }
    //return;    
}
