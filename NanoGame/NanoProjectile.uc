/**
 * Base class for Nano Projectiles
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoProjectile extends Projectile
	native(Weapon)
	config(Weapon);

// this should be promoted to GameFramework  (and need to relook at the UT3 Projectile so we can grab some of its sweet functionality)


/** TRUE to suppress all audio effects for this projectile, FALSE otherwise */
var bool								bSuppressAudio;

/** Multiplier affecting how much gravity to apply to this projectile. */
var() float								GravityScale;

/** Internal.  The AC for the active in-flight sound **/
var protected transient AudioComponent	InFlightSound;
/** SoundCue to use for looping in-flight audio. */
var() protected const SoundCue			InFlightSoundTemplate;
/** True if the InFlightAudio loop should start immediately, false otherwise. */
var() protected const bool				bAutoStartInFlightAudio;

var() bool								bAddBaseVelocity;

/** World velocity of the projectile's frame of reference at the time of firing. */
var transient repnotify vector			InitialFrameOfRefVelocity;

/** Trail Particle System */
var	protected const ParticleSystem		TrailTemplate;
/** Trail emitter */
var transient SpawnedNanoEmitter		TrailEmitter;

var	DynamicLightEnvironmentComponent	ProjLightEnvironment;

var	bool								bIgnoreInstigatorCollision;

/** If TRUE, should be stopped by GrenadeBlockingVolume */
var	bool								bStoppedByGrenadeBlockingVolume;
/** How large the radius of perturbation is when we hit a fluid surface */
var	float								FluidForceRadius;



//
// Internal simulation variables.
//

/** Simulate gravity */
var() const protected bool	bPerformGravity;

/** Length of the fixed timestep for grenade simulation. */
var protected const float			SimFixedTimeStep;
/** Used by simulation code to run gravity on a fixed timestep. */
var protected transient const float	TimeTilNextGravUpdate;
/** Used by simulation code to track mid-simulation gravity advances on collisions. */
var protected transient const float SimInternalGravityAdvanceTime;

/** Melee weapon is capable of reflecting this proj */
var(Reflect) bool	bReflectable;
/** Next time a reflection is allowed on this proj */
var(Reflect) float	NextReflectTime;
/** Number of times this proj has been reflected */
var(Reflect) byte	ReflectCount, OldReflectCount;
/** Amount of time after a bad reflect that proj should explode */
var(Reflect) config	float	BadReflectDetonateTime;
var(Reflect) config	float	GoodReflectDetonateTime;

var(Reflect)	config float			ReflectZBoost;
var(Reflect)	Vector					ReflectDir;
var(Reflect)	float					ReflectRatio;
var(Reflect)	int						ReflectDataIdx;
var(Reflect)	class<NanoWeap_Melee>	ReflectWpnClass;
var(Reflect)	Pawn					ReflectTarget;

var(Reflect) bool	bDisplayReflectIcon;
var(Debug)	 bool	bDebugReflect;


// Homing Variables
var			Vector	TravelDirection;
var			Actor	HomeTarget;
var			vector  HomeLocation;			// home to the specified location if hometarget == none
var config	float	HomeLeadPct;
var config	float	HomeAccelScale;
var			bool	bHomeToTarget, bHomeToLocation;
var			bool	bPerfectHome;
var	repnotify		bool	bExploded;


/** This is the sound to play when this projectile gets close to a Human Player **/
var SoundCue ProximitySound;
/** Internal.  The AC for the active ProximitySound sound **/
var protected transient AudioComponent ProximitySoundAC;

/** Distance at which we play the proximity sound **/
var float ProximitySoundDistance;

cpptext
{
	virtual void TickSpecial( FLOAT DeltaSeconds );
	virtual UBOOL IgnoreBlockingBy( const AActor *Other ) const;

	virtual void processHitWall( const FCheckResult& Hit, FLOAT TimeSlice = 0.0f );
	virtual void physProjectile( FLOAT DeltaTime, INT Iterations );
}

