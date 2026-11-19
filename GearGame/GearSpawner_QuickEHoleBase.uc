/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 *
 * Defines the quick emergence hole spawner.
 */
class GearSpawner_QuickEHoleBase extends GearSpawner
	native(Spawner)
	abstract
	placeable;

//Warning

/** Whether or not this hole has a warning step */
var()  bool bHasWarning;

/** How long the warning will last before the actual hole starts */
var() float WarningTime;

/** The camera shake to play during the warning stage */
var() editinline CameraShake WarningCameraShake; 

/** Distance within which to play a full magnitude WarningCameraShake for a given player */
var() float WarningCameraShakeInnerDist;
/** Maximum distance at which to play WarningCameraShake for a given player */
var() float WarningCameraShakeOuterDist;

/** Time from the beginning of the warning till when the warning camera shake should start */
var() float WarningCameraShakeStartTime;

/** The sound to play during the warning stage */
var() SoundCue WarningSound;

/** The particle systems to use during the warning stage */
var() ParticleSystemComponent WarningParticleSystem;

//Hole

/** Length of time the hole is opening */
var() float HoleTime;

/** The particle systems to use during the hole entrance */
var() ParticleSystemComponent HoleParticleSystem;

/** The mesh to raise from the ground to represent the hole entrance */
var() StaticMeshComponent HoleRubble;

/** When to start raising the rubble mesh from beneath the ground */
var() float HoleRubbleRaiseStartTime;

/** When the rubble mesh should have reached its designated height */
var() float HoleRubbleRaiseEndTime;

/** Start location of rubble mesh */
var transient vector RubbleMeshStartTranslation;

/** Amount to raise the rubble mesh by */
var() vector HoleRubbleRaiseTranslation;

/** The material to apply to the rubble */
var() Material HoleRubbleMaterial;

/** The light to apply to the hole */
var() PointLightComponent HoleLight;

/** The time at which the light's brightness should reach its peak */
var() float HoleLightPeakTime;

/** The time at which the light should go out */
var() float HoleLightEndTime;

/** The peak value of the light's brightness */
var() float HoleLightPeakBrightness;

/** The decal to apply to the ground where the hole is emerging */
var transient DecalComponent HoleDecal;

/** The material to use on the hole decal */
var() MaterialInterface HoleDecalMaterial;

/** The name of the material parameter on the decal that controls the fade in and out */
var name HoleFadeParameterName;

/** The time to start fading in the hole decal */
var() float HoleDecalFadeInStartTime;

/** The time when the hole decal should be fully faded in */
var() float HoleDecalFadeInEndTime;

/** The camera shake to play on all nearby players when the hole opens */
var() editinline CameraShake HoleCameraShake;

/** Distance within which to play a full magnitude HoleCameraShake for a given player */
var() float HoleCameraShakeInnerDist;
/** Maximum distance at which to play HoleCameraShake for a given player */
var() float HoleCameraShakeOuterDist;

/** The time to start playing the camera shake */
var() float HoleCameraShakeStartTime;

/** The time to spawn the first enemy from the hole */
var() float HoleInitialSpawnTime;

/** The amount of time to wait after a spawn before spawning another */
var() float HoleSpawnInterval;

/** Current hole status for replication synching*/
enum EQuickHoleState
{
	QHS_Inactive,
	QHS_Warning,
	QHS_Opening,
	QHS_Finished,
};

/** The current state of the Hole */
var repnotify EQuickHoleState HoleState;

/** The time since the current state started */
var float StateTime;

/** The time the last tick was executed */
var float OldStateTime;

/** How many spawns have already occurred through this entrance. Used to space out the spawns */
var int NumSpawnsOccurred;

/** Whether or not you want to see the mesh and decal in the editor */
var() bool bShowGraphicsInEditor;

