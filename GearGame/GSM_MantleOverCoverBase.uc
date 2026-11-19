
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_MantleOverCoverBase extends GSM_BaseVariableFall
	native(SpecialMoves)
	abstract;

/** Animations to play */
var			Array<GearPawn.BodyStance>	BSList_Jump, BSList_Fall, BSList_Land, BSList_MirroredJump, BSList_MirroredFall, BSList_MirroredLand;
var			GearPawn.BodyStance			BS_PlayedStance;
var			int							VariationIndex;

/** Set this to FALSE to not play a mirror transition */
var	const	bool				bCheckForMirrorTransition;
/** Are we using the mirrored version of the animations? */
var			bool				bUsingMirroredVersion;

/** This is the angle for which we scan for cover nodes to then check for mantling over capability **/
var config	float				CheckForAutoMantleOverFOV;

/** Default mantle over distance. Used to scale root motion. */
var	const	float				DefaultMantleDistance;
/** Scale factor for root motion. To adapt jump to cover thickness */
var			float				RootMotionScaleFactor;
/** TRUE if doing a jump to fall physics transition during that frame. */
var			bool				bJumpToFallPhysicsTransition;
/** When Jump animation finishes in the middle of a frame, this indicates the time left that should be processed with falling physics. */
var			float				JumpToFallTransitionTime;
/** Forward velocity applied when falling */
var			float				FallForwardVelocity;

/** Temporary cylinders placed at the destination to prevent other players from blocking the mantle */
var MantlePlaceholderCylinder PlaceholderCylinder,PlaceholderCylinder2;

/**
 * Cached cover information, because this special move breaks Pawn out of cover.
 */
var float				CoverInfoTimestamp;
var	CoverLink			CurrentLink;
var	CoverSlot			CurrentSlot, RightSlot, LeftSlot;
var	int					CurrentSlotIdx, RightSlotIdx, LeftSlotIdx;
var bool				bIsOnASlot;
var float				CurrentSlotPct;

/** debug.. useful for testing the travlled distance of the mantle */
var BasedPosition		StartLoc;
var vector				AccumRootMotionDelta;
var vector				AccumLocationDelta;

var bool				bAllowTransitionToAMove;

var float				MantleDistance;
var BasedPosition		MantleStartLoc, MantleEndLoc;

// ref to the pawn we need to make move away from our destination when/if we actually mantle
var array<GearPawn>		AIsToPushOutOfDestination;

var BasedPosition		EstimatedLandingLoc;

/** when determining if we are right on a slot, or between two slots use this tolerance value for CurrentSlotPct */
var float               OnSlotTolerance;

var transient vector LastLocation;

/** Jump Blend Out Time for mantle
 *  By default, due to root motion handling, (not to miss anything) we play longer
 *  But for special cases - i.e. Thrashball - we don't want to pause it in the middle
 */
var float       JumpBlendOutTime;

// C++ functions
cpptext
{
	virtual void TickSpecialMove(FLOAT DeltaTime);
}

//`define debugmantle(msg)	`log(`msg)
`define debugmantle(msg)

protected function bool InternalCanDoSpecialMove()
{
	local GearPC		PC;
	local bool			bCheck;
	local Actor HitActor;
	local vector HitLocation, HitNormal;
	local vector StartTrace, EndTrace, Extent;
	local vector SlotLoc1,SlotLoc2,hitloc;

	PC = GearPC(PawnOwner.Controller);

	if( PawnOwner.CurrentLink == None || ( PC != None && PC.bBreakFromCover ) )
	{
		`debugmantle(PawnOwner.WorldInfo.TimeSeconds @ class @ GetFuncName() @ PawnOwner @ "FAILED because not in cover");
		return FALSE;
	}

	// don't allow if carrying a heavy weapon
	if( PawnOwner.MyGearWeapon != None && PawnOwner.MyGearWeapon.WeaponType == WT_Heavy )
	{
		`debugmantle(PawnOwner.WorldInfo.TimeSeconds @ class @ GetFuncName() @ PawnOwner @ "FAILED because carrying a heavy weapon");
		return FALSE;
	}

	CurrentSlotIdx = PawnOwner.CurrentSlotIdx;
	if( PC != None )
	{
		CurrentSlotIdx = PawnOwner.PickClosestCoverSlot(TRUE);

		// MT-> if this is our pending move don't check joystick as joystick was already checked when we triggered the SM
		if( PC.IsLocalPlayerController() && !PawnOwner.bIsPendingMove )
		{
			`debugmantle( "Abs(PC.RemappedJoyUp): " $ Abs(PC.RemappedJoyUp) $ " Abs(PC.RemappedJoyRight) " $ Abs(PC.RemappedJoyRight)  );

			if( ( Abs(PC.RemappedJoyUp) < Abs(PC.RemappedJoyRight) || PC.RemappedJoyUp <= PC.DeadZoneThreshold ) && !PC.bForcedRoadieRun )
			{
				`debugmantle(PawnOwner.WorldInfo.TimeSeconds @ class @ GetFuncName() @ PawnOwner @ "FAILED because joy dir is not up enough");
				return FALSE;
			}
		}

		// Check if can mantle
		// If Pawn is right on a slot
		//`debugmantle(`showvar(PawnOwner.CurrentSlotPct)@`showvar(abs(PawnOwner.CurrentSlotPct-1.0))@`showvar(OnSlotTolerance));
		if( CurrentSlotIdx != -1 && (PawnOwner.CurrentSlotPct > (1.0-OnSlotTolerance) || PawnOwner.CurrentSlotPct < OnSlotTolerance))
		{
			`debugmantle("ON SLOT");
			bIsOnASlot = TRUE;

			bCheck =	CurrentSlotIdx >= 0 &&
						CurrentSlotIdx < PawnOwner.CurrentLink.Slots.Length &&
						PawnOwner.CurrentLink.Slots[CurrentSlotIdx].bCanMantle;
		}
		else	// in between 2 slots
		{
			`debugmantle("BETWEEN SLOTS");
			bIsOnASlot = FALSE;

			bCheck =	(PawnOwner.LeftSlotIdx	>= 0 && PawnOwner.LeftSlotIdx  < PawnOwner.CurrentLink.Slots.Length) && // Left  index in bounds
						(PawnOwner.RightSlotIdx >= 0 && PawnOwner.RightSlotIdx < PawnOwner.CurrentLink.Slots.Length) && // Right index in bounds
						PawnOwner.CurrentLink.Slots[PawnOwner.LeftSlotIdx].bCanMantle &&
						PawnOwner.CurrentLink.Slots[PawnOwner.RightSlotIdx].bCanMantle;
		}

		if( !bCheck )
		{
			`debugmantle(PawnOwner.WorldInfo.TimeSeconds @ class @ GetFuncName() @ PawnOwner @ "FAILED because slots don't allow a mantle");
			return FALSE;
		}

		// Prevent mantling from too far away
		if (PawnOwner.IsDoingSpecialMove(SM_Run2MidCov) && VSize(PawnOwner.CurrentLink.GetSlotLocation(CurrentSlotIdx) - PawnOwner.Location) > 96.f)
		{
			return FALSE;
		}

		// ensure there is nothing in between us and the slot we're mantling from
		StartTrace = PawnOwner.Location;
		Extent = PawnOwner.GetCollisionExtent();
		Extent *= 0.5;

		if( bIsOnASlot )
		{
			EndTrace		= PawnOwner.CurrentLink.GetSlotLocation(PawnOwner.CurrentSlotIdx);
		}
		// if in between 2 slots, interpolate direction between the 2 mantle targets.
		else
		{
			// Left dir
			SlotLoc1 = PawnOwner.CurrentLink.GetSlotLocation(PawnOwner.LeftSlotIdx);

			// Right dir
			SlotLoc2 = PawnOwner.CurrentLink.GetSlotLocation(PawnOwner.RightSlotIdx);

			EndTrace = VLerp(SlotLoc1,SlotLoc2,PawnOwner.CurrentSlotPct);
		}

		// ensure there is nothing in between us and the cover slot we're mantling from
		foreach PawnOwner.TraceActors(class'Actor',HitActor,HitLocation,HitNormal,EndTrace,StartTrace,Extent,,PawnOwner.TRACEFLAG_Blocking)
		{
			if (!HandleHitActor(HitActor, false, HitLoc))
			{
				return false;
			}
		}
	}
	else
	{
		// AI is alwyas on a slot
		bIsOnASlot = TRUE;
	}

	return SetCoverData();
}

