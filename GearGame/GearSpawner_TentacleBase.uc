/**
* Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
*
*/
class GearSpawner_TentacleBase extends GearSpawner
	DependsOn(GearPawn)
	abstract;


/** The mesh of the spawner */
var() SkeletalMeshComponent Mesh;

/** Particle for when the spawner initially opens up from the tentacle */
var ParticleSystem SpawnParticleEffect;
/** Reference to the particle system component for SpawnParticleEffect */
var ParticleSystemComponent SpawnParticleComp;

/** The lighting environment for this spawner's mesh */
var() const LightEnvironmentComponent LightEnvironment;

/** Whether this spawner has opened or not */
var repnotify bool bOpen;
/** Counter so we know when to start a spawning particle effect */
var repnotify int SpawnCount;

/** Noise played when something spawns from the tentacle */
var SoundCue SpawnNoise;

/** Cached custom anim node sequence reference */
var GearAnim_Slot FullBodySlot;

/** Whether this spawner is going to visibly burst open and play sounds */
var() bool bIsBurstingSpawner;

/** Whether or not to display the mesh for this spawner */
var() repnotify bool bHideMesh;


/** Variables to replicate */
replication
{
	if (ROLE==ROLE_Authority && bNetDirty)
		bOpen,SpawnCount,bHideMesh;
}

/** Replicated variable notification */
simulated event ReplicatedEvent(name VarName)
{
	// Clients need to open the spawner
	if (VarName == 'bOpen')
	{
		if(bOpen)
		{
			PlayOpenAnimation();
		}
	}
	// Clients need to play spawn effects
	else if(VarName == 'SpawnCount')
	{
		PlaySpawnEffects();
	}
	// Hide/Show the mesh
	else if (VarName == 'bHideMesh')
	{
		Mesh.SetHidden(bHideMesh);
	}
	else
	{
		Super.ReplicatedEvent(VarName);
	}
}

/** Adjust the spawn locations and grab any anim references needed */
simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	// Adjust the spawn locations via the drawscale
	SpawnSlots[0].LocationOffset *= DrawScale;
	// Cache fullbody slot
	FullBodySlot = GearAnim_Slot(Mesh.FindAnimNode('Custom_FullBody'));
	// Set mesh visibility
	Mesh.SetHidden(bHideMesh);
}

/** Plays effects and sounds when a creature spawns */
simulated function PlaySpawnEffects()
{
	if (bIsBurstingSpawner)
	{
		// Set up and play the spawn effect
		SpawnParticleComp.SetTemplate(SpawnParticleEffect);
		SpawnParticleComp.SetHidden(FALSE);
		SpawnParticleComp.ActivateSystem();
		// Play the spawn sound
		PlaySound(SpawnNoise);
	}
}

/** Plays the burst open animation */
simulated function PlayOpenAnimation()
{
	FullBodySlot.PlayCustomAnim('Burst', 1.f, 0.2f, 0.2f, FALSE);
}

/** Kismet action handler for making the spawner open up */
function OnToggle(SeqAct_Toggle Action)
{
	Super.OnToggle(Action);
	Open();
}

/** Make the spawner open up and set the flag that will allow the client to do the same */
function Open()
{
	bOpen = true;
	PlayOpenAnimation();
	SetTimer(0.5f,FALSE,nameof(BumpPlayers));
}

/** Make any players near the spawner push back and take damage */
simulated final function BumpPlayers()
{
	local GearPawn_COGGear Victim;

	foreach VisibleCollidingActors(class'GearPawn_COGGear', Victim, 384, Location)
	{
		if (Victim.Base == self)
		{
			Victim.SetBase(None);
			Victim.AddVelocity(vector(Rotation) * 200  + vect(0,0,200),Victim.Location,class'GDT_EmergenceHoleOpening');
		}
	}
}

/** Overloaded to handle spawning effects and to send creatures flying in the correct direction */
event HandleSpawn(GearPawn NewSpawn, int SlotIdx)
{
	local rotator Rot;

	Super.HandleSpawn(NewSpawn,SlotIdx);

	// Set the proper rotation of the spawned creature
	Rot = NewSpawn.Rotation;
	NewSpawn.SetRotation( Rot );

	// If the spawner isn't open yet and someone is spawning a creature already, go ahead and open the spawner
	if (!bOpen &&
		WorldInfo.NetMode != NM_DedicatedServer)
	{
		Open();
	}

	// Increment counter so the client will play any spawn effects
	SpawnCount++;
	// Play the spawn effects
	PlaySpawnEffects();
}

defaultproperties
{
	bBlockActors=FALSE
	bCollideActors=TRUE
	bWorldGeometry=FALSE
	bGameRelevant=TRUE
	bProjTarget=TRUE
	RemoteRole=ROLE_SimulatedProxy
	bAlwaysRelevant=true
	bMovable=true
	bRouteBeginPlayEvenIfStatic=true
	SpawnSlots(0)=(LocationOffset=(X=0,Y=0,Z=0))
	bIsBurstingSpawner=true
}
