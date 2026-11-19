/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 *
 * Defines the corpser egg spawner.
 */
class GearSpawner_CorpserEggBase extends GearSpawner
	config(Pawn)
	DependsOn(GearPawn)
	native(Spawner)
	abstract
	implements(EditorLinkSelectionInterface,Interface_NavMeshPathObstacle);

/** Static mesh component */
var	SkeletalMeshComponent Mesh;

/** cached custom anim node sequence reference */
var GearAnim_Slot FullBodySlot;

/** Amount of health the egg has */
var config float EggHealth;

/** The names of the animations for the egg */
var Array<Name> EggAnimNames;

/** The names of the animations for opening the egg */
var array<Name> EmergeAnimNames;
/** The names of the animations for idling after opening the egg */
var array<Name> EmergeIdleAnimNames;

/** Is the egg actively spawning? */
var bool bSpawning;

/** Whether it's time to spawn a larva yet */
var bool bAllowSpawn;

/** Emerge explosion template */
var GearExplosion EmergeTemplate;

/** enum of animations for the egg */
enum EEggAnim
{
	EGG_None,
	EGG_Idle,
	EGG_Cracking,
	EGG_CrackIdle,
	EGG_Death,
	EGG_DeathIdle,
	EGG_Open,
	EGG_OpenIdle,
};

/** The current animation playing */
var repnotify EEggAnim CurrentAnimation;

/** Enum of the different types of emerging that can happen */
enum EEggEmergeAnim
{
	EGG_EMERGE_A,
	EGG_EMERGE_B,
};

/** The emerge animation to use for this egg spawner */
var() EEggEmergeAnim EmergeAnim;

/** used when receiving animation on the client to know what the previous anim was */
var EEggAnim LastReplicatedAnimation;

/** Minimum amount of time to spend in the cracked open state */
var() float MinCrackTime;

/** Maximum amount of time to spend in the cracked open state */
var() float MaxCrackTime;

/** The chainsaw trigger associated with this spawner */
var() Trigger_ChainsawInteraction ChainsawTrigger;

/* Material used to control the inner glow material */
var transient MaterialInstanceConstant InnerGlowMaterial;
/* Material used to control the membrane material */
var transient MaterialInstanceConstant MembraneMaterial;

/** Time we started emerging the creature */
var transient float TimeOfEmerge;

/** Used for keeping track of the collision cylinder we have **/
var protected CylinderComponent CollisionCylinderComponent;

/** tracks whether this egg has been registered with the navmesh or not */
var transient bool bRegisteredWithNavMesh;


replication
{
	if (bNetDirty)
		CurrentAnimation;
}

cpptext
{
	virtual void LinkSelection(USelection* SelectedObjects);

	/**
	 * this function should populate out_polyshape with a list of verts which describe this object's 
	 * convex bounding shape
	 * @param out_PolyShape - output array which holds the vertex buffer for this obstacle's bounding polyshape
	 * @return TRUE if this object should block things right now (FALSE means this obstacle shouldn't affect the mesh)
	 */
	virtual UBOOL GetBoundingShape(TArray<FVector>& out_PolyShape);

	/**
	 * when TRUE polys internal to this obstacle will be preserved, but still split. (useful for things like cost volumes that 
	 * need to adjust cost but not completely destroy parts of the mesh
	 * @return TRUE if polys should be preserved internal to this obstacle
	 */
	virtual UBOOL PreserveInternalPolys() { return FALSE; }

	/**
	 * For debugging.  Verifies that this pathobject is still alive and well and not orphaned or deleted
	 * @return - TRUE If this path object is in good working order
	 */
	virtual UBOOL VerifyObstacle()
	{
		return !IsPendingKill();
	}

	virtual void BeginDestroy()
	{
		Super::BeginDestroy();
		UnRegisterObstacle();
	}
}

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	// Setup the spawn slot
	SpawnSlots.Length = 1;

	SetupEffectComponents();

	// Set up the Animations
	InitializeAnimations();

	if (ChainsawTrigger != None)
	{
		ChainsawTrigger.AddEventDelegate(OnChainsawed);
	}

	RegisterObstacle();
}

/** Called by the chainsaw trigger when someone chainsaws within it */
simulated function OnChainsawed()
{
	DoDeath();
}