replication
{
	if( Role == ROLE_Authority && bNetDirty )
		bExploded, bHomeToTarget, bHomeToLocation, InitialFrameOfRefVelocity;

	if( Role == ROLE_Authority && bNetDirty && bHomeToTarget )
		HomeTarget;

	if( Role == ROLE_Authority && bNetDirty && bHomeToLocation )
		HomeLocation;

	if( Role == ROLE_Authority && bNetDirty && (bHomeToTarget || bHomeToLocation) )
		HomeAccelScale;
}

simulated function PostBeginPlay()
{
	super.PostBeginPlay();

	Acceleration.X = 0;
	Acceleration.Y = 0;
	Acceleration.Z = GetGravityZ() * GravityScale;
	//`log( "Acceleration.Z" @ Acceleration.Z @ GetGravityZ() @ GravityScale );

	if (!bSuppressAudio && bAutoStartInFlightAudio)
	{
		StartInFlightAudio();
	}

	if (TrailTemplate != None)
	{
		SpawnTrail();
	}
}

simulated event ReplicatedEvent( name VarName )
{
	Super.ReplicatedEvent( VarName );

	switch( VarName )
	{
		case 'bExploded':
			Explode( Location, Normal(Velocity) );
			break;
	}
}


simulated function Tick(float DeltaTime)
{
	super.Tick(DeltaTime);

    PossiblyPlayProximitySound();
}


/** 
 *  This will check to see if the projectile is close to a player.  If it is then it will play a proximity sound.
 *  This will allow us to have a sort of doppler affect when the projectile goes zooming past a player within the ProximitySoundDistance.
 **/
simulated function PossiblyPlayProximitySound()
{
	local PlayerController PC;
	local bool bNearAPlayer;

	// check to see if we should play the sound for the Proximity or not
	if( ( bExploded == FALSE )
		&& ( ProximitySound != None) 
		&& ( ( ProximitySoundAC == None ) 
		      || ( ProximitySoundAC.IsPlaying() == FALSE ) ) // we need to test this as ProximitySoundAC will be a valid ref until GC occurs so for cases where players are lined up in a row you want another Proximity sound to play
		)
	{
		// check to see if we are near a player
		foreach LocalPlayerControllers( class'PlayerController', PC )
		{
			if( ( PC.Pawn != none ) && ( VSize(PC.Pawn.Location - Location) < ProximitySoundDistance ) )
			{
            	bNearAPlayer = TRUE;
				break;
			}
		}

		if ( bNearAPlayer == TRUE )
		{
			ProximitySoundAC = CreateAudioComponent( ProximitySound, FALSE, FALSE, FALSE,, TRUE ); 
			if( ProximitySoundAC != None )
			{
				//`log( "PossiblyPlayProximitySound" @ VSize(Velocity) );
				ProximitySoundAC.FadeIn(0.001f, 1.f);
			}
		}
	}
}


simulated function StopSpecialActions()
{
	bHomeToTarget	= FALSE;
	bHomeToLocation = FALSE;
}

simulated reliable server final function SetTravelDirection( Vector NewDirection )
{
	TravelDirection = NewDirection;
	if( Role == ROLE_Authority ) 
	{
		ClientSetTravelDirection( TravelDirection.X, TravelDirection.Y, TravelDirection.Z );
	}
}

simulated reliable client final function ClientSetTravelDirection( float X, float Y, float Z )
{
	TravelDirection.X = X;
	TravelDirection.Y = Y;
	TravelDirection.Z = Z;
}

