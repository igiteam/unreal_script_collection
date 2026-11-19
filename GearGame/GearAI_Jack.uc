/**
* Class to handle the AI controlling of Jack
*
* Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
*/
class GearAI_Jack extends GearAI
	native(AI)
	config(AI);

/** GoW global macros */

var() Vehicle_Jack_Base Jack;

var Vector	LastIdleLocation;
var Vector	LastMoveLocation;
var float	NextPOITime;
var float	NextIdleMoveTime;
var bool	bScriptedCloaking;
var float	CloakByEnemyTime;
var bool    bInterruptablePOI;

/** Jack is teleporting to a good spot... suspend auto cloak/decloak */
var bool	bTeleporting;

/** Last time successfully reached idle move goal */
var float	LastReachedMoveGoalTime;

var array<JackPointOfInterest>	JackInterestList;
/** Jack interest POIs were assigned by LD */
var bool						bLDSetPOI;

/** desired height above mesh to hover */
var float HoverHeight;

struct native JackAngryItem
{
	var Pawn    Instigator;
	var float   LastRecoilTime;
};
var array<JackAngryItem> AngryList;

cpptext
{
	// Overidden to fly to the min height of the two polys joined by this edge
	virtual FVector GetEdgeZAdjust(FNavMeshEdgeBase* Edge)
	{
		FVector Extent = FVector(1.f);

		if(Pawn != NULL)
		{
			Extent = Pawn->GetCylinderExtent();
		}
		if(Edge == NULL || Edge->GetPoly0() == NULL || Edge->GetPoly1() == NULL)
		{
			return FVector(0.f,0.f,Extent.Z);
		}
		FLOAT HeightOffEdge = Min<FLOAT>(Edge->GetPoly0()->GetPolyHeight(), Edge->GetPoly1()->GetPolyHeight());
		HeightOffEdge -= Extent.Z+5.f;

		HeightOffEdge = Min<FLOAT>(HeightOffEdge,HoverHeight);

		return FVector(0.f,0.f,HeightOffEdge);
	}

	void SetupPathfindingParams( FNavMeshPathParams& out_ParamCache );
}

simulated function DrawDebug( GearHUD_Base HUD, name Category, optional bool bSpecificDebug )
{
	Super.DrawDebug( HUD, Category, bSpecificDebug );

	DrawDebugBox( GetDestinationPosition(), vect(5,5,5), 0, 255, 0 );
	DrawDebugBox( LastIdleLocation, vect(5,5,5), 255, 0, 0 );
	DrawDebugBox( LastMoveLocation, vect(5,5,5), 0, 0, 255 );
}