simulated event ReplicatedEvent(name VarName)
{
	local EEggAnim NewAnimation;

	if (VarName == nameof(CurrentAnimation))
	{
		NewAnimation = CurrentAnimation;
		CurrentAnimation = LastReplicatedAnimation;
		switch (NewAnimation)
		{
			case EGG_Idle:
			case EGG_CrackIdle:
			case EGG_DeathIdle:
			case EGG_OpenIdle:
			case EGG_Open:
				break;
			case EGG_Cracking:
				StartCracking();
				break;
			case EGG_Death:
				StartDeath();
				break;
			default:
				`Warn("Unhandled animation type" @ NewAnimation);
				break;
		}
		CurrentAnimation = NewAnimation;
		LastReplicatedAnimation = NewAnimation;
	}
	else
	{
		Super.ReplicatedEvent(VarName);
	}
}

/** kill off any effects we need to stop **/
simulated event Destroyed()
{
	UnRegisterObstacle();

	Super.Destroyed();
}


/**
 * Called when this spawner is activated (via Toggle).
 */
function Activated()
{
	RegisterObstacle();
}

/**
 * Called when this spawner is deactivated (via Toggle, or auto deactivate).
 */
function DeActivated()
{
	UnRegisterObstacle();
}


/** Grabs reference to the node and starts the idle animation */
simulated function InitializeAnimations()
{
	FullBodySlot = GearAnim_Slot(Mesh.FindAnimNode('Custom_FullBody'));
	CurrentAnimation = EGG_Idle;
	FullBodySlot.PlayCustomAnim(EggAnimNames[CurrentAnimation], 1.f, 0.0f, 0.0f, true);
}

/**
 *  Setup up the effect components
 */
simulated function SetupEffectComponents()
{
}

/** Overridden to time the spawning with the hatch animation */
event bool GetSpawnSlot(out int out_SpawnSlotIdx, out vector out_SpawnLocation, out rotator out_SpawnRotation)
{
	if (bActive)
	{
		// if already in the spawning process
		if (bSpawning)
		{
			// and ready to spawn
			if (bAllowSpawn)
			{
				// turn off the spawn
				bAllowSpawn = FALSE;
				// and return the slot
				out_SpawnSlotIdx = 0;
				Mesh.GetSocketWorldLocationAndRotation('SpawnLocation',out_SpawnLocation,out_SpawnRotation);
				return true;
			}
			// otherwise keep waiting
		}
		else
		{
			// start the spawning process
			StartCracking();
		}
	}
	return false;
}

/** Set up the collision for what it should be after being opened */
simulated function PostOpenEggSetup()
{
	CollisionCylinderComponent.SetActorCollision(false, false);
	CollisionComponent.SetActorCollision(false, false);
	UnRegisterObstacle();
}

/** Starts playing the crack open animation and sets a delegate so we can play the cracked open idle animation */
simulated function StartCracking()
{
	local float AnimTime;

	// Let the system know we are in the process of spawning, but stop the spawning from actually happening until we're ready
	bSpawning = TRUE;
	bAllowSpawn = FALSE;

	// play the animation
	CurrentAnimation = EGG_Cracking;
	AnimTime = FullBodySlot.PlayCustomAnim(EggAnimNames[CurrentAnimation], 1.f, 0.0f, 0.0f, false);

	// Set the timer so we know when to play the cracked open idle
	SetTimer(AnimTime, FALSE, nameof(FinishedCracking));

	// Turn the chainsaw trigger on
	if (ChainsawTrigger != None)
	{
		ChainsawTrigger.SetTriggerEnable(true);
	}
}

/** Plays the cracked open idle animation and sets a timer for how long it should wait before opening */
simulated function FinishedCracking()
{
	local float CrackTime;

	// play the looping animation
	CurrentAnimation = EGG_CrackIdle;
	FullBodySlot.PlayCustomAnim(EggAnimNames[CurrentAnimation], 1.f, 0.0f, 0.0f, true);

	// Set a timer so we can transition to the opening animation
	CrackTime = MinCrackTime + (FRand() * (MaxCrackTime - MinCrackTime));
	CrackTime = (CrackTime < 0.0f) ? 0.0f : CrackTime;
	SetTimer(CrackTime, false, nameof(StartOpening));
}

/** Starts playing the opening animation, sets a delegate to play the open-idle animation and an anim notify will tell us when to spawn the larva */
simulated function StartOpening()
{
	local float AnimTime;

	// play the animation
	CurrentAnimation = EGG_Open;
	AnimTime = FullBodySlot.PlayCustomAnim(EmergeAnimNames[EmergeAnim], 1.f, 0.0f, 0.0f, false);

	// Set the timer so we know when to play the open idle
	SetTimer(AnimTime, FALSE, nameof(FinishedOpening));

	// Turn the chainsaw trigger off
	if (ChainsawTrigger != None)
	{
		ChainsawTrigger.SetTriggerEnable(false);
	}

	// Initialize the material parameter
	InitEmergeMaterials();
}

/** Initialize the material parameters */
simulated function InitEmergeMaterials()
{
	if (InnerGlowMaterial == None)
	{
		InnerGlowMaterial = new(Outer) class'MaterialInstanceConstant';
		InnerGlowMaterial.SetParent(Mesh.GetMaterial(0));
		Mesh.SetMaterial(0, InnerGlowMaterial);
		InnerGlowMaterial.SetScalarParameterValue('Inner_Glow', 3.0f);
	}

	if (MembraneMaterial == None)
	{
		MembraneMaterial = new(Outer) class'MaterialInstanceConstant';
		MembraneMaterial.SetParent(Mesh.GetMaterial(1));
		Mesh.SetMaterial(1, MembraneMaterial);
		MembraneMaterial.SetScalarParameterValue('Fade', 5.0f);
	}

	TimeOfEmerge = WorldInfo.TimeSeconds;
}

/** Overloaded to handle the material params */
simulated function Tick(float DeltaTime)
{
	local float TimeSinceEmgerge;
	local float ParamValue;

	if (TimeOfEmerge > 0)
	{
		TimeSinceEmgerge = WorldInfo.TimeSeconds - TimeOfEmerge;
		if (TimeSinceEmgerge < 5.0f)
		{
			if (InnerGlowMaterial != None)
			{
				ParamValue = 1.0f - (TimeSinceEmgerge / 4.4f);
				ParamValue = FClamp(ParamValue, 0.0f, 1.0f);
				InnerGlowMaterial.SetScalarParameterValue('Inner_Glow', ParamValue * 3.0f);
			}

			if (MembraneMaterial != None)
			{
				ParamValue = 1.0f - (TimeSinceEmgerge / 1.4f);
				ParamValue = FClamp(ParamValue, 0.0f, 1.0f);
				MembraneMaterial.SetScalarParameterValue('Fade', ParamValue * 5.0f);
			}
		}
		else
		{
			TimeOfEmerge = 0.0f;
		}
	}

	Super.Tick(DeltaTime);
}

/** Plays the opened idle animation - an anim notify will determine when to spawn the larva */
simulated function FinishedOpening()
{
	// play the looping animation
	CurrentAnimation = EGG_OpenIdle;
	FullBodySlot.PlayCustomAnim(EmergeIdleAnimNames[EmergeAnim], 1.f, 0.0f, 0.0f, true);
	PostOpenEggSetup();
}

/** Starts playing the death animation, sets a delegate to play the death idle animation */
simulated function StartDeath()
{
	// Clear any timers
	ClearTimer(nameof(FinishedCracking));
	ClearTimer(nameof(StartOpening));
	ClearTimer(nameof(FinishedOpening));

	// play the animation
	CurrentAnimation = EGG_Death;
	SetTimer(1.5f, false, nameof(StartDeathAnimation));

	// Turn the chainsaw trigger off
	if (ChainsawTrigger != None)
	{
		ChainsawTrigger.SetTriggerEnable(false);
	}

	// Initialize the material parameter
	InitEmergeMaterials();
}

/** Actually play the death animation now */
simulated function StartDeathAnimation()
{
	local float AnimTime;

	AnimTime = FullBodySlot.PlayCustomAnim(EggAnimNames[CurrentAnimation], 1.f, 0.0f, 0.0f, false);
	// Set the timer so we know when to play the death idle
	SetTimer(AnimTime, FALSE, nameof(FinishedDeath));

}

/** Plays the death idle animation */
simulated function FinishedDeath()
{
	// play the looping animation
	CurrentAnimation = EGG_DeathIdle;
	FullBodySlot.PlayCustomAnim(EggAnimNames[CurrentAnimation], 1.f, 0.0f, 0.0f, true);
	PostOpenEggSetup();
}

/** Take damage - take no damage through traditional means */
event TakeDamage( int Damage, Controller EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser);

/** Play the death animation and stop the spawner */
simulated function DoDeath()
{
	StartDeath();
	bActive = FALSE;
	DeActivated();
}

/** Set flag so we spawn the larva */
function ANIM_NOTIFY_SpawnLarva()
{
	bAllowSpawn = TRUE;
}

/** Called during the emerge animation */
simulated function ANIMNOTIFY_DoEmergeEffects()
{
	local GearExplosionActor ExplosionActor;
	local vector NewLoc;

	if (Mesh != None)
	{
		EmergeTemplate.InitFromContentTemplate();
		EmergeTemplate.Damage = 0;
		EmergeTemplate.DamageRadius = 0;
		NewLoc = Location;
		NewLoc.Z += 1.0f;
		ExplosionActor = Spawn(class'GearExplosionActor',,, NewLoc, Rotation);
		if (ExplosionActor != None)
		{
			ExplosionActor.Explode(EmergeTemplate);
		}
	}
}

/** Overloaded to handle spawning effects and to send creatures flying in the correct direction */
event HandleSpawn(GearPawn NewSpawn, int SlotIdx)
{
	local rotator Rot;
	local GearAI AI;
	local vector NewLoc;

	Super.HandleSpawn(NewSpawn,SlotIdx);

	// Set the proper rotation of the spawned creature
	Rot = NewSpawn.Rotation;
	NewSpawn.SetRotation( Rot );
	NewLoc = NewSpawn.Location;
	NewLoc.Z += 20.0f;
	NewSpawn.SetLocation(NewLoc);

	AI = GearAI(NewSpawn.Controller);
	if (AI != None)
	{
		AI.DoEmerge((EmergeAnim == EGG_EMERGE_A) ? SM_Emerge_Type1 : SM_Emerge_Type2);
	}
}

/**
 * script accessible function that builds the bounding shape for the navmesh obstacle 
 * Note: needs to return a CW wound convex shape!
 * @param shape - array of verts for cutting shape
 * @return TRUE if the shape creation was a success
 */
event bool GetObstacleBoudingShape(out array<vector> Shape)
{
	local vector Offset;

	// Clockwise!
	// top right corner
	Offset.X = CollisionCylinderComponent.CollisionRadius;
	Offset.Y = CollisionCylinderComponent.CollisionRadius;
	Shape.AddItem(Location + (Offset >> Rotation));
	// bottom right corner
	Offset.X = -CollisionCylinderComponent.CollisionRadius;
	Offset.Y = CollisionCylinderComponent.CollisionRadius;
	Shape.AddItem(Location + (Offset >> Rotation));
	// bottom left corner
	Offset.X = -CollisionCylinderComponent.CollisionRadius;
	Offset.Y = -CollisionCylinderComponent.CollisionRadius;
	Shape.AddItem(Location + (Offset >> Rotation));
	// top left corner
	Offset.X =  CollisionCylinderComponent.CollisionRadius;
	Offset.Y = -CollisionCylinderComponent.CollisionRadius;
	Shape.AddItem(Location + (Offset >> Rotation));

	return TRUE;
}

native function RegisterObstacle();
native function UnRegisterObstacle();


defaultproperties
{
	bEdShouldSnap=TRUE
	bBlockActors=true
	bCollideActors=true
	bWorldGeometry=FALSE
	bGameRelevant=TRUE
	bProjTarget=TRUE
	RemoteRole=ROLE_SimulatedProxy
	bAlwaysRelevant=true

	Begin Object Class=DynamicLightEnvironmentComponent Name=MyLightEnvironment
		LightShadowMode=LightShadow_Modulate
		bSynthesizeSHLight=FALSE
		bDynamic=FALSE
		bCastShadows=FALSE
		TickGroup=TG_DuringAsyncWork
		MinTimeBetweenFullUpdates=1.0f
		InvisibleUpdateTime=5.0f
	End Object
	Components.Add(MyLightEnvironment)

	Begin Object Class=SkeletalMeshComponent Name=EggSkelMesh
		CollideActors=true
		BlockActors=true
		BlockZeroExtent=true
		BlockNonZeroExtent=false
		BlockRigidBody=TRUE
		bCastDynamicShadow=false
		LightEnvironment=MyLightEnvironment
	End Object
	Mesh=EggSkelMesh
	CollisionComponent=EggSkelMesh
	Components.Add(EggSkelMesh)

	Begin Object Class=CylinderComponent Name=CollisionCylinder
		CollisionRadius=50.0f
		CollisionHeight=100.0f
		BlockNonZeroExtent=TRUE
		BlockZeroExtent=FALSE
		BlockActors=TRUE
		CollideActors=TRUE
	End Object
	CollisionCylinderComponent=CollisionCylinder
	Components.Add(CollisionCylinder)


	Begin Object Class=StaticMeshComponent Name=Skirt
	CollideActors=false
	BlockActors=false
	BlockZeroExtent=false
	BlockNonZeroExtent=false
	BlockRigidBody=false
// 		CollideActors=true
// 		BlockActors=true
// 		BlockZeroExtent=true
// 		BlockNonZeroExtent=true
// 		BlockRigidBody=true
		HiddenGame=false
		AlwaysLoadOnClient=true
		bCastDynamicShadow=false
		LightEnvironment=MyLightEnvironment
	End Object
	Components.Add(Skirt)

	EggAnimNames(EGG_Idle)="Idle"
	EggAnimNames(EGG_Cracking)="Cracking"
	EggAnimNames(EGG_CrackIdle)="Cracking_Idle"
	EggAnimNames(EGG_Death)="Death"
	EggAnimNames(EGG_DeathIdle)="Death_Idle"

	MinCrackTime=10.0f
	MaxCrackTime=20.0f

	EmergeAnimNames(EGG_EMERGE_A)="Opening"
	EmergeAnimNames(EGG_EMERGE_B)="Opening_b"
	EmergeIdleAnimNames(EGG_EMERGE_A)="Opening_Idle"
	EmergeIdleAnimNames(EGG_EMERGE_B)="Opening_b_Idle"
}
