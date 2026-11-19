//=============================================================================
// L13A1_Gas_Grenade_Projectile.uc
//
//=============================================================================

class L13A1_Gas_Grenade_Projectile extends SASGrenadeProjectile;


const GAS_INTERVAL = 0.33;


//-----------------------------------------------------------------------------
// Member Vars

var () float mMaxBurnTime;						// Time that the grenade emits gas for
var () float mGassedRecoveryTime;				// Time to recover once clear of gas cloud
var () float mCloudDissipationTime;				// Time to disperse once burn time is complete
var () float mCloudCylinderMaxRadius;			// Max radius to grow to
var () float mCloudCylinderMaxHeight;			// Max height to grow to

var int		mTimerGas;
var float	mBurnTimer;							// Internal timer used to measure burn time
var float	mEmissionTimer;						// Timer used to control particle emission
var float	mDissipationRate;					// Rate at which cloud dissipates
var float	mCloudCylinderRadiusRate;			// How fast the cylinder expands outwards
var float	mCloudCylinderHeightRate;			// How fast the cylinder expands upwards
var float	mCylinderRadius;					// Current cloud radius
var float	mCylinderHeight;					// Current cloud height
var float	mCloudDensity;						// Current density (0 -> 1)


///////////////////////////////////////////////////////////////////////////////
// PreBeginPlay
//
event PreBeginPlay()
{
	Super.PreBeginPlay();
	mTimerGas = AddMultiTimer();
}


///////////////////////////////////////////////////////////////////////////////
// GetSpecialDamageRadius
//
event float GetSpecialDamageRadius()
{
	return mCloudCylinderMaxRadius;
}


///////////////////////////////////////////////////////////////////////////////
// Explode
//
// Overrides the default Explode method in SASGrenadeProjectile.uc. The L13A1
// creates a spreading gas cloud that dissipates as its radius increases.
// Characters are affected for less time if they are at the edge of the cloud
// rather than the centre.
//
simulated function Explode(
	Vector		aHitLocation,
	Vector		aHitNormal )
{
	// Set ourselves up as emitting CS gas
	GotoState ('Exploding');
}


///////////////////////////////////////////////////////////////////////////////
// drawDebug
//
// Draws all child gas clouds of this actor
//
function DrawDebug (
	HUD		aHUD)			// HUD object which handles the drawing
{
	local float		shade;
	local Color		gasColour;
	local Vector	posn;

	if ( mCloudDensity > 0.0 )
	{
		shade = 255.0 * mCloudDensity;
		gasColour = class'Canvas'.Static.MakeColor (0, int (shade), 0);
		posn = Location;
		posn.Z = Location.Z + mCylinderHeight / 2;
		aHUD.Draw3DCylinder (posn, vect (0, 0, 1), mCylinderRadius, mCylinderHeight, 16, gasColour);
	} // if
} // DrawDebug


///////////////////////////////////////////////////////////////////////////////
// STATE Exploding
//
// State entered when the grenade begins to emit gas

simulated function UpdateGasPawns();

