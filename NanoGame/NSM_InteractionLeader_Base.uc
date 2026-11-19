/**
 * NSM_InteractionLeader_Base
 * Base class for Pawn to Pawn Interactions.
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NSM_InteractionLeader_Base extends NanoSpecialMove
	native(SpecialMoves)
	abstract;

/** Pointer to Follower. */
var transient NanoPawn		Follower;
/** if other than SM_None, then force InteractionPawn into this special move. */
var Name			FollowerSpecialMoveName;
/** Max time to wait for Interaction to start. If it can't be made, special move will be aborted. */
var float			InteractionStartTimeOut;

/** If TRUE, Pawns will be aligned with each other. */
var bool			bAlignPawns;
/** Desired distance to align both pawns. */
var	float			AlignDistance;
/** Should Follower look in same dir as me? */
var bool			bAlignFollowerLookSameDirAsMe;

var EPawnInteractionType	InteractionType;

var bool bRelativeToRootBone;

// C++ functions
cpptext
{
	virtual void PrePerformPhysics(FLOAT DeltaTime);
	virtual void TickSpecialMove(FLOAT DeltaTime);
}

function SpecialMoveStarted( bool bForced, Name PrevMove )
{
	Super.SpecialMoveStarted( bForced, PrevMove );

	// Reset variables
	Follower = None;
	bAlignFollowerLookSameDirAsMe = default.bAlignFollowerLookSameDirAsMe;
	bAlignPawns = default.bAlignPawns;

	// Set up a safety net in case interaction cannot be started
	MyNP.SetTimer( InteractionStartTimeOut, FALSE, nameof(self.InteractionStartTimedOut), self );

	// See if we can start interaction right now. If we can't, keep trying until we can.
	CheckReadyToStartInteraction();
}

function SpecialMoveEnded( Name PrevMove, Name NextMove )
{
	// Clear timer
	MyNP.ClearTimer(nameof(CheckReadyToStartInteraction), self);
	MyNP.ClearTimer(nameof(InteractionStartTimedOut), self);

	DetachPawn( Follower );
	// Clear reference to Interaction Pawn.
	Follower = None;

	Super.SpecialMoveEnded( PrevMove, NextMove );
}