simulated function AddExtraOverheadInfo( GearHUD_Base HUD )
{
	Super.AddExtraOverheadInfo( HUD );

	HUD.Canvas.DrawText( "Throttle:"@Jack.Throttle@"Steer:"@Jack.Steering@"Rise:"@Jack.Rise );
	HUD.Canvas.DrawText( "TimeSinceLastReached:"@`TimeSince(LastReachedMoveGoalTime) );
}

function Possess( Pawn NewPawn, bool bVehicleTransition )
{
	super.Possess( NewPawn, bVehicleTransition );

	Jack = Vehicle_Jack_Base(Pawn);
	// Make Jack the driver of himself
	Jack.Driver		= Jack;
	Jack.bDriving	= TRUE;

	SetDesiredRotation(Jack.Rotation);

//	SetTimer( 10.f, TRUE, nameof(CheckAreaForPOI) );
}

function float GetMoveTimeOutDuration(vector dest, bool bDontCare)
{
	local float Dist;

	if( JackPointOfInterest(MoveGoal) != None || JackPointOfInterest(GetTetherActor()) != None )
	{
		return 10.f;
	}
	if( GetTetherActor() != None && MoveGoal == GetTetherActor() )
	{
		return 10.f;
	}

	Dist = VSize(Pawn.Location - Dest);
	return FMax(0.5f,4.0f * (Dist / Jack.GroundSpeed));
}

function ClearMovementInfo( optional bool bSkipCombatZones = TRUE )
{
	Super.ClearMovementInfo( bSkipCombatZones );

	LastIdleLocation = vect(0,0,0);
	LastMoveLocation = vect(0,0,0);
	LastReachedMoveGoalTime = 0.f;
}

protected function AbortMovementCommands()
{
	Super.AbortMovementCommands();

	AbortCommand( None, class'AIcmd_Hover_MoveToGoal_Mesh');
	AbortCommand( None, class'AICmd_React_JackInvestigate' );
}

final function bool LDSetPOI()
{
	return (bLDSetPOI || JackPointOfInterest(GetTetherActor()) != None);
}

function bool SetTether( Vector NewTetherLocation, Actor NewTetherActor, optional float NewTetherDistance, optional bool NewbDynamicTether, optional float NewTetherPersistDuration, optional bool bInteruptable, optional bool bIsValidCache )
{
	local JackPointOfInterest POI;

	POI = JackPointOfInterest(NewTetherActor);
	if( POI != None )
	{
		bInterruptablePOI = bInteruptable;
		return InvestigatePOI( POI, TRUE );
	}

	return Super.SetTether( NewTetherLocation, NewTetherActor, NewTetherDistance, NewbDynamicTether, NewTetherPersistDuration, bInteruptable, bIsValidCache );
}

function bool ShouldMoveToSquad( optional bool bSkipLastPositionCheck, optional Vector TestLocation )
{
	local Vector LeaderPos;
	local float	 DistToLeader;

	// Don't move to squad if already given an action or no squad leader to move to
	if( MoveAction != None || IsTethered() || !HasSquadLeader() || ShouldBeStationary() )
	{
		//debug
		`AILog("Shouldn't move to squad, move action:"@MoveAction@"tether:"@PrintTetherInfo()@"squad formation:"@GetSquadName()@GetSquadLeader()@ShouldBeStationary() );

		return FALSE;
	}

	LeaderPos = GetSquadLeaderLocation();
	DistToLeader = VSize(LeaderPos-Pawn.Location);

	//debug
	`AILog("Too far from squad leader?"@LeaderPos@DistToLeader );

	if( DistToLeader > 768.f )
	{
		return TRUE;
	}
	return FALSE;
}

function bool ShouldBeStationary()
{
	if( IsTimerActive('DelayJackCloak') ||
		IsTimerActive('DelayJackDecloak') )
	{
		return TRUE;
	}

	return Jack.ShouldBeStationary();
}


/** @return whether we should exit combat and return to the idle state, generally because we don't have any more enemies */
function bool ShouldReturnToIdle()
{
	return (!bMovingToGoal && !bTeleporting && !HasAnyEnemies());
}

function bool HasAnyEnemies()
{
	if( Jack.ShouldBeStationary() || !bInterruptablePOI )
	{
		return FALSE;
	}

	return Super.HasAnyEnemies();
}

function HandleFailedPathFind(Actor MoveToActor)
{
	local Vector SafeLoc;

	`AILog( GetFuncName()@NavigationHandle.LastPathError );

	if( NavigationHandle.LastPathError == PATHERROR_STARTPOLYNOTFOUND )
	{
		SafeLoc = Pawn.Location;
		if( NavigationHandle.ComputeValidFinalDestination( SafeLoc ) )
		{
			TeleportToGoodSpot( SafeLoc );
			return;
		}
	}

	class'AICmd_MoveToMesh'.static.MoveToMesh( self );
}

