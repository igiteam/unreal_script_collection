class MOHARagdollSkelComponent extends MOHASkeletalMeshComponent
    native
    editinlinenew
    hidecategories(Object)
    autoexpandcategories(Collision,Rendering,Lighting);

enum ERagdollState
{
    eRagdollState_None,             // 0
    eRagdollState_Limp,             // 1
    eRagdollState_BoneSpring,       // 2
    eRagdollState_Powered,          // 3
    eRagdollState_HitReaction,      // 4
    eRagdollState_MAX               // 5
};

struct native RagdollImpulse
{
    var Vector HitLocation;
    var Vector Momentum;
    var class<DamageType> DamageType;
    var TraceHitInfo HitInfo;
    var bool bIsRadial;
    var bool bUseFalloff;

    structdefaultproperties
    {
        HitLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Momentum=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        DamageType=none
        HitInfo=(Material=none,PhysMaterial=none,Item=0,BoneName="None",HitComponent=none)
        bIsRadial=false
        bUseFalloff=false
    }
};

struct native MomentumHistory
{
    var private int NumSamples;
    var private int NextSample;
    var private float SampleTimer;
    var private float ThresholdSquared;
    var private Vector Samples[20];
    var private Vector Momentum;

    structdefaultproperties
    {
        NumSamples=0
        NextSample=0
        SampleTimer=0.0000000
        ThresholdSquared=0.0000000
        Samples[0]=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Samples[1]=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Samples[2]=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Samples[3]=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Samples[4]=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Samples[5]=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Samples[6]=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Samples[7]=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Samples[8]=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Samples[9]=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Samples[10]=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Samples[11]=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Samples[12]=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Samples[13]=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Samples[14]=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Samples[15]=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Samples[16]=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Samples[17]=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Samples[18]=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Samples[19]=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Momentum=(X=0.0000000,Y=0.0000000,Z=0.0000000)
    }
};

var const transient Matrix PreviousLocalToWorld;
var() float hitReactionDuration;
var() float hitReactionFadeDuration;
var transient bool bDebugDisableImpulse;
var transient bool bForceSleep;
var transient bool bRagdollIsTerminal;
var transient bool bForceSeedVelocities;
var transient bool bInTick;
var transient bool goingRagdoll;
var() float fHitReactionImpactForceMax;
var() float fHitReactionImpactForceMin;
var() float fHitReactionEnergyScalarMax;
var() float fHitReactionEnergyScalarMin;
var() float fHitReactionEnergyMin;
var() float fHitReactionEnergyMax;
var() float limpRagdollImpactForce;
var() MOHARagdollAudioAsset audioImpactHandlerAsset;
var() editinline RB_ConstraintSetup handsConstraintSetup;
var RB_ConstraintInstance handsConstraintInstance;
var MaterialInstance JointLimitMaterial;
var() PhysicsAsset ReactionLocomotionPhysics;
var() int iDefaultDeathLODLevel;
var transient MomentumHistory MomentumMemory;
var transient MOHARagdollSkelComponent.ERagdollState pendingRagdollState;
var transient MOHARagdollSkelComponent.ERagdollState CurrentState;
var transient array<RagdollImpulse> pendingImpulses;
var transient MOHARagdollAudioInstance audioImpactHandler;
var export editinline transient RagdollState States[ERagdollState];
var array<string> RagdollLogEntries;

// Export UMOHARagdollSkelComponent::execAddRagdollImpulse(FFrame&, void* const)
native function AddRagdollImpulse(const out Vector inHitlocation, const out Vector inMomentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo);

// Export UMOHARagdollSkelComponent::execAddRagdollRadialImpulse(FFrame&, void* const)
native function AddRagdollRadialImpulse(const out Vector inOrigin, float inMomentum, class<DamageType> DamageType, float DamageRadius, bool DoFalloff);

// Export UMOHARagdollSkelComponent::execGoTerminalRagdoll(FFrame&, void* const)
native function GoTerminalRagdoll(MOHARagdollSkelComponent.ERagdollState mode, optional bool forceVelocities);

// Export UMOHARagdollSkelComponent::execGetRigidBodyID(FFrame&, void* const)
native function int GetRigidBodyID(name BoneName);

// Export UMOHARagdollSkelComponent::execGetLimpRagdollMomentumMagnitude(FFrame&, void* const)
native function float GetLimpRagdollMomentumMagnitude();

// Export UMOHARagdollSkelComponent::execAddToRagdollRecord(FFrame&, void* const)
native final function AddToRagdollRecord(coerce string Text);

// Export UMOHARagdollSkelComponent::execDumpRagdollRecordToFile(FFrame&, void* const)
native final function DumpRagdollRecordToFile();

event BeginPlay()
{
    //return;    
}

event OnLimpRagdollImpact()
{
    local MOHAAIPawn P;

    P = MOHAAIPawn(Owner);
    // End:0x1D
    if(P == none)
    {
        return;
    }
    P.OnLimpRagdollImpact();
    //return;    
}

defaultproperties
{
    hitReactionDuration=1.4000000
    hitReactionFadeDuration=0.4000000
    fHitReactionImpactForceMax=-0.0500000
    fHitReactionImpactForceMin=-0.0010000
    fHitReactionEnergyScalarMax=4.0000000
    fHitReactionEnergyScalarMin=1.0000000
    fHitReactionEnergyMax=200.0000000
    limpRagdollImpactForce=-0.0083300
    // Reference: RB_ConstraintSetup'Default__MOHARagdollSkelComponent.HitReactionHandsContraint'
    begin object name=HitReactionHandsContraint class=Class'Engine.RB_ConstraintSetup'
    end object
    handsConstraintSetup=HitReactionHandsContraint
    iDefaultDeathLODLevel=2
    // Reference: LimpRagdollState'Default__MOHARagdollSkelComponent.LimpState'
    begin object name=LimpState class=Class'LimpRagdollState'
    end object
    States=LimpState
    // Reference: BoneSpringRagdollState'Default__MOHARagdollSkelComponent.BoneSpringState'
    begin object name=BoneSpringState class=Class'BoneSpringRagdollState'
    end object
    States=BoneSpringState
    // Reference: PoweredRagdollState'Default__MOHARagdollSkelComponent.PoweredState'
    begin object name=PoweredState class=Class'PoweredRagdollState'
    end object
    States=PoweredState
    // Reference: ReactionRagdollState'Default__MOHARagdollSkelComponent.ReactionState'
    begin object name=ReactionState class=Class'ReactionRagdollState'
    end object
    States=ReactionState
    bUpdateKinematicBonesFromAnimation=false
}