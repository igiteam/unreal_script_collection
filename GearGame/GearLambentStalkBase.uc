/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 *
 * Defines the lambent stalk spawner.
 */
class GearLambentStalkBase extends Actor
	native(Spawner)
	abstract
	placeable
	implements(EditorLinkSelectionInterface);

/** What the player sees as the stalk name during POI */
var localized string FriendlyName;

/********************************************************
 *    Warning
 *******************************************************/

/** How long the warning will last before the actual hole starts */
var(Warning) float WarningTime;

/** The camera shake to play during the warning stage */
var(Warning) CameraShake WarningCameraShake; 

/** Time from the beginning of the warning till when the warning camera shake should start */
var(Warning) float WarningCameraShakeStartTime;

/** The sound to play during the warning stage */
var(Warning) SoundCue WarningSound;

/** The particle systems to use during the warning stage */
var(Warning) ParticleSystemComponent WarningParticleSystem;

/********************************************************
 *    Emerging
 *******************************************************/

//Animation time randomization
var(Emerging) float EmergeMinAnimationTimeMultiplier;
var(Emerging) float EmergeMaxAnimationTimeMultiplier;
var float EmergeAnimationTimeMultiplier;

//The amount of time the emerge animation will take
var float EmergeAnimTime;

//The particle system to use during the emerge stage
var(Emerging) ParticleSystem EmergePSTemplate;

//The name of the socket on the StalkMesh the system should be attached to
var(Emerging) name EmergeSystemSocketName;

//The dust particle system to use during the emerge stage
var(Emerging) ParticleSystemComponent DustParticleSystem;

//The name of the socket on the StalkMesh the system should be attached to
var(Emerging) name DustSystemSocketName;

/** The light to apply to the emergence */
var(Emerging) PointLightComponent EmergeLight;

/** The time at which the light's brightness should reach its peak */
var(Emerging) float LightPeakTime;

/** The time at which the light should go out */
var(Emerging) float LightEndTime;

/** The peak value of the light's brightness */
var(Emerging) float LightPeakBrightness;

/** The camera shake to play on all nearby players when the stalk emerges */
var(Emerging) CameraShake EmergeCameraShake;

/** The time to start playing the camera shake */
var(Emerging) float EmergeCameraShakeStartTime;

/** The sounds to play when the stalk starts emerging */
var(Emerging) array<SoundCue> EmergeSounds;

/** When the ehole opens this explosion will go off **/
var GearExplosion ExplosionTemplate;

/********************************************************
 *    Ready
 *******************************************************/
//Looping sound played while it is alive
var() SoundCue AliveAmbientSound;

//The audio component that is playing the Alive Ambient Sound
var AudioComponent AliveSoundComponent;

// The stalk itself
var() SkeletalMeshComponent StalkMesh;

//Time into Emerging state that the stalk should start raising
var(Emerging) float StalkRaiseStartTime;

//Time into Emerging state that the stalk should have finished raising
var(Emerging) float StalkRaiseEndTime;

//The name of the emerge animation
var(Emerging) Name EmergeAnimName;

/********************************************************
 *    Rubble
 *******************************************************/
var(Rubble) bool bUseRubble;
/** The rubble mesh */
var(Rubble) StaticMeshComponent RubbleMesh;

/** When to start raising the rubble mesh from beneath the ground */
var(Rubble) float RubbleRaiseStartTime;

/** When the rubble mesh should have reached its designated height */
var(Rubble) float RubbleRaiseEndTime;

/** Amount to raise the rubble mesh by */
var(Rubble) vector RubbleRaiseTranslation;

/** The material to apply to the rubble */
var(Rubble) Material RubbleMaterial;

/** The decal to apply to the ground where the stalk is emerging */
var transient DecalComponent RubbleDecal;

/** The material to use on the rubble decal */
var(Rubble) MaterialInterface RubbleDecalMaterial;

/** The name of the material parameter on the decal that controls the fade in and out */
var name RubbleFadeParameterName;

