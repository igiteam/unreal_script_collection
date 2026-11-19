//***********************************************************************
// Class:		SPActorDestructComponent
// Description:
// Created By:  Asim Naseer, Spark Unlimited 2005
// integrated from Pandora to TP by Doug Kuppinger 8/25/06
//***********************************************************************

class SPActorDestructComponent extends ActorDestructComponent
	hidecategories(Object)
	native;

//***********************************************************************
// INCLUDES
//***********************************************************************

//***********************************************************************
// MACROS
//***********************************************************************

//***********************************************************************
// STRUCT DECLARATIONS
//***********************************************************************

// Imporatnt - Add all component data in this struct only.
// It is in struct so it can be copied with single assignment

var () 	SPDestructibleProperties	properties;
var ()	float						MinCollisionVelocity;
var ()	float						MaxCollisionVelocity;
var () 	int							HitPoints;
var () 	bool						OnlyDestroyedByKismet;
var () 	bool						AutoTrigger;
var ()  float						Sharpness;				// How much more or less damage this does to other objects on collisions.
//var		AudioComponent				AC;
var  	float						FloatDamageRemainder;
var 	const class<DamageType> 	DefaultDamageType;
var transient float					FireLastDamageAmount;	// Used to only get damaged by the maximum instanced fire damage amount per frame.
var transient float					FireLastDamageTime;
var transient float					FireFractionalDamage;
var transient bool					bDestroyed;
var transient bool					bKismetDetroying;
var transient int					OnFireCount;
var transient int					OnFireMax;

//***********************************************************************
// VARIABLE DECLARATIONS
//***********************************************************************

//***********************************************************************
// CPP TEXT
//***********************************************************************
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

//***********************************************************************
// NATIVE FUNCTION DECLARATIONS
//***********************************************************************

native final static function WorldInfo GetWorldInfo();
native function int SpeedToDamage( float speed );

native final function Actor SPSpawn
(
	class<actor>      SpawnClass,
	optional actor	  SpawnOwner,
	optional name     SpawnTag,
	optional vector   SpawnLocation,
	optional rotator  SpawnRotation,
	optional Actor	  Template
);

//***********************************************************************
// FUNCTION DECLARATIONS
//***********************************************************************

//***********************************************************************
// FUNCTIONS/STATES
//***********************************************************************

native function bool	CanDoDamageType(class<DamageType> damageType);

//-----------------------------------------------------------------------
// Function:
// Description:
//-----------------------------------------------------------------------
event HandleRigidBodyCollision( float velocityMag, Actor instigator, vector hitLocation, vector contactNormal )
{
	local int damage;
	local vector momentum;
	local Pawn pawn;
	local Controller controller;

	damage = velocityMag * GetHitUnitsPerVelocityUnit();
	momentum = velocityMag * contactNormal;
	pawn = Pawn( instigator );
	if ( pawn != None )
		controller = pawn.controller;
	else
		controller = None;

	TakeDamage( damage, controller, hitLocation, momentum, class'TPDamageTypeRigidBody' ); // problem? was SPDamageTypeRigidBody
}

function bool CanCatchOnFire()
{
	return (OnFireCount < OnFireMax);
}

function bool IsOnFire()
{
	return OnFireCount > 0;
}


function int CatchOnFire()
{
	OnFireCount++;
	
	return OnFireCount;
}

function int UnCatchOnFire()
{
	OnFireCount = max(0, OnFireCount-1);
	
	return OnFireCount;
}




function Pawn GetPawnOwner()
{
	local Pawn pawn;
	pawn = pawn( owner );
    
	return Pawn;
}

//-----------------------------------------------------------------------
// Function:
// Description:
//-----------------------------------------------------------------------
function int FloatingPointAdjustDamage(float Damage)
{
	local int intDamage;
	local int extraDamage;

	// truncate the health
	intDamage = Damage;
	FloatDamageRemainder += (Damage - intDamage);

	// apply remainder
	extraDamage = FloatDamageRemainder;
	intDamage += extraDamage;

	// store the remainder
	FloatDamageRemainder = (FloatDamageRemainder - extraDamage);

	return intDamage;
}

//-----------------------------------------------------------------------
// Function:
// Description:
//-----------------------------------------------------------------------
function DestroyedByKismet()
{
	bKismetDetroying = true;
}


//-----------------------------------------------------------------------
// Function:
// Description:
//-----------------------------------------------------------------------
function CauseDestruction( float Damage, Controller instigatedBy, Vector hitlocation, Vector momentum, class<DamageType> damageType, optional TraceHitInfo HitInfo )
{
	local SPDProcessManager ProcessManager;

	if ( bDestroyed )
		return;

	if ( properties == None )
		return;

	ProcessManager = class'SPDProcessManager'.static.Get(owner);
	if ( ProcessManager != None )
		ProcessManager.DoDestruct( Owner, properties, damage, instigatedBy, hitlocation, momentum, damageType, HitInfo );
	bDestroyed = true;
	HitPoints = -1;
}

event HandleTakeDamage( float Damage, Controller instigatedBy, Vector hitlocation, Vector momentum, class<DamageType> damageType, optional TraceHitInfo HitInfo)
{
	TakeDamage(Damage, instigatedBy, hitlocation, momentum, damageType, HitInfo );
}

