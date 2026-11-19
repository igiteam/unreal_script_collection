class OLEnemyNanoCloud extends OLEnemyPawn
	native(AI)
	placeable; 

////////////////////////////////////////////////////////////////////////////////////////////
// Variables
////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////

// Components

var ParticleSystemComponent CloudEmitter;
var MaterialInstanceConstant MatInstSwarm;
var MaterialInstanceConstant MatInstSkeleton;
var MaterialInstanceConstant MatInstEyes;
var StaticMeshComponent SphereMesh;
var TextureMovie SwarmMindMovie;
var MaterialInstanceConstant MatBloodyMain;
var Material MatBloodySecondary;

// State

enum NanoCloudForm
{
	NCF_Swarm,
	NCF_Human,
	NCF_MorphingToSwarm,
	NCF_MorphingToHuman,
};

var NanoCloudForm CurrentForm;
var float MorphStartedTime;

enum MorphingValueType
{
	MVT_CloudEmitter,
	MVT_SmallEmitters,
	MVT_SwarmMaterial,
	MVT_SkeletonMaterial,
	MVT_EyesMaterial,
};

struct native MorphingTransition
{
	var float PreValue;
	var float PostValue;
	var const float StartTime;
	var const float EndTime;
};

var array<float> MorphValues;
var array<MorphingTransition> HumanMorphs;
var array<MorphingTransition> SwarmMorphs;

var float AlwaysVisibleRange;
var float DistanceBasedVisibilityMorphTimeScale;

var float MorphMultiplier;

var bool bAlwaysVisible;
var float AlwaysVisibleChangeTime;
var float FullOpacityDistance;
var float CurrentOpacity;

var const float DefaultMorphMultiplier;
var const float ChaseMorphMultiplier;

var const float HumanMorphDuration; // total duration
var const float SwarmMorphDuration;
var const float HumanMorphPhase1Time; // Time after the start of morph at which to switch to phase 1
var const float SwarmMorphPhase1Time; // Time after the start of morph at which to switch to phase 1

var float TimeSinceLastChange;
var float TimeForNextChange;

var const float PatrolChangeMin;
var const float PatrolChangeMax;

var const name CloudEmitterAttachBoneName;
var const name NanoSphereAttachBoneName;

////////////////////////////////////////////////////////////////////////////////////////////
// Methods
////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////

cpptext
{
	virtual void TickPrePhysics(FLOAT deltaTime);
	virtual void TickPostPhysics(FLOAT deltaTime);

	virtual void EnableNightVisionEffect();
	virtual void DisableNightVisionEffect();

	virtual void BeginDestroy();

	UBOOL IsMorphing() const { return (CurrentForm == NCF_MorphingToHuman || CurrentForm == NCF_MorphingToSwarm); }

private:
	void UpdateMorph(FLOAT deltaTime);
	void UpdateVisibleComponents(FLOAT deltaTime);
	void UpdateState(FLOAT deltaTime);	
}

native function NativePostBeginPlay();

native function MorphToSwarm(optional float TimeScale = -1.0);
native function MorphToHuman(optional float TimeScale = -1.0);
native function SetSwarmForm(); // immediate, without morphing
native function SetHumanForm(); // immediate, without morphing

native function SwitchToBloodyMaterialNotify();

simulated event PostBeginPlay()
{
	Super.PostBeginPlay();
	SetHumanForm();
}

function OnMorphNanoCloud(OLSeqAct_MorphNanoCloud Action)
{
	if (Action.InputLinks[0].bHasImpulse)
	{
		if (Action.bInstantMorph)
		{
			SetSwarmForm();
		}
		else
		{
			MorphToSwarm(Action.TimeScale);
		}
	}
	else if (Action.InputLinks[1].bHasImpulse)
	{
		if (Action.bInstantMorph)
		{
			SetHumanForm();
		}
		else
		{
			MorphToHuman(Action.TimeScale);
		}
	}
}

function OnSetNanoCloudVisibility(OLSeqAct_SetNanoCloudVisibility Action)
{
	AlwaysVisibleRange = Action.AlwaysVisibleDistance;
	DistanceBasedVisibilityMorphTimeScale = Action.DistanceBasedVisibilityMorphTimeScale;
}

////////////////////////////////////////////////////////////////////////////////////////////
// Properties
////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////