/** The time to start fading in the rubble decal */
var(Rubble) float RubbleDecalFadeInStartTime;

/** The time when the rubble decal should be fully faded in */
var(Rubble) float RubbleDecalFadeInEndTime;

//The original rubble mesh translation
var Vector OriginalRubbleMeshTranslation;

//The name of the looping idle animation
var(Rubble) Name IdleAnimName;

/** The last time players were reminded to shoot the pods */
var transient float LastPodsReminderTime;

/** How often to remind players to shoot out the pods */
var const float PodsReminderFrequency;

/********************************************************
 *    Dying/Dead
 *******************************************************/

//The name of the animation to play when the stalk dies
var Name DyingAnimName;

//The name of the material parameter that controls the dying effect
var Name DyingMatParameterName;

//The maximum value of the dying material parameter
var float MaxDyingMatValue;

//How long it takes to die
var float DyingTime;

//Sound to be played when it dies
var(Dead) SoundCue DeathSound;

//The particle system to use during the dying stage
var(Dead) ParticleSystemComponent DeathParticleSystem;

//The name of the socket on the StalkMesh the system should be attached to
var(Dead) name DeathSystemSocketName;

/********************************************************
 *    Global parameters
 *******************************************************/

/** Possible options for the stalk */
enum EStalkActionOptions
{
	SAP_WarningAndEmerge,
	SAP_JustEmerge,
	SAP_AlreadyEmergedDoNothing
};

/** What actions the stalk will take */
var()  EStalkActionOptions bStalkAction;


/** Current hole status for replication synching*/
enum EStalkState
{
	SS_Inactive,
	SS_Warning,
	SS_Emerging,
	SS_Ready,
	SS_Dying,
	SS_Dead,
};

/** The current state of the stalk */
var repnotify EStalkState StalkState;
/** last replicated stalk state (client only) */
var EStalkState LastStalkState;

/** The time since the current state started */
var float StateTime;

/** The time the last tick was executed */
var float OldStateTime;

/** Whether or not you want to see the mesh and decal in the editor */
var() bool bShowGraphicsInEditor;

/** Whether or not you wish the see the stalk in its emerged state */
var() bool bShowFullyEmergedStalk;

/** All potential ways to override the properties with a physical material */
enum EStalkPhysicalMaterialOptions
{
	SPMO_DontUsePhysMat,
	SPMO_UseSurfacePhysMat,
	SPMO_UseDirtPhysMat,
	SPMO_UseSandPhysMat,
	SPMO_UseStonePhysMat,
};

/** Whether or not to override the properties with ones from a physical material */
var() EStalkPhysicalMaterialOptions PhysMatOptions;

/** The physical material we were using last */
var PhysicalMaterial PhysMaterial;

/** Default physical materials */
var PhysicalMaterial DirtPhysMat;
var PhysicalMaterial SandPhysMat;
var PhysicalMaterial StonePhysMat;


// POD MANAGEMENT
var array<GearSpawner_LambentPodBase> ActivePods;

/** Optional POI so LDs don't have to drop them on every spawner */
var GearPointOfInterest_Stalk	POI;
/** Whether to spawn a POI for this spawner or not */
var() bool bSpawnPOI;

/** The light environment for the stalk */
var() DynamicLightEnvironmentComponent LightEnvironment;

// CHECKPOINT
struct CheckpointRecord
{
	var EStalkState StalkState;
};


/** Function to construct an instance of the specified rubble decal material 
 *	@param MatInt - The specified material
 *	@param FadeValue - The initial setting for the scalar parameter for fading the material
 */
native function MaterialInstanceConstant ConstructRubbleDecalMaterialInstance(MaterialInterface MatInt, float FadeValue);

/** Function to construct the appropriate material instances for the stalk
 */
native function ConstructStalkMaterialInstances();

/** Override the location used to target this pawn for LOS checks
 * @returns Figure out who we are targetting.
 */
