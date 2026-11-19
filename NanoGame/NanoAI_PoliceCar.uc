/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAI_PoliceCar extends NanoAI_FlyerHoverBase
	native(AI);

var transient NanoPawn_MetaCorp_PoliceCarBase   MyCar;

/** Stimulus query for breaking us out of patrolling and into pursuing enemy */
var StimulusQuery   PatrollingForTargetQuery;

var() config float DurationOfDashingBeforeMovingInaccuracyNoLongerAffects;


event Possess(Pawn NewPawn, bool bVehicleTransition)
{
	Super.Possess(NewPawn,bVehicleTransition);
	MyCar = NanoPawn_MetaCorp_PoliceCarBase(NewPawn);
	MyCar.MyAI = self;

	//NavigationHandle.bDebugConstraintsAndGoalEvals = TRUE;
	//NavigationHandle.bUltraVerbosePathDebugging = TRUE;

	class'NanoAICmd_PoliceCar_RiseFromSmog'.static.RiseFromSmog(self);
}


function StartFiring()
{
	PossiblyPickFireTarget();

	`log( self @ "StartFiringStartFiringStartFiringStartFiring" @ `showvar(FireTarget) );

	`AILog(GetFuncName()@`showvar(FireTarget));

	if (FireTarget != None)
	{
		//NanoGRI(WorldInfo.GRI).AttemptToPlayLine(EDLine_OpenFire,Pawn);
		//bAttemptingToFireWeapon = TRUE;
		RegisterAsActiveAttacker();
		TryToFireWeapon();
	}
}

function bool IsFireLineBlocked();


function TryToFireWeapon()
{
	`log( self @ "TryToFireWeaponTryToFireWeaponTryToFireWeaponTryToFireWeaponTryToFireWeaponTryToFireWeapon ");

	if (FireTarget != None)
	{
		Focus = FireTarget;
		if( NanoWeap_Melee(Pawn.Weapon) != None || (LineOfSightTo(FireTarget) && !IsFireLineBlocked()) )
		{
			`log("firing at target" @ `showvar(FireTarget) );
			`AILog("firing at target");
			Pawn.StartFire(0);
			//bAttemptingToFireWeapon = FALSE;
		}
		else
		{
			`log(GetFuncName()@"no LOS to target");
			`AILog(GetFuncName()@"no LOS to target");
			SetTimer(0.25f,FALSE,nameof(TryToFireWeapon));
		}
	}
	else
	{
		`Log("Lost fire target, aborting fire attempt" @ `showvar(FireTarget));
		`AILog("Lost fire target, aborting fire attempt");
		StopFiring();
	}
}


function Rotator GetAdjustedAimFor( Weapon W, vector StartFireLoc )
{
	local vector AimErrorDir, AimLoc;
	local float AdjustedMaxInaccuracy, AdjustedMinInaccuracy;
	local FiringTargetableDatum FiringDatum;
	local bool bHasBeenDashingForMoreThanNSeconds;
	local vector TargetedLocation;
	local vector BulletMagnetLoc;


	if (FireTarget != None)
	{
		AdjustedMaxInaccuracy = GetMaxInaccuracy();
		AdjustedMinInaccuracy = MinInaccuracy;

		// TODO:  maybe check to see if we are NanoPawn(Pawn).bLockedOnTarget   and then don't do any inaccuracy?

		// if the AI's pawn is moving
		if( VSize(Pawn.Velocity) > Pawn.GroundSpeed * 0.35 )
		{
			AdjustedMinInaccuracy *= MovingMinInaccuracyModifer_Self;
			AdjustedMaxInaccuracy *= MovingMaxInaccuracyModifer_Self;
		}

	
		FireTarget.GetFiringTargetableDatum( FiringDatum );

		// if we are dashing
		if( FiringDatum.bIsDashing == TRUE )
		{
			// and have been for more than 5 seconds
			if( `TimeSince(FiringDatum.LastDashStartTime) > DurationOfDashingBeforeMovingInaccuracyNoLongerAffects )
			{
				bHasBeenDashingForMoreThanNSeconds = TRUE;
			}
		}

		// if the FireTarget is moving fast
		if( ( VSize(FireTarget.GetVelocity()) > class'NanoPawn'.default.GroundSpeed * 0.65 )
			// and have been doing for less than N seconds.  (if more than we do not want to make firing less accurate)
			&& ( bHasBeenDashingForMoreThanNSeconds == FALSE )
			)
		{
			//`log( "REDUCING ACCURACY" );
			AdjustedMinInaccuracy *= MovingMinInaccuracyModifer_FireTarget;
			AdjustedMaxInaccuracy *= MovingMaxInaccuracyModifer_FireTarget;
		}
		else
		{
			//`log( "normal ACCURACY" @ `showvar(bHasBeenDashingForMoreThanNSeconds));
		}


		TargetedLocation = FireTarget.GetTargetedLocation();

		// we check to see if there are any objects that are attracting our bullets
		// if there are then aim directly at them
		if( GetPossibleBulletMagnetLocation( TargetedLocation, BulletMagnetLoc ) == TRUE )
		{
			//`log( "using the BulletMagnet Location" );
			AimLoc = BulletMagnetLoc;
		}
		else
		{
			//`log( "using the Normal  TargetedLocation" );
			AimLoc = TargetedLocation + (FireTarget.GetVelocity() * LeadTargetPercentOfVelocity);
			AimLoc.Z -= 32.f;	
			AimErrorDir = Normal((AimLoc - StartFireLoc) cross vect(0,0,1));
			AimLoc += AimErrorDir * (FRand() > 0.5 ? 1 : -1) * RandRange(AdjustedMinInaccuracy,AdjustedMaxInaccuracy);
			AimLoc.Z += (FRand() > 0.5 ? 1 : -1) * RandRange(AdjustedMinInaccuracy,AdjustedMaxInaccuracy);
		}


		return rotator(AimLoc - StartFireLoc);
	}

	return Super.GetAdjustedAimFor(W,StartFireLoc);
}


defaultproperties
{
	ListOfAIActionsThisAICanDo.Empty()
	ListOfAIActionsThisAICanDo.Add( class'NanoAIAction_Idle_Car_PatrolARoute' )
	ListOfAIActionsThisAICanDo.Add( class'NanoAIAction_ConfrontPossibleThreat_PoliceCar' )

	bUseBoidMovement=FALSE

	LineToPlayWhenKilled=EDLine_PoliceCar_ShotDown

	CruisingAltitude=512.0f;

	PatrollingForTargetQuery=(QueryLabel="PatrollingForTarget",bAllowFriendly=FALSE,bAllowNonFriendly=TRUE,bRequireCombative=QO_Allow,MinFOV=-1.f,MaxFOV=-1.f,MinDist=0.f,MaxDist=2700.0f,DistanceAboveUsToIgnoreStimuli=2048.f )

	ConfrontPossibleThreatQuery=(QueryLabel="ConfrontTarget",Visibility=QO_Allow,bAllowFriendly=FALSE,bAllowNonFriendly=TRUE,bRequireCombative=QO_Require,bRequireDamaged=TRUE,MinFOV=-1.f,MaxFOV=-1.f,MinDist=0.f,MaxDist=2700.0f,DistanceAboveUsToIgnoreStimuli=2048.f )
}