/** All potential ways to override the properties with a physical material */
enum EQEHolePhysicalMaterialOptions
{
	QEHPMO_DontUsePhysMat,
	QEHPMO_UseSurfacePhysMat,
	QEHPMO_UseDirtPhysMat,
	QEHPMO_UseSandPhysMat,
	QEHPMO_UseStonePhysMat,
	QEHPMO_UseWaterPhysMat
};

/** Whether or not to override the properties with ones from a physical material */
var() EQEHolePhysicalMaterialOptions PhysMatOptions;

/** The physical material we were using last */
var PhysicalMaterial PhysMaterial;

/** Default physical materials */
var PhysicalMaterial DirtPhysMat;
var PhysicalMaterial SandPhysMat;
var PhysicalMaterial StonePhysMat;
var PhysicalMaterial WaterPhysMat;

/** When the ehole opens this explosion will go off **/
var GearExplosion ExplosionTemplate;

/** Function to construct an instance of the specified hole decal material 
 *	@param MatInt - The specified material
 *	@param FadeValue - The initial setting for the scalar parameter for fading the material
 */
native function MaterialInstanceConstant ConstructHoleDecalMaterialInstance(MaterialInterface MatInt, float FadeValue);

cpptext
{
	virtual void PostLoad();
	virtual void PostEditChangeProperty(FPropertyChangedEvent& PropertyChangedEvent);
	virtual void PostEditMove(UBOOL bFinished);
	virtual void ApplyPhysicalMaterialOverrides();
}

replication
{
	if (bNetDirty)
		HoleState;
}


simulated event ReplicatedEvent(name VarName)
{
	if (VarName == 'HoleState')
	{
		switch (HoleState)
		{
			case QHS_Inactive:
				break;
			case QHS_Warning:
				StartWarning();
				break;
			case QHS_Opening:
				StartOpening();
				break;
			case QHS_Finished:
				StartFinished();
				break;
		}
	}
	else
	{
		Super.ReplicatedEvent(VarName);
	}
}

simulated function PostBeginPlay()
{	
	Super.PostBeginPlay();
	
	HoleDecal.SetDecalMaterial(ConstructHoleDecalMaterialInstance(HoleDecalMaterial, 0.0f));
	
	RubbleMeshStartTranslation = HoleRubble.Translation - HoleRubbleRaiseTranslation;
	HoleRubble.SetTranslation(RubbleMeshStartTranslation);
	
	if (HoleRubbleMaterial != None)
	{
		HoleRubble.SetMaterial(0, HoleRubbleMaterial);
	}
}

/** Start the warning sequence for the hole */
simulated function StartWarning()
{
	local AudioComponent AudioComp;
	
	if (bHasWarning)
	{
		HoleState = QHS_Warning;
		StateTime = 0.0f;

		WarningParticleSystem.ActivateSystem();

		AudioComp = CreateAudioComponent(WarningSound,FALSE,TRUE);
		if ( AudioComp != None )
		{
			AudioComp.Play();
		}
	}
	else
	{
		StartOpening();
	}
}

/** Start the opening sequence for the hole */
simulated function StartOpening()
{
	HoleState = QHS_Opening;
	StateTime = 0.0f;
	
	WarningParticleSystem.DeactivateSystem();
	HoleParticleSystem.ActivateSystem();

	HoleRubble.SetHidden(False);
	HoleLight.SetEnabled(True);
	
	DoOpeningEHoleExplosion();
}

function DoOpeningEHoleExplosion()
{
	local GearExplosionActor ExplosionActor;

	ExplosionActor = Spawn(class'GearExplosionActor',,, Location+vect(0,0,32), rot(0,0,0));

	if( ExplosionActor != None )
	{
		if( Instigator != None )
		{
			ExplosionActor.Instigator = Instigator;
			ExplosionActor.InstigatorController = Instigator.Controller;
		}
		ExplosionTemplate.InitFromContentTemplate();
		ExplosionActor.Explode( ExplosionTemplate );
	}
}

