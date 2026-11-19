/**
 * MetaCorp UrbanPacificationMek
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoPawn_MetaCorp_PacifierBotBase extends NanoPawn_MetaCorp_MechsBase
	implements(NanoInterface_TattlerBotDock)
	native(Pawn)
	abstract;

/** Particle system for jet exhaust when undocked from chassis */
var	protected const ParticleSystem		PS_ExhaustEffect;
/** Emitter to exhaust particle system */
var transient NanoEmitter				ExhaustEmitter;

var() StaticMeshComponent				ChestPlateComp;

struct native PacifierLimbInfo
{
	var() Name						LimbName;
	/** Limb class to spawn when created */
	var() class<Pacifier_LimbBase>	LimbClass;
	
	/** Reference to the limb that was created */
	var	  Pacifier_LimbBase			Limb;
};

/** List of limbs attached to this mech */
var array<PacifierLimbInfo>	LimbList;
var bool bChassisDestroyed;
/** Direct pointer to chassis */
var() Pacifier_LimbBase	Chassis;

/** Mek has undocked from the Chassis/legs */
var bool bUndocked;
/** Used to play full body anims on bot */
var NanoAnimBlendList	FullBodyNode;

/** Used to avoid physics collision doing damage too often */
var float	LastKActorImpactDamageTime;

struct native TattlerBotDock
{
	var() Name	SocketName;
	var() NanoPawn_MetaCorp_SentryBotBase Bot;
};
var() array<TattlerBotDock>	Docks;

/** This is the distance that tattlers have to be within for the pacbot to grab them **/
var protected float DistanceToGrabTattlers;

// SOUNDS
var protected SoundCue	DetachFromChassisCue;
var protected transient AudioComponent AC_HoverIdleLoop;
var protected SoundCue	HoverIdleLoopCue;
var protected SoundCue	HoverThrustCue;
var protected SoundCue	DestroyedCue;

var protected array<SoundCue> VO_Target;
var protected array<SoundCue> VO_Search;
var protected array<SoundCue> VO_Damage;
var protected array<SoundCue> VO_Affirmative;
var protected array<SoundCue> VO_Negative;

/** This the distance at which distance based performance will occur. **/
var protected float DistanceBasedPerformance;

/** This stores whether or not we have distance based PerformanceSettings on or not.  We use this so we don't constantly set Performance values which may reattach and replicate. **/
var transient bool bCurrDistanceBasedPerformanceOn;

cpptext
{
	virtual void OnRigidBodyCollision( const FRigidBodyCollisionInfo& MyInfo, const FRigidBodyCollisionInfo& OtherInfo, const FCollisionImpactData& RigidCollisionData );

	virtual void TickSpecial( FLOAT DeltaSeconds );

    /** 
	 * This will look to see if the player is near the car and then update the collision settings for it.
	 * We just use distance at the moment.  The assumption is that cars always need to run run run otherwise they 
	 * can get into traffic jams or other crazy situations.  But there is no need for them to be encroach checking constantly.
	 **/
	virtual void UpdatePerformanceSettingsBasedOnPlayer();
};

function Init()
{
	local int LimbIdx;

	// For each limb defined in default properties
	for( LimbIdx = 0; LimbIdx < LimbList.Length; LimbIdx++ )
	{
		if( LimbList[LimbIdx].LimbClass == None )
			continue;

		// Spawn the limb
		LimbList[LimbIdx].Limb = Spawn(LimbList[LimbIdx].LimbClass, self);
		if( LimbList[LimbIdx].Limb != None )
		{
			// Init the limb
			LimbList[LimbIdx].Limb.InitLimb( NanoAI_PacifierBot(Controller) );
		}
	}
	Chassis = FindLimbByName( 'Chassis' );

	// Attach chest plate to socket
	Mesh.AttachComponentToSocket( ChestPlateComp, 'ChestPlate' );
    ChestPlateComp.SetShadowParent( Mesh );

	SetTimer( 1.f, FALSE, nameof(TryToFindTattlerForEyes) );
}