function PickIdleMoveLocation( optional bool bInCombat, optional bool bForceSquadMove )
{
	local Vector MovePt, CamLoc, AvoidDir, HitLocation, HitNormal, LeaderLoc;
	local Rotator CamRot;
	local float	 DistOffset, DistTest;
	local bool	 bMove, bSkipHeightAdjust;
	local int Idx;
	local JackPointOfInterest POI;
	local Actor FocusActor, HitActor;
	local bool	bForceTeleport;
	local vector PreAdjsutMovePt;

	//debug
	`AILog( GetFuncName()@PrintTetherInfo()@JackInterestList.Length@NextPOITime-WorldInfo.TimeSeconds@MoveAction@PrintTetherInfo()@ShouldBeStationary() );

	bSkipHeightAdjust = FALSE;
	bReachedMoveGoal = FALSE;
	RouteCache_Empty();

	if( ShouldBeStationary() )
	{
		return;
	}

	// If have some places to go an inspect
	if( !bInCombat && !IsTethered() && JackInterestList.Length > 0 && WorldInfo.TimeSeconds > NextPOITime )
	{
		Idx	= Rand(JackInterestList.Length);
		POI	= JackInterestList[Idx];
		JackInterestList.Remove( Idx, 1 );
		bLDSetPOI = (bLDSetPOI && JackInterestList.Length > 0);
		if( POI != None )
		{
			InvestigatePOI( POI );
			return;
		}
	}

	// Check if Jack should move to the squad leader...
	if( bForceSquadMove || ShouldMoveToSquad() )
	{
		// If leader is reachable...
		LeaderLoc = GetSquadLeaderLocation();

		//debug
		`AILog( GetFuncName()@"should move to squad"@NavigationHandle.PointReachable( LeaderLoc ) );

		if (NavigationHandle.PointReachable(LeaderLoc))
		{
			// Pick a spot a good distance from him
			MovePt = LeaderLoc + Normal(Pawn.Location-LeaderLoc) * 512.f;
		}
		else
		{
			// Otherwise, move directly to leader
			LastIdleLocation = vect(0,0,0);
			MovePt = LeaderLoc;
			DistOffset = 512.f;
		}

		bMove = TRUE;
		Focus = None;
	}
	else
	if( Jack.IsTooCloseToPlayerCamera( CamLoc, CamRot ) &&
		GetObstructionAdjustDir( CamLoc, AvoidDir ) )
	{
		//debug
		`AILog( "Too close to player camera!"@AvoidDir );

		LastIdleLocation = vect(0,0,0);
		MovePt = Pawn.Location + AvoidDir * 256.f;
		bMove = TRUE;
	}
	else
	// Otherwise, if we have been idle long enough...
	if( WorldInfo.TimeSeconds > NextIdleMoveTime )
	{
		// Twitch in a random direction
		if( IsZero(LastIdleLocation) )
		{
			MovePt = Pawn.Location + VRand() * 128.f;
		}
		else
		{
			MovePt = LastIdleLocation + VRand() * 128.f;
		}
		bMove = FastTrace( MovePt, Pawn.Location );

		//debug
		`AILog( "Idle twitch..."@LastIdleLocation@bMove );
	}

	// If should move...
	if( bMove )
	{
		if( !NavigationHandle.ComputeValidFinalDestination( MovePt ) )
		{
			//debug
			`AILog( "Failed to validate MovePt" );

			return;
		}
		bForceTeleport = ShouldForceTeleport( MovePt );

		//debug
		`AILog( "Moving..."@MovePt@NavigationHandle.PointReachable( MovePt )@bForceTeleport );

		if( bForceTeleport )
		{
			//debug
			`AILog( ".... Force teleport to good spot"@MovePt );

			TeleportToGoodSpot( MovePt );
			return;
		}
		else
		// If point is not directly reachable...
		if( !NavigationHandle.PointReachable( MovePt ) )
		{
			//FlushPersistentDebugLines();
			//DrawDebugSphere(MovePt, 10, 10, 255, 0, 0, TRUE);
			//DrawDebugSphere(Pawn.Location, 10, 10, 0, 255, 0, TRUE);
			//DrawDebugLine( MovePt, Pawn.Location, 255, 0, 0, TRUE );

			bMove = FALSE;

			if( GeneratePathToValidatedLocation(MovePt,, TRUE) )
			{
				//debug
				`AILog( "generated path to validated location"@MovePt );

				bMove = TRUE;
			}

			if( !bMove )
			{
				//debug
				`AILog( "failed to find path to dest..." );

				// Try lowering to ground
				HitActor = Trace( HitLocation, HitNormal, Pawn.Location - vect(0,0,700), Pawn.Location );
				if( HitActor != None )
				{
					DistTest = VSize(HitLocation-Pawn.Location);

					//debug
					`AILog( "Try to lower to ground"@DistTest );

					if( DistTest > 80.f )
					{
						LastIdleLocation = vect(0,0,0);
						MovePt = HitLocation + vect(0,0,50);
						bMove = TRUE;
						bSkipHeightAdjust = TRUE;
					}
				}

				if( !bMove )
				{
					//debug
					`AILog( ".... Try teleport to good spot"@MovePt );

					TeleportToGoodSpot( MovePt );
					return;
				}
			}
		}
		else
		{
			//debug
			`AILog( "..... point was reachable!" );

			if( GetTetherActor() != None )
			{
				FocusActor = GetTetherActor();
			}
			else
			{
				FocusActor = Focus;
			}
		}

		// If should complete the move
		if( bMove )
		{
			// Try to adjust the height of the move point to be over the leaders head
			if( !bSkipHeightAdjust && !IsTethered() )
			{
				PreAdjsutMovePt = MovePt;
				MovePt += Jack.AdjustDestination( None, MovePt );

				if( !NavigationHandle.PointReachable(MovePt))
				{
					MovePt = PreAdjsutMovePt;
				}
				//debug
				`AILog( "... Adjusted destination to"@MovePt );
			}

			if( !Pawn.ReachedPoint( MovePt, Pawn.Anchor ) )
			{
				if( IsZero(LastIdleLocation) )
				{
					LastIdleLocation = MovePt;
				}

				// Update next idle twitch time
				NextIdleMoveTime = WorldInfo.TimeSeconds + (1.f + FRand() * 5.f);
				// Execute the move
				LastMoveLocation = MovePt;
				SetMovePoint( MovePt, FocusActor, TRUE, DistOffset);
			}
			else
			{
				`AILog( "Error: ... No move?" );
			}
		}
	}
	else
	{
		bReachedMoveGoal = TRUE;
	}

}