final simulated function SetHomeToTarget( Actor Target, float AccelSpeed, bool bPerfect )
{
	//debug
	`log( "SetHomeToTarget"@Target@AccelSpeed@bPerfect, bDebugReflect );

	bHomeToTarget	= true;
	HomeTarget		= Target;
	bPerfectHome	= bPerfect;
	HomeAccelScale  = AccelSpeed;
}

final simulated function SetHomeToLocation( Vector Loc, float AccelSpeed, bool bPerfect )
{
	bHomeToLocation = true;
	HomeLocation	= Loc;
	bPerfectHome	= bPerfect;
	HomeAccelScale	= AccelSpeed;
}


/** Spawn trail behind projectile. */
simulated protected function SpawnTrail()
{
	if ( (WorldInfo.NetMode != NM_DedicatedServer) && (TrailTemplate != None) )
	{
		// @todo look to moving this to the object pool
		TrailEmitter = Spawn(class'SpawnedNanoEmitter', Self);
		if( TrailEmitter != None )
		{
			TrailEmitter.bPostUpdateTickGroup = true;
			TrailEmitter.SetTemplate(TrailTemplate, false );
			TrailEmitter.SetBase( Self );
		}
	}
}

simulated protected function StopInFlightAudio()
{
	if (InFlightSound != None)
	{
		InFlightSound.FadeOut(0.250f, 0.f);
		InFlightSound = None;
	}
}

simulated protected function StartInFlightAudio()
{
	if( (InFlightSound == None) &&
		(InFlightSoundTemplate != None) &&
		(WorldInfo.NetMode != NM_DedicatedServer)
		)
	{
		InFlightSound = CreateAudioComponent( InFlightSoundTemplate, TRUE, TRUE );
		if(InFlightSound != None)
		{
			InFlightSound.bAutoDestroy = TRUE;
			InFlightSound.Location = Location;
			AttachComponent( InFlightSound );
			InFlightSound.FadeIn(0.250f, 1.f);
		}
	}
}

simulated function SuppressAudio(bool bSuppress)
{
	if (bSuppress && !bSuppressAudio)
	{
		// audio turning off, stop the inflight audio
		StopInFlightAudio();
	}
	else if (!bSuppress && bSuppress)
	{
		// audio turning on, restart flight sound
		StartInFlightAudio();
	}

	bSuppressAudio = bSuppress;
}

simulated function Destroyed()
{
	StopInFlightAudio();

	// Clean up trail if spawned
	if( TrailEmitter != None )
	{
		TrailEmitter.bDestroyOnSystemFinish = true;
		TrailEmitter.ParticleSystemComponent.DeactivateSystem();
		TrailEmitter.SetBase( None );
		TrailEmitter = None;
	}

	super.Destroyed();
}

function NanoProjInit( Vector Direction, optional Actor TargetActor )
{
	// call super first to get the vel set, then maybe adjust it
	Init( Direction );

	// tweak direction to account for motion of base
	if ( bAddBaseVelocity && (Instigator != None) && (Instigator.Base != None) && !Instigator.Base.bStatic )
	{
		// @fixme, this will not account for linear vel as a result of base rotation.
		// need to find a way to get that information.
		InitialFrameOfRefVelocity = Instigator.Base.Velocity + (Instigator.Base.AngularVelocity cross (Instigator.Location - Instigator.Base.Location));
		Velocity += InitialFrameOfRefVelocity;
		//		`log("adding base vel"@InitialFrameOfRefVelocity@"to old vel"@Direction*Speed@"newvel"@Velocity);
	}
	else
	{
		InitialFrameOfRefVelocity = vect(0,0,0);
	}
}

simulated function bool StopsProjectile(Projectile P)
{
	return FALSE;
}

/** Stops projectile simulation without destroying it.  Projectile is resting, essentially. */
simulated protected function StopSimulating()
{
	Velocity = vect(0,0,0);
	Acceleration = vect(0,0,0);
	RotationRate = rot(0,0,0);
	SetPhysics(PHYS_None);
	SetCollision(FALSE, FALSE);

	StopInFlightAudio();
	StopTrailEmitter();

	bRotationFollowsVelocity = FALSE;
}

simulated protected function StopTrailEmitter()
{
	if( TrailEmitter != None )
	{
		TrailEmitter.bDestroyOnSystemFinish = true;
		TrailEmitter.ParticleSystemComponent.DeactivateSystem();
		TrailEmitter.SetBase( None );
		TrailEmitter = None;
	}
}