simulated function Destroyed()
{
	local int LimbIdx;

	Super.Destroyed();

	// Cleanup limbs
	for( LimbIdx = 0; LimbIdx < LimbList.Length; LimbIdx++ )
	{
		if( LimbList[LimbIdx].Limb != None )
		{
			LimbList[LimbIdx].Limb.Destroy();
		}
	}
	LimbList.Length = 0;

	// Cleaup effects
	ExhaustEmitter.Destroy();

	// Cleanup sounds
	AC_HoverIdleLoop.Stop();
}

simulated function CacheAnimNodes()
{
	FullBodyNode = NanoAnimBlendList(Mesh.FindAnimNode('FullBodyNode'));
}

simulated function ClearAnimNodes()
{
	FullBodyNode = None;
}

simulated function UpdateMesh( float DeltaTime )
{
	local int Idx;

	// Update all limbs
	for( Idx = 0; Idx < LimbList.Length; Idx++ )
	{
		if( LimbList[Idx].Limb == None )
			continue;
		LimbList[Idx].Limb.UpdateMesh( DeltaTime );
	}

	// Update docked tattler bots
	for( Idx = 0; Idx < Docks.Length; Idx++ )
	{
		if( Docks[Idx].Bot == None )
			continue;
		if( Docks[Idx].Bot.Controller == None )
		{
			Docks[Idx].Bot = None;
			continue;
		}

		NanoAI(Docks[Idx].Bot.Controller).ClampedBaseRotation = Rotator(GetDockLookDir(Docks[Idx].Bot));
	}
}

/** Enable all limbs - except the core */
final function EnableAllLimbs( bool inbEnabled )
{
	local int LimbIdx;
	for( LimbIdx = 0; LimbIdx < LimbList.Length; LimbIdx++ )
	{
		if( LimbList[LimbIdx].LimbName != 'Core' ) 
		{
			LimbList[LimbIdx].Limb.SetEnabled( inbEnabled );
		}
	}
}

simulated function Pacifier_LimbBase FindLimbByName( Name LimbName )
{
	local int Idx;

	for( Idx = 0; Idx < LimbList.Length; Idx++ )
	{
		if( LimbList[Idx].LimbName == LimbName )
		{
			return LimbList[Idx].Limb;
		}
	}
	return None;
}

simulated function bool IsTargetable( optional ETargetQueryType QT )
{
	return FALSE;
}

simulated function float GetBasePriority(NanoPC Askee, optional NanoPawn AskeePawn)
{
	// Can only target body parts of pac-bot
	return INDEX_NONE;
}

simulated function bool CanBeDusted()
{
	return FALSE;
}

simulated function bool CanBeDensed()
{
	return FALSE;
}


event TakeDamage(int Damage, Controller InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	Damage = 0; // for now no damage to the mek
	Super.TakeDamage(Damage,InstigatedBy,HitLocation,Momentum,DamageType,HitInfo,DamageCauser);
/*
	// only bombs kill these guys
	if( DamageType == class'NDT_Bomb' && InstigatedBy != Controller )
	{
		`log( "BOOOOOOOOM" );
		Died( InstigatedBy, DamageType, HitLocation );
	}*/
}

function bool Died(Controller Killer, class<DamageType> DamageType, vector HitLocation)
{
	local int LimbIdx;

	// Cleanup limbs
	for( LimbIdx = 0; LimbIdx < LimbList.Length; LimbIdx++ )
	{
		if( LimbList[LimbIdx].Limb != None )
		{
			LimbList[LimbIdx].Limb.Destroy();
		}
	}
	LimbList.Length = 0;

	PlaySound( DestroyedCue );

	return Super.Died( Killer, DamageType, HitLocation );
}


/** This will return the struct that holds all of the values for this specific pawn **/
simulated function NanoCausingChaosValueDatum GetDeathChaosValue()
{
	return class'NanoCausingChaosValues'.default.PacificationBotKilled;
}

simulated function bool IsAbleToWalk()
{
	// Check if legs are too damage to walk
	return !bChassisDestroyed;
}

simulated function bool ShouldUndock()
{
	return (!bUndocked && bChassisDestroyed);
}

simulated function bool StuckInPlace()
{
	local int LimbIdx;

	if( IsTimerActive( nameof(UndockAnimFinished) ) )
	{
		return TRUE;
	}

	for( LimbIdx = 0; LimbIdx < LimbList.Length; LimbIdx++ )
	{
		if( LimbList[LimbIdx].Limb == None )
			continue;

		if( LimbList[LimbIdx].Limb.PreventBotMovement() )
		{
			return TRUE;
		}
	}
	return FALSE;
}