event PlayCollisionSound(float damage)
{
	// Try to use an audiocomponent to modify volume based on damage received.
	/*if ( AC == none || AC.bFinished )
	{
		
		AC = GetPawnOwner().CreateAudioComponent( properties.CollisionSound[0], false, true );
		AC.VolumeMultiplier = damage / 10;
		// AC.PitchMultiplier = ;
		AC.Play();
		`log("AC Played Sound:" @ properties.CollisionSound[0]);
	}*/

	if ( properties.CollisionSound[0] != None )
		Owner.PlaySound( properties.CollisionSound[0] );	

}
					   
//-----------------------------------------------------------------------
// Function:
// Description:
//-----------------------------------------------------------------------
event TakeDamage( int Damage, Controller instigatedBy, Vector hitlocation, Vector momentum, class<DamageType> damageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{

	local int RemainingHitPoints;
	local Pawn pawn;

	//`log("ActorDesturctComponent::TakeDamage()");

	if ( bDestroyed )
		return;

	// only do damage if there is a OnBreakActionList to handle it. DK
	if (!CanDoDamageType(damageType))
	{
		return;
	}
	
	if ( OnlyDestroyedByKismet == true )
	{
		if ( bKismetDetroying != true )
			return;
	}
	else if ( ! AutoTrigger )
	{
		return;
	}

	//`log("ActorDesturctComponent::TakeDamage() part 2");
	

	bKismetDetroying = false;

	pawn = GetPawnOwner();

	//Log("ActorDesturctComponent::TakeDamage() Damage =" @ Damage);
	
	Damage = FloatingPointAdjustDamage(Damage);

	if ( pawn != None )
	{
		// use the pawns health directly, thus we assume the pawn has already decremented its health
		/*
		RemainingHitPoints = Pawn.Health;
		*/
		
		// This assumption is incorrect
		// 1) Pawn calls Actor's TakeDamage before Health is decremented
		// 2) Actor's TakeDamage calls Actor's NotifyActorDestructComponent
		// 3) Actor's NotifyActorDestructComponent calls ActorDestructComponent's NotifyDamage
		// 4) ActorDestructComponent's NotifyDamage calls SPActorDestructComponent's TakeDamage
		// 5) after all this Health is decremented, Doh! too late
		// anything derived from SPPawn(Pandora) would work, but not anything derived from Pawn
		RemainingHitPoints = Pawn.Health - Damage; // do your destruction check with this frame's damage
	}
	else
	{
		RemainingHitPoints = HitPoints - Damage;
		HitPoints = RemainingHitPoints;
	}

//	`log("ActorDesturctComponent::TakeDamage() Damage =" @ Damage @ " ,hp =" @ RemainingHitPoints @ "remainder =" @ FloatDamageRemainder);

	if ( ( RemainingHitPoints <= 0 ) && ( properties != None ) )
	{
		CauseDestruction( Damage, instigatedBy, hitlocation, momentum, damageType, HitInfo );
//		`log("ActorDesturctComponent::TakeDamage() DESTRUCTION");
	}
	else
	{
		PlayCollisionSound(Damage);
		//Owner.PlaySound( properties.CollisionSound[0] );
	}
	super.TakeDamage( Damage, instigatedBy, hitlocation, momentum, damageType, HitInfo, DamageCauser );
	// `log("ActorDesturctComponent::TakeDamage()  TOOK DAMAGE.");
}

//-----------------------------------------------------------------------
// Function:
// Description:
//-----------------------------------------------------------------------
event ExecuteDestructionFromKismet(Actor Instigator, float Momentum, class<DamageType> DamageType)
{
	CauseDestruction(0, Controller(Instigator), Owner.location, vector(Owner.Rotation) * Momentum, DamageType);
}

//-----------------------------------------------------------------------
// Function:
// Description:
//-----------------------------------------------------------------------
function int GetHitPoints()
{
	local Pawn pawn;

	pawn = GetPawnOwner();
	if ( pawn != None )
	{
		return Pawn.Health;
	}
	else
	{
		return HitPoints;
	}
}

//-----------------------------------------------------------------------
// Function:
// Description:
//-----------------------------------------------------------------------
function SetHitPoints( int NewHitPointValue )
{
	HitPoints = NewHitPointValue;
}

//-----------------------------------------------------------------------
// Function:
// Description:
//-----------------------------------------------------------------------
static function float GetHitUnitsPerVelocityUnit()
{
 	local TPSinglePlayerGameInfo  spGameInfo; // problem? was PandoraSPGameInfo
 
 	spGameInfo = TPSinglePlayerGameInfo(GetWorldInfo().Game); // problem? was PandoraSPGameInfo
 	if ( spGameInfo == None )
 		return 0;
 	return spGameInfo.HitUnitsPerVelocityUnit;
}

function PostBeginPlay()	// Doesn't get called on non-actors
{
	;
	if ( properties.sharpness ~= 1.0f )
	{
		;
		// Do nothing
	}
	else
	{
		if ( sharpness ~= 1.0f )
		{
			sharpness = properties.sharpness;
			;
		}
		else
		{
			
		}
	}


}