defaultproperties 
{
	HumanMorphs(MVT_SmallEmitters)={(
		PreValue=0.0,
		PostValue=1.0,
		StartTime=0.0,
		EndTime=1.5,
	)}

	HumanMorphs(MVT_SkeletonMaterial)={(
		PreValue=0.0,
		PostValue=1.0,
		StartTime=0.0,
		EndTime=1.5,
	)}

	HumanMorphs(MVT_EyesMaterial)={(
		PreValue=0.0,
		PostValue=1.0,
		StartTime=0.0,
		EndTime=1.0,
	)}

	HumanMorphs(MVT_SwarmMaterial)={(
		PreValue=0.0,
		PostValue=1.0,
		StartTime=0.0,
		EndTime=3.0,
	)}

	HumanMorphs(MVT_CloudEmitter)={(
		PreValue=1.0,
		PostValue=0.0,
		StartTime=0.0,
		EndTime=2.5,
	)}

	SwarmMorphs(MVT_SmallEmitters)={(
		PreValue=1.0,
		PostValue=0.0,
		StartTime=1.0,
		EndTime=6.5,
	)}

	SwarmMorphs(MVT_SkeletonMaterial)={(
		PreValue=1.0,
		PostValue=0.0,
		StartTime=1.0,
		EndTime=5.0,
	)}

	SwarmMorphs(MVT_EyesMaterial)={(
		PreValue=1.0,
		PostValue=0.0,
		StartTime=0.0,
		EndTime=5.3,
	)}

	SwarmMorphs(MVT_SwarmMaterial)={(
		PreValue=1.0,
		PostValue=0.0,
		StartTime=0.0,
		EndTime=4.0,
	)}

	SwarmMorphs(MVT_CloudEmitter)={(
		PreValue=0.0,
		PostValue=1.0,
		StartTime=1.0,
		EndTime=4.0,
	)}

	MorphValues=(0,0,0,0,0);

	DefaultMorphMultiplier=1.0f
	ChaseMorphMultiplier=0.3f

	Begin Object Name=WPawnSkeletalMeshComponent
		SkeletalMesh=SkeletalMesh'02_NanoCloud.Pawn.Nano_Swarm_body'
		AnimSets(0)=AnimSet'03_Soldier.Soldier_V2'
		AnimSets(1)=AnimSet'03_Swarm.Swarm-AS'
		AnimTreeTemplate=AnimTree'02_Behaviors.Enemy.Enemy_AnimTree'
		CastShadow=false
		BlockActors=false
		CollideActors=false
		PhysicsAsset=PhysicsAsset'02_Soldier.Pawn.Soldier-v2_Physics'
	End Object
	Mesh=WPawnSkeletalMeshComponent
	Components.Add(WPawnSkeletalMeshComponent)

	Begin Object Class=StaticMeshComponent Name=SphereMeshComp
		StaticMesh=StaticMesh'02_NanoCloud.Sphere.NanoSphere'
		LightEnvironment=MyLightEnvironment
		CastShadow=false
		bUsePrecomputedShadows=true
		LightingChannels=(Static=false,Dynamic=true,CompositeDynamic=True)
		BlockActors=false
		CollideActors=false
		bAcceptsLights=False
		DepthPriorityGroup=SDPG_Foreground
	End Object
	SphereMesh=SphereMeshComp
	NanoSphereAttachBoneName=NPCLarge

	SwarmMindMovie=TextureMovie'02_NanoCloud.Movie.SwamMind'

	Begin Object Class=ParticleSystemComponent Name=NanoSwarmLCalfComponent
		Template=ParticleSystem'VFX_Nano.OutlineSwarm.NanoSwarmCalf-01'
		bAutoActivate=true
	End Object
	NanoSwarmEmitters[0]=(Emitter=NanoSwarmLCalfComponent,BoneName=NPCLarge-L-Calf)

	Begin Object Class=ParticleSystemComponent Name=NanoSwarmRCalfComponent
	Template=ParticleSystem'VFX_Nano.OutlineSwarm.NanoSwarmCalf-01'
	bAutoActivate=true
	End Object
	NanoSwarmEmitters[1]=(Emitter=NanoSwarmRCalfComponent,BoneName=NPCLarge-R-Calf)

	Begin Object Class=ParticleSystemComponent Name=NanoSwarmLThighComponent
		Template=ParticleSystem'VFX_Nano.OutlineSwarm.NanoSwarmThigh-01'
		bAutoActivate=true
	End Object
	NanoSwarmEmitters[2]=(Emitter=NanoSwarmLThighComponent,BoneName=NPCLarge-L-Thigh)

	Begin Object Class=ParticleSystemComponent Name=NanoSwarmRThighComponent
		Template=ParticleSystem'VFX_Nano.OutlineSwarm.NanoSwarmThigh-01'
		bAutoActivate=true
	End Object
	NanoSwarmEmitters[3]=(Emitter=NanoSwarmRThighComponent,BoneName=NPCLarge-R-Thigh)

	Begin Object Class=ParticleSystemComponent Name=NanoSwarmLForearmComponent
		Template=ParticleSystem'VFX_Nano.OutlineSwarm.NanoSwarmForearm-01'
		bAutoActivate=true
	End Object
	NanoSwarmEmitters[4]=(Emitter=NanoSwarmLForearmComponent,BoneName=NPCLarge-L-Forearm)

	Begin Object Class=ParticleSystemComponent Name=NanoSwarmRForearmComponent
		Template=ParticleSystem'VFX_Nano.OutlineSwarm.NanoSwarmForearm-01'
		bAutoActivate=true
	End Object
	NanoSwarmEmitters[5]=(Emitter=NanoSwarmRForearmComponent,BoneName=NPCLarge-R-Forearm)

	Begin Object Class=ParticleSystemComponent Name=NanoSwarmLUpperarmComponent
		Template=ParticleSystem'VFX_Nano.OutlineSwarm.NanoSwarmUpperArm-01'
		bAutoActivate=true
	End Object
	NanoSwarmEmitters[6]=(Emitter=NanoSwarmLUpperarmComponent,BoneName=NPCLarge-L-UpperArm)

	Begin Object Class=ParticleSystemComponent Name=NanoSwarmRUpperarmComponent
		Template=ParticleSystem'VFX_Nano.OutlineSwarm.NanoSwarmUpperArm-01'
		bAutoActivate=true
	End Object
	NanoSwarmEmitters[7]=(Emitter=NanoSwarmRUpperarmComponent,BoneName=NPCLarge-R-UpperArm)

	Begin Object Class=ParticleSystemComponent Name=NanoSwarmHeadComponent
		Template=ParticleSystem'VFX_Nano.OutlineSwarm.NanoSwarmHead-01'
		bAutoActivate=true
	End Object
	NanoSwarmEmitters[8]=(Emitter=NanoSwarmHeadComponent,BoneName=NPCLarge-Head)

	Begin Object Class=ParticleSystemComponent Name=NanoSwarmSpine3Component
		Template=ParticleSystem'VFX_Nano.OutlineSwarm.NanoSwarmSpine3-01'
		bAutoActivate=true
	End Object
	NanoSwarmEmitters[9]=(Emitter=NanoSwarmSpine3Component,BoneName=NPCLarge-Spine3)

	Begin Object Class=ParticleSystemComponent Name=CloudEmitterComponent
		Template=ParticleSystem'VFX_Nano.Swarm.NanoSwarm-01'
		bAutoActivate=true
	End Object
	CloudEmitter=CloudEmitterComponent
	CloudEmitterAttachBoneName=NPCLarge-Spine

	MatInstSwarm=MaterialInstanceConstant'02_NanoCloud.Material.NANOSWARM_MAT_INST'
	MatInstSkeleton=MaterialInstanceConstant'02_NanoCloud.Material.NANOSWARMSkeleton_inst'
	MatInstEyes=MaterialInstanceConstant'02_NanoCloud.Material.EyeCloud_INST'

	MatBloodyMain=MaterialInstanceConstant'02_NanoCloud.Material.SwarmBloody_INST'
	MatBloodySecondary=Material'02_NanoCloud.Material.SwarmBloody-02'
		
	PatrolChangeMin=3.0f
	PatrolChangeMax=5.0f

	BehaviorTree=OLBTBehaviorTree'02_AI_Behaviors.NanoCloud_BT'

	SoundEventIdleStart=AkEvent'Swarm_Sound.Swarm_Idle'
	SoundEventIdleStop=AkEvent'Swarm_Sound.Swarm_Idle_Stop'

	bCanVault=true
	bCanThrow=true

	VisionBone=NPCLarge-Head
	HeadBoneName=NPCLarge-Head
	HipBone=NPCLarge
	
	DoorOpenDistancePush=50.0
	DoorOpenDistancePull=50.0

	DoorBreakDistance=50.0
	DoorChasingBreakDistance=50.0

	WallBashDistance=75.0
	WallBashTime=0.2

	DoorOpenEndOffsetPushLeft=(X=100.0,Y=0.0)
	DoorOpenEndOffsetPushRight=(X=100.0,Y=0.0)
	DoorOpenEndOffsetPullLeft=(X=100.0,Y=0.0)
	DoorOpenEndOffsetPullRight=(X=100.0,Y=0.0)
	DoorOpenEndOffsetPushLeftWithClose=(X=100.0,Y=0.0)
	DoorOpenEndOffsetPushRightWithClose=(X=100.0,Y=0.0)
	DoorOpenEndOffsetPullLeftWithClose=(X=100.0,Y=0.0)
	DoorOpenEndOffsetPullRightWithClose=(X=100.0,Y=0.0)

	DoorBashEndOffset=(X=100.0,Y=0.0)

	LockerAttackOffset=(X=93.9,Y=0.0)

	BedInvestigateOffsetLeft=(X=-70.0,Y=-103.7)
	BedInvestigateOffsetRight=(X=-70.0,Y=103.7)

	BedAttackOffsetLeft=(X=20.9,Y=-101)
	BedAttackOffsetRight=(X=-43.3,Y=106.4)

	AlwaysVisibleRange=500.0;
	DistanceBasedVisibilityMorphTimeScale=12.0;
	FullOpacityDistance=0.0;
}