/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearPinataCandy extends DroppedPickup;

/** visual mesh component */
var StaticMeshComponent Mesh;
/** list of potential meshes of which one will be attached */
var array<StaticMesh> PossibleMeshes;
/** trail emitter */
var ParticleSystemComponent TrailEffect;
/** sound played when picked up */
var SoundCue PickupSound;
/** sound played when we bounce off a surface */
var SoundCue BounceSound;

/** how many points a player gets for picking this up */
var int ScoringValue;

simulated event PostBeginPlay()
{
	// choose a random visual mesh
	Mesh.SetStaticMesh(PossibleMeshes[Rand(PossibleMeshes.length)]);
	AttachComponent(Mesh);

	Super.PostBeginPlay();
}

function GiveTo(Pawn P)
{
	local GearPC GPC;
	local int Amount;

	Amount = GearPRI(P.PlayerReplicationInfo).ModifyScore(ScoringValue, eEXP_Objectives);

	GPC = GearPC(P.Controller);
	if (GPC != None)
	{
		GPC.ClientAddKillPoints(Amount);
	}

	PlaySound(PickupSound);

	Super.GiveTo(P);
}

// ignore encroachment
event EncroachedBy(Actor Other);

simulated event Landed(vector HitNormal, Actor FloorActor)
{
	// clear component and return to pool
	if (TrailEffect != None)
	{
		TrailEffect.DeactivateSystem();
	}
	SetPhysics(PHYS_None);
}

simulated event HitWall(vector HitNormal, Actor Wall, PrimitiveComponent WallComp)
{
	local float Speed;

	if (Pawn(Wall) == None)
	{
		Velocity = 0.6 * ((Velocity dot HitNormal) * HitNormal * -2.0 + Velocity);   // Reflect off Wall w/damping
		Speed = VSize(Velocity);

		if (Velocity.Z > 400)
		{
			Velocity.Z = 0.5 * (400 + Velocity.Z);
		}

		// if we've slowed down enough, stop bouncing
		if (Speed <= 40.0)
		{
			bBounce = false;
			Landed(HitNormal, Wall);
		}
		else
		{
			PlaySound(BounceSound, true);
		}
	}
}

auto state Pickup
{
	function bool ValidTouch(Pawn Other)
	{
		// make sure its a live human player that can pick up hats
		if ( Other == None || !Other.bCanPickupInventory || (Other.DrivenVehicle == None && Other.Controller == None) ||
			PlayerController(Other.Controller) == None )
		{
			return false;
		}
		// make sure game will let player pick me up
		else
		{
			return WorldInfo.Game.PickupQuery(Other, Inventory.class, self);
		}
	}

	event BeginState(name PreviousStateName);
}

defaultproperties
{
	Begin Object Class=ParticleSystemComponent Name=ParticleFX
		Template=ParticleSystem'LD_Mutators_All.Effects.Party_Paper1b'
	End Object
	TrailEffect=ParticleFX
	Components.Add(ParticleFX)

	Begin Object Class=StaticMeshComponent Name=TheMeshComp
		CollideActors=false
	End Object
	Mesh=TheMeshComp

	PossibleMeshes[0]=StaticMesh'LD_Mutators_All.Mesh.Pinata_Mesh1'
	PossibleMeshes[1]=StaticMesh'LD_Mutators_All.Mesh.Pinata_Mesh2'
	PossibleMeshes[2]=StaticMesh'LD_Mutators_All.Mesh.Pinata_Mesh3'
	PossibleMeshes[3]=StaticMesh'LD_Mutators_All.Mesh.Pinata_Mesh4'

	PickupSound=SoundCue'Interface_Audio.Pinata.PinataCoinPickup01_Cue'
	BounceSound=SoundCue'Interface_Audio.Pinata.PinataCoinBounce_01_Cue'

	Physics=PHYS_Falling
	bBounce=true
	LifeSpan=30.0
}