/** Start the finishing sequence for the hole */
simulated function StartFinished()
{
	HoleState = QHS_Finished;
	StateTime = 0.0f;
	
	WarningParticleSystem.DeactivateSystem();
	
	HoleRubble.SetHidden(False);
	HoleLight.SetEnabled(True);
	
	HoleRubble.SetTranslation(HoleRubble.Translation);
		
	HoleLight.SetLightProperties(0.0f,,);
	
	MaterialInstance(HoleDecal.GetDecalMaterial()).SetScalarParameterValue(HoleFadeParameterName,1.0f);	
}

/** Per tick update
 *	@param DeltaTime - Time since last tick
 */
simulated function Tick(float DeltaTime)
{
	local vector NewMeshTranslation;
	local GearPC PC;
	local float PlayerDist;
	
	Super.Tick(DeltaTime);
	
	OldStateTime = StateTime;
	StateTime += DeltaTime;

	if (HoleState == QHS_Warning)
	{
		// Shake
		if (StateTime >= WarningCameraShakeStartTime && OldStateTime < WarningCameraShakeStartTime)
		{
			foreach WorldInfo.AllControllers(class'GearPC',PC)
			{
				PlayerDist = VSize(PC.Pawn.Location - Location);
				if( PlayerDist < WarningCameraShakeInnerDist )
				{
					PC.ClientPlayCameraShake(WarningCameraShake, 1.0f, true);
				}
				else if( PlayerDist < WarningCameraShakeOuterDist )
				{
					PC.ClientPlayCameraShake(WarningCameraShake, (PlayerDist - WarningCameraShakeInnerDist) / (WarningCameraShakeOuterDist - WarningCameraShakeInnerDist), true);
				}
			}
		}
		// End Warning
		if (StateTime >= WarningTime)
		{
			StartOpening();
		}
	}
	else if (HoleState == QHS_Opening)
	{
		//Raising Rubble
		if (StateTime <= HoleRubbleRaiseStartTime)
		{
			NewMeshTranslation = RubbleMeshStartTranslation;
		}
		else if (StateTime > HoleRubbleRaiseStartTime && StateTime < HoleRubbleRaiseEndTime)
		{
			NewMeshTranslation = VLerp(RubbleMeshStartTranslation,
									   RubbleMeshStartTranslation + HoleRubbleRaiseTranslation, 
									   (StateTime - HoleRubbleRaiseStartTime) / (HoleRubbleRaiseEndTime - HoleRubbleRaiseStartTime));
		}
		else if (StateTime >= HoleRubbleRaiseEndTime)
		{
			NewMeshTranslation = RubbleMeshStartTranslation + HoleRubbleRaiseTranslation;
		}
		HoleRubble.SetTranslation(NewMeshTranslation);
		
		//Light
		if (HoleLightPeakTime != 0.0 && HoleLightEndTime != 0.0)
		{
			if (StateTime <= HoleLightPeakTime)
			{
				HoleLight.SetLightProperties((StateTime/HoleLightPeakTime)*HoleLightPeakBrightness,,);
			}
			else if (StateTime > HoleLightPeakTime && StateTime < HoleLightEndTime)
			{
				HoleLight.SetLightProperties((1.0f-((StateTime-HoleLightPeakTime)/(HoleLightEndTime-HoleLightPeakTime)))*HoleLightPeakBrightness,,);
			}
			else if (StateTime >= HoleLightEndTime)
			{
				HoleLight.SetLightProperties(0.0f,,);
			}
		}
		
		//Camera Shake
		if (StateTime >= HoleCameraShakeStartTime && OldStateTime < HoleCameraShakeStartTime)
		{
			foreach WorldInfo.AllControllers(class'GearPC',PC)
			{
				PlayerDist = VSize(PC.Pawn.Location - Location);
				if( PlayerDist < HoleCameraShakeInnerDist )
				{
					PC.ClientPlayCameraShake(HoleCameraShake, 1.0f, true);
				}
				else if( PlayerDist < HoleCameraShakeOuterDist )
				{
					PC.ClientPlayCameraShake(HoleCameraShake, (PlayerDist - HoleCameraShakeInnerDist) / (HoleCameraShakeOuterDist - HoleCameraShakeInnerDist), true);
				}
			}
		}
		
		//Decal
		if (StateTime <= HoleDecalFadeInStartTime)
		{
			MaterialInstance(HoleDecal.GetDecalMaterial()).SetScalarParameterValue(HoleFadeParameterName,0.0f);
		}
		else if (StateTime > HoleDecalFadeInStartTime && StateTime < HoleDecalFadeInEndTime)
		{
			MaterialInstance(HoleDecal.GetDecalMaterial()).SetScalarParameterValue(HoleFadeParameterName,((StateTime-HoleDecalFadeInStartTime)/(HoleDecalFadeInEndTime-HoleDecalFadeInStartTime)));
		}
		else if (StateTime >= HoleDecalFadeInEndTime)
		{
			MaterialInstance(HoleDecal.GetDecalMaterial()).SetScalarParameterValue(HoleFadeParameterName,1.0f);
		}		
		
		// End Opening
		if (StateTime >= HoleTime)
		{
			StartFinished();
		}
	}
}