/** Called when this actor touches a fluid surface */
simulated function ApplyFluidSurfaceImpact( FluidSurfaceActor Fluid, vector HitLocation)
{
	local float AdjustedVelocity;
	local Emitter SplashEmitter;

	if (bAllowFluidSurfaceInteraction)
	{
		AdjustedVelocity = 0.01 * Abs(Velocity.Z);
		Fluid.FluidComponent.ApplyForce( HitLocation, AdjustedVelocity * Fluid.FluidComponent.ForceImpact, FluidForceRadius, True );
	}

	if ( CanSplash() )
	{
		if ( WorldInfo.NetMode != NM_DedicatedServer && 
			(Instigator != None) && 
			Instigator.IsPlayerPawn() && 
			Instigator.IsLocallyControlled() )
		{
			SplashEmitter = NanoGRI(WorldInfo.GRI).NOP.GetImpactEmitter(Fluid.ProjectileEntryEffect, HitLocation, rotator(vect(0,0,1)));
			SplashEmitter.ParticleSystemComponent.ActivateSystem();
		}
	}
}

simulated final function AllowHitInstigator()
{
	bBlockedByInstigator = TRUE;
}

simulated function HandleReflectRatio( out ReflectData Data )
{
	// Damage/Stun modifications
	// Keep damage scaling of old instigator attached to projectile
	Damage *= Lerp( Data.DamageScale.X, Data.DamageScale.Y, ReflectRatio );
	if( Instigator != None ) 
	{
//		Damage *= NanoPawn(Instigator).DamageScaling;
	}
	//	StunTime   *= Lerp( Data.StunScale.X, Data.StunScale.Y, ReflectRatio );
}

simulated function bool IsOwningClient()
{
	return (WorldInfo.NetMode == NM_Standalone || (Instigator != None && Instigator.IsLocallyControlled()));
}

