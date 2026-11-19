//=============================================================================
// SASFighterController.uc
// 
// Abstract superclass of SAS and terrorist controllers. 
//=============================================================================

class SASFighterController extends SASAIController
	native
	abstract;

//-----------------------------------------------------------------------------
// Constants

//-----------------------------------------------------------------------------
// Enums

//-----------------------------------------------------------------------------
// Structs

//-----------------------------------------------------------------------------
// Member Variables

var float			mLastHitEnemyTime;					// Last time I damaged an enemy.
var SASPawn			mLastEnemyHitBy;					// Last enemy that damaged me.
var float			mLastEnemyHitByTime;				// Level time last damaged by an enemy.

//-----------------------------------------------------------------------------
// Native Functions

//-----------------------------------------------------------------------------
// Exec Functions

//-----------------------------------------------------------------------------
// Functions


///////////////////////////////////////////////////////////////////////////////
// DamageAttitudeTo
// 
// Called on taking damage to instigate a response.
function DamageAttitudeTo(
	Pawn	aInstigator,		// Pawn that damaged us.
	float	aDamage )			// Damage amount.
{
	local SASPawn				other;
	local SASFighterController	instigatorFC;

	other = SASPawn( aInstigator );
	if ( (other != None) && mSASPawn.IsAThreat( other ) )
	{
		// Record last enemy hit by and time.
		mLastEnemyHitBy		= other;
		mLastEnemyHitByTime = Level.TimeSeconds;

		// Record last successful hit time for damage instigator.
		if ( other.Controller != None )
		{
			instigatorFC = SASFighterController( other.Controller );
			if ( instigatorFC != None )
			{
				instigatorFC.mLastHitEnemyTime = Level.TimeSeconds;
			}
		}
	}
}


///////////////////////////////////////////////////////////////////////////////
// SetEnemy
// 
function bool SetEnemy(
	Actor aNewEnemy )
{
	// Clear existing enemy
	if ( aNewEnemy == None )
	{
		Enemy = None;
		Target = None;
		return false;
	} // if

	// Same enemy as current
	if ( aNewEnemy == Enemy )
	{
		return false;
	}

	Enemy = aNewEnemy;
	mSASPawn.AcquiredNewTarget();

	return true;
}


//-----------------------------------------------------------------------------
// States

//-----------------------------------------------------------------------------
// Default Properties