/**
 * Overridden to start the activation if it was not already started, and to reject spawns if this spawner is used up
 *	@param out_SpawnSlotIdx - spawn slot to be used, or overridden with spawn slot that will be used
 *	@param out_SpawnLocation - location where the spawn will occur
 *	@param out_SpawnRotation - rotation for the spawn
 *	@return True if the entrance is willing to accept the spawn, False otherwise.
 */
event bool GetSpawnSlot(out int out_SpawnSlotIdx, out vector out_SpawnLocation, out rotator out_SpawnRotation)
{
	//Must have room for more guys
	if (NumSpawnsBuffered >= MaxSpawnBufferLength 
		// Must not be too late even if we are not finished yet.
		|| (HoleState == QHS_Opening && StateTime >= HoleInitialSpawnTime) ) 
	{
		return FALSE;
	}
	//If we are inactive, it's time to go active!
	if (HoleState == QHS_Inactive || HoleState == QHS_Finished)
	{
		StartWarning();
	}
	return Super.GetSpawnSlot(out_SpawnSlotIdx, out_SpawnLocation, out_SpawnRotation);
}

/**
 * Called when a new pawn is spawned using this spawner,
 * use to handle any special behaviors, such as playing
 * an animation, etc.
 *	@param NewSpawn - The pawn that was just spawned
 *	@param SlotIdx - The spawn slot index that was used to spawn this pawn
 */
event HandleSpawn(GearPawn NewSpawn, int SlotIdx)
{
	local GearAI AI;
	local Vector NewLocation;
	
	NumSpawnsOccurred++;

	AI = GearAI(NewSpawn.Controller);

	if (AI != None)
	{
		//Drudges are messed up, they need to start lower.
		if (GearPawn_LambentDroneBase(NewSpawn) != None)
		{
			NewSpawn.SetCollision(NewSpawn.bCollideActors, FALSE);
			NewSpawn.bCollideWorld = FALSE;
			NewLocation = NewSpawn.Location;
			NewLocation.Z -= 50;
			NewSpawn.SetLocation(NewLocation);
		}
	
		if( SpawnSlots[SlotIdx].EmergeAnim == EHEA_CrawlUp )
		{
			AI.DoEmerge(SM_Emerge_Type1);
		}
		else if( SpawnSlots[SlotIdx].EmergeAnim == EHEA_Jump )
		{
			AI.DoEmerge(SM_Emerge_Type3);
		}
		else // EHEA_Random
		{
			if( FRand() < 0.50f )
			{
				AI.DoEmerge(SM_Emerge_Type3);
			}
			else
			{
				AI.DoEmerge(SM_Emerge_Type1);
			}
		}
	}
	
	//Disable the spawn slot once a dude has used it to avoid dudes coming through the same slot.
	SpawnSlots[SlotIdx].bEnabled = False;
}