simulated final function Reflect( Pawn NewInst, float FOV, float Ratio, int AngleDev, bool bLeft, int DataIdx, class<NanoWeap_Melee> WpnClass, float Delay )
{
	local Vector	NewToOldDir, ViewDir, LeadVect;
	local float		ViewDotShooter, VelSize, TimeToTarg, DistToTarg;
	local Rotator	RandomRot;
	local ReflectData Data;
	local PlayerController PC;

	//debug
	`log( `location@`showvar(Instigator)@`showvar(NewInst)@`showvar(FOV), bDebugReflect );

	// Store variables for replication
	ReflectRatio	= Ratio;
	ReflectWpnClass = WpnClass;
	ReflectDataIdx  = DataIdx;
	if( NewInst != Instigator )
	{
		ReflectTarget = Instigator;
	}

	// Locally compute what we need
	Data		= WpnClass.default.ProjReflectList[DataIdx];
	ViewDir		= Vector(NewInst.GetViewRotation());

	if( Instigator != None ) 
	{
		VelSize		 = VSize( Velocity );
		NewToOldDir  = Instigator.Location - NewInst.Location;
		DistToTarg   = VSize( NewToOldDir );
		if( DistToTarg > 0.0 ) 
		{
			NewToOldDir /= DistToTarg;	//normalize NewToOldDir
		}

		// Check to see if initial shooter is within reflectors cone still
		ViewDotShooter = ViewDir DOT NewToOldDir;
		if( ViewDotShooter >= FOV ) 
		{
			// If yes, primary direction is to the shooter - add in lead time
			TimeToTarg	= DistToTarg / VelSize;
			LeadVect	= (Instigator.Velocity * TimeToTarg) * Data.LeadPct;
			ReflectDir	= Normal( (Instigator.Location + LeadVect) - NewInst.Location );
		}
		else 
		{
			// Otherwise, primary direction is along new instigator view
			ReflectDir = ViewDir;
		}
	}
	else 
	{
		// Otherwise, primary direction is along new instigator view
		ReflectDir = ViewDir;
	}

	// Randomize reflect dir
	// Get angle by adjusting ratio by fall off
	RandomRot.Yaw = Lerp( Data.Angle.X, Data.Angle.Y, ReflectRatio ** Data.AngleFallOff ) + AngleDev;
	if( bLeft ) 
	{ 
		ReflectDir = ReflectDir << RandomRot; 
	}
	else
	{ 
		ReflectDir = ReflectDir >> RandomRot; 
	}

	ReflectDir	  = Normal( ReflectDir );

	HandleReflectRatio( Data );

	Instigator	= NewInst;
	// Don't let it hit instigator too quickly again
	bBlockedByInstigator = FALSE;
	SetTimer( 0.5, FALSE, nameof(AllowHitInstigator));


	NextReflectTime	= WorldInfo.TimeSeconds + 0.5;

	// Clear owner so projectile can collide with the previous owner
	SetOwner( None );

	if( !IsOwningClient() ) 
	{
		// If on server
		if( Role == ROLE_Authority ) 
		{
			PC = PlayerController(Instigator.Controller);
		}
		else 
		{
			foreach LocalPlayerControllers( class'PlayerController', PC )
			{
				if( PC.Pawn == NewInst )
				{
					break;
				}
			}
		}

		// Change delay by players ping
		if( PC != None ) 
		{
//			Delay -= PC.GetPing();
			//debug
//			`log( self@"Delay by"@PC.GetPing(), bDebugReflect );
		}
	}

	//debug
	`log( self@"Timer: APPLYREFLECT"@Delay, bDebugReflect );

	ReflectCount++;

	if( Delay <= 0.0 )	
	{ 
		ApplyReflect(); 
	}
	else
	{ 
		SetTimer( Delay, FALSE, nameof(ApplyReflect) ); 
	}

	if( Data.Level <= 0 /*REFLECT_LEVEL_BAD*/ ) 
	{
// 		RandSpinRange( rng(10000, 196608) );
// 		bFixedRotationDir		 = TRUE;
// 		bRotationByVelocity		 = FALSE;
// 		bTrailRotationByVelocity = FALSE;
	}

	if( Role == ROLE_Authority ) 
	{
		ClientReflect( Instigator, ReflectDataIdx, ReflectWpnClass, ReflectDir.X, ReflectDir.Y, ReflectDir.Z );


//		ClientReflect( Instigator, ReflectRatio, ReflectDataIdx, ReflectWpnClass, ReflectDir * 1000, Delay );
	}
}

simulated final reliable client function ClientReflect( Pawn NewInst, int DataIdx, class<NanoWeap_Melee> WpnClass, float DirX, float DirY, float DirZ )
{
	local ReflectData Data;
//	local UCEmitter EM;
	local vector Dir;

	//debug
	`log(self @ Instigator @ "ClientReflect" @ NewInst @ DataIdx @ WpnClass, bDebugReflect);

	Instigator = NewInst;
	if( (WorldInfo.NetMode != NM_Client) || IsOwningClient() )
	{
		return;
	}

	//debug
	`log( "INSIDE CLIENT REFLECT", bDebugReflect );

	Data = WpnClass.default.ProjReflectList[DataIdx];

	// create Dir from components (replicated that way to avoid compression
	Dir.X = DirX;
	Dir.Y = DirY;
	Dir.Z = DirZ;
	// Set Velocity & Accel
	SetTravelDirection(Dir);
	Speed *= Lerp(Data.SpeedScale.X, Data.SpeedScale.Y, ReflectRatio);
	Velocity = Dir * Speed;
	Velocity.Z += ReflectZBoost;
	Acceleration = vect(0,0,0);
	SetRotation(rotator(Velocity));

	ReflectCount++;
	if( Data.Level <= class'NanoWeap_Melee'.const.REFLECT_LEVEL_BAD )
	{
/*		RandSpinRange( rng(10000, 196608) );
		bFixedRotationDir		 = true;
		bRotationByVelocity		 = false;
		bTrailRotationByVelocity = false;
*/
	}

	StopSpecialActions();

/*	// Apply travel sound cue
	if( AmbientSoundCue == 'None' && TravelCue != 'None' ) 
	{
		LocalPlaySoundCue( TravelCue, true );
	}
*/
	NextReflectTime	= WorldInfo.TimeSeconds + 0.5;

	if( WorldInfo.NetMode != NM_DedicatedServer )
	{
/*
		// Spawn effect
		EM = Spawn( WpnClass.default.ReflectLevelEmitterClass[Data.Level],,, Location, Rotation );
		if( EM != None )
		{
			WpnClass.static.ColorizeEffect( EM, UCPawn(Instigator).SpeciesClass.default.ReflectEffectColor );
		}
*/

		// Play reflect sound
		PlaySound( WpnClass.default.ReflectLevelSound[Data.Level] );
	}
}

simulated final function ApplyReflect()
{
	local ReflectData Data;
//	local UCEmitter EM;

	Data = ReflectWpnClass.default.ProjReflectList[ReflectDataIdx];

	StopSpecialActions();

/*
	// apply travel sound cue
	if( AmbientSoundCue == 'None' && TravelCue != 'None' )
	{
		LocalPlaySoundCue(TravelCue,true);
	}
*/

	//debug
	`log( self@"APPLY REFLECT - Home"@Data.HomeSpeed@ReflectTarget, bDebugReflect );

	if( Data.HomeSpeed > 0.0 && ReflectTarget != None ) 
	{
		SetHomeToTarget( ReflectTarget, Data.HomeSpeed, false );
	}

	// Set Velocity & Accel
	SetTravelDirection( ReflectDir );
	Speed			*= Lerp( Data.SpeedScale.X, Data.SpeedScale.Y, ReflectRatio );
	Velocity		 = ReflectDir * Speed;
	Velocity.Z		+= ReflectZBoost;
	Acceleration	 = vect(0,0,0);

	SetRotation( Rotator(Velocity) );

	NextReflectTime	= WorldInfo.TimeSeconds + 0.5;

	// Reset lifespan of projectile
	LifeSpan = default.LifeSpan;

	if( WorldInfo.NetMode != NM_DedicatedServer ) 
	{
/*
		// Spawn effect
		EM = Spawn( ReflectWpnClass.default.ReflectLevelEmitterClass[Data.Level],,, Location, Rotation );
		ReflectWpnClass.static.ColorizeEffect( EM, UCPawn(Instigator).SpeciesClass.default.ReflectEffectColor );
*/

		// Play reflect sound
		PlaySound( ReflectWpnClass.default.ReflectLevelSound[Data.Level] );
	}

	if( Data.Level == 0 /*REFLECT_LEVEL_BAD*/ ) 
	{
		SetTimer( BadReflectDetonateTime, FALSE, nameof(Detonate) );
	}
	else /* Good or perfect reflect */
	{
		SetTimer( GoodReflectDetonateTime, FALSE, nameof(Detonate) );
	}

	//debug
	`log( self@"REFLECTED - "@`showvar(Damage)@`showvar(Speed), bDebugReflect );
}

simulated final function Detonate()
{
	Explode( Location, Normal(Velocity) );
}


defaultproperties
{
	bReflectable=TRUE
	bPerformGravity=FALSE
	SimFixedTimeStep=0.05f		// 20 hz

	FluidForceRadius=10.0

	Begin Object Class=DynamicLightEnvironmentComponent Name=MyLightEnvironment
		bEnabled=TRUE
		InvisibleUpdateTime=5.0
		MinTimeBetweenFullUpdates=2.0
		TickGroup=TG_DuringAsyncWork
		bCastShadows=FALSE
	End Object
	ProjLightEnvironment=MyLightEnvironment
	Components.Add(MyLightEnvironment)

	bAutoStartInFlightAudio=TRUE
	bAddBaseVelocity=TRUE
	bNetTemporary=FALSE // disable so projectiles can be reflected

	LifeSpan=+0010.000000

	
//	bDebugReflect=TRUE
}