function PlayIdleSound()
{
	SetTimer( 15.0f + 45.f * FRand(), FALSE, nameof(PlayIdleSound) );

	if( Jack.IsCloaked() || Pawn == None )
	{
		return;
	}

	Jack.PlayIdleSound();
}

/**
* Overridden to not call BeginCombatCommand as it can cause infinite recursion
*/
simulated function OnTeleport(SeqAct_Teleport Action)
{
	//debug
	`AILog( GetFuncName()@Action );

	// Clear cover
	InvalidateCover();

	ClearMovementInfo(FALSE);

	// Clear route list
	RouteCache_Empty();

	Pawn.ZeroMovementVariables();

	if( Action != None )
	{
		// Actually do the teleport
		super(AIController).OnTeleport( Action );
	}
}

state Action_Idle
{
	function BeginState( Name PreviousStateName )
	{
		Super.BeginState( PreviousStateName );

		SetTimer( 1.5f + 5.f * FRand(), FALSE, nameof(PlayIdleSound) );
	}

Begin:
	//debug
	`AILog( "BEGIN TAG"@HasAnyEnemies()@bTeleporting@Jack.ShouldBeStationary(), 'State' );

	// make sure we have a squad
	if (Squad == None)
	{
		SetSquadName('Alpha');
	}

	if( !bTeleporting )
	{
		if( (Pawn != None) && !IsWithinTether( Pawn.Location ) )
		{
			//debug
			`AILog( "Not within tether, moving..."@PrintTetherInfo() );

			if( JackPointOfInterest(GetTetherActor()) != None )
			{
				InvestigatePOI( JackPointOfInterest(GetTetherActor()), FALSE );
			}
			else
			{
				// Move to tether
				class'AICmd_MoveToTether'.static.MoveToTether( self, GetTetherLocation(), GetTetherActor() );
			}
		}
		else if( HasAnyEnemies() )
		{
			CheckCombatTransition();
		}
		else
		{
			PickIdleMoveLocation();
		}

		//debug
		`AILog( "Finished idle move"@bReachedMoveGoal@Focus@PrintTetherInfo() );

		UpdateFocalPoint();
	}

	Jack.Throttle = 0;
	Jack.Steering = 0;
	Jack.Rise	  = 0;

	Sleep(0.1f+FRand()*0.5f);

	Goto('Begin');
}

function UpdateFocalPoint()
{
	//debug
	`AILog( GetFuncName()@IsTethered()@GetTetherActor()@GetTetherLocation()@Focus );

	if( IsTethered() )
	{
		if( NavigationPoint(GetTetherActor()) == None )
		{
			// Look at the actor we were told to move to
			SetFocalPoint( GetTetherLocation(), TRUE );
			return;
		}
	}

	if( Focus == None )
	{
		Focus = GetTetherActor();
	}

	if( Focus == None )
	{
		SetFocalPoint( Pawn.Location + Vector(Pawn.Rotation) * 512.f, TRUE );
	}
	else
	{
		SetFocalPoint( Focus.Location, TRUE );
	}
}

function bool ShouldForceTeleport( Vector MovePt )
{
	if( `TimeSince( LastReachedMoveGoalTime ) > 10.f )
	{
		if( LastReachedMoveGoalTime == 0.f || NavigationHandle.PointReachable( MovePt ) )
		{
			LastReachedMoveGoalTime = WorldInfo.TimeSeconds;
			return FALSE;
		}

		return TRUE;
	}
	return FALSE;
}

