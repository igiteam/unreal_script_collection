/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_Boomer_Mantle extends GSM_NonCoverUserMantleOverCover;

/** Radius to check for potential kick victims */
var float VictimCheckRadius;

/** Damage to apply to kick victims */
var float MeleeDamage;

/** Radius to actually damage victims */
var float MeleeDamageRadius;

/** FOV to acquire melee targets */
var Vector2D MeleeAcquireDotFOV;

/** Location where the Pawn started the mantle */
var transient Vector MoveStartLocation;

/** Damagetype to apply to kick victims */
var class<GearDamageType> KickDamageType;

/** Sound to play upon successful kick */
var SoundCue KickSound;

/** Screen Shake play for kicker on impact */
var protected const GearCameraShake ImpactScreenShake;

/** Whether this is a mantle kick or normal mantle */
var bool bMantleKick;

/**
 * See if we should mantle kick this time
 * 
 * @param bForced - whether the special move was forced
 * 
 * @param PrevMove - the previous special move
 */
function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	Super.SpecialMoveStarted(bForced, PrevMove);

	bMantleKick = FALSE;
	if (GetVictimPawn(PawnOwner.Location) != None)
	{
		bMantleKick = TRUE;
		PawnOwner.SetCollision(PawnOwner.bCollideActors, false, true);
		MoveStartLocation = PawnOwner.Location;
	}
}

/** Start the mantle kick when we fall */
event DoingJumpToFallPhysicsTransition()
{
	if (bMantleKick && PawnOwner.Role == ROLE_Authority)
	{
		DoMantleKickDamage();
	}

	Super.DoingJumpToFallPhysicsTransition();
}

/**
 * Clean up the mantle kick
 * 
 * @param PrevMove - the previous special move
 * 
 * @param NextMove - the next special move
 */
simulated function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	if (bMantleKick)
	{
		PawnOwner.SetCollision(PawnOwner.bCollideActors, PawnOwner.default.bBlockActors, PawnOwner.default.bIgnoreEncroachers);
	}

	Super.SpecialMoveEnded(PrevMove, NextMove);
}

/**
 * Check if Victim can be hit with a mantle kick
 * 
 * @param Victim - the pawn to test
 * 
 * @param StartLocation - the start location of the mantle
 * 
 * @return true if Victim will be damaged by a Mantle Kick
 */
final function bool IsValidVictim(GearPawn Victim, Vector StartLocation)
{
	local vector VictimLoc, DirToVictim, DirToVictim2D, CheckDir, CheckDir2D;

	// If Victim cannot be attacked by PawnOwner, bail immediately
	if( Victim == PawnOwner ||
		PawnOwner.IsSameTeam(Victim) ||
		//Victim.IsDBNO(false, true)   ||   // Design keeps flipflopping on whether to allow mantle kicking of DBNO enemies.
		( Victim.Base != None && Victim.Base.IsA('GearPawnRidable_Base') ) ||
		Victim.IsDoingSpecialMove(SM_MantleKick) ||
		(!Victim.CanDoSpecialMove(SM_StumbleFromMantleKick) && !Victim.IsDBNO() && !Victim.IsAKidnapper()) )
	{
		return FALSE;
	}

	VictimLoc = Victim.GetMeleeHitTestLocation();
	DirToVictim = Normal(VictimLoc - StartLocation);
	CheckDir = vector(PawnOwner.Rotation);

	// If our check FOV is a cone, then perform a simple dot product
	if( MeleeAcquireDotFOV.X == MeleeAcquireDotFOV.Y )
	{
		// Make sure victim is in FOV
		if( DirToVictim dot CheckDir < MeleeAcquireDotFOV.X )
		{
			return FALSE;
		}
	}
	// Not a cone, so do separate FOV checks for horizontal and vertical planes
	else
	{
		// First check for horizontal plane
		CheckDir2D.X	= CheckDir.X;
		CheckDir2D.Y	= CheckDir.Y;
		CheckDir2D.Z	= 0.f;
		CheckDir2D		= Normal(CheckDir2D);

		DirToVictim2D.X	= DirToVictim.X;
		DirToVictim2D.Y	= DirToVictim.Y;
		DirToVictim2D.Z	= 0.f;
		DirToVictim2D	= Normal(DirToVictim2D);

		// Make sure victim is in horizontal FOV
		if( DirToVictim2D dot CheckDir2D < MeleeAcquireDotFOV.X )
		{
			return FALSE;
		}

		// Then, check for vertical plane
		DirToVictim2D.X	= DirToVictim dot CheckDir2D;
		DirToVictim2D.Y	= 0.f;
		DirToVictim2D.Z	= DirToVictim.Z;
		DirToVictim2D	= Normal(DirToVictim2D);

		CheckDir2D		= Vect(1.f, 0.f, 0.f);

		// Make sure victim is in vertical FOV
		if( DirToVictim2D dot CheckDir2D < MeleeAcquireDotFOV.Y )
		{
			return FALSE;
		}
	}
	return TRUE;
}

