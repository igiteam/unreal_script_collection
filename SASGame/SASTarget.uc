class SASTarget extends Mover
	native;

#exec OBJ LOAD FILE=..\StaticMeshes\KrmSM.usx PACKAGE=KrmSM

// A header file named the same as the class is implicitly included as soon as it exists... hence removed the cpptext here.

////////////////////////////////////////////////////////////////////////////////
// variables 
//
var int					AggregateNumHits;
var(Target) int			NumHitsThreshold;
var bool				mIsDead;

var(Target) int			WhichShape;
var(Target) float		HeightScale;		// How much of the height of the bounding box is actually the target shape.

var int					Score;				// current points scored
var int					TotalScore;			// add up the score that this target has received
var(Target) bool		Vertical;			// if the target doesn't move then don't check mover
var(Target) bool		FlipYZ;				// the Y & Z coords get flipped ...

var(Target)	int			mNumZones;			// total number of scoring zones on all targets
var(Target) int			mZoneScores[16];	// scores for zones

var int					mZone;				// current zone hit
var int					mZoneHits[16];		// zone hit counts totals

var(Target) Name		mEventHit;			// trigger an event when hit
var(Target) Name		mEventDone;			// trigger an event when done

var bool				mbHasBeenHit;

var(Target) bool		mValidAITarget;		// Can the AI shoot at this object ?

cleannative function NativeTakeDamage ( int Damage, Vector hitlocation, class<DamageType> damageType );

native final function bool IsAValidAITarget();

////////////////////////////////////////////////////////////////////////////////
// functions 
//

function FinishedOpening()
{
	// when targets open they stop being dead.
	mIsDead = false;
	
	Super.FinishedOpening();
}


function int GetShape ()
{
	if ( StaticMesh == StaticMesh'KrmSM.Furniture.Krm0018_Target' )
	{
		return 0;
	}
	else
	if ( StaticMesh == StaticMesh'KrmSM.Furniture.Krm0018_Target_2' )
	{
		return 1;
	}
	else
	if ( StaticMesh == StaticMesh'KrmSM.Furniture.Krm0018_TargetV2' )
	{
		return 2;
	}
	else
	if ( StaticMesh == StaticMesh'KrmSM.Furniture.Krm0018_TargetV2_2' )
	{
		return 3;
	}
	else
	if ( StaticMesh == StaticMesh'KrmSM.Furniture.Krm0018_TargetV3' )
	{
		return 4;
	}
	else
	if ( StaticMesh == StaticMesh'KrmSM.Furniture.Krm0018_TargetV4' )
	{
		return 5;
	}
	else
	if ( StaticMesh == StaticMesh'KrmSM.Furniture.Krm0018_TargetV5' )
	{
		return 6;
	}
	else
	if ( StaticMesh == StaticMesh'KrmSM.Furniture.Krm0018_TargetV5_2' )
	{
		return 7;
	}
	else
	if ( StaticMesh == StaticMesh'KrmSM.Furniture.Krm0018_TargetV6' )
	{
		return 8;
	}
	else
	if ( StaticMesh == StaticMesh'KrmSM.Furniture.Krm0018_TargetV6_2' )
	{
		return 9;
	}
	else
	if ( StaticMesh == StaticMesh'KrmSM.Furniture.Krm0018_TargetV7' )
	{
		return 10;
	}
	else
	if ( StaticMesh == StaticMesh'KrmSM.Furniture.Krm0018_TargetV7_2' )
	{
		return 11;
	}
	else
	if ( StaticMesh == StaticMesh'KrmSM.Furniture.Krm0018_TargetV8' )
	{
		return 12;
	}
	else
	if ( StaticMesh == StaticMesh'KrmSM.Furniture.Krm0018_TargetV8_2' )
	{
		return 13;
	}
	else
	if ( StaticMesh == StaticMesh'KrmSM.Furniture.Krm0018_TargetV9' )
	{
		return 14;
	}
	else
	if ( StaticMesh == StaticMesh'KrmSM.Furniture.Krm0018_TargetV9_2' )
	{
		return 15;
	}
	else
	{
		return -1;
	}
}

function PreBeginPlay ()
{
	Super.PreBeginPlay ();

	if ( WhichShape == -1 )
	{
		WhichShape = GetShape ();
	}
}

function PostBeginPlay ()
{
	Super.PostBeginPlay ();

	SetTimer (0.1, true);
}

event Timer ()
{
	local Controller C;

	// Show ourselves to nearby SASSoldierControllers
	if ( IsAValidAITarget() )
	{
		for (C = Level.ControllerList; C != None; C = C.NextController)
		{
			if (SASSoldierController (C) != None && C.LineOfSightTo (self))
			{
				SASSoldierController (C).SeeSASTarget (self);
			} // if
		} // for
	} // if
} // Tick

// When damaged
function bool BasicTakeDamage (
	int					Damage,
	Pawn				instigatedBy,
	Vector				hitlocation, 
	Vector				momentum,
	class<DamageType>	damageType,
	optional Weapon		wpn)
{
	// only when live, open or upstanding ...
	if ( mIsDead || ( !Vertical && ( ( KeyNum != 1 ) || ( PhysAlpha != 0.0 ) ) ) )
	{
		return false;
	}

	// no shape, then bail out here
	if ( WhichShape == -1 )
	{
		Warn ( "No shape found for" @self );
		return false;
	}

	// only the player scores (i.e. not wingmen ...)
	if ( PlayerController ( instigatedBy.Controller ) != None )
	{
		// let's see where, converted to object space, for the sake of scoring.
		NativeTakeDamage ( Damage, hitlocation, damageType  );
	}

	// And then count how many hits.
	AggregateNumHits++;
	TriggerEvent ( mEventHit, self, None );
	mbHasBeenHit = true;

	if ( AggregateNumHits == NumHitsThreshold )
	{
		// reset hit count.
		AggregateNumHits = 0;
		mIsDead = true;
		TriggerEvent ( mEventDone, self, None );

		// and do something.
		return true;
	}

	return false;
}

function int GetZoneHits ( int aZone )
{
	if ( aZone < mNumZones )
	{
		return mZoneHits [ aZone ];
	}

	return 0;
}

//::function int GetZoneScore ( int aZone )
//::{
//::	if ( aZone < mNumZones )
//::	{
//::		return mZoneScores [ aZone ];
//::	}
//::
//::	return 0;
//::}

//::function int GetZoneHitsScore ( int aZone )
//::{
//::	if ( aZone < mNumZones )
//::	{
//::		return mZoneHits [ aZone ] * mZoneScores [ aZone ];
//::	}
//::
//::	return 0;
//::}

//::function int GetNumZones ()
//::{
//::	return mNumZones;
//::}



// Decompiled with UE Explorer.
defaultproperties
{
    NumHitsThreshold=2
    WhichShape=-1
    HeightScale=0.5000000
    mNumZones=16
    mZoneScores[1]=100
    mZoneScores[2]=250
    mZoneScores[3]=500
    mZoneScores[4]=1000
    mZoneScores[5]=3000
    mZoneScores[6]=500
    mZoneScores[7]=1000
    mZoneScores[8]=3000
    mZoneScores[9]=500
    mZoneScores[10]=3000
    mZoneScores[11]=-5000
    mZoneScores[12]=-5000
    mZoneScores[13]=2000
    mZoneScores[14]=5000
    mZoneScores[15]=5000
    CollisionRadius=24.0000000
    CollisionHeight=96.0000000
}