//=============================================================================
// SASKnifeWeapon.uc 
//
// Abstract base class of all knife type weapons in SAS.
//=============================================================================

class SASKnifeWeapon extends SASWeapon
	abstract;


//-----------------------------------------------------------------------------
// Constants

//-----------------------------------------------------------------------------
// Member Vars

var float	mDamageDelay;

var bool			mbUseSecondSlash;
var Vector			mPrevBladeLocation;
var float			mDamageStartTime;
var Pawn			mLastHitPawn;
var array<Sound>	mSwipeSounds;

struct	DebugTrace
{
	var vector	Start;
	var vector	End;
};


//-----------------------------------------------------------------------------
// Functions

///////////////////////////////////////////////////////////////////////////////
// NeedsToReload
//
simulated event bool NeedsToReload ()
{
	return false;
}


///////////////////////////////////////////////////////////////////////////////
// PlayIdleAnim
// 
// Tween to weapon idle anim
simulated function PlayIdleAnim ()
{
	if (Instigator == None)
	{
		return;
	}

	//TweenAnim ('shoot', 0.3);
	LoopAnim (mIdleAnims [0], 1.0, 0.05);
}


///////////////////////////////////////////////////////////////////////////////
// Fire
//
simulated function Fire(
	float aValue )
{
	mbUseSecondSlash = false;
	Super(SASWeapon).Fire( aValue );
}


///////////////////////////////////////////////////////////////////////////////
// ToggleMode
//
// Sighting toggle function hijacked for playing 2nd swipe attack.
simulated function ToggleMode()
{
	mbUseSecondSlash = true;
	Super(SASWeapon).Fire( 0.0 );
}


///////////////////////////////////////////////////////////////////////////////
// PlayWeaponAnim
//
// Play weapon animation type on hands mesh. Also plays the matching anim on the
// 1st person gun/clip meshes if the meshes/anims exist.
simulated function PlayWeaponAnim(
	EWeaponAnim		aeWpnAnim,
	optional float	aRate,
	optional float	aBlendTime,
	optional float	aStartFrame )
{
	local name	anim;
	local Sound	swipeSound;

	if ( aeWpnAnim == WPNANIM_UnsightedFire )
	{
		if ( mbUseSecondSlash )
		{
			anim = mAltFireAnim;
		}
		else
		{
			anim = mUnsightedFireAnim;
		}

		PlayAnim( anim, 1.0, aBlendTime );

		if ( mSwipeSounds.Length > 0 )
		{
			swipeSound = mSwipeSounds[Rand(mSwipeSounds.Length)];
			if ( swipeSound != None )
			{
				PlayOwnedSound( 
					swipeSound, 
					SLOT_None,
					RandRange(FireVolumeMin, FireVolumeMax),
					false,
					mAudibleRadius,
					RandRange(FirePitchMin, FirePitchMax),
					true );
			}
		}
	}
	else
	{
		Super.PlayWeaponAnim( aeWpnAnim, aRate, aBlendTime, aStartFrame );
	}
}


function Vector GetBladeLocation()
{
	local Coords	boneCoords;
	local Vector	cameraLoc,
					bladeLoc;
	local Vector	X,Y,Z;
	local Rotator	cameraRot;
	local float		pushOut;
	local Actor		camera;

	if ( mFPWeaponMeshActor != None )
	{
		if ( Level.NetMode != NM_Standalone && Level.NetMode != NM_Client )
		{
			// Server needs to update location of FP knife mesh).
		
			// First it needs to put it in the correct offset from the pawn.
			SASPlayerController( Instigator.Controller ).PlayerCalcView( camera, cameraLoc, cameraRot );
			cameraLoc += (PlayerViewOffset >> Rotation);
			cameraloc += GetInertialBobOffset() * BobDamping;
			cameraLoc -= Vector(cameraRot) * mCollisionPushBackCurDist;
			SetLocation( cameraLoc );

			boneCoords = GetBoneCoords( ATTACHBONE_HandsToGun, true );

			mFPWeaponMeshActor.SetLocation( boneCoords.Origin );
			mFPWeaponMeshActor.SetRotation( 
				OrthoRotation(	boneCoords.XAxis, 
								boneCoords.YAxis, 
								boneCoords.ZAxis ) );
			
		}
		pushOut = 20.0;
		if ( mCollisionPushBackCurDist > 4.0 )
		{
			pushOut += 6.0;
		}
		GetAxes( mFPWeaponMeshActor.Rotation, X, Y, Z ); 
		bladeLoc = mFPWeaponMeshActor.Location + (Z * pushOut);

		if ( Level.NetMode != NM_Standalone && Level.NetMode != NM_Client )
		{
			// If server, need to reattach the knife to the hand (the forced location/rotation update
			// makes it detach).
			AttachToBone( mFPWeaponMeshActor, ATTACHBONE_HandsToGun );
		}

		return bladeLoc;
	}
	return vect(0,0,0);
}

