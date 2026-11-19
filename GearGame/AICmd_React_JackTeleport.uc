/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class AICmd_React_JackTeleport extends AICommand
	within GearAI_Jack;

var Vector	Destination;
var bool	bGotStuck;
var bool    bExactDestination;
	
static function bool Teleport( GearAI_Jack AI, Vector inDestination, optional bool inbExactDestination )
{
	local AICmd_React_JackTeleport Cmd;

	if( AI != None )
	{
		Cmd = new(AI) class'AICmd_React_JackTeleport';
		if( Cmd != None )
		{
			Cmd.Destination = inDestination;
			Cmd.bExactDestination = inbExactDestination;
			AI.PushCommand( Cmd );
			return TRUE;
		}
	}
	return FALSE;
}

/** Build debug string */
event String GetDumpString()
{
	return Super.GetDumpString()@"Dest"@Destination;
}

function Pushed()
{
	Super.Pushed();
	
	bTeleporting = TRUE;
	GotoState( 'TeleportJack' );
}

function Popped()
{
	Super.Popped();

	ReachedMoveGoal();
	bTeleporting = FALSE;
	Pawn.SetAnchor( None );
}

function CloakStuckCheck()
{
	//debug
	`AILog( "Jack got stuck cloaking?! hmmmmmm...." );

	bGotStuck = TRUE;

	Jack.CloakedAnimName = Jack.JackFoldAnimName;
	Jack.bCloaking = FALSE;
}

function bool VerifyDestination()
{
	local Pawn P;
	local bool bOverlap;
	local array<CoverInfo> InfoList;
	local CoverInfo Info;

	if( !NavigationHandle.ComputeValidFinalDestination( Destination ) )
	{
		return FALSE;
	}

	if( !bExactDestination )
	{
		// check for overlap with other pawns and try to find a spot to fit
		foreach OverlappingActors( class'Pawn', P, Pawn.CylinderComponent.CollisionRadius, Destination )
		{
			if( P != Pawn )
			{
				bOverlap = TRUE;
				break;
			}
		}

		if( bOverlap )
		{
			if( NavigationHandle.GetAllCoverSlotsInRadius( Destination, 1024.f, InfoList ) )
			{
				foreach InfoList(Info)
				{
					bOverlap = FALSE;
					Destination = Info.Link.GetSlotLocation( Info.SlotIdx );
					foreach OverlappingActors( class'Pawn', P, Pawn.CylinderComponent.CollisionRadius, Destination )
					{
						if( P != Pawn )
						{
							bOverlap = TRUE;
							break;
						}
					}

					if( !bOverlap )
					{
						break;
					}
				}
			}
		}
	}

	return TRUE;
}

state TeleportJack `DEBUGSTATE
{
Begin:
	//debug
	`AILog( "BEGIN TAG"@Jack.CloakedAnimName );

	Pawn.ZeroMovementVariables();
	
	Sleep( 1.f );

	// If not cloaked... Cloak jack
	if( !Jack.IsCloaked() )
	{
		//debug
		`AILog( "Tell jack to cloak..." );

		SetTimer( 5.f, FALSE, nameof(self.CloakStuckCheck), self );

		Jack.SetCloakState( Jack.JackFoldAnimName );
		do
		{
			Sleep( 0.1f );
		} until( !Jack.bCloaking );

		ClearTimer( 'CloakStuckCheck', self );

		//debug
		`AILog( "Jack finished cloaking"@Jack.bCloaking );
	}

	if( VerifyDestination() &&
		TeleportToLocation( Destination, Pawn.Rotation, FALSE, FALSE ) )
	{
		//debug
		`AILog( "Jack got to a good spot - uncloak him" );

		Status = 'Success';
	}
	else
	{
		//debug
		`AILog( "Failed to find spot for jack to teleport to" );

		Status = 'Failure';
	}

	Sleep( 0.25f );

	// Uncloak jack
	Jack.SetCloakState( '' );
	do
	{
		Sleep( 0.1f );
	} until( !Jack.bCloaking );

	
	PopCommand( self );
}

defaultproperties
{

}