simulated function UndockAnimFinished()
{
	FullBodyNode.SetActiveChild( 0, 0.1f );
}

simulated function UndockFromChassis()
{
	if( !bUndocked && Chassis != None )
	{
		bUndocked = TRUE;
		Chassis.DetatchLimb();

		SetPhysics( PHYS_Flying );
		PlayUndockFromChassisEffects();
		
		LimbList.Remove( LimbList.Find( 'Limb', Chassis ), 1 );
		Chassis = None;

		PlayDropChestPlate();
	}
}

simulated function PlayUndockFromChassisEffects()
{
	// Play animation to separate
	FullBodyNode.SetActiveChild( 1, 0.1f );
	SetTimer( Mesh.GetAnimLength('Separate'), FALSE, nameof(UndockAnimFinished) );

	// Spawn effects
	if( ExhaustEmitter == None )
	{
		ExhaustEmitter = Spawn(class'SpawnedNanoEmitter', self);
		if( ExhaustEmitter != None )
		{
			ExhaustEmitter.LifeSpan = 0.0f;
			ExhaustEmitter.bPostUpdateTickGroup = TRUE;
			ExhaustEmitter.SetTemplate(PS_ExhaustEffect, FALSE );
			ExhaustEmitter.SetBase( self,, Mesh, 'Exhaust' );
		}
	}

	PlaySound( DetachFromChassisCue );
	if( AC_HoverIdleLoop == None )
	{
		AC_HoverIdleLoop = new(self) class'AudioComponent';
		AttachComponent( AC_HoverIdleLoop );
		AC_HoverIdleLoop.bStopWhenOwnerDestroyed = TRUE;
		AC_HoverIdleLoop.SoundCue = HoverIdleLoopCue;
	}
	AC_HoverIdleLoop.FadeIn( 1.f+FRand()*1.f, 1.0f );
	SetTimer( 2.f+FRand()*1.f, FALSE, nameof(PlayThrustMovementSound) );
}

simulated function PlayThrustMovementSound()
{
	if( VSizeSq(Velocity) > 1000.f )
	{
		PlaySound( HoverThrustCue );
	}
	SetTimer( 2.f+FRand()*1.f, FALSE, nameof(PlayThrustMovementSound) );
}

simulated function PlayDropChestPlate()
{
	local Pacifier_LimbBase Core;

	Core = FindLimbByName( 'Core' );
	if( Core != None )
	{
		Core.SetEnabled( TRUE );
	}
}

simulated event PlayFootStepSound( int FootDown )
{
	if( Chassis != None )
	{
		Chassis.HandleFootStep( FootDown );
	}
}

simulated function bool CanBeBaseForPawn( Pawn P )
{
	local int Idx;
	local NanoPawn_MetaCorp_SentryBotBase Bot;

	Bot = NanoPawn_MetaCorp_SentryBotBase(P);
	if( Bot != None )
	{
		Idx = Docks.Find( 'Bot', Bot );
		if( Idx >= 0 )
		{
			return TRUE;
		}
	}

	return Super.CanBeBaseForPawn(P);
}

simulated function int FindTattlerBotDock( NanoPawn_MetaCorp_SentryBotBase Bot )
{
	local int Idx;
	Idx = Docks.Find( 'Bot', Bot );
	if( Idx < 0 )
	{
		Idx = Docks.Find( 'Bot', None );
	}
	return Idx;
}

function TryToFindTattlerForEyes()
{
	local int EmptyIdx;
	local NanoAI_SentryBot SentryBot;

	foreach WorldInfo.AllControllers( class'NanoAI_SentryBot',SentryBot )
	{
		EmptyIdx = Docks.Find( 'Bot', None );
		if( EmptyIdx < 0 )
			break;

		if( SentryBot.PendingDock == None 
			&& (SentryBot.Dock == None || !SentryBot.Dock.GetInterfaceActor().IsA( 'NanoPawn_MetaCorp_PacifierBot' )) 
			&& ( VSize(SentryBot.Pawn.Location - Location) < DistanceToGrabTattlers )
			)
		{
			Docks[EmptyIdx].Bot = SentryBot.MySentryBot;
			// so now that the bot has a new dock we need to tell it's old dock to spawn another bot
			SentryBot.Dock.SpawnABot();
			SentryBot.RegisterPendingDock( self );
		}
	}

	EmptyIdx = Docks.Find( 'Bot', None );
	if( EmptyIdx >= 0 )
	{
		SetTimer( 1.f, FALSE, nameof(TryToFindTattlerForEyes) );
	}
}

