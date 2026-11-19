/**
 * MetaCorp SkywayPatrol
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoPawn_MetaCorp_SkywayPatrol extends NanoPawn_MetaCorp_RiotCop;

/** Attached JetPack actor */
var JetPack JetPack;
var AnimNodeAimOffset FlyDirAimOffset;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	JetPack = Spawn(class'JetPack',self);
	JetPack.SetBase( self,, Mesh, 'JetPack' );
	JetPack.SetRelativeLocation( vect(0,0,0) );
}

simulated function Destroyed()
{
	Super.Destroyed();

	JetPack.PlayExplode();
}

simulated function CacheAnimNodes()
{
	Super.CacheAnimNodes();
	FlyDirAimOffset = AnimNodeAimOffset(Mesh.FindAnimNode('FlyDirAimOffset'));
}

simulated function ClearAnimNodes()
{
	Super.ClearAnimNodes();
	FlyDirAimOffset = None;
}

simulated function UpdateAimOffsetNodes( float DeltaTime )
{
	local Vector X, Y, Z;
	local Vector VelDir;
	local Vector2D DesiredOffset;
	
	Super.UpdateAimOffsetNodes( DeltaTime );

	GetAxes( Rotation, X, Y, Z );
	VelDir = Normal(Velocity);


	DesiredOffset.X = VelDir DOT Y;
	DesiredOffset.Y = VelDir DOT X;
	
	// Set left/right lean
	FlyDirAimOffset.Aim.X = FInterpTo( FlyDirAimOffset.Aim.X, DesiredOffset.X, DeltaTime, 3.f );
	FlyDirAimOffset.Aim.Y = FInterpTo( FlyDirAimOffset.Aim.Y, DesiredOffset.Y, DeltaTime, 3.f );
}

simulated function bool CanFly()
{
	return (JetPack != None && JetPack.CanFly());
}

function StartFlying()
{
	if( CanFly() )
	{
		SetPhysics( PHYS_Flying );
		JetPack.SetEnabled( TRUE );
	}
}

function StopFlying()
{
	if( Physics == PHYS_Flying )
	{
		SetPhysics( PHYS_Falling );
		ZeroMovementVariables();
		Falling();

		if( JetPack != None )
		{
			JetPack.SetEnabled( FALSE );
		}
	}
}

function SetMovementPhysics()
{
	StartFlying();
	if( Physics != PHYS_Flying )
	{
		Super.SetMovementPhysics();
	}
}

function ApplyJuggle( float JuggleMag, float JuggleZ, Vector Dir, optional NanoPawn Juggler, optional bool bDoKnockBack )
{
	Super.ApplyJuggle( JuggleMag, JuggleZ, Dir, Juggler, bDoKnockBack );

	SetTimer( 0.25f + (0.5f * FRand()), FALSE, nameof(AttemptToRecoverFromJuggle) );
}

function AttemptToRecoverFromJuggle()
{
	local NanoAI AI;

	if( bJuggled && CanFly() )
	{
		bJuggled = FALSE;
		bKnockedDown = FALSE;
		bKnockDownOnLanding = FALSE;

		AI = NanoAI(Controller);
		if (AI != None)
		{
			AI.UnstunAI('Knockdown');
			AI.UnstunAI('Knockback');
		}
		if (!bImpaledOnSword)
		{
			SetMovementPhysics();
		}
	}
}

/** This will return the struct that holds all of the values for this specific pawn **/
simulated function NanoCausingChaosValueDatum GetDeathChaosValue()
{
	return class'NanoCausingChaosValues'.default.SkywayPatrolEliteKilled;
}

simulated event Falling()
{
	SetTimer( GetFallDuration()-0.5f, FALSE, nameof(PlayPreLand) );
	Super.Falling();
}

simulated function PlayPreLand()
{
	if( Physics == PHYS_Falling )
	{
		FullBodySlot.PlayCustomAnim('JetPack_PreLand', 1.0, 0.1, 0.1, FALSE, TRUE);
	}
}

simulated event PlayLanded( float ImpactVel )
{
	FullBodySlot.PlayCustomAnim('JetPack_Land', 1.0, 0.1, 0.1, FALSE, TRUE);
}

defaultproperties
{
	ControllerClass=class'NanoAI_SkyPatrol'

	Begin Object Name=NanoPawnMesh
		SkeletalMesh=SkeletalMesh'MET_ShockTrooperProto.SK_MET_ShockTrooper_Proto'
		PhysicsAsset=PhysicsAsset'MET_ShockTrooperProto.SK_MET_ShockTrooper_Proto_Physics'
		AnimSets.Add(AnimSet'MET_ShockTrooperProto.AS_MET_ShockTrooper_Proto')
		AnimSets.Add(AnimSet'REB_AnyaProto.AS_REB_AnyaProto_Civilian')
		AnimTreeTemplate=AnimTree'MET_ShockTrooperProto.AT_SkyPatrolProto'
		Translation=(Z=-88.0)
	End Object

	LeftHandSocketName="Weapon_L"
	RightHandSocketName="Weapon_R"

	AimAttractors(0)=(OuterRadius=64.f,InnerRadius=4.f,BoneName="b_MF_Spine_02")
	AimAttractors(1)=(OuterRadius=32.f,InnerRadius=10.f,BoneName="b_MF_Head")
	AimAttractors(2)=(OuterRadius=32.f,InnerRadius=10.f,BoneName="b_MF_Calf_L")
	AimAttractors(3)=(OuterRadius=32.f,InnerRadius=10.f,BoneName="b_MF_Calf_R")

	bCanFly=TRUE

	BatonClass=class'NanoWeap_BatonEMP'
}