simulated native function vector GetTargetLocation(optional Actor RequestedBy, optional bool bRequestAlternateLoc) const;

cpptext
{
	virtual void PostLoad();
	virtual void PostEditChangeProperty(FPropertyChangedEvent& PropertyChangedEvent);
	virtual void PostEditMove(UBOOL bFinished);
	virtual void ApplyPhysicalMaterialOverrides();
	virtual void Spawned();
	
	// >>>>>> EditorLinkSelectionInterface
	virtual void LinkSelection(USelection* SelectedObjects);
}

replication
{
	if (bNetDirty)
		StalkState, EmergeAnimationTimeMultiplier;
}


simulated event ReplicatedEvent(name VarName)
{
	if (VarName == 'StalkState')
	{
		HandleStalkState(StalkState, LastStalkState);
		LastStalkState = StalkState;
	}
	else
	{
		Super.ReplicatedEvent(VarName);
	}
}

/** Handles the immediate transition of handling the state of the stalk */
simulated function HandleStalkState(EStalkState NewStalkState, EStalkState PrevStalkState)
{
	switch (NewStalkState)
	{
		case SS_Inactive:
			break;
		case SS_Warning:
			StartWarningState();
			break;
		case SS_Emerging:
			StartEmergingState();
			break;
		case SS_Ready:
			StartReadyState();
			break;
		case SS_Dying:
			// Clients need to go through the ready state if JIPing
			if (PrevStalkState == SS_Inactive)
			{
				StartReadyState();
			}
			StartDyingState();
			break;
		case SS_Dead:
			// Clients need to go through the ready state if JIPing
			if (PrevStalkState == SS_Inactive)
			{
				StartReadyState();
			}

			// Clients need to go through the dying state if not coming from the dying state
			if (PrevStalkState != SS_Dying)
			{
				StartDyingState();
			}
			StartDeadState();
			break;
	}
}

function bool ShouldSaveForCheckpoint()
{
	return (StalkState != SS_Inactive);
}

function CreateCheckpointRecord(out CheckpointRecord Record)
{
	Record.StalkState = StalkState;
}

function ApplyCheckpointRecord(const out CheckpointRecord Record)
{
	HandleStalkState(Record.StalkState, StalkState);
	StalkState = Record.StalkState;
}

