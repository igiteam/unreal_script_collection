
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_MantleKick extends GSM_MidLvlJumpOver;

/** Radius to check for potential victims */
var float VictimCheckRadius;
/** Radius to actually damage victims */
var float MeleeDamageRadius;
/** Damage to apply to hit victims */
var float MeleeDamage;
/** damagetype to apply to hit victims */
var class<GearDamageType> KickDamageType;
/** FOV to acquire melee targets */
var Vector2D MeleeAcquireDotFOV;
/** Location where the Pawn started the mantle */
var transient Vector MoveStartLocation;
/** Sound to play upon successful kick */
var SoundCue KickSound;
/** Name of camera animation to play when this special move starts. */
var Array<CameraAnim>	CameraAnims;
/** Screen Shake play for kicker on impact */
var protected const GearCameraShake ImpactScreenShake;

protected function bool InternalCanDoSpecialMove()
{
	// We can only do MantleKick if we have a victim and are in cover that we can mantle
	if( Super.InternalCanDoSpecialMove() )
	{
		return ( GetVictimPawn(PawnOwner.Location) != None );
	}
	return FALSE;
}


/** Get nearby player in cover to mantle kick */
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

/** Returns true if Victim will be damaged by a Mantle Kick */
final function bool IsValidVictim(GearPawn Victim, Vector StartLocation)
{
	local vector VictimLoc, DirToVictim, DirToVictim2D, CheckDir, CheckDir2D;
	local float Thresh;

	// If Victim cannot be attacked by PawnOwner, bail immediately
	if( Victim == PawnOwner ||
		PawnOwner.IsSameTeam(Victim) ||
		//Victim.IsDBNO(false, true)   ||   // Design keeps flipflopping on whether to allow mantle kicking of DBNO enemies.
		( Victim.Base != None && Victim.Base.IsA('GearPawnRidable_Base') ) ||
		Victim.IsDoingSpecialMove(SM_MidLvlJumpOver) ||
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

	// ensure victim is far enough away (e.g. not right on top of us) .. fixes cases of victims being kick-able when on near side of cover
	// native static final function DrawDebugCylinder(vector Start, vector End, float Radius, INT Segments, byte R, byte G, byte B, optional bool bPersistentLines) const; // SLOW! Use for debugging only!
	Thresh = (PawnOwner.GetCollisionRadius() + Victim.GetCollisionRadius()+5);
	Thresh *= Thresh;
	
	if( VSizeSq2D(Victim.Location - StartLocation) < Thresh )
	{
		return FALSE;
	}

	return TRUE;
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
 *  Override mantle's ClearLanding() to avoid adding a collision cylinder at our destination,
 *  which would cause problems for the Leader who is located where that cylinder would be placed.
 *  Instead, place a cylinder at the starting point to prevent our victim from mantling into us.
 */
simulated function ClearLanding()
{
	// and a second in between to keep people from getting in the middle
	PlaceholderCylinder = PawnOwner.Spawn(class'MantlePlaceholderCylinder',,,PawnOwner.Location);
	if(PlaceholderCylinder != None)
	{
		PlaceholderCylinder.PawnToIgnore = PawnOwner;
		PlaceholderCylinder.SetCollisionSize(PawnOwner.GetCollisionRadius()*1.5f,30.f);
	}
}

/** Overridden to give default fall velocity, since we don't call VerifyLandingClear() for mantle kick to calculate a new fall velocity */
simulated function vector GetFallVelocityToHitEstimatedLandingPos()
{
	return Vector(PawnOwner.Rotation)*FallForwardVelocity;
}

protected function bool HandleHitActor(Actor HitActor, bool bIsAI, vector HitLocation, optional vector StartDownTrace, out optional INT bHitSomethingHoriz)
{
	local GearPawn GP;
	// Do not avoid victims - we WANT to hit them! :)

	GP = GearPawn(HitActor); 
	if( GP != None && IsValidVictim(GP,PawnOwner.Location) )
	{
		return TRUE;
	}
	return Super.HandleHitActor(HitActor, bIsAI, HitLocation, StartDownTrace, bHitSomethingHoriz);
}

/** Notification forwarded by GearAnimNotify_SpecialMove */
function AnimNotify(AnimNodeSequence SeqNode, GearAnimNotify_SpecialMove NotifyObject)
{
	if( PawnOwner.Role == ROLE_Authority )
	{
		DoMantleKickDamage();
	}
}

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

simulated function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	MoveStartLocation = PawnOwner.Location;
	PawnOwner.SetCollision(PawnOwner.bCollideActors, false, true);
	Super.SpecialMoveStarted(bForced, PrevMove);
}

simulated function PlayJump()
{
	Super.PlayJump();
	PlayCamera();
}

simulated function PlayLand()
{
	Super.PlayLand();

	if (PlaceholderCylinder != None)
	{
		PlaceholderCylinder.Destroy();
		PlaceholderCylinder = None;
	}
}

simulated function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	PawnOwner.SetCollision(PawnOwner.bCollideActors, PawnOwner.default.bBlockActors, PawnOwner.default.bIgnoreEncroachers);
	Super.SpecialMoveEnded(PrevMove, NextMove);
}