/** Apply mantle kick damage to deserving pawns */
function DoMantleKickDamage()
{
	local GearPawn VictimPawn;
	local GearPC VictimPC;
	local float Damage;

	//PawnOwner.DrawDebugCone(MoveStartLocation, vector(PawnOwner.Rotation), MeleeDamageRadius, Acos(MeleeAcquireDotFOV.X), Acos(MeleeAcquireDotFOV.Y), 16, MakeColor(255,0,0,255), TRUE);

	ForEach PawnOwner.CollidingActors(class'GearPawn', VictimPawn, MeleeDamageRadius, MoveStartLocation)
	{
		if( IsValidVictim(VictimPawn, MoveStartLocation) )
		{
			Damage = MeleeDamage;
			if( Damage > 0 )
			{
				// Give Damage
				VictimPawn.TakeDamage(Damage, PawnOwner.Controller, VictimPawn.Location, vector(PawnOwner.Rotation), KickDamageType);

				VictimPawn.SoundGroup.PlayEffort(VictimPawn, GearEffort_MantleKicked);

				// and make them stumble
				if( !VictimPawn.bPlayedDeath && !VictimPawn.InGodMode() )
				{
					if( VictimPawn.Role == ROLE_Authority )
					{
						VictimPawn.DoStumbleFromMantleKickSpecialMove(PawnOwner);
					}
				}
			}

			PawnOwner.PlaySound(KickSound);

			// do melee hit effects...
			if( PCOwner != None )
			{
				PCOwner.ClientPlayCameraShake(ImpactScreenShake,,true);
			}

			VictimPC = GearPC(VictimPawn.Controller);
			if( VictimPC != None )
			{
				VictimPC.ClientPlayForceFeedbackWaveform(class'GearWaveForms'.default.MeleeHit);
			}
		}
	}
}

/**
 * Find a possible pawn to mantle kick
 * 
 * @param StartLocation - where the mantle kick will start
 */
final function GearPawn GetVictimPawn(Vector StartLocation)
{
	local GearPawn FoundPawn;

	//PawnOwner.FlushPersistentDebugLines();
	//PawnOwner.DrawDebugCone(PawnOwner.Location, vector(PawnOwner.Rotation), VictimCheckRadius, Acos(MeleeAcquireDotFOV.X), Acos(MeleeAcquireDotFOV.Y), 16, MakeColor(0,0,255,255), TRUE);

	ForEach PawnOwner.CollidingActors(class'GearPawn', FoundPawn, VictimCheckRadius, StartLocation)
	{
		if( IsValidVictim(FoundPawn, StartLocation) )
		{
			return FoundPawn;
		}
	}
	return None;
}

/**
 * Finds mantle distance.
 * Uses Mantle Target as a suggestion, but performs a trace to find how thick cover is.
 * mantle targets are from slots to slots, and player may not be on a slot.
 * Also "slots to slots" may not be aligned with each other (along cover normal/pawn rotation)
 * so this information cannot be used as is.
 * Here a trace is performed to find how thick this cover is, and then uses that to scale root motion
 * on jumping animation to make sure player can jump over without getting stuck inside cover.
 */
