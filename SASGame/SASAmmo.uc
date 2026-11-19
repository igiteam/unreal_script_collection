//=============================================================================
// SASAmmo.uc
//
// Abstract base class of all weapon ammo in SAS
//=============================================================================

class SASAmmo extends Ammunition
	native;


//-----------------------------------------------------------------------------
// Constants

///////////////////////////////////////////////////////////////////////////////
// const multipliers for projectile penetration
// assumed cubes sequence for testing
// TODO: these need to be adjusted during play testing ...
// 
const PENETRATION_FACTOR_LIGHT		= 50.0;	
const PENETRATION_FACTOR_MEDIUM		= 250.0;	
const PENETRATION_FACTOR_HEAVY		= 1000.0;	

const HUMAN_PENETRATION_THICKNESS	= 256.0;


//-----------------------------------------------------------------------------
// Enums

//-----------------------------------------------------------------------------
// Member variables

var() int	Damage;
var() int	MinDamage;		// If MinDamage and MaxDamage are set they
var() int	MaxDamage;		// override any Damage value
var() int	Penetration;

var() bool	mDamageStructures;	// Used when attacking inanimate objects (doors)

var() float mDamageDropPerMetre;

var Name mBoneName;


//-----------------------------------------------------------------------------
// Native Functions

///////////////////////////////////////////////////////////////////////////////
// FireRayThroughObjects
// 
// Very expensive - does multiple line checks until a bullet is stopped.
// Potential ways of reducing traces:
// 1) Limit max number of objects a bullet can pass through.
// 2) Don't allow penetration for bullets hitting at distance from player(s) unless fired by player. 
native(753) final function FireRayThroughObjects(
	Weapon	aFiredFromWeapon,		// Weapon fired from 
	bool	abFiredByAI,
	vector	aStartTrace,
	float	aTraceDist,
 	vector	aTraceDir,
	Actor	aTarget );

//-----------------------------------------------------------------------------
// Exec Functions

//-----------------------------------------------------------------------------
// Functions

///////////////////////////////////////////////////////////////////////////////
// PreBeginPlay
//
function PreBeginPlay ()
{
	Super.PreBeginPlay ();

	if (MaxDamage > 0)
	{
		if (MinDamage >= MaxDamage)
		{
			LogHuman ("SASAmmo " $self$ " must have MaxDamage > MinDamage for random damage to work");
		} // if
	} // if
} // if

///////////////////////////////////////////////////////////////////////////////
// SpawnProjectile
// 
// Same as Ammunition.SpawnProjectile but without AmmoAmount decrementing as
// this has been moved to SASWeapon code.
function SpawnProjectile(
	vector	aStart, 
	rotator aDir)
{
	Spawn(ProjectileClass,,, aStart, aDir);	
}

//-----------------------------------------------------------------------------
// States


//-----------------------------------------------------------------------------
// Default Properties


// Decompiled with UE Explorer.
defaultproperties
{
    Penetration=500
    mBoneName="'"
    bInstantHit=true
}