simulated function PostBeginPlay()
{	
	local AnimNodeSequence AnimNode;
	local MaterialInstanceConstant MIC;

	Super.PostBeginPlay();
	
	if (bUseRubble)
	{
		if (RubbleDecalMaterial != None)
		{
			RubbleDecal.SetDecalMaterial(ConstructRubbleDecalMaterialInstance(RubbleDecalMaterial, 0.0f));
		}

		if (RubbleMesh != None)
		{
			OriginalRubbleMeshTranslation = RubbleMesh.Translation;
			RubbleMesh.SetTranslation(RubbleMesh.Translation - RubbleRaiseTranslation);
		}

		if (RubbleMaterial != None)
		{
			MIC = new class'MaterialInstanceConstant';
			MIC.SetParent(RubbleMaterial);
			RubbleMesh.SetMaterial(0, MIC);
		}
	}

	AnimNode = AnimNodeSequence(StalkMesh.Animations);
	if (AnimNode == None && StalkMesh.Animations.IsA('AnimTree'))
	{
		AnimNode = AnimNodeSequence(AnimTree(StalkMesh.Animations).Children[0].Anim);
	}
	if (AnimNode == None)
	{
		`warn("Base animation node is not an AnimNodeSequence (Owner:" @ Owner $ ")");
	}
	else
	{
		AnimNode.SetAnim(EmergeAnimName);
		EmergeAnimTime = AnimNode.AnimSeq.SequenceLength;
		if (bStalkAction != SAP_AlreadyEmergedDoNothing && AnimNode.AnimSeq != None)
		{
			AnimNode.SetPosition(0,false);
		}
		else
		{
			AnimNode.SetPosition(EmergeAnimTime,false);
		}
	}
	if (Role == ROLE_Authority)
	{
		EmergeAnimationTimeMultiplier = RandRange(EmergeMinAnimationTimeMultiplier, EmergeMaxAnimationTimeMultiplier);
		bForceNetUpdate=true;
		
		if ( bSpawnPOI )
		{
			POI = Spawn( class'GearPointOfInterest_Stalk', self );
		}
	}
	
	StalkMesh.AttachComponentToSocket(DeathParticleSystem,DeathSystemSocketName);
	StalkMesh.AttachComponentToSocket(DustParticleSystem,DustSystemSocketName);
	
	ConstructStalkMaterialInstances();

	if (bStalkAction != SAP_AlreadyEmergedDoNothing)
	{
		StalkMesh.SetHidden(TRUE);
	}
	else
	{
		// Just go right to ready (idle anim et al)
		StalkMesh.SetHidden(FALSE);
		StartReadyState();
	}
}

/** Turn on the POI */
function TurnOnPOI()
{
	TogglePOI(true);
}

/** Toggles the POI on and off */
function TogglePOI( bool bOn )
{
	if ( bSpawnPOI )
	{
		if ( bOn )
		{
			POI.EnablePOI();
		}
		else
		{
			POI.DisablePOI();
		}
	}
}

/** Start the warning sequence for the stalk */
simulated function StartWarningState()
{
	local float TimeToPOI;
	local AudioComponent AudioComp;
	
	//Do not allow warning to start from any state other than inactive
	if (StalkState == SS_Inactive)
	{
		if (bStalkAction == SAP_WarningAndEmerge)
		{
			StalkState = SS_Warning;
			StateTime = 0.0f;

			WarningParticleSystem.ActivateSystem();

			AudioComp = CreateAudioComponent(WarningSound,FALSE,TRUE);
			if ( AudioComp != None )
			{
				AudioComp.Play();
			}

			// Want to show POI shortly before emergence
			TimeToPOI = Max(WarningTime - 1.0, 0);
			SetTimer(TimeToPOI, false, nameof(TurnOnPOI));
		}
		else if (Role == ROLE_Authority)
		{
			StartEmergingState();
		}
	}
}

/** Start the emerging sequence for the stalk */
simulated function StartEmergingState()
{
	local AudioComponent AudioComp;
	local vector EmergeLoc;
	local Rotator EmergeRot;
	local int Iter;
	
	if (bStalkAction == SAP_AlreadyEmergedDoNothing)
	{
		if (Role == ROLE_Authority)
		{
			StartReadyState();
		}
		return;
	}
	
	//Do not allow reentrance into emerging from emerging
	if (Role != ROLE_Authority || StalkState != SS_Emerging)
	{
		StalkState = SS_Emerging;
		StateTime = 0.0f;
		
		WarningParticleSystem.DeactivateSystem();
		DustParticleSystem.ActivateSystem();

		if (EmergeSystemSocketName != 'None' && WorldInfo != None && WorldInfo.MyEmitterPool != None)
		{
			// Emit particles at the emerge location
			if (StalkMesh.GetSocketWorldLocationAndRotation( EmergeSystemSocketName, EmergeLoc, EmergeRot ))
			{
			   WorldInfo.MyEmitterPool.SpawnEmitter( EmergePSTemplate, EmergeLoc, EmergeRot );
			}
		}

		if (bUseRubble && RubbleMesh != None)
		{
			RubbleMesh.SetHidden(False);
		}
		
		StalkMesh.SetHidden(False);
		EmergeLight.SetEnabled(True);
		
		for (Iter = 0; Iter < EmergeSounds.Length; Iter++)
		{
			AudioComp = CreateAudioComponent(EmergeSounds[Iter],FALSE,TRUE);
			if ( AudioComp != None )
			{
				AudioComp.Play();
			}
		}
		
		StalkMesh.PlayAnim(EmergeAnimName,EmergeAnimTime*EmergeAnimationTimeMultiplier);
	}

	if (bStalkAction == SAP_JustEmerge)
	{
		TogglePOI( true );
	}

	DoOpeningEHoleRadialDamage();
}

function DoOpeningEHoleRadialDamage()
{
	local GearExplosionActor ExplosionActor;

	ExplosionActor = Spawn(class'GearExplosionActor',,, Location+vect(0,0,32), rot(0,0,0));

	if( ExplosionActor != None )
	{
		ExplosionActor.Explode( ExplosionTemplate );
	}
}

/** The stalk has just become ready to support spawning */
simulated function StartReadyState()
{		
	local MaterialInstance DecalMaterial;

	StalkState = SS_Ready;
	StateTime = 0.0f;
	
	WarningParticleSystem.DeactivateSystem();
	
	if (bUseRubble && RubbleMesh != None)
	{
	   RubbleMesh.SetHidden(False);
	   RubbleMesh.SetTranslation(OriginalRubbleMeshTranslation);
	   RubbleMesh.SetActorCollision(true, true);
	}
	
	StalkMesh.SetHidden(False);
	EmergeLight.SetEnabled(True);
	EmergeLight.SetLightProperties(0.0f,,);
	
	if (bUseRubble)
	{
		DecalMaterial = MaterialInstance(RubbleDecal.GetDecalMaterial());
		if (DecalMaterial != None)
		{
			DecalMaterial.SetScalarParameterValue(RubbleFadeParameterName,1.0f);	
		}
	}

	AliveSoundComponent = CreateAudioComponent(AliveAmbientSound,FALSE,TRUE);
	if ( AliveSoundComponent != None )
	{
		AliveSoundComponent.Play();
	}
	
	StalkMesh.PlayAnim(IdleAnimName,,true);
}

/** Start the dying sequence for the stalk */
simulated function StartDyingState()
{
	local AudioComponent AudioComp;

	StalkState = SS_Dying;
	StateTime = 0.0f;
	
	if (AliveSoundComponent != None)
	{
		AliveSoundComponent.Stop();
	}
	
	DeathParticleSystem.ActivateSystem();
	
	AudioComp = CreateAudioComponent(DeathSound,FALSE,TRUE);
	if ( AudioComp != None )
	{
		AudioComp.Play();
	}
	
	StalkMesh.StopAnim();
}

/** The stalk is now dead. Perform any operation necessary. */
simulated function StartDeadState()
{
	local MaterialInstance Mat;
	local MaterialInterface MatInt;
	
	StalkState = SS_Dead;
	StateTime = 0.0f;
	
	foreach StalkMesh.Materials(MatInt)
	{
		Mat = MaterialInstance(MatInt);
		if (Mat != None)
		{
			Mat.SetScalarParameterValue(DyingMatParameterName, MaxDyingMatValue);
		}
	}
}

/** Per tick update
 *	@param DeltaTime - Time since last tick
 */
simulated function Tick(float DeltaTime)
{
	local vector NewMeshTranslation;
	local GearPC PC;
	local MaterialInterface MatInt;
	local MaterialInstance Mat, DecalMaterial;;
	local float PercentageDead;
	local float ParamValue;
	
	Super.Tick(DeltaTime);
	
	OldStateTime = StateTime;
	StateTime += DeltaTime;

	switch(StalkState)
	{
		case SS_Warning:
			// Shake
			if (StateTime >= WarningCameraShakeStartTime && OldStateTime < WarningCameraShakeStartTime)
			{
				foreach WorldInfo.AllControllers(class'GearPC',PC)
				{
					PC.ClientPlayCameraShake(WarningCameraShake,, true);
				}
			}
			// End Warning
			if (Role == ROLE_Authority && StateTime >= WarningTime)
			{
				StartEmergingState();
			}
			break;
		case SS_Emerging:			
			if (Role == ROLE_Authority && LastPodsReminderTime == 0 && PlayerCanSeeMe(True))
			{
				GearGame(WorldInfo.Game).TriggerGUDEvent(GUDEvent_StalkEmerging, None);
				LastPodsReminderTime = WorldInfo.TimeSeconds;
			}

			//Raising Rubble
			if (RubbleMesh != None)
			{
				if (StateTime <= RubbleRaiseStartTime)
				{
					NewMeshTranslation = OriginalRubbleMeshTranslation - RubbleRaiseTranslation;
				}
				else if (StateTime > RubbleRaiseStartTime && StateTime < RubbleRaiseEndTime)
				{
					NewMeshTranslation = VLerp(OriginalRubbleMeshTranslation - RubbleRaiseTranslation,
						OriginalRubbleMeshTranslation, 
						(StateTime - RubbleRaiseStartTime) / (RubbleRaiseEndTime - RubbleRaiseStartTime));
				}
				else if (StateTime >= RubbleRaiseEndTime)
				{
					NewMeshTranslation = OriginalRubbleMeshTranslation;
				}
				RubbleMesh.SetTranslation(NewMeshTranslation);
			}

			//Light
			if (LightPeakTime != 0.0 && LightEndTime != 0.0)
			{
				if (StateTime <= LightPeakTime)
				{
					EmergeLight.SetLightProperties((StateTime/LightPeakTime)*LightPeakBrightness,,);
				}
				else if (StateTime > LightPeakTime && StateTime < LightEndTime)
				{
					EmergeLight.SetLightProperties((1.0f-((StateTime-LightPeakTime)/(LightEndTime-LightPeakTime)))*LightPeakBrightness,,);
				}
				else if (StateTime >= LightEndTime)
				{
					EmergeLight.SetLightProperties(0.0f,,);
				}
			}
			
			//Camera Shake
			if (StateTime >= EmergeCameraShakeStartTime && OldStateTime < EmergeCameraShakeStartTime)
			{
				foreach WorldInfo.AllControllers(class'GearPC',PC)
				{
					PC.ClientPlayCameraShake(EmergeCameraShake,, true);
				}
			}
			
			//Decal	
			if (bUseRubble)
			{
				DecalMaterial = MaterialInstance(RubbleDecal.GetDecalMaterial());
				if (DecalMaterial != None)
				{
					if (StateTime <= RubbleDecalFadeInStartTime)
					{
						DecalMaterial.SetScalarParameterValue(RubbleFadeParameterName,0.0f);
					}
					else if (StateTime > RubbleDecalFadeInStartTime && StateTime < RubbleDecalFadeInEndTime)
					{
						DecalMaterial.SetScalarParameterValue(RubbleFadeParameterName,((StateTime-RubbleDecalFadeInStartTime)/(RubbleDecalFadeInEndTime-RubbleDecalFadeInStartTime)));
					}
					else if (StateTime >= RubbleDecalFadeInEndTime)
					{
						DecalMaterial.SetScalarParameterValue(RubbleFadeParameterName,1.0f);
					}	
				}
			}

			// End Opening
			if (Role == ROLE_Authority && StateTime >= EmergeAnimationTimeMultiplier*EmergeAnimTime)
			{
				StartReadyState();
			}
			break;
		case SS_Ready:
			if (Role == ROLE_Authority && ActivePods.Length > 0 && `TimeSince(LastPodsReminderTime) > PodsReminderFrequency)
			{
				if ( PlayerCanSeeMe(True))
				{
					GearGame(WorldInfo.Game).TriggerGUDEvent(GUDEvent_StalkPodsReminder, None);
					LastPodsReminderTime = WorldInfo.TimeSeconds;
				}
				else
				{
					// Put in a 2 second timeout so we don't keep checking every frame
					LastPodsReminderTime = WorldInfo.TimeSeconds - PodsReminderFrequency + 2.0;
				}
			}
			break;
		case SS_Dying:
			PercentageDead = StateTime/DyingTime;
			ParamValue = MaxDyingMatValue*PercentageDead;
			if (Role == ROLE_Authority && StateTime >= DyingTime)
			{
				ParamValue = MaxDyingMatValue;
				StartDeadState();
			}
			foreach StalkMesh.Materials(MatInt)
			{
				Mat = MaterialInstance(MatInt);
				if (Mat != None)
				{
					Mat.SetScalarParameterValue(DyingMatParameterName, ParamValue);
				}
			}
			break;
		case SS_Dead:
			break;
	}
}