/** Caches the cover data for the mantle. Returns false if a mantle cannot be executed */
simulated function bool SetCoverData()
{
	local bool bCheck;

	CurrentSlotIdx = PawnOwner.CurrentSlotIdx;

	// Check that the slot the player is on has a mantle target
	if( PawnOwner.Controller != None )
	{
		if( GearPC(PawnOwner.Controller) != None )
		{
			CurrentSlotIdx = PawnOwner.PickClosestCoverSlot(TRUE);
		}

		CurrentLink	= PawnOwner.CurrentLink;

		if( bIsOnASlot )
		{
			bCheck = CurrentLink != None;
		}
		else
		{
			// Make sure all links are valid
			bCheck			= CurrentLink != None && LeftSlot.bCanMantle && RightSlot.bCanMantle;

			// Pawn is in between 2 slots
			bIsOnASlot		= FALSE;
			LeftSlotIdx		= PawnOwner.LeftSlotIdx;
			RightSlotIdx	= PawnOwner.RightSlotIdx;
			if( bCheck )
			{
				LeftSlot		= CurrentLink.Slots[LeftSlotIdx];
				RightSlot		= CurrentLink.Slots[RightSlotIdx];
			}
			CurrentSlotPct	= PawnOwner.CurrentSlotPct;

		}

		if( !bCheck )
		{
			`debugmantle(PawnOwner.WorldInfo.TimeSeconds @ class @ GetFuncName() @ PawnOwner @ "CoverSlot has no mantle target set! Deny mantle over! CurrentLink:" @ CurrentLink @ "CurrentSlotIdx:" @ CurrentSlotIdx);
			return FALSE;
		}

		// Adjust mantle to fit this cover's thickness.
		if( !FindMantleDistance() )
		{
			`debugmantle(PawnOwner.WorldInfo.TimeSeconds @ class @ GetFuncName() @ PawnOwner @ "FAILED because couldn't adjust mantle distance.");
			return FALSE;
		}

		CoverInfoTimestamp = PawnOwner.WorldInfo.TimeSeconds;
	}
	return TRUE;
}

simulated function GetMantleInformation( out BasedPosition InMantleStartLoc, out BasedPosition InMantleEndLoc, out float InMantleDistance)
{
	local Vector MantleDir;
	local vector Dir1, Dir2;

	// if on a single slot, mantle to MantleTarget slot directly
	if( bIsOnASlot )
	{
		MantleDir		= Vector(CurrentLink.GetSlotRotation(CurrentSlotIdx));
		MantleDir.Z		= 0.f;
	}
	// if in between 2 slots, interpolate direction between the 2 mantle targets.
	else
	{
		// Left dir
		Dir1			= Vector(CurrentLink.GetSlotRotation(LeftSlotIdx));
		Dir1.Z			= 0.f;

		// Right dir
		Dir2			= Vector(CurrentLink.GetSlotRotation(RightSlotIdx));
		Dir2.Z			= 0.f;

		MantleDir		= VLerp(Dir1, Dir2, CurrentSlotPct);
	}

	InMantleDistance = class'GearScout'.default.MaxMantleLateralDist;

	// Normalize Mantle Direction
	MantleDir		= Normal(MantleDir);
	Vect2BP( InMantleStartLoc, PawnOwner.Location );
	Vect2BP( InMantleEndLoc, PawnOwner.Location + MantleDir * InMantleDistance );
}