function ReachedMoveGoal()
{
	//debug
	`AILog( GetFuncName() );

	LastIdleLocation = vect(0,0,0);
	LastReachedMoveGoalTime = WorldInfo.TimeSeconds;
}

function ReachedIntermediateMoveGoal()
{
	ReachedMoveGoal();
}

final function bool GetObstructionAdjustDir( Vector AvoidLoc, out Vector out_Dir )
{
	local Vector X, Y, Z, VectToDanger;
	local bool bLeftOpen, bRightOpen, bFrontOpen, bBackOpen;
	local float DotX, DotY;

	// Figure out which directions we can evade
	GetAxes( Pawn.Rotation, X, Y, Z );
	bRightOpen = FastTrace( Pawn.Location + Y * 256.f, Pawn.Location );
	bLeftOpen  = FastTrace( Pawn.Location - Y * 256.f, Pawn.Location );
	bFrontOpen = FastTrace( Pawn.Location + X * 256.f, Pawn.Location );
	bBackOpen  = FastTrace( Pawn.Location - X * 256.f, Pawn.Location );

	// Get Dots to the point
	VectToDanger = Normal(AvoidLoc-Pawn.Location);
	DotX = X DOT VectToDanger;
	DotY = Y DOT VectToDanger;

	// If dot is mostly forward or backward
	if( DotX >= 0.7071 ||
		DotX <= -0.7071 )
	{
		// If can evade back and should
		if( bBackOpen && DotX >= 0.7071 )
		{
			// Evade back
			out_Dir = -X;
			return TRUE;
		}
		else
		// Otherwise, if can evade forward and should
		if( bFrontOpen && DotX <= -0.7071 )
		{
			out_Dir = X;
			return TRUE;
		}
		else
		// Otherwise, if can evade right and should OR
		// Wants to evade left but can't
		if( (bRightOpen && DotY < 0) ||
			(DotY >= 0 && !bLeftOpen) )
		{
			// Evade right
			out_Dir = Y;
			return TRUE;
		}
		else
		// Otherwise, if can evade left and should OR
		// Wants to evade right but can't
		if( (bLeftOpen && DotY >= 0) ||
			(DotY < 0 && !bRightOpen) )
		{
			out_Dir = -Y;
			return TRUE;
		}
	}
	else
	{
		// If can evade left and should
		if( bLeftOpen && DotY >= 0.7071 )
		{
			// Evade left
			out_Dir = -Y;
			return TRUE;
		}
		else
		// Otherwise, if can evade right and should
		if( bRightOpen && DotY <= -0.7071 )
		{
			// Evade right
			out_Dir = Y;
			return TRUE;
		}
		else
		// Otherwise, if can evade forward and should OR
		// Wants to evade back but can't
		if( (bFrontOpen && DotX < 0) ||
			(DotX >= 0 && !bBackOpen) )
		{
			// Evade forward
			out_Dir = X;
			return TRUE;
		}
		else
		// Otherwise, if can evade back and should OR
		// Wants to evade forward but can't
		if( (bBackOpen && DotX >= 0) ||
			(DotX < 0 && !bFrontOpen) )
		{
			out_Dir = -X;
			return TRUE;
		}
	}

	return FALSE;
}

function bool AngryInsteadOfRecoil( Controller InstigatedBy )
{
	local int Idx;
	local float TimeSinceLastRecoil;

	if( Pawn.Weapon != None && InstigatedBy != None && InstigatedBy.Pawn != None )
	{
		if( !Jack.IsSameTeam( InstigatedBy.Pawn) )
		{
			return TRUE;
		}

		Idx = AngryList.Find( 'Instigator', InstigatedBy.Pawn );
		if( Idx < 0 )
		{
			Idx = AngryList.Length;
			AngryList.Length = Idx + 1;
			AngryList[Idx].Instigator = InstigatedBy.Pawn;
			AngryList[Idx].LastRecoilTime = WorldInfo.TimeSeconds;
		}
		else
		{
			TimeSinceLastRecoil = `TimeSince(AngryList[Idx].LastRecoilTime);
			AngryList[Idx].LastRecoilTime = WorldInfo.TimeSeconds;
			if( TimeSinceLastRecoil < 10.f )
			{

				return TRUE;
			}
		}
	}

	return FALSE;
}