///////////////////////////////////////////////////////////////////////////////
// STATE NormalFire
//
state NormalFire
{
	event BeginState()
	{
		Enable( 'Tick' );
		mLastHitPawn = None;
		mPrevBladeLocation = GetBladeLocation();
		mDamageStartTime = Level.TimeSeconds + mDamageDelay;
	}

	event EndState()
	{
		Disable( 'Tick' );
	}

	event Tick(
		float	aDeltaSeconds )
	{
		local int					i,
									numIncrements;
		local float					traceLength,
									traceIncrementSize;
		local SASPawn				hitPawn;
		local Vector				hitLoc,
									eyePos,						
									traceStart,
									traceEnd,
									traceDir;
		local SASPlayerController	localPC;
		local SASGRI				gri;
		local bool					bOldMissionComplete;

		if ( mFPWeaponMeshActor != None )
		{
			traceStart = mPrevBladeLocation;
			traceEnd = GetBladeLocation();
			mPrevBladeLocation = traceEnd;

			if ( mDamageStartTime < Level.TimeSeconds )
			{
				// First test for collision along line from rev blade pos to current pos.
				hitPawn = SASPawn( Instigator.PawnTrace(
										PAWN_All,
										hitLoc,
										traceEnd,
										traceStart,
										,
										,
										,
										true ) );	// Want to trace bones.

				// If not hit, test for collision from eye position to several points along the
				// line which the blade has moved.
				if ( hitPawn == None )
				{
					// Get view location.
					eyePos = Instigator.Location + Instigator.EyePosition();
			
					// Get test point increment size.
					traceDir = traceEnd - traceStart;
					traceLength = NormalizeAndGetLength( traceDir );
					numIncrements = int( traceLength / 10 ) + 2;
					traceIncrementSize = traceLength / (numIncrements-1);

					for ( i = 0; i < numIncrements; ++i )
					{
						traceEnd = traceStart + (traceDir * (traceIncrementSize * i));

						hitPawn = SASPawn( Instigator.PawnTrace(
										PAWN_All,
										hitLoc,
										traceEnd,
										eyePos,
										,
										,
										,
										true ) );	// Want to trace bones.

						if ( hitPawn != None )
						{
							break;
						}
					}
				}
				
				if ( hitPawn != None )
				{
					if ( hitPawn != mLastHitPawn )
					{
						localPC = SASPlayerController( Level.GetLocalPlayerController() );
						if ( localPC != None )
						{
							gri = SASGRI( localPC.GameReplicationInfo );
						}

						// Store if mission not yet complete to check if this slash results in mission completion.
						if ( gri != None )
						{
							bOldMissionComplete = gri.mbRoundComplete;
						}

						hitPawn.TakeDamage( SASAmmo( AmmoType ).Damage, Instigator, hitLoc, vect(0,0,0), AmmoType.MyDamageType );
						mLastHitPawn = hitPawn;

						// Did bullet hitting this pawn resulted in mission completion.
						if ( (gri != None) && gri.mbRoundComplete && !bOldMissionComplete )
						{
							// Sanity check hit pawn is now dead.
							if ( (hitPawn.Health <= 0) || hitPawn.mbIsIncapacitated )
							{
								// If damaged pawn is a terrorist killed by a soldier then play the bullet cam.
								if (	(Instigator != None) &&
										(Instigator.mPawnType == PAWN_Soldier) &&
										(hitPawn.mPawnType == PAWN_Terrorist) )
								{
									localPC.InitBulletCam( 
										Instigator.Location + Instigator.EyePosition(), 
										hitLoc, 
										SASPawn( Instigator ), 
										hitPawn,
										true ); 
								}
							}
						}
					}
					
					// TODO: Hit fx
				}
			}
		}
	}
}


state ClientFiring
{
	event BeginState()
	{
		Enable( 'Tick' );
		mLastHitPawn = None;
		mPrevBladeLocation = GetBladeLocation();
		mDamageStartTime = Level.TimeSeconds + mDamageDelay;
	}

	event EndState()
	{
		Disable( 'Tick' );
	}

	event Tick(
		float	aDeltaSeconds )
	{
		local SASPawn				hitPawn;
		local Vector				hitLoc,
									traceStart,
									traceEnd;

		if ( mFPWeaponMeshActor != None )
		{
			traceStart = mPrevBladeLocation;
			traceEnd = GetBladeLocation();
			mPrevBladeLocation = traceEnd;

			if ( mDamageStartTime < Level.TimeSeconds )
			{
				hitPawn = SASPawn( Instigator.PawnTrace(
										PAWN_All,
										hitLoc,
										traceEnd,
										traceStart,
										,
										,
										,
										true ) );	// Want to trace bones.
				if ( hitPawn != None )
				{
					// TODO: Hit fx
				}
			}
		}
	}
}


//-----------------------------------------------------------------------------
// Default Properties


// Decompiled with UE Explorer.
defaultproperties
{
    mDamageDelay=0.1000000
    mSwipeSounds[0]=Sound'MM_Weapons.Knife.WD_knife_swipe_01'
    mSwipeSounds[1]=Sound'MM_Weapons.Knife.WD_knife_swipe_02'
    mSwipeSounds[2]=Sound'MM_Weapons.Knife.WD_knife_swipe_03'
    mSwipeSounds[3]=Sound'MM_Weapons.Knife.WD_knife_swipe_04'
    mSwipeSounds[4]=Sound'MM_Weapons.Knife.WD_knife_swipe_05'
    mSwipeSounds[5]=Sound'MM_Weapons.Knife.WD_knife_swipe_06'
    mCategory=2
    me3PAnimSet=5
    mMagSize=1
    mAllowedFireModes=1
    mAimedShotRiseMin=0.0000000
    mAimedShotRiseMax=0.0000000
    mNormalShotRiseMin=0.0000000
    mNormalShotRiseMax=0.0000000
    mAltFireAnim="1st_Attack2"
    PickupAmmoCount=9999
}