/** Whether or not this entrance is ready for the spawn right now 
 *	@param out_SpawnSlotIdx - spawn slot to be used, or overridden with spawn slot that will be used
 *	@param out_SpawnLocation - location where the spawn will occur
 *	@param out_SpawnRotation - rotation for the spawn
 *	@return True if the entrance is willing to accept the spawn, False otherwise.
 */
event bool WantsSpawnNow(out int out_SpawnSlotIdx, out vector out_SpawnLocation, out rotator out_SpawnRotation)
{
	if ( HoleState == QHS_Opening && StateTime >= HoleInitialSpawnTime+(HoleSpawnInterval*NumSpawnsOccurred) )
	{
		return Super.GetSpawnSlot(out_SpawnSlotIdx, out_SpawnLocation, out_SpawnRotation);
	}
	else
	{
		return FALSE;
	}
}

defaultproperties
{
	bHasWarning=True
	WarningTime=2.f

	Begin Object Class=GearCameraShake Name=WarningCameraShake0
		OscillationDuration=3.f
		RotOscillation={(Pitch=(Amplitude=30.f,Frequency=18.f),
						Yaw=(Amplitude=30.f,Frequency=18.f),
						Roll=(Amplitude=80.f,Frequency=40.f))}
		LocOscillation={(Y=(Amplitude=0.7f,Frequency=18.f),
						Z=(Amplitude=1.4f,Frequency=28.f))}
		FOVOscillation=(Amplitude=1.1f,Frequency=11.1f)
	End Object
	WarningCameraShakeStartTime=0.15f
	WarningCameraShake=WarningCameraShake0
	WarningCameraShakeInnerDist=1000.f
	WarningCameraShakeOuterDist=4000.f

	Begin Object Class=GearCameraShake Name=HoleCameraShake0
		OscillationDuration=1.f
		RotOscillation={(Pitch=(Amplitude=35.f,Frequency=21.f),
						Yaw=(Amplitude=35.f,Frequency=21.f),
						Roll=(Amplitude=85.f,Frequency=42.f))}
		LocOscillation={(Y=(Amplitude=0.7f,Frequency=21.f),
						Z=(Amplitude=1.4f,Frequency=28.f))}
		FOVOscillation=(Amplitude=1.3f,Frequency=11.1f)
	End Object
	HoleCameraShake=HoleCameraShake0
	HoleCameraShakeStartTime=0.05
	HoleCameraShakeInnerDist=1000.f
	HoleCameraShakeOuterDist=4000.f
	
	Begin Object Class=ParticleSystemComponent Name=WarningDust
		Rotation=(Pitch=16384)
		bAutoActivate=False
    End Object
	Components.Add(WarningDust)
	WarningParticleSystem=WarningDust
	
	HoleTime=3.0f
	
	Begin Object Class=ParticleSystemComponent Name=HoleExplode
		Rotation=(Pitch=16384)
		bAutoActivate=False
    End Object
	Components.Add(HoleExplode)
	HoleParticleSystem=HoleExplode
	
	Begin Object Class=StaticMeshComponent Name=RubbleMesh
		CollideActors=TRUE
		BlockZeroExtent=TRUE
		bAcceptsLights=TRUE
		Scale3D=(X=0.25,Y=0.25,Z=0.25)
		Translation=(Z=0)
		bForceDirectLightMap=TRUE
		bUsePrecomputedShadows=TRUE
		bAllowApproximateOcclusion=TRUE
		LightingChannels=(bInitialized=True,BSP=FALSE,Static=TRUE,Dynamic=FALSE,CompositeDynamic=TRUE)
		HiddenEditor=TRUE
	End Object
	Components.Add(RubbleMesh)
	HoleRubble=RubbleMesh
	CollisionComponent=RubbleMesh

	bCollideActors=true	 // Collision is on for world geometry
	bProjTarget=true	 // Do zero extent bullet traces collide
	bBlockActors=false   // Actor penetration doesn't matter yet
	
	HoleRubbleRaiseStartTime=0.2f
	HoleRubbleRaiseEndTime=.35f
	HoleRubbleRaiseTranslation=(Z=35.0f)
	
	Begin Object Class=PointLightComponent Name=HoleLightComp
		Radius=373.5
		Brightness=0.000000
		LightColor=(B=120,G=149,R=235,A=0)
		LightingChannels=(BSP=True,CompositeDynamic=True,Dynamic=True,Static=True)
		LightAffectsClassification=LAC_USER_SELECTED
		LightEnv_BouncedLightBrightness=0.00001
		LightEnv_BouncedModulationColor=(B=0,G=0,R=0,A=255)
		Translation=(Z=44.0)
    End Object
	Components.Add(HoleLightComp)
	HoleLight=HoleLightComp
	
	HoleLightPeakTime=0.0f
	HoleLightEndTime=0.0f
	HoleLightPeakBrightness=90.0f
	
	Begin Object Class=DecalComponent Name=HoleDecalComp
		FarPlane=100.0
		Height=500.0
		Width=500.0
		ParentRelativeOrientation=(Yaw=0,Pitch=-16384,Roll=0)
		ParentRelativeLocation=(X=0,Y=0,Z=0)
		DecalTransform=DecalTransform_OwnerRelative
		bMovableDecal=TRUE
		HiddenEditor=TRUE
	End Object
	Components.Add(HoleDecalComp)
	HoleDecal=HoleDecalComp
	
	HoleFadeParameterName=Fade

	HoleDecalFadeInStartTime=0.05
	HoleDecalFadeInEndTime=0.77
	
	Begin Object Class=SpriteComponent Name=Sprite
		HiddenGame=TRUE
		AlwaysLoadOnClient=FALSE
		AlwaysLoadOnServer=FALSE
		bIsScreenSizeScaled=TRUE
		ScreenSize=0.0025
	End Object
	Components.Add(Sprite)
	
	//Component that draws the special debug lines
	Begin Object Class=QuickEHoleRenderingComponent Name=HoleRenderer
	End Object
	Components.Add(HoleRenderer)
	
	bShowGraphicsInEditor=false
	
	PhysMatOptions=QEHPMO_UseSurfacePhysMat
	
	bGameRelevant=TRUE
	bMovable=FALSE
	RemoteRole=ROLE_SimulatedProxy
	bAlwaysRelevant=true
	bOnlyDirtyReplication=true
	
	SpawnSlots(0)=(LocationOffset=(X=50,Y=0,Z=-150.0))
	SpawnSlots(1)=(LocationOffset=(X=0,Y=50,Z=-150.0), RotationOffset=(Yaw=16384))
	
	MaxSpawnBufferLength=2
	
	HoleInitialSpawnTime=0.06
	HoleSpawnInterval=0.015
	
	HoleState=QHS_Inactive

	bUsesDelayedSpawns=true;

	// explosion when the ehole opens
	Begin Object Class=GearExplosion Name=ExploTemplate0
	    MyDamageType=class'GDT_EmergenceHoleOpening'
		MomentumTransferScale=0.f	// Scale momentum defined in DamageType

		ActorClassToIgnoreForDamage=class'GearGame.GearPawn_LocustBase'
		ActorClassToIgnoreForKnockdownsAndCringes=class'GearGame.GearPawn_LocustBase'

		FractureMeshRadius=100.0
		FracturePartVel=300.0

		KnockDownRadius=0
		CringeRadius=256
		CringeDuration=(X=2.f,Y=1.f)
		bAllowMovementDuringCringe=true
	End Object
	ExplosionTemplate=ExploTemplate0	
}