/////////////////////////////////////////////////////
////// INTERFACE: NanoInterface_TattlerBotDock //////
/////////////////////////////////////////////////////
simulated function Actor GetInterfaceActor()
{
	return self;
}

function HandleNewDock(NanoPawn_MetaCorp_SentryBotBase InBot)
{
	local NanoAI AI;

	InBot.AccelRate = 0.f;

	AI = NanoAI(InBot.Controller);
	AI.bClampRotation	 	 = TRUE;
	AI.ClampedBaseRotation	 = Rotator(GetDockLookDir(InBot));
	AI.ClampedRotationLimits = rot(7000,5000,4096);
}

simulated function CompleteDock( NanoPawn_MetaCorp_SentryBotBase InBot )
{
	local int Idx;

	InBot.bCanStrafe = InBot.default.bCanStrafe;
	InBot.Velocity = vect(0,0,0);
	InBot.SetPhysics(PHYS_None);

	Idx = Docks.Find( 'Bot', InBot );
	InBot.SetLocation( GetDockLocation(InBot, TRUE) );
	InBot.SetBase( self,, Mesh, Docks[Idx].SocketName );
}

simulated function vector GetDockLocation(NanoPawn_MetaCorp_SentryBotBase Bot, optional bool bFinalDock)
{
	local int Idx; 
	local Vector SocketLoc;
	local Rotator SocketRot;

	if( !bFinalDock )
	{
		return Location + Normal(Bot.Location-Location) * 512.f;
	}

	Idx = FindTattlerBotDock( Bot );
	if( Idx >= 0 )
	{
		Mesh.GetSocketWorldLocationAndRotation( Docks[Idx].SocketName, SocketLoc, SocketRot );
		return SocketLoc;
	}
	return vect(0,0,0);
}

simulated function Vector GetDockLookDir(NanoPawn_MetaCorp_SentryBotBase InBot)
{
	return Vector(Rotation);
}

simulated function PrepareReturnToDock(NanoPawn_MetaCorp_SentryBotBase InBot)
{
	// Increase tattler bot movement speeds when docking in pacbot
	InBot.GroundSpeed = 1000.f;
	InBot.AirSpeed = 1000.f;
}

simulated function PrepareToDockBot(NanoPawn_MetaCorp_SentryBotBase InBot)
{
	local int Idx;

	Idx = FindTattlerBotDock( InBot );
	if( Idx >= 0 )
	{
		Docks[Idx].Bot = InBot;
	}

	InBot.bCanStrafe = TRUE;
	InBot.SetPhysics(PHYS_Flying);
}

simulated function PrepareToUndockBot(NanoPawn_MetaCorp_SentryBotBase Bot)
{
	local int Idx;
	Idx = FindTattlerBotDock( Bot );
	if( Idx >= 0 )
	{
		Docks[Idx].Bot = None;
	}
}

/** This will spawn a new bot from this Dock **/
simulated function SpawnABot();  // do nothing

/** This gets called when the bot this camera has spawned has been killed **/
simulated function BotHasBeenKilled(); // do nothing


simulated function PlayVoiceOver_Target()
{
	PlaySound( VO_Target[Rand(VO_Target.Length)] );
}

simulated function PlayVoiceOver_Search()
{
	PlaySound( VO_Search[Rand(VO_Search.Length)] );
}

simulated function PlayVoiceOver_Damage()
{
	PlaySound( VO_Damage[Rand(VO_Damage.Length)] );
}

simulated function PlayVoiceOver_Affirmative()
{
	PlaySound( VO_Affirmative[Rand(VO_Affirmative.Length)] );
}

simulated function PlayVoiceOver_Negative()
{
	PlaySound( VO_Negative[Rand(VO_Negative.Length)] );
}


defaultproperties
{

}