function RegisterPod(GearSpawner_LambentPodBase Pod)
{
	if (Pod != none && ActivePods.Find(Pod) == INDEX_NONE)
	{
		ActivePods.AddItem(Pod);
	}
}


function PodDied(GearSpawner_LambentPodBase Pod)
{
	local int PodIdx;

	ActivePods.RemoveItem(Pod);

	if(Role == ROLE_Authority)
	{
		// Let the other pods know this may be the last guy
		for (PodIdx=0; PodIdx<ActivePods.length; PodIdx++)
		{
			ActivePods[PodIdx].CheckFactoryEmpty();
		}

		if (ActivePods.Length <= 0)
		{
			StartDyingState();
		}
	}
}

/** Return top of stalk when its emerging, otherwise nothing to force look at base */
function name GetStalkLookAtPos()
{
	if (StalkState > SS_Warning)
	{
		return 'Stalk_End_1';
	}

	return '';
}

/** Get POI Text for Stalk */
function string GetDisplayName()
{
	return FriendlyName;
}

defaultproperties
{
	bUseRubble=true
	StalkState=SS_Inactive
	
	EmergeAnimName=Emerge_Fast
	DyingAnimName=Stalk_Emerge
	IdleAnimName=Emerge_Fast_Idle
	
	PodsReminderFrequency=15.0f

	Begin Object Class=DynamicLightEnvironmentComponent Name=MyLightEnvironment
		LightShadowMode=LightShadow_Modulate
		bUseBooleanEnvironmentShadowing=True
		ModShadowFadeoutTime=0.75f
	End Object
	LightEnvironment=MyLightEnvironment
	Components.Add(MyLightEnvironment)

	Begin Object Class=SkeletalMeshComponent Name=StalkMesh0
		BlockZeroExtent=TRUE
		BlockNonZeroExtent=TRUE
		CollideActors=TRUE
		BlockActors=TRUE
		BlockRigidBody=TRUE
		RBChannel=RBCC_Default
		RBCollideWithChannels=(Default=TRUE,BlockingVolume=TRUE,EffectPhysics=TRUE,GameplayPhysics=TRUE,Pawn=TRUE)
		HiddenEditor=FALSE
		LightEnvironment=MyLightEnvironment
	End Object
	Components.Add(StalkMesh0)
	StalkMesh=StalkMesh0
	
	bShowFullyEmergedStalk=TRUE
	
	CollisionComponent=StalkMesh0
	
	bCollideActors=TRUE
	bBlockActors=TRUE
	BlockRigidBody=TRUE
	bProjTarget=TRUE
	
	bNoDelete=TRUE

	// explosion when the ehole opens
	Begin Object Class=GearExplosion Name=ExploTemplate0
	    MyDamageType=class'GDT_EmergenceHoleOpening'
		MomentumTransferScale=0.f	// Scale momentum defined in DamageType
		ActorClassToIgnoreForDamage=class'GearGame.GearPawn_LocustBase'
		ActorClassToIgnoreForKnockdownsAndCringes=class'GearGame.GearPawn_LocustBase'

		FractureMeshRadius=100.0
		FracturePartVel=300.0

		Damage=700
		DamageRadius=512
		DamageFalloffExponent=1.0f

		KnockDownRadius=0
		CringeRadius=1024
	End Object
	ExplosionTemplate=ExploTemplate0	
}