function bool DoRecoil(Controller InstigatedBy)
{
	//debug
	`AILog( GetFuncName() );

	if( AngryInsteadOfRecoil( InstigatedBy ) )
	{
		FireTarget = InstigatedBy.Pawn;
		if( !Pawn.Weapon.IsFiring() )
		{
			StartFiring( 2 );
		}
	}
	else if( Jack.Recoil() )
	{
		return class'AICmd_React_JackRecoil'.static.Recoil( self );
	}

	return FALSE;
}

simulated function OnToggleCinematicMode( SeqAct_ToggleCinematicMode Action )
{
	Super.OnToggleCinematicMode( Action );

	ClearTimer( 'DelayJackCloak' );
	ClearTimer( 'DelayJackDecloak' );
}

function bool TeleportToGoodSpot(vector DesiredLoc, optional bool bClearMovement = true, optional bool bExactSpot )
{
	//debug
	`AILog( GetFuncName()@DesiredLoc@bClearMovement );

	ClearTimer( 'DelayJackCloak' );
	ClearTimer( 'DelayJackDecloak' );

	if( bClearMovement )
	{
		ClearMovementInfo();
	}
	return class'AICmd_React_JackTeleport'.static.Teleport( self, DesiredLoc, bExactSpot );
}

/**
 * Accessor function for toggling Jack's cloaking device.
 * Allows chance for guds sounds, delays, etc.
 */
function bool SetCloaking( bool inbCloak, optional bool bScripted, optional bool bForce, optional float Delay )
{
//	`log( "A"@bScriptedCloaking@bScripted@"--"@inbCloak@bForce );

	if( !bForce && bScriptedCloaking && !bScripted )
	{
		return FALSE;
	}

	//debug
	`AILog( GetFuncName()@inbCloak@bScripted@bForce@Delay@Jack.IsCloaked()@ShouldMoveToSquad()@"Timers"@IsTimerActive('DelayJackCloak')@IsTimerActive('DelayJackDecloak') );

	if( ( inbCloak &&  Jack.IsCloaked()) ||
		(!inbCloak && !Jack.IsCloaked()) )
	{
		//debug
		`AILog( "Already cloaking..."@Jack.bCloaking@bScriptedCloaking );

		return Jack.bCloaking && bScriptedCloaking;
	}

	if( Delay <= 0.f )
	{
		ClearTimer( 'DelayJackCloak' );
		ClearTimer( 'DelayJackDecloak' );

		// If this is a non-scripted decloak and Jack is too far from squad
		if( !inbCloak && Jack.IsCloaked() )
		{
			if( !bForce && !bScripted && ShouldMoveToSquad() )
			{
				TeleportToGoodSpot( GetSquadLeaderLocation() );
				return FALSE;
			}
		}

		return Jack.SetCloakState( inbCloak ? Jack.JackFoldAnimName : '', bForce );
	}

	if( inbCloak && !IsTimerActive('DelayJackCloak') )
	{
		//debug
		`AILog( "Set Delay Cloak" );

		ClearTimer( 'DelayJackDecloak' );
		SetTimer( Delay, FALSE, nameof(DelayJackCloak) );
	}
	else
	if( !inbCloak && !IsTimerActive('DelayJackDecloak') )
	{
		//debug
		`AILog( "Set Delay DeCloak" );

		ClearTimer( 'DelayJackCloak' );
		SetTimer( Delay, FALSE, nameof(DelayJackDecloak) );
	}
	return TRUE;
}

function DelayJackCloak()
{
	ClearTimer( 'DelayJackCloak' );
	ClearTimer( 'DelayJackDecloak' );

	//debug
	`AILog( GetFuncName()@Jack.IsCloaked() );

	if( !Jack.IsCloaked() )
	{
		// Play recoil anim half the time
		Jack.SetCloakState( FRand() < 0.5f ? Jack.JackRecoilAnimName : Jack.JackFoldAnimName );
	}
}

function DelayJackDecloak()
{
	ClearTimer( 'DelayJackCloak' );
	ClearTimer( 'DelayJackDecloak' );

	NextPOITime = WorldInfo.TimeSeconds + 20.f + FRand() * 20.f;

	//debug
	`AILog( GetFuncName()@Jack.IsCloaked()@ShouldMoveToSquad() );

	// If this is a non-scripted decloak and Jack is too far from squad
	if( Jack.IsCloaked() )
	{
		if( ShouldMoveToSquad() )
		{
			// Teleport to better location before decloaking
			TeleportToGoodSpot( GetSquadLeaderLocation() );
		}
		else
		{
			Jack.SetCloakState( '' );
		}
	}
}