// default uses cover normal (overidden in non cover version)
simulated native function vector GetMantleDir( Vector InStartLoc, Vector InEndLoc );

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
	local Vector	StartTrace, EndTrace, FallStart;
	local float		AnimScale;//, CoverThickness;

	// Get mantle information
	GetMantleInformation(MantleStartLoc, MantleEndLoc, MantleDistance);

	StartTrace = BP2Vect(MantleStartLoc);
	EndTrace = BP2Vect(MantleEndLoc);

	if(PawnOwner.FindMantleDistance(StartTrace,EndTrace,MantleDistance))
	{
			// Get DrawScale value
			AnimScale = PawnOwner.DrawScale*PawnOwner.Mesh.Scale;

			// Scale Factor based on current mantle distance, and default one. Do not reduce it, only increase it
			RootMotionScaleFactor = FMax(MantleDistance / (DefaultMantleDistance*AnimScale), 1.f);

			//`log(">>>>>>>>>>>>>>>>>>>>>>INNER TRACE>>>>>>>>>>>>>>>>>>>>>>>"@"MantleStartLoc:"@BP2Vect(MantleStartLoc)@"MantleEndLoc:"@BP2Vect(MantleEndLoc));
			//`log(self@"Mantle Distance:" @ MantleDistance @ "ScaleFactor:" @ RootMotionScaleFactor@`showvar(DefaultMantleDistance)@`showvar(AnimScale));
	}
	else
	{
		return FALSE;
	}

	FallStart = StartTrace + Normal(EndTrace-StartTrace) * MantleDistance;
	if (!VerifyLandingClear(BP2Vect(MantleStartLoc),FallStart))
	{
		`debugmantle("landing isn't clear"@BP2Vect(MantleStartLoc)@"--"@BP2Vect(MantleEndLoc)@"--"@PawnOwner.Location);
		return FALSE;
	}

	//PawnOwner.FlushPersistentDebugLines();
	//PawnOwner.DrawDebugLine(PawnOwner.Location, PawnOwner.Location + GetMantleDir( BP2Vect(MantleStartLoc), BP2Vect(MantleEndLoc) ) * MantleDistance, 0, 255, 0, TRUE);
	//PawnOwner.DebugFreezeGame();

	Vect2BP( StartLoc, PawnOwner.Location );
	AccumRootMotionDelta = vect(0,0,0);

	return TRUE;
}

simulated function float GetEstimatedHorizFallDist()
{
	// assume he falls collision height to reach the ground, and find out long it will take to fall that dist, then multiply times fall velocity
	local float t;

	t = sqrt(PawnOwner.GetCollisionHeight()/(abs(PawnOwner.GetGravityZ())));
	return VSize2D(GetInitialFallVelocity() * t);
}

protected function bool HandleHitActor(Actor HitActor, bool bIsAI, vector HitLocation, optional vector StartDownTrace, out optional INT bHitSomethingHoriz)
{
	local Gearpawn GP;
	local GearPRI PRI;
	if (HitActor != None)
	{
		if (HitActor.bBlockActors && !HitActor.bTearOff )
		{
			// skip dead guys
			GP=Gearpawn(HitActor);
			if(GP != none && GP.Health <= 0 && !GP.IsDBNO())
			{
				return true;
			}

			// if we're a player, and we just ran into a non-player pawn, save them off so we push them out of the way if we actually mantle
			if(!bIsAI)
			{
				if(GP != none)
				{
					if(GP.Role == ROLE_Authority && !GP.IsHumanControlled())
					{
						AIsToPushOutOfDestination.AddItem(GP);
						// return true since we are going to push this mofo out of the way
						return true;
					}
					else if(GP.Role < ROLE_Authority) // if this isn't the server check the PRI to see if it's a bot but don't add anything to the list.. the server does that
					{
						PRI = GearPRI(GP.PlayerReplicationInfo);
						if(PRI != none && PRI.bBot)
						{
							return true;
						}
					}

				}
			}
			return false;
		}

		// if this is the first time we hit something but didn't bail, start the downcheck from here
		if(bHitSomethingHoriz==0)
		{
			bHitSomethingHoriz=1;
			StartDownTrace=HitLocation;
		}
	}
	return true;
}


//`define mantle_debug(expr) `expr
 `define mantle_debug(expr)
function bool VerifyLandingClear(vector InMantleStartLoc, vector InMantleEndLoc)
{
	local vector StartTrace, EndTrace;
	local vector HitLocation, HitNormal;
	local actor HitActor;
	local vector Extent;
	local bool bIsAI;
	local vector StartDownTrace;
	local INT bHitSomethingHoriz;
	local vector locEstLandingSpot;

	`mantle_debug(PawnOwner.DrawDebugLine(InMantleStartLoc, InMantleStartLoc+Vect(0,0,100),255,0,0,TRUE));
	`mantle_debug(PawnOwner.DrawDebugLine(InMantleEndLoc, InMantleEndLoc+Vect(0,0,100),0,255,255,TRUE));

	// reset list of pawns to push out each time we test
	AIsToPushOutOfDestination.length =0;

	// skip world geometry collision for players but retain for AI
	bIsAI = GearAI(PawnOwner.Controller) != None;

	Extent = PawnOwner.GetCollisionExtent() * vect(1.f,1.f,0.25f);

	// trace fwd and see if we hit something horizontally
	StartTrace = InMantleEndLoc + vect(0,0,1) * pawnOwner.GetCollisionHeight();
	EndTrace = StartTrace + GetMantleDir( InMantleStartLoc, InMantleEndLoc ) * GetEstimatedHorizFallDist();


	`mantle_debug(`log(`showvar(GetEstimatedHorizFallDist())@`showvar(GetInitialFallVelocity())));
	StartDownTrace=EndTrace;//by default start where the horiz trace ends
	foreach PawnOwner.TraceActors(class'Actor',HitActor,HitLocation,HitNormal,EndTrace,StartTrace,Extent,,PawnOwner.TRACEFLAG_Blocking)
	{
		// if we hit something blocking that wont' move away for us, bail
		if(!HandleHitActor(HitActor,bIsAI,HitLocation,StartDownTrace,bHitSomethingHoriz))
		{
			if( VSize2D(InMantleStartLoc - HitLocation) < class'GearScout'.default.MinMantleLateralDist )
			{
				`mantle_debug(PawnOwner.DrawDebugBox(HitLocation,Extent,255,0,0,TRUE));
				`mantle_debug(PawnOwner.DrawDebugLine(StartTrace,EndTrace,255,0,0,TRUE));
				return false;
			}
			else
			{
				`mantle_debug(PawnOwner.DrawDebugBox(HitLocation,Extent,255,255,0,TRUE));
				StartDownTrace = HitLocation;
				break;
			}
		}
	}
 	`mantle_debug(PawnOwner.DrawDebugBox(EndTrace,Extent,0,255,0,TRUE));
 	`mantle_debug(PawnOwner.DrawDebugLine(StartTrace,EndTrace,0,255,0,TRUE));

	// trace down and see if we hit something vertically
	EndTrace = StartDownTrace - vect(0,0,100);
	//HitActor = PawnOwner.Trace(HitLocation, HitNormal, EndTrace, StartTrace, true, Extent );
	foreach PawnOwner.TraceActors(class'Actor',HitActor,HitLocation,HitNormal,EndTrace,StartDownTrace,Extent,,PawnOwner.TRACEFLAG_Blocking)
	{
		// if we hit a pawn or we hit something too high, and handlehitactor bails.. we also bail on the mantle
		if((Pawn(HitActor) != none || MantlePlaceholderCylinder(HitActor) != None || abs(HitLocation.Z - StartTrace.Z) < class'GearScout'.default.MinMantleFallDist) && !HandleHitActor(HitActor,bIsAI,HitLocation))
		{
			`mantle_debug(PawnOwner.DrawDebugBox(HitLocation,Extent,255,0,0,TRUE));
			`mantle_debug(PawnOwner.DrawDebugLine(StartDownTrace,EndTrace,255,0,0,TRUE));
			return false;
		}
	}
 	`mantle_debug(PawnOwner.DrawDebugBox(EndTrace,Extent,0,255,0,TRUE));
 	`mantle_debug(PawnOwner.DrawDebugLine(StartDownTrace,EndTrace,0,255,0,TRUE));

	// assume we didn't hit anything
	locEstLandingSpot=EndTrace;

	// check against world geo
	HitActor = pawnOwner.Trace(HitLocation,HitNormal,EndTrace,StartDownTrace,false,Extent);
	if(HitActor != none)
	{
		if(bIsAI && abs(HitLocation.Z - StartTrace.Z) < Extent.Z)
		{
			return false;
		}

		locEstLandingSpot = HitLocation;
	}

	//compensate for extent only being 0.25 height
	 locEstLandingSpot += vect(0,0,1)*Extent.Z*2.0f;
	 Vect2BP(EstimatedLandingLoc,locEstLandingSpot);


	return true;
}

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	if( PawnOwner != None && CoverInfoTimestamp < PawnOwner.WorldInfo.TimeSeconds )
	{
		SetCoverData();
	}

	bAllowTransitionToAMove = FALSE;

	Super.SpecialMoveStarted(bForced,PrevMove);

	// Disable steps smoothing
	PawnOwner.bCanDoStepsSmoothing = FALSE;
	bJumpToFallPhysicsTransition = FALSE;

	LastLocation = PawnOwner.Location;
	//PawnOwner.FlushPersistentDebugLines();

	ClearLanding();
}

function ClearLanding()
{
	local GearPawn GP;
	local bool bDoCylinder;
	local vector CylLoc;

	bDoCylinder=true;

	// try and push AIs out of the way, if no AIs to push out of the way, then spawn cylidner on opposing side to keep ppl awayyy
	foreach AIsToPushOutOfDestination(GP)
	{
		if(GP!=none && GP.MYGearAI != none)
		{
			GP.MyGearAI.VacateMantleDestination(PawnOwner);
			bDoCylinder=false;
		}
	}
	AIsToPushOutOfDestination.length = 0;


	if(bDoCylinder)
	{
		CylLoc = BP2Vect(EstimatedLandingLoc);
		PlaceholderCylinder = PawnOwner.Spawn(class'MantlePlaceholderCylinder',,,CylLoc);
		if (PlaceholderCylinder != None)
		{
			PlaceholderCylinder.PawnToIgnore = PawnOwner;
			PlaceholderCylinder.SetCollisionSize(PawnOwner.GetCollisionRadius()*1.15f,PawnOwner.GetCollisionHeight());
			//PawnOwner.DrawDebugBox(CylLoc,pawnOwner.GetCollisionExtent()*vect(1.15f,1.15f,1.f),255,255,0,TRUE);
		}

		// and a second in between to keep people from getting in the middle
		CylLoc = BP2Vect(MantleEndLoc);
		PlaceholderCylinder2 = PawnOwner.Spawn(class'MantlePlaceholderCylinder',,,CylLoc);
		if(PlaceholderCylinder2 != None)
		{
			PlaceholderCylinder2.PawnToIgnore = PawnOwner;
			PlaceholderCylinder2.SetCollisionSize(PawnOwner.GetCollisionRadius()*1.35f,PawnOwner.GetCollisionHeight());
			//PawnOwner.DrawDebugBox(CylLoc,pawnOwner.GetCollisionExtent()*vect(1.35f,1.35f,1.f),255,255,0,TRUE);
		}
	}
}


/**
 * Pick a mantle variation
 * This means that clients and server won't be playing the same animation,
 * but we don't really care as long as the root motion and physics are the same.
 */
simulated function INT PickVariationIndex()
{
	return 	Rand(BSList_Jump.Length);
}

/** called on a timer to trigger the cover link delegate for mantling in case something wanted to be notified */
final function TriggerNotify()
{
	if (CoverLink_Spawnable(CurrentLink) != None)
	{
		CoverLink_Spawnable(CurrentLink).NotifyMantle(PawnOwner);
	}
}

/** Play Jump. */
simulated function PlayJump()
{
	local rotator NewRotation;
	local int MantleRotYaw;
	local float MantleAnimTime;
	local vector MantleDir;

//	`log(PawnOwner.WorldInfo.TimeSeconds @ class @ GetFuncName() @ PawnOwner);
	//`AILog_Ext(GetFuncName(),,Pawnowner.MyGearAI);

	MoveType = EMT_Jump;

	// Pick a mantle variation
	// This means that clients and server won't be playing the same animation,
	// but we don't really care as long as the root motion and physics are the same.
	VariationIndex = PickVariationIndex();

	// Play Jump animation.
	if( bCheckForMirrorTransition && PawnOwner.bIsMirrored )
	{
		bUsingMirroredVersion	= TRUE;
		BS_PlayedStance			= BSList_MirroredJump[VariationIndex];

		// Play body stance animation.
		MantleAnimTime = PawnOwner.BS_Play(BS_PlayedStance, SpeedModifier, 0.25f / SpeedModifier, JumpBlendOutTime, FALSE, TRUE);

		// Play animation mirrored
		PawnOwner.BS_SetMirrorOptions(BS_PlayedStance, FALSE, TRUE, TRUE);

		// This is a super hack to not trigger the mirror transition blend out just now.
		// We want to play 3 animations in a row. ugh!
		if( PawnOwner.MirrorNode != None )
		{
			PawnOwner.MirrorNode.bLockBlendOut = TRUE;
		}
	}
	else
	{
		bUsingMirroredVersion = FALSE;
		BS_PlayedStance = BSList_Jump[VariationIndex];
		MantleAnimTime = PawnOwner.BS_Play(BS_PlayedStance, SpeedModifier, 0.25f / SpeedModifier, JumpBlendOutTime, FALSE, TRUE);
	}

	if (PawnOwner.Role == ROLE_Authority)
	{
		PawnOwner.SetTimer(MantleAnimTime * 0.5, false, nameof(TriggerNotify), self);
	}

	// Turn on Root motion on animation node
	PawnOwner.BS_SetRootBoneAxisOptions(BS_PlayedStance, RBA_Translate, RBA_Translate, RBA_Translate);

	// Enable end of animation notification. This is going to call SpecialMoveEnded()
	PawnOwner.BS_SetAnimEndNotify(BS_PlayedStance, TRUE);

	// Turn on Root motion on mesh.
	//`log(GetFuncName()@" Setting RootMotionMode -- Old:" @ PawnOwner.Mesh.RootMotionMode @ "to RMM_Accel");

	PawnOwner.Mesh.RootMotionMode = RMM_Accel;

	// Set Jumping physics
	PawnOwner.SetPhysics(JumpingPhysics);
	// Reset the base to the clamped base if pawn has one
	PawnOwner.SetBase( PawnOwner.ClampedBase );

	// Set smaller collision cylinder to get around mid level cover not respecting standard height
	PawnOwner.SetCollisionSize(PawnOwner.default.CylinderComponent.CollisionRadius, PawnOwner.default.CylinderComponent.CollisionHeight * 0.5f);
	//PawnOwner.SetCollision(false,false,false);

	// unnghh!
	PawnOwner.SoundGroup.PlayEffort(PawnOwner, GearEffort_MantleEffort, true);
	PawnOwner.SoundGroup.PlayFoleySound(PawnOwner, GearFoley_Body_Mantle);

	// if local player or server
	if( PawnOwner.Controller != None )
	{
		// Have Pawn face mantle direction
		MantleDir = GetMantleDir(BP2Vect(MantleStartLoc),BP2Vect(MantleEndLoc));

		//PawnOwner.DrawDebugLine(PawnOwner.Location, PawnOwner.Location + MantleDir * 1000,255,255,0,TRUE);

		MantleRotYaw	= Rotator(MantleDir).Yaw;

		// Pawn
		NewRotation		= PawnOwner.Rotation;
		NewRotation.Yaw	= MantleRotYaw;

		if ( PawnOwner.IsHumanControlled() )
		{
			SetFacePreciseRotation(NewRotation,0);
		}
		else
		{
			// I'd like it to be not unlocked when starting to play jump until it gets out of this mantle cover state
			// Default SetFacePreciseRotation behavior is to let it go after reached
			// This guarantees that it will not allow any other rotation change, but I need to unlock it before get out
			PawnOwner.SetDesiredRotation(NewRotation, TRUE, FALSE, 0.15f);
		}

		// Controller for AI
		if( AIController(PawnOwner.Controller) != None )
		{
			NewRotation		= PawnOwner.Controller.Rotation;
			NewRotation.Yaw	= MantleRotYaw;
		}

		// Adapt mantle to fit path network
		AdaptJumpToPathing();
	}
}


/**
 * Check mantle target, and adapt jump by scaling root motion
 * So Pawn falls in right spot.
 */
simulated function AdaptJumpToPathing()
{
	// Scale root motion translation by ScaleFactor, except for Z component.
	PawnOwner.Mesh.RootMotionAccelScale.X = RootMotionScaleFactor;
	PawnOwner.Mesh.RootMotionAccelScale.Y = RootMotionScaleFactor;
	PawnOwner.Mesh.RootMotionAccelScale.Z = 1.f;
}


/** Stop Jump animation and perform any clean up to restore Pawn is original state. */
simulated function StopJump()
{
//	`log(PawnOwner.WorldInfo.TimeSeconds @ class @ GetFuncName() @ PawnOwner);

	// Restore original collision cylinder height
	PawnOwner.SetCollisionSize(PawnOwner.default.CylinderComponent.CollisionRadius, PawnOwner.default.CylinderComponent.CollisionHeight);
	//PawnOwner.SetCollision(PawnOwner.default.bCollideWorld,PawnOwner.default.bCollideActors,Pawnowner.default.bIgnoreEncroachers);
	PawnOwner.FitCollision();
}


/** Notification called when body stance animation finished playing */
simulated function BS_AnimEndNotify(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{

	//`AILog_Ext(GetFuncName()@ExcessTime@self@"usingmirrored?"@bUsingMirroredVersion@BS_PlayedStance.AnimName[BS_FullBody]@SeqNode.AnimSeqName@"Startloc:"@BP2Vect(StartLoc)@"CurrentLoc:"@PawnOwner.Location@RootMotionScaleFactor,,Pawnowner.MyGearAI);
//	`log(PawnOwner.WorldInfo.TimeSeconds @ GetFuncName() @ PawnOwner @ "PlayedTime:" @ PlayedTime @ "ExcessTime:" @ ExcessTime);
	if( MoveType == EMT_Jump )
	{
		//`log(">>>>>>>>>>>>>>>>>>>>>>>>>> ACTUAL DISTANCE--"@VSize2D(BP2Vect(StartLoc)-PawnOwner.Location)@"RootMotionDelta:"@VSize(AccumRootMotionDelta));
		//`AILog_Ext(">>>>>>>>>>>>>>>>>>>>>>>>>> ACTUAL DISTANCE--"@VSize2D(BP2Vect(StartLoc)-PawnOwner.Location)@"RootMotionDelta:"@VSize(AccumRootMotionDelta),,PawnOwner.MyGearAI);
		// Animation stopped playing, and we wish to use root motion that was extracted on this frame.
		// However that rarely maps to a full frame of movement, so we need to calculate the movement for a full frame.
		// So get the time left for this frame and simulate falling physics for that.

		// Time that went by beyond end of jumping animation.
		// Clamp to a min of 10FPS in case transition happened during a freeze, to avoid sending the player across the level
		JumpToFallTransitionTime = FMin(ExcessTime, 0.1f);

		// On simulated proxies, transition to falling right away
		if( PawnOwner.Role == ROLE_SimulatedProxy )
		{
			PlayFall();
		}
		// otherwise, delay transition to next frame, to have physics process root motion.
		else
		{
			bJumpToFallPhysicsTransition = TRUE;
		}
	}
	// Super hack -- see below in PlayFallAnimation()
	//else if( MoveType == EMT_Fall && PawnOwner.WorldInfo.NetMode == NM_ListenServer && !PawnOwner.IsLocallyControlled() )
	//{
	//	Landed(0.f, 0.f);
	//}
	// If we're done playing the land animation, we can end this special move.
	else if( MoveType == EMT_Land )
	{
		PawnOwner.EndSpecialMove();
	}
}

event DoingJumpToFallPhysicsTransition()
{
//	`log(PawnOwner.WorldInfo.TimeSeconds @ class @ GetFuncName() @ "JumpToFallTransitionTime:" @ JumpToFallTransitionTime);

	// Start blending to the Fall animation.
	PlayFallAnimation(JumpToFallTransitionTime);

	// Root motion has been applied, transition is done, start fall part.
	PlayFall();
}

//function RootMotionExtracted(SkeletalMeshComponent SkelComp, out BoneAtom ExtractedRootMotionDelta)
//{
//	AccumRootMotionDelta += ExtractedRootMotionDelta.Translation;
//}

simulated function PlayFallAnimation(float StartTime)
{
	// Stop Jump animation
	//PawnOwner.BS_Stop(BS_PlayedStance, 0.2f);
	PawnOwner.BS_SetAnimEndNotify(BS_PlayedStance, FALSE);


	//`AILog_Ext(">>>>>>>>>>>>>>>>>>>>>>>>>>"@GetFuncName()@" ACTUAL DISTANCE--"@VSize2D(BP2Vect(StartLoc)-PawnOwner.Location)@"RootMotionDelta:"@VSize(AccumRootMotionDelta),,PawnOwner.MyGearAI);

	//`log(">>>>>>>>>>>>>>>>>>>>>>>>>> "@GetFuncName()@" DISTANCE--"@VSize2D(BP2Vect(StartLoc)-PawnOwner.Location)@"DesiredDistance:"@MantleDistance@"RootMotionDelta:"@VSize(AccumRootMotionDelta)@"ScaleFactor:"@RootMotionScaleFactor);

	// if we went less than 80% of the desired mantle distance at this point, teleport to the end point so we don't get stuck
	if(VSize2D(BP2Vect(StartLoc)-PawnOwner.Location) < MantleDistance * 0.75f)
	{
		//PawnOwner.DrawDebugCoordinateSystem(pawnOwner.location,rot(0,0,0),100.f,TRUE);
		//PawnOwner.DrawDebugLine(BP2Vect(StartLoc),PawnOwner.Location,255,255,0,TRUE);
		//`AILog_Ext(">>>>>>>>>>>>>>>>>>>>>>>>>>"@GetFuncName()@" SNAPPING TO END POINT BECAUSE WE DIDN'T MAKE IT ALL THE WAY!!",,PawnOwner.MyGearAI);
		PawnOwner.SetLocation(BP2Vect(MantleEndLoc));
		PawnOwner.FitCollision();
	}

	// Turn off mirroring
	if( bUsingMirroredVersion )
	{
		PawnOwner.BS_SetMirrorOptions(BS_PlayedStance, FALSE, FALSE, FALSE);
	}

	// Play Fall animation
	if( bUsingMirroredVersion )
	{
		BS_PlayedStance	= BSList_MirroredFall[VariationIndex];
	}
	else
	{
		BS_PlayedStance	= BSList_Fall[VariationIndex];
	}

	PawnOwner.BS_Play(BS_PlayedStance, SpeedModifier * 0.3f, 0.15f/SpeedModifier, -1.f, FALSE, TRUE);
	// Kill any root movement, we want to stay at the origin.
	PawnOwner.BS_SetRootBoneAxisOptions(BS_PlayedStance, RBA_Discard, RBA_Discard, RBA_Discard);

	// Our slot node has already been ticked, so it's going to remain stuck on the end of the jump animation on this frame.
	// and create a pop. So force a blend, so we can see the fall animation.
	// => smooth transition.
	//PawnOwner.BS_AccelerateBlend(BS_PlayedStance, StartTime);

	// Adjust animation transition, so it is smooth
	if( StartTime > 0.f )
	{
		PawnOwner.BS_SetPosition(BS_PlayedStance, StartTime * SpeedModifier);
	}

	// Unfortunately on listen servers, autonomous Pawns are moved through server updates, and animation is ticked normally
	// So that creates a delay when landing. The animation is finished, the pawn is on the ground, but the physics change to PHYS_Falling a second later.
	// So to not make that look ugly, we hack to play the land animation once the fall animation is finished.
	//if( PawnOwner.WorldInfo.NetMode == NM_ListenServer && !PawnOwner.IsLocallyControlled() )
	//{
	//	PawnOwner.BS_SetAnimEndNotify(BS_PlayedStance, TRUE);
	//}

//	`log(PawnOwner.WorldInfo.TimeSeconds @ class @ GetFuncName() @ "StartTime:" @ StartTime);
}
simulated function vector GetFallVelocityToHitEstimatedLandingPos()
{
	local vector EstimatedLandingLoc_Vec;
	local float ForwardVel;
	local float t;
	local float Vert_Fall_Dist;

	EstimatedLandingLoc_Vec = BP2Vect(EstimatedLandingLoc);

	Vert_Fall_Dist = Abs(PawnOwner.Location.Z - EstimatedLandingLoc_Vec.Z);
	t = sqrt(Vert_Fall_Dist/(abs(PawnOwner.GetGravityZ())));

	ForwardVel = VSize2D(EstimatedLandingLoc_Vec-PawnOwner.Location) / t;
	//`log(self@GetFuncName()@"forward vel!"@`showvar(ForwardVel));


	return Vector(PawnOwner.Rotation)*ForwardVel;
}

simulated function vector GetInitialFallVelocity()
{
	return Vector(PawnOwner.Rotation) * FallForwardVelocity * RootMotionScaleFactor * SpeedModifier;
}

/** Play Fall */
simulated function PlayFall()
{
	local vector	HitLocation, HitNormal, TraceEnd, TraceStart;
	local Actor		HitActor;
	local float		DistanceToGround, FallDuration;

	// Stop current move
	StopCurrentMoveType();

	// Now we're falling.
	MoveType = EMT_Fall;

	//`log(GetFuncName()@" Setting RootMotionMode -- Old:" @ PawnOwner.Mesh.RootMotionMode @ "to: RMM_Ignore");

	PawnOwner.Mesh.RootMotionMode = RMM_Ignore;

	// Set falling physics
	//PawnOwner.DrawDebugCoordinateSystem(PawnOwner.Location,rot(0,0,0),15,TRUE);
	PawnOwner.SetPhysics(FallingPhysics);
	// Reset the base to the clamped base if pawn has one
	PawnOwner.SetBase( PawnOwner.ClampedBase );

	if( PawnOwner.Controller != None )
	{
		// Add reasonable velocity to continue moving forward a bit when falling
		PawnOwner.Velocity = GetFallVelocityToHitEstimatedLandingPos();
	}

	// Trace down to try to guess when Pawn is going to land
	TraceStart	= PawnOwner.Location + PawnOwner.default.CollisionComponent.Translation + Vect(0,0,-1.f) * PawnOwner.default.CylinderComponent.CollisionHeight + Vector(PawnOwner.Rotation) * PawnOwner.default.CylinderComponent.CollisionRadius;
	TraceEnd	= TraceStart + Vect(0,0,-1.f) * 1024.f;
	HitActor	= PawnOwner.Trace(HitLocation, HitNormal, TraceEnd, TraceStart, TRUE);

	//PawnOwner.FlushPersistentDebugLines();
	//PawnOwner.DrawDebugLine(TraceStart, TraceEnd, 255, 0, 0, TRUE);

	// Play falling, variable animation.
	if( HitActor != None )
	{
		DistanceToGround	= VSize(HitLocation - TraceStart);
		// Approximate fall duration with gravity force.
		FallDuration		= Sqrt(DistanceToGround / Abs(PawnOwner.GetGravityZ()));

//		`log(`showvar(HitActor)@`showvar(DistanceToGround)@`showvar(FallDuration)@`showvar(TraceStart)@`showvar(HitLocation));
		//PawnOwner.DebugFreezeGame();
		// Adjust play rate to match fall duration
		AdjustFallingPlayRate(FallDuration);
	}
}

/** Adjust play rate to match fall duration */
simulated function AdjustFallingPlayRate(float FallDuration)
{
	local float TimeLeft, PlayRate;

	// Give us a couple extra frames for the transition (@ 30Hz).
	FallDuration += 0.07f;

	TimeLeft = PawnOwner.BS_GetTimeLeft(BS_PlayedStance);
	PlayRate = 1.f;
	if( FallDuration > 0 )
	{
		PlayRate = TimeLeft / FallDuration;
	}

//	`log(GetFuncName()@`showvar(TimeLeft)@`showvar(PlayRate)@`showvar(FallDuration));
	PawnOwner.BS_SetPlayRate(BS_PlayedStance, PawnOwner.BS_GetPlayRate(BS_PlayedStance) * PlayRate);
}

/** Stop Jump animation and perform any clean up to restore Pawn is original state. */
simulated function StopFall()
{
//	`log(PawnOwner.WorldInfo.TimeSeconds @ class @ GetFuncName() @ PawnOwner);

	// Stop Fall animation.
	//PawnOwner.BS_Stop(BS_PlayedStance, 0.2f);

	PawnOwner.BS_SetAnimEndNotify(BS_PlayedStance, FALSE);
	// Restore original Root motion on mesh.
	//`log(GetFuncName()@" Setting RootMotionMode -- Old:" @ PawnOwner.Mesh.RootMotionMode @ "to:" @ PawnOwner.default.Mesh.RootMotionMode);
	PawnOwner.Mesh.RootMotionMode = PawnOwner.default.Mesh.RootMotionMode;
}


/** Play Land */
simulated function PlayLand()
{
	// Stop current move
	StopCurrentMoveType();
//	`log(PawnOwner.WorldInfo.TimeSeconds @ class @ GetFuncName() @ PawnOwner);

	// Restore original collision cylinder height
	//PawnOwner.SetCollisionSize(PawnOwner.default.CylinderComponent.CollisionRadius, PawnOwner.default.CylinderComponent.CollisionHeight);
	// move Pawn out of the way if colliding against something
	//PawnOwner.FitCollision();

	// now we've landed
	MoveType = EMT_Land;

	if( bUsingMirroredVersion )
	{
		BS_PlayedStance	= BSList_MirroredLand[VariationIndex];
	}
	else
	{
		BS_PlayedStance	= BSList_Land[VariationIndex];
	}

	// Play Landing animation.
	PawnOwner.BS_Play(BS_PlayedStance, SpeedModifier, 0.05f/SpeedModifier, -1.f, FALSE, TRUE);

	// Set flag to get notification when animation is done playing
	PawnOwner.BS_SetAnimEndNotify(BS_PlayedStance, TRUE);

	// Turn on Root motion on animation node
	PawnOwner.BS_SetRootBoneAxisOptions(BS_PlayedStance, RBA_Translate, RBA_Translate, RBA_Translate);

	// Turn on Root motion on mesh.
	//`log(GetFuncName()@" Setting RootMotionMode -- Old:" @ PawnOwner.Mesh.RootMotionMode @ "to: RMM_Accel");
	PawnOwner.Mesh.RootMotionMode = RMM_Accel;
}


/** Stop Land animation and perform any clean up to restore Pawn is original state. */
simulated function StopLand()
{
//	`log(PawnOwner.WorldInfo.TimeSeconds @ class @ GetFuncName() @ PawnOwner);

	// Stop Fall animation.
	PawnOwner.BS_Stop(BS_PlayedStance, 0.33f/SpeedModifier);

	// Turn off animend notification flag
	PawnOwner.BS_SetAnimEndNotify(BS_PlayedStance, FALSE);

	// Restore original Root motion on mesh.
	//log(" Setting RootMotionMode:" @ PawnOwner.default.Mesh.RootMotionMode @ "to:" @ PawnOwner.Mesh.RootMotionMode);
	//`log(GetFuncName()@" Setting RootMotionMode -- Old:" @ PawnOwner.Mesh.RootMotionMode @ "to:" @ PawnOwner.default.Mesh.RootMotionMode);
	PawnOwner.Mesh.RootMotionMode = PawnOwner.default.Mesh.RootMotionMode;
}

/**
 * On server only, possibly save chained move
 * @Return TRUE if move could be chained to this one
 */
function bool CanChainMove(ESpecialMove NextMove)
{
	return (NextMove == SM_RoadieRun || NextMove == SM_Run2MidCov || NextMove == SM_Run2StdCov);
}

/**
 * Can a new special move override this one before it is finished?
 * This is only if CanDoSpecialMove() == TRUE && !bForce when starting it.
 */
function bool CanOverrideMoveWith(ESpecialMove NewMove)
{
	return (bAllowTransitionToAMove && NewMove == SM_RoadieRun);
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	// unlock desired rotation
	if( PawnOwner.IsHumanControlled() == FALSE )
	{
		PawnOwner.LockDesiredRotation(FALSE);
	}

	Super.SpecialMoveEnded(PrevMove, NextMove);

	if (PlaceholderCylinder != None)
	{
		PlaceholderCylinder.Destroy();
		PlaceholderCylinder = None;
	}

	if(PlaceholderCylinder2 != None)
	{
		PlaceholderCylinder2.Destroy();
		PlaceholderCylinder2 = None;
	}

	// Set Smooth cover interpolation.
	PawnOwner.InterpolatePawnRotation(0.33f/SpeedModifier);

	PawnOwner.ClearTimer('DelayedForcedRoadieRun', Self);

	PawnOwner.BS_Stop(BS_PlayedStance, 0.33f/SpeedModifier);
	PawnOwner.BS_SetAnimEndNotify(BS_PlayedStance, FALSE);

//	`log(PawnOwner.WorldInfo.TimeSeconds @ class @ GetFuncName() @ PawnOwner);

	// Restore original collision cylinder height
	//PawnOwner.SetCollisionSize(PawnOwner.default.CylinderComponent.CollisionRadius, PawnOwner.default.CylinderComponent.CollisionHeight);

	// This is a super hack to not trigger the mirror transition blend out just now.
	// We want to play 3 animations in a row. ugh!
	if( PawnOwner.MirrorNode != None )
	{
		PawnOwner.MirrorNode.bLockBlendOut = FALSE;
	}

	// Reset root motion scale
	RootMotionScaleFactor					= default.RootMotionScaleFactor;
	PawnOwner.Mesh.RootMotionAccelScale		= PawnOwner.default.Mesh.RootMotionAccelScale;
	PawnOwner.Mesh.RootMotionMode			= PawnOwner.default.Mesh.RootMotionMode;

	// Re-enable steps smoothing
	PawnOwner.bCanDoStepsSmoothing			= PawnOwner.default.bCanDoStepsSmoothing;
	// force a ground check to curb floating after mantles
	PawnOwner.bForceFloorCheck				= TRUE;

	// check for a transition to roadie run
	if( PCOwner != None && NextMove == SM_None )
	{
		if( PCOwner.IsHoldingRoadieRunButton() || PCOwner.bForcedRoadieRun )
		{
			if( PCOwner.CanDoSpecialMove(SM_RoadieRun) )
			{
				PawnOwner.QueueRoadieRunMove();
			}
		}
	}
}

event Landed(float DistanceToImpact, float TimeToImpact)
{
//	`log(PawnOwner.WorldInfo.TimeSeconds @ class @ GetFuncName() );
	// Otherwise play landing
	Super.Landed(DistanceToImpact, TimeToImpact);

//	`log(PawnOwner.WorldInfo.TimeSeconds @ class @ GetFuncName() @ "DistanceToImpact:" @ DistanceToImpact @ "TimeToImpact:" @ TimeToImpact );

	// Allow transition to another special move.
	PawnOwner.SetTimer( 0.1f/SpeedModifier, FALSE, nameof(self.AllowTransitionToAMove), self );
}

simulated function AllowTransitionToAMove()
{
	bAllowTransitionToAMove = TRUE;
	CheckTransitionToAMove();
}

function Tick(float DeltaTime)
{
	Super.Tick(DeltaTime);

// 	PawnOwner.DrawDebugPoint(PawnOwner.Location, 4, MakeLinearColor(1,0,0,1), TRUE);
// 	PawnOwner.DrawDebugLine(LastLocation, PawnOwner.Location, 255, 0, 0, TRUE);
// 	LastLocation = PawnOwner.Location;
//
// 	PawnOwner.DrawDebugPoint(PawnOwner.Mesh.GetBoneLocation('b_MF_Pelvis'), 4, MakeLinearColor(0,1,0,1), TRUE);

	if( bAllowTransitionToAMove )
	{
		CheckTransitionToAMove();
	}
}

simulated function CheckTransitionToAMove()
{
	local bool			bToggleInput;
	local ESpecialMove	OriginalSpecialMove;

	if( PCOwner != None && ( PCOwner.IsHoldingRoadieRunButton() || PCOwner.bForcedRoadieRun ) &&
		PawnOwner != None && PawnOwner.PendingSpecialMoveStruct.SpecialMove == SM_None )
	{
		// need move input for CanDoSpecialMove()
		bToggleInput = (PCOwner.bIgnoreMoveInput > 0);
		OriginalSpecialMove = PawnOwner.SpecialMove;
		if( bToggleInput )
		{
			PCOwner.IgnoreMoveInput(FALSE);
		}
		if( PCOwner.CanDoSpecialMove(SM_RoadieRun) )
		{
			PawnOwner.QueueRoadieRunMove(false);
			bAllowTransitionToAMove = FALSE;
		}
		// restore move input status
		if( bToggleInput && PawnOwner.SpecialMove == OriginalSpecialMove )
		{
			PCOwner.IgnoreMoveInput(TRUE);
		}
	}
	else if (PawnOwner.PendingSpecialMoveStruct.SpecialMove != SM_None && CanOverrideMoveWith(PawnOwner.PendingSpecialMoveStruct.SpecialMove))
	{
		PawnOwner.DoSpecialMove(PawnOwner.PendingSpecialMoveStruct.SpecialMove, false, PawnOwner.PendingSpecialMoveStruct.InteractionPawn, PawnOwner.PendingSpecialMoveStruct.Flags);
		bAllowTransitionToAMove = false;
	}
}

defaultproperties
{
	BSList_Jump(0)=(Stance=((Slot=BS_FullBody,AnimName="AR_Mantle_Start")))
	BSList_Fall(0)=(Stance=((Slot=BS_FullBody,AnimName="AR_Mantle_Mid")))
	BSList_Land(0)=(Stance=((Slot=BS_FullBody,AnimName="AR_Mantle_End")))

	bCheckForMirrorTransition=TRUE
	BSList_MirroredJump(0)=(Stance=((Slot=BS_FullBody,AnimName="AR_Mantle_Mirrored_Start")))
	BSList_MirroredFall(0)=(Stance=((Slot=BS_FullBody,AnimName="AR_Mantle_Mirrored_Mid")))
	BSList_MirroredLand(0)=(Stance=((Slot=BS_FullBody,AnimName="AR_Mantle_Mirrored_End")))

	JumpingPhysics=PHYS_Flying		// Collision is disabled, we don't want Pawn to fall through world
	FallingPhysics=PHYS_Falling

	DefaultMantleDistance=141.f	// default mantle over distance in POC_CoverTest
	RootMotionScaleFactor=1.f
	// MT->NOTE: increasing this will break mantles in a lot of cases (where there is collision closeish to the other side of the mantle)  change this number with care!
	// also, if you change htis be sure to change the corresponding value in GearScout.uc
	FallForwardVelocity=100.0
	GravityScale=3.f

	bCoverExitMirrorTransition=TRUE
	bCanFireWeapon=FALSE
	bCameraFocusOnPawn=FALSE

	//MT->if this is off it's possible to get mantles to start in the wrong direction which causes snaps and badness
	bLockPawnRotation=TRUE
	bForcePrecisePosition=TRUE

	bBreakFromCoverOnEnd=TRUE
	bDisableMovement=TRUE

	Action={(
			 ActionName=MantleOver,
			 ActionIconDatas=(	(ActionIcons=((Texture=Texture2D'Warfare_HUD.WarfareHUD_ActionIcons',U=212,V=314,UL=35,VL=43))), // A Button
								(ActionIcons=((Texture=Texture2D'Warfare_HUD.WarfareHUD_ActionIcons',U=0,V=0,UL=105,VL=103)))	),
			)}

	OnSlotTolerance=0.05

	JumpBlendOutTime = -1.f
}