/** Safety net in case Interaction cannot be started. Abort special move. */
function InteractionStartTimedOut()
{
	if( MyNP.ActiveSpecialMove == self)
	{
		`Warn(MyNP.WorldInfo.TimeSeconds @ MyNP @ class @ GetFuncName() @ "InteractionStartTimeOut hit!! Aborting move." @ Follower @ Follower.ActiveSpecialMoveName );

		// Call on whatever is available. This could be replicated both ways, but we really do not want to be stuck.
		if( MyNP.IsLocallyControlled() )
		{
			MyNP.LocalEndSpecialMove( MyNP.ActiveSpecialMoveName );
		}
		else if( MyNP.WorldInfo.NetMode != NM_Client )
		{
			MyNP.ServerEndSpecialMove( MyNP.ActiveSpecialMoveName );
		}
	}
}

function InitFollowerSpecialMoveName();

/** Checks if Interaction is ready to be started, and starts if it is. */
final function CheckReadyToStartInteraction()
{
	// Make sure we have an InteractionPawn, this is a requirement for these types of special moves
	if( MyNP.InteractionPawn != None )
	{
		// Save variable here for ease of use.
		Follower = MyNP.InteractionPawn;
		InitFollowerSpecialMoveName();

		MyNP.InteractionType     = InteractionType;
		Follower.InteractionType = InteractionType;

		// If server, start Follower special move if not already done.
		if( MyNP.WorldInfo.NetMode != NM_Client )
		{
			// Make sure we have a valid Pawn to work with
			if( Follower != None )
			{
				if( Follower.IsGameplayRelevant() )
				{
					if( !Follower.IsDoingSpecialMove(FollowerSpecialMoveName) )
					{
						Follower.ServerDictateSpecialMove(FollowerSpecialMoveName, TRUE, MyNP);
					}
				}
				else
				{
					// Our Pawn is never going to go in his special move... pop an error, and exit move.
					`Warn(MyNP.WorldInfo.TimeSeconds @ MyNP @ class @ GetFuncName() @ "Follower not gameplay relevant, Interaction cannot be started!!!" @ Follower @ Follower.ActiveSpecialMoveName);
					MyNP.ServerEndSpecialMove(MyNP.ActiveSpecialMoveName);
				}
			}
			else
			{
				`warn( MyNP.WorldInfo.TimeSeconds @ MyNP @ class @ GetFuncName() @ "Follower was None!!" );
			}
		}
	}
	else
	{
		`warn( MyNP.WorldInfo.TimeSeconds @ MyNP @ class @ GetFuncName() @ "MyNP.InteractionPawn was None!!" );
	}


	// If not ready, then set timer to try again next tick.
	if( !IsReadyToStartInteraction() )
	{
		if( Follower == None )
		{
			`log(MyNP.WorldInfo.TimeSeconds @ MyNP @ class @ GetFuncName() @ "Not ready to StartInteraction, delay... Follower:" @ Follower, ,'SpecialMoves');
		}
		else
		{
			`log(MyNP.WorldInfo.TimeSeconds @ MyNP @ class @ GetFuncName() @ "Not ready to StartInteraction, delay... Follower:" @ Follower @ "Follower.SpecialMove:" @ Follower.ActiveSpecialMoveName, ,'SpecialMoves');
		}

		// Retry next frame...
		MyNP.SetTimer( MyNP.WorldInfo.DeltaSeconds, FALSE, nameof(self.CheckReadyToStartInteraction), self );
	}
	// otherwise, start interaction now!
	else
	{
		`log(MyNP.WorldInfo.TimeSeconds @ MyNP @ class @ GetFuncName() @ "StartInteraction. Follower:" @ Follower @ "Follower.SpecialMove:" @ ((Follower != None) ? Follower.ActiveSpecialMoveName : ''), ,'SpecialMoves');

		// Clear timeout timer
		MyNP.ClearTimer(nameof(CheckReadyToStartInteraction), self);
		MyNP.ClearTimer(nameof(InteractionStartTimedOut), self);
		if( Follower != None )
		{
			// Notify follower that we're about to start.
			Follower.SpecialMoveMessageEvent( 'InteractionStarted', MyNP );
		}
		// And start interaction!
		StartInteraction();
	}
}

/**
 * Conditions to determine if interaction is ready to be started.
 * - Need an InteractionPawn
 * - InteractionPawn needs to be doing his InteractionPawnSpecialMove if it is other than SM_None.
 */
function bool IsReadyToStartInteraction()
{
	return (Follower != None && Follower.IsDoingSpecialMove(FollowerSpecialMoveName));
}

/** StartInteraction */
function StartInteraction();

/** Messages sent to this special move */
function bool MessageEvent(Name EventName, Object Sender)
{
	if( EventName == 'FollowerLeavingSpecialMove' )
	{
		OnFollowerLeavingSpecialMove();
		return TRUE;
	}

	return Super.MessageEvent(EventName, Sender);
}

/** Notification when Follower is leaving his FollowerSpecialMove */
function OnFollowerLeavingSpecialMove();

event Name GetAttachSocketName()
{
	return 'AttachSocket';
}

/**
 * Dump relative location of a Bone to MyNP
 * For debugging purposes
 */
event DebugSocketRelativeLocation(name InSocketName)
{
	local Vector MarkerLoc;
`if(`notdefined(FINAL_RELEASE))
	local Vector RelativeLoc;
`endif
	local Rotator MarkerRot;

	// Get position of marker
	//MarkerLoc = MyNP.Mesh.GetBoneLocation(BoneName);
	MyNP.Mesh.GetSocketWorldLocationAndRotation(InSocketName, MarkerLoc, MarkerRot);

	// Dump a little debug info to display the location we got:
	MyNP.DrawDebugSphere(MarkerLoc, 4, 8, 255, 0, 255, TRUE);

`if(`notdefined(FINAL_RELEASE))
	// Transform marker location to be relative to Leader location and rotation.
	RelativeLoc = WorldToRelativeOffset(MyNP.Rotation, MarkerLoc - MyNP.Location);

	`log(GetFuncName() @ "RelativeLoc:" @ RelativeLoc);
`endif
}