simulated function bool FindMantleDistance()
{
	local Vector	StartTrace, EndTrace;
	local float		AnimScale;//, CoverThickness;
	local GearPawn  VictimPawn;

	// find victim
	VictimPawn = GetVictimPawn(PawnOwner.Location);

	// if victim
	if ( VictimPawn != None )
	{
		// Get mantle information
		GetMantleInformation(MantleStartLoc, MantleEndLoc, MantleDistance);

		StartTrace = BP2Vect(MantleStartLoc);
		EndTrace = BP2Vect(MantleEndLoc);

		// Find mantle distance and give victim pawn to ignore
		if(PawnOwner.FindMantleDistance(StartTrace,EndTrace,MantleDistance, VictimPawn))
		{
				// Get DrawScale value
				AnimScale = PawnOwner.DrawScale*PawnOwner.Mesh.Scale;
				// Scale Factor based on current mantle distance, and default one. Do not reduce it, only increase it
				RootMotionScaleFactor = FMax(MantleDistance / (DefaultMantleDistance*AnimScale), 1.f);
				//`log(">>>>>>>>>>>>>>>>>>>>>>INNER TRACE>>>>>>>>>>>>>>>>>>>>>>>"@HitActor@"HitLoc:"@HitLocation@"MantleEndLoc:"@BP2Vect(MantleEndLoc));
				//`log("Mantle Distance:" @ MantleDistance @ "ScaleFactor:" @ RootMotionScaleFactor);
		}
		else
		{
			return FALSE;
		}


		//PawnOwner.FlushPersistentDebugLines();
		//PawnOwner.DrawDebugLine(PawnOwner.Location, PawnOwner.Location + GetMantleDir( BP2Vect(MantleStartLoc), BP2Vect(MantleEndLoc) ) * MantleDistance, 0, 255, 0, TRUE);
		//PawnOwner.DebugFreezeGame();

		Vect2BP( StartLoc, PawnOwner.Location );
		AccumRootMotionDelta = vect(0,0,0);
		return TRUE;
	}

	return Super.FindMantleDistance();
}

/** 
 * Override mantle's ClearLanding() to avoid adding a collision cylinder at our destination,
 * which would cause problems for the Leader who is located where that cylinder would be placed
 */
function ClearLanding()
{
	if (!bMantleKick)
	{
		Super.ClearLanding();
	}
}

/**
 * Overridden to give default fall velocity, since we don't call VerifyLandingClear() for mantle kick to calculate a new fall velocity
 * 
 * @return the fall velocity vector
 */
simulated function vector GetFallVelocityToHitEstimatedLandingPos()
{
	if (bMantleKick)
	{
		return Vector(PawnOwner.Rotation)*FallForwardVelocity;
	}

	return Super.GetFallVelocityToHitEstimatedLandingPos();
}

// 	DefaultMantleDistance=283.0f
// 	FallForwardVelocity=600.f
// 	GravityScale=6.f

defaultproperties
{
	DefaultMantleDistance=236.0f
	FallForwardVelocity=100.f
	GravityScale=4.f
	bCheckForMirrorTransition=FALSE
	BSList_Jump(0)=(Stance=((Slot=BS_FullBody,AnimName="AR_Mantle_Start")))
	BSList_Fall(0)=(Stance=((Slot=BS_FullBody,AnimName="AR_Mantle_Mid")))
	BSList_Land(0)=(Stance=((Slot=BS_FullBody,AnimName="AR_Mantle_End")))

	// Mantle kick variables
	VictimCheckRadius=300.f
	MeleeDamageRadius=350.f
	MeleeDamage=200.f
	KickDamageType=class'GDT_MantleKick'
	MeleeAcquireDotFOV=(X=0.9f,Y=0.7f)	
	KickSound=SoundCue'Foley_BodyMoves.CoverCombat.CoverCombat_KickCue'

	Begin Object Class=GearCameraShake Name=ImpactScreenShake0
		OscillationDuration=0.400000
		LocOscillation={(X=(Amplitude=10.f,Frequency=30.f,InitialOffset=EOO_OffsetRandom),
						Y=(Amplitude=10.f,Frequency=30.f),
						Z=(Amplitude=10.f,Frequency=30.f))}
	End Object
	ImpactScreenShake=ImpactScreenShake0
}
