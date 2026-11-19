/**
 * This is the Nanite Tornado's actor which will be spawned in the world and can persist and have some extra
 * behavior associated with it
 * 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NaniteTornado extends Actor;

/** The effect to play when for the Nanite Tornado when it is spawned **/
var ParticleSystem NaniteTornadoSpawnEffect;
var transient SpawnedNanoEmitter NaniteTornadoFunnel;
var SoundCue NaniteTornadoSpawnSound;


var const Vector DefaultTwister_Scale;

var const Vector DefaultTornado_Width;


var transient bool bFullTornadoPower;


var protected CylinderComponent CylinderComponent;


/** This is who spawned the nanite tornado that is about to kill this guy **/
var Controller NaniteTornadoInstigator;

/** This is our force field for attacting orbitals.  (we probably want to make this be a generic tornado forcefield that can attact all sorts of things **/
var NanoForceField_OrbitalAttractorTornado OrbitalsAttact;


/** This is the stun type a nanite tornado gives a pawn**/
var name StunType;


simulated event PostBeginPlay()
{
	super.PostBeginPlay();
}


simulated function StartMiniTornado( Actor Target, Controller InNaniteTornadoInstigator )
{
	local vector SpawnLocation;


	NaniteTornadoInstigator = InNaniteTornadoInstigator;

	SpawnLocation = Target.Location - (vect(0,0,1) * 88.0f); // hack for now

	NaniteTornadoFunnel = Spawn( class'SpawnedNanoEmitter',,, SpawnLocation, rot(0,0,0) );
	NaniteTornadoFunnel.SetTemplate( NaniteTornadoSpawnEffect, TRUE );
	// set the size of the tornado to be smaller than max
	NaniteTornadoFunnel.ParticleSystemComponent.SetVectorParameter( 'Twister_Scale', vect(0.2f, 0.2f, 0.75f) );
	NaniteTornadoFunnel.ParticleSystemComponent.SetVectorParameter( 'Tornado_Width', vect(0.0f, 15.0f, 0.0f) );
    NaniteTornadoFunnel.SetBase( self );
	SetBase( Target );
}


simulated function InvokeFullTornado()
{
	local NanoPawn NP;

	`log( "InvokeFullTornado" );
	// make the tornado big!
	bFullTornadoPower = TRUE;
	SetBase( none );
	NaniteTornadoFunnel.ParticleSystemComponent.SetVectorParameter( 'Twister_Scale', DefaultTwister_Scale );		
	NaniteTornadoFunnel.ParticleSystemComponent.SetVectorParameter( 'Tornado_Width', DefaultTornado_Width );

	// so here we need to check all of the pawns that might be near us and then ask if we are overlapping with them
	// as the Touch event doesn't fire for actors already inside our collision cylinder
	foreach VisibleCollidingActors( class'NanoPawn', NP, CylinderComponent.CollisionRadius, Location, TRUE )
	{
		if( ( IsOverlapping( NP ) == true ) && ( NanoPawn_RebelsBase(NP) == none ) )
		{
		   KillDueTornado( NP );
		}
	}


	AddAnOrbitalAttractorTornado( 150.0f, -100.0f );

}


simulated function ShutDownTornado()
{
	SetCollision( FALSE, FALSE, FALSE ); // turn off collision so we don't throw them up into the air on touch
	NaniteTornadoFunnel.ParticleSystemComponent.DeactivateSystem();
	NaniteTornadoFunnel = none;

	OrbitalsAttact.bForceActive = FALSE;
	OrbitalsAttact = none;
}


/** **/
event Touch( Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal )
{	
	local NanoPawn NP;
	//`log( "NaniteTornado Touch:" @ Other );

	if( bFullTornadoPower == TRUE )
	{
		NP = NanoPawn(Other);
	    if( ( NP != none ) 
			&& ( NP.Health > 0 )
	    	&& ( NanoPawn_RebelsBase(NP) == none )   // don't toss rebels
	    	)
	    {
			NP.AffectedByTornado = self;
	    }
	}
}


simulated function KillDueTornado( NanoPawn NP )
{
	//`log( "KillDueTornado KnockbackKnockbackKnockback" ); 
	NP.Knockback( (NP.NaniteTornadoUpVelocity*vect(0,0,1)), TRUE, StunType );
	
	if( NP.PSC_NaniteTornadoEjectTrail == none )
	{
		NP.PSC_NaniteTornadoEjectTrail = new(NP) class'NanoParticleSystemComponent';
	    NP.PSC_NaniteTornadoEjectTrail.SetTemplate( NP.PS_NaniteTornadoEjectTrail );
	    //NP.Mesh.AttachComponentToSocket( NP.PSC_NaniteTornadoEjectTrail, NP.GhostDashTrailName );
	}
	NP.PSC_NaniteTornadoEjectTrail.ActivateSystem();	
	
	NP.NaniteTornadoInstigator = NaniteTornadoInstigator;
	NP.SetTimer( 2.0f, FALSE, nameof(NP.KillPawnDueToNaniteTornado) );

}

simulated function AddAnOrbitalAttractorTornado( float InRadius, float InStrength )
{
	OrbitalsAttact = Spawn( class'NanoForceField_OrbitalAttractorTornado', self,,Location+vect(0,0,750) );
	OrbitalsAttact.Shape = new(OrbitalsAttact) class'ForceFieldShapeCapsule';

    OrbitalsAttact.bForceActive = FALSE;

	OrbitalsAttact.ForceHeight = 1500;
	OrbitalsAttact.ForceTopRadius = 150;
	OrbitalsAttact.ForceRadius = 150;

    OrbitalsAttact.RadialStrength = -25;
	OrbitalsAttact.RotationalStrength = 1;
	OrbitalsAttact.LiftStrength = 20;

	OrbitalsAttact.LiftFalloffHeight = 0.9f;
	OrbitalsAttact.EscapeVelocity = 100000000.0f;

	OrbitalsAttact.HeightOffset = 0;
	OrbitalsAttact.SelfRotationStrength = 0;
	OrbitalsAttact.BSpecialRadialForceMode = FALSE;


    OrbitalsAttact.SetHardAttach( TRUE );
	OrbitalsAttact.SetBase( self );

	OrbitalsAttact.DoInitRBPhys();

	OrbitalsAttact.bForceActive = TRUE;
	//OrbitalsAttractList.AddItem( OrbitalsAttact );
}




defaultproperties
{
	NaniteTornadoSpawnSound=SoundCue'Gameplay_Audio.Dusting.Nanite_Tornado_Cue'
	NaniteTornadoSpawnEffect=ParticleSystem'Nano_Effects_Ghost.Effects.P_Nano_Effects_GhostTornado'
	   //Twister_Scale - multiplier for width of geometric tornado
       //Tornado_Width - radius of ground effect

	DefaultTwister_Scale=(X=1.0f,Y=1.0f,Z=1.0f)
	DefaultTornado_Width=(X=0.0f,Y=150.0f,Z=0.0f)


	Begin Object Class=CylinderComponent NAME=CollisionCylinder
		CollisionRadius=150.0
		CollisionHeight=1500.0
		CollideActors=TRUE
	End Object
	CylinderComponent=CollisionCylinder
	CollisionComponent=CollisionCylinder
	Components.Add(CollisionCylinder)

	bCollideActors=true
	bCollideWorld=false
	bBlockActors=false
	bIgnoreEncroachers=true

	bStatic=false
	RemoteRole=ROLE_SimulatedProxy

	StunType="NaniteTornado"

}