function OnJackControl( SeqAct_JackControl inAction )
{
	local bool bClearLatent, bAborted;

	ClearTimer( 'DelayJackCloak' );
	ClearTimer( 'DelayJackDecloak' );

	// Cloak/Decloak
	if( inAction.InputLinks[0].bHasImpulse ||
		inAction.InputLinks[1].bHasImpulse )
	{
		//debug
		`AILog( "..." );

		bScriptedCloaking = TRUE;
		bClearLatent = !SetCloaking( inAction.InputLinks[0].bHasImpulse, TRUE );
		bAborted	 = bClearLatent;

		//debug
		`AILog( GetFuncName()@"Cloak"@inAction.InputLinks[0].bHasImpulse@bClearLatent@inAction );
	}
	else
	// Lights on/off
	if( inAction.InputLinks[2].bHasImpulse ||
		inAction.InputLinks[3].bHasImpulse )
	{
		Jack.SetSpotLightState( inAction.InputLinks[2].bHasImpulse );
		bClearLatent = TRUE;

		//debug
		`AILog( GetFuncName()@"Lights"@inAction.InputLinks[2].bHasImpulse@bClearLatent@inAction );
	}
	else
	// Unfold/Fold monitor
	if( inAction.InputLinks[4].bHasImpulse ||
		inAction.InputLinks[5].bHasImpulse )
	{
		bClearLatent = !Jack.SetMonitorState( inAction.InputLinks[4].bHasImpulse );
		bAborted	 = bClearLatent;

		//debug
		`AILog( GetFuncName()@"Monitors"@inAction.InputLinks[4].bHasImpulse@bClearLatent@inAction );
	}
	else
	// Start/Stop welding
	if( inAction.InputLinks[6].bHasImpulse ||
		inAction.InputLinks[7].bHasImpulse )
	{
		bClearLatent = !Jack.SetWeldingState( inAction.InputLinks[6].bHasImpulse );
		bAborted	 = bClearLatent;

		//debug
		`AILog( GetFuncName()@"Welding"@inAction.InputLinks[6].bHasImpulse@bClearLatent@inAction );
	}
	else
	// Recoil
	if( inAction.InputLinks[8].bHasImpulse )
	{
		bClearLatent = !Jack.Recoil();
		bAborted	 = bClearLatent;

		//debug
		`AILog( GetFuncName()@"Recoil"@bClearLatent@inAction );
	}
	else
	// Start/Stop scan
	if( inAction.InputLinks[9].bHasImpulse ||
		inAction.InputLinks[10].bHasImpulse )
	{
		bClearLatent = !Jack.SetScanningState( inAction.InputLinks[9].bHasImpulse );
		bAborted	 = bClearLatent;
		bClearLatent = TRUE;

		//debug
		`AILog( GetFuncName()@"Scanning"@inAction.InputLinks[9].bHasImpulse@bAborted@inAction );
	}
	else
	// Pointing
	if( inAction.InputLinks[11].bHasImpulse )
	{
		bClearLatent = !Jack.SetPointingState( TRUE );
		bAborted	 = bClearLatent;

		//debug
		`AILog( GetFuncName()@"Pointing"@inAction );
	}
	else
	// Reset LD control of Jack
	if( inAction.InputLinks[12].bHasImpulse )
	{
		bScriptedCloaking = FALSE;
		bClearLatent = TRUE;

		//debug
		`AILog( GetFuncName()@"Release"@inAction );
	}
	else
	// Adjust Jack's spotlight (defer to Vehicle_Jack_Base)
	if( inAction.InputLinks[13].bHasImpulse )
	{
		Jack.OnJackControlSpotlight(inAction);
	}

	if( bClearLatent )
	{
		ClearLatentAction( class'SeqAct_JackControl', bAborted );
	}
}

function OnAISetTarget( SeqAct_AISetTarget InAction )
{
	local JackPointOfInterest POI;
	local Actor NewTarget;

	//debug
	`AILog( GetFuncName()@"override?"@InAction.bOverwriteExisting );

	// clear the existing list if specified
	if( InAction.bOverwriteExisting )
	{
		JackInterestList.Length = 0;
	}

	// copy the targets
	foreach InAction.FocusTargets( NewTarget )
	{
		POI = JackPointOfInterest(NewTarget);
		if( POI != None )
		{
			POI.bInvestigated = FALSE;
			JackInterestList.AddItem( POI );
		}
	}

	bLDSetPOI = (JackInterestList.Length > 0);
}

function SetMovePoint( vector NewMovePoint, optional Actor NewMoveFocus,
						 optional bool bInterruptable, optional float OffsetDist,
						 optional bool bIsValidCache, optional bool bAllowedToFire=TRUE,
						 optional bool bAllowPartialPath, optional bool bInCanPathfind = true )
{
	//debug
	`AILog( GetFuncName()@NewMovePoint@NewMoveFocus@bInterruptable@bAllowedToFire, 'Move' );

	bReachedMoveGoal = FALSE;
	bMoveGoalInterruptable = bInterruptable; //@FIXME: doesn't support stacking!
	MoveOffset = OffsetDist; //@FIXME: doesn't support stacking!

	if (!IsZero(NewMovePoint))
	{
		class'AICmd_Hover_MoveToGoal_Mesh'.static.HoverToPoint(self,NewMovePoint,EnemyDistance_Short,HoverHeight);
	}
}


function CheckAreaForPOI()
{
	local JackPointOfInterest JPOI;

	if( LDSetPOI() )
		return;

	JackInterestList.Length = 0;
	foreach Pawn.DynamicActors( class'JackPointOfInterest', JPOI )
	{
		if( !JPOI.bInvestigated && VSize(Pawn.Location-JPOI.Location) < 512.f )
		{
			JackInterestList[JackInterestList.Length] = JPOI;
		}
	}

	//debug
	`AILog( GetFuncName()@"POI List"@JackInterestList.Length );
}

function bool InvestigatePOI( JackPointOfInterest POI, optional bool bSetTether )
{
	//debug
	`AILog( GetFuncName()@POI );

	if( bSetTether )
	{
		Vect2BP( TetherPosition, POI.Location, POI );
	}

	return class'AICmd_React_JackInvestigate'.static.Investigate( self, POI );
}

function bool ShouldPrintStaleWarning()
{
	return FALSE;
}

function bool NotifyBump( Actor Other, vector HitNormal )
{
	local Pawn bumpPawn;
	local AICmd_MoveToGoal_Mesh ActiveMoveCmd;

	//debug
	`AILog(GetFuncName()@Other);

	bumpPawn = Pawn(Other);
	if( bumpPawn != None )
	{
		ActiveMoveCmd = AICmd_MoveToGoal_Mesh(GetActiveCommand());
		if (ActiveMoveCmd != None && MoveGoal == bumpPawn)
		{
			`AILog("Popping Move To Goal command early because bumped into MoveGoal");
			ActiveMoveCmd.Status = 'Success';
			PopCommand(ActiveMoveCmd);
		}
		if( IsFriendlyPawn( bumpPawn ) )
		{
			if( Pawn.Base != bumpPawn &&
				bumpPawn.Base != Pawn )
			{
				//debug
				`AILog(GetFuncName()@Other);

				// try to step aside for them
				StepAsideFor( bumpPawn );
			}
		}
		else
		{
			bumpPawn.TakeDamage( 1000.f, self, Pawn.Location, vect(0,0,0), class'GDT_Melee' );
		}
	}

	return FALSE;
}

function bool StepAsideFor( Pawn ChkPawn )
{
	// Don't let jack be bumped out of the way if he's welding scanning or pointing
	if( Jack == None	||
		Jack.bWelding	||
		Jack.bScanning	||
		Jack.bPointing	)
	{
		return FALSE;
	}

	return Super.StepAsideFor( ChkPawn );
}

defaultproperties
{
	DefaultCommand=class'AICmd_Base_Jack'

	DefaultReactConditions.Empty
	DefaultReactConditionClasses.Empty

	bAllowCombatTransitions=true
	bIgnoreSquadPosition=true
	bCanRevive=false
	bInterruptablePOI=TRUE

	MaxStepAsideDist=128.0

	HoverHeight=768.0
}