/** Attach Follower to Leader */
function AttachFollowerToLeader( Name SocketName, optional Vector AttachLocation, optional Rotator AttachRotation )
{
	local SkeletalMeshSocket	Socket;

	// Force replication update.
	Follower.bForceNetUpdate = TRUE;

	Follower.SetBase(None);
	Follower.SetPhysics(PHYS_None);
	Follower.SetHardAttach(TRUE);

	Follower.SetCollision(TRUE, FALSE);
	Follower.bCollideWorld = FALSE;

	// Make sure kidnapper has his attachment bone defined.
	Socket = MyNP.Mesh.GetSocketByName(SocketName);
	if( Socket != None )
	{
		Follower.SetBase(MyNP,, MyNP.Mesh, Socket.BoneName);
		Follower.SetRelativeLocation( Socket.RelativeLocation - Follower.default.Mesh.Translation );
		Follower.SetMeshTranslationOffset( vect(0,0,0) );

		if( bRelativeToRootBone )
		{
			Follower.SetRelativeLocation( Follower.Location - Follower.Mesh.GetBoneLocation( 'b_MF_Root' ) );
		}
	}
	else
	{
		`Warn(MyNP.WorldInfo.TimeSeconds @ class @ GetFuncName() @ "Leader" @ MyNP.class @ "Has no attachment socket" @ SocketName @ "!!!!");

		if( AttachRotation != rot(0,0,0) )
		{
			Follower.SetRotation(AttachRotation);
		}
		else
		{
			Follower.SetRotation(MyNP.Rotation);
		}

		// b_MF_Attach doesn't exist on all Pawns!!
		if( AttachLocation != vect(0,0,0) )
		{
			Follower.SetLocation(AttachLocation);
		}
		else
		{
			Follower.SetLocation(MyNP.Location);
		}
		Follower.SetBase(MyNP);
	}

	// need to set PHYS_None again, because SetBase() changes physics to PHYS_Falling
	Follower.SetPhysics(PHYS_None);

	// Log all debug information.
	`log(MyNP.WorldInfo.TimeSeconds @ MyNP @ class @ GetFuncName() @ "Attached Follower:" @ Follower
		@ "BaseSkelComponent:" @ Follower.BaseSkelComponent
		@ "SocketName:" @ SocketName
		@ "BaseBoneName:" @ Follower.BaseBoneName
		@ "RelativeLocation:" @ Follower.RelativeLocation
		@ "RelativeRotation:" @ Follower.RelativeRotation
		@ "bHardAttach:" @ Follower.bHardAttach
		@ "bIgnoreBaseRotation:" @ Follower.bIgnoreBaseRotation, ,'SpecialMoves');

	// Shadow parent, to render only one shadow for both.
	Follower.Mesh.SetShadowParent(MyNP.Mesh);
}

/**
 * Detaches a based Pawn from the Leader.
 */
function DetachPawn(NanoPawn APawn)
{
	APawn.SetBase( None );
	APawn.SetHardAttach( FALSE );
	APawn.SetPhysics( PHYS_Falling );

	APawn.SetCollision( TRUE, TRUE );
	APawn.bCollideWorld = TRUE;

	// Clear Shadow parent
	APawn.Mesh.SetShadowParent( None );
}

defaultproperties
{
	InteractionStartTimeOut=4.f
}