simulated function PlayCamera()
{
	local int		AnimIdx;
	if( PCOwner != None && PawnOwner.IsLocallyControlled() )
	{
		AnimIdx = PCOwner.ChooseRandomCameraAnim(CameraAnims, 0.7f);
		if (AnimIdx != INDEX_NONE)
		{
			Super.PlayCameraAnim(PawnOwner, CameraAnims[AnimIdx],,0.7f, 0.25f, 0.25f);
		}
	}
}

defaultproperties
{
	VictimCheckRadius=300.f
	MeleeDamageRadius=350.f
	MeleeDamage=200.f
	FallForwardVelocity=10.f
	KickDamageType=class'GDT_MantleKick'

	MeleeAcquireDotFOV=(X=0.9f,Y=0.7f)

	bDisablePOIs=TRUE

	bCancelIfFailedOnServer=TRUE

	// mantle kick distance is 114.f
	DefaultMantleDistance=114.f

	KickSound=SoundCue'Foley_BodyMoves.CoverCombat.CoverCombat_KickCue'

	BSList_Jump(0)=(Stance=((Slot=BS_FullBody,AnimName="AR_Mantle_Kick_Start")))
	BSList_Fall(0)=(Stance=((Slot=BS_FullBody,AnimName="AR_Mantle_Kick_Mid")))
	BSList_Land(0)=(Stance=((Slot=BS_FullBody,AnimName="AR_Mantle_Kick_End")))

	bCheckForMirrorTransition=TRUE
	BSList_MirroredJump(0)=(Stance=((Slot=BS_FullBody,AnimName="AR_Mantle_Kick_Mirrored_Start")))
	BSList_MirroredFall(0)=(Stance=((Slot=BS_FullBody,AnimName="AR_Mantle_Kick_Mirrored_Mid")))
	BSList_MirroredLand(0)=(Stance=((Slot=BS_FullBody,AnimName="AR_Mantle_Kick_Mirrored_End")))

	Action={(
			 ActionName=MantleOver,
			 ActionIconDatas=(	(ActionIcons=((Texture=Texture2D'Warfare_HUD.WarfareHUD_ActionIcons',U=212,V=314,UL=35,VL=43))), // A Button
								(ActionIcons=((Texture=Texture2D'Warfare_HUD.WarfareHUD_ActionIcons',U=284,V=346,UL=104,VL=91)))	),
			)}

	CameraAnims(0)=CameraAnim'COG_MarcusFenix.Camera_Anims.AR_Melee_Mantle_Kick'

	Begin Object Class=GearCameraShake Name=ImpactScreenShake0
		OscillationDuration=0.400000
		LocOscillation={(X=(Amplitude=10.f,Frequency=30.f,InitialOffset=EOO_OffsetRandom),
						Y=(Amplitude=10.f,Frequency=30.f),
						Z=(Amplitude=10.f,Frequency=30.f))}
	End Object
	ImpactScreenShake=ImpactScreenShake0

	bDisableLook=TRUE
}