state Exploding
{
	event BeginState()
	{
		SetMultiTimer( mTimerGas, GAS_INTERVAL, true );
	}

	event EndState()
	{
		StopMultiTimer( mTimerGas );
	}

	simulated function Explode (
		Vector		aHitLocation,
		Vector		aHitNormal)
	{
		local SASGenericExplosion	myExplosion;

		// Self destruct if all explosions have been triggered
		if (mExplosionsTriggered < mNumExplosions)
		{
			// spawn the explosion effects, sound and damage
			myExplosion = Spawn( mExplosionClass,,, aHitLocation, rot(16384,0,0) );
			mExplosionsTriggered++;

			// Attach explosion to self if required
			if ( mbAttachExplosions )
			{
				myExplosion.SetBase( self );
			}

			SetTimer( RandRange( mTimeBetweenExplosions.Min, mTimeBetweenExplosions.Max ), false );
		}
		else
		{
			SetTimer( 0.0, false );
		}
	}

	simulated event MultiTimer(
		int	aTimerIdx )
	{
		switch ( aTimerIdx )
		{
		case mTimerGas:
			UpdateGasPawns();
			break;

		default:
			Super.MultiTimer( aTimerIdx );
			break;
		}
	}

	simulated function UpdateGasPawns()
	{
		local SASPawn			targetPawn;
		local float				top,
								bottom;
		local vector			headPos,
								tmpLoc;
		local SASGameInfo		gi;
		local bool				bGassed;
		local SASAssaultVolume	grenadeAV;

		gi = SASGameInfo( Level.Game );
		if ( gi != None )
		{
			// Test against all pawns
			top = location.Z + mCylinderHeight;
			bottom = location.Z;

			foreach gi.RadiusSASPawns( class'SASPawn', targetPawn, Location, mCylinderRadius )
			{
				if ( !targetPawn.mbHasGasMask )
				{
					// If pawn's head is within radius of the grenade and within height bounds, send it a 'gassed' message
					headPos = targetPawn.Location;
					headPos.Z += targetPawn.EyeHeight;

					if (headPos.Z < top && headPos.Z > bottom)
					{
						// Pawn is gassed if :
						// 1) In same AV
						// 2) Has Line of sight from head to grenade location
						// 3) Has line of sight from head to grenade location adjusted to head height.
						bGassed = false;
						grenadeAV = gi.GetEncompassingAssaultVolume( Location );
						if ( gi.GetEncompassingAssaultVolume( Location ) == targetPawn.GetAssaultVolume() )
						{
							bGassed = true;
						}
						else
						{
							// Check line of sight from head to grenade.
							if ( FastTrace( Location, headPos ) )
							{
								bGassed = true;
							}
							else
							{
								// Check line of sight from head to grenade location at head height. But only
								// if the adjusted grenade loc is in the grenade's AV
								tmpLoc = Location;
								tmpLoc.Z = headPos.Z;
								if (	(grenadeAV != None) &&
										(grenadeAV == gi.GetEncompassingAssaultVolume( tmpLoc )) )
								{
									if ( FastTrace( tmpLoc, headPos ) )
									{
										bGassed = true;
									}
								}
							}
						}

						if ( bGassed )
						{
							targetPawn.DoGassed (mCloudDensity * mGassedRecoveryTime);
						}
					}
				}
			}
		}
	}

	simulated function Tick(
		float aDeltaSeconds )
	{
		mBurnTimer += aDeltaSeconds;

		// If still burning then expand cloud
		if ( mBurnTimer < mMaxBurnTime )
		{
			mCylinderRadius += mCloudCylinderRadiusRate * aDeltaSeconds;
			if (mCylinderHeight < mCloudCylinderMaxHeight)
			{
				mCylinderHeight += mCloudCylinderRadiusRate * aDeltaSeconds;
			}
		}
		// Otherwise allow the cloud to dissipate
		else
		{
			// Stop our explosion emitters creating new particles
			/* TBD */

			mCloudDensity -= mDissipationRate * aDeltaSeconds;

			// Completely dissipated ?
			if ( mCloudDensity < 0.0 )
			{
				Disable ('Tick');
				Destroy ();

				// Need to destroy explosion emitters here ?

				return;
			}
		}
	}

Begin:
	
	mCylinderRadius				= 0.0;
	mCylinderHeight				= 0.0;
	mCloudCylinderRadiusRate	= mCloudCylinderMaxRadius / mMaxBurnTime;
	mCloudCylinderHeightRate	= mCloudCylinderMaxHeight / mMaxBurnTime;
	mCloudDensity				= 1.0;
	mDissipationRate			= 1.0 / mCloudDissipationTime;

	// Trigger off start of explosion chain.
	Explode( Location + (Vect(0,0,1) * 16), vect(0,0,1) );

	Enable ('Tick');
}


///////////////////////////////////////////////////////////////////////////////
// Default properties


// Decompiled with UE Explorer.
defaultproperties
{
    mMaxBurnTime=12.0000000
    mGassedRecoveryTime=10.0000000
    mCloudDissipationTime=10.0000000
    mCloudCylinderMaxRadius=600.0000000
    mCloudCylinderMaxHeight=150.0000000
    mCategory=2
    mTimeToExplode=2.4000000
    mExplosionClass=Class'SASEffects.Explosion_L13A1_Gas_Grenade'
    mTimeBetweenExplosions=(Min=0.0000000,Max=0.0000000)
    mbAttachExplosions=true
    mLifetimeAfterExplosions=10.0000000
    mImpactSounds=/* Array type was not detected. */
    Speed=750.0000000
    MaxSpeed=1200.0000000
    TossZ=120.0000000
    Mesh=SkeletalMesh'WpAn.CSGasGren_projectile'
}