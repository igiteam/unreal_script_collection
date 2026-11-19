/**
 * 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAICmd_BullRam_BeingRidden extends NanoAICmd within NanoAI_BullRam;


var transient NanoPC PlayerRidingMe;

var transient float SavedGroundSpeed;

var transient float TimeStartOfBeingRidden;




static final function BeingRidden( NanoAI_BullRam AI, NanoPC InPlayerRidingMe )
{
	local NanoAICmd_BullRam_BeingRidden Cmd;
	if (AI != None)
	{
		Cmd = new(AI) class'NanoAICmd_BullRam_BeingRidden';
		if (Cmd != None)
		{
			Cmd.PlayerRidingMe = InPlayerRidingMe;
			AI.PushCommand(Cmd);
		}
	}
}


function Pushed()
{
	super.Pushed();
	SavedGroundSpeed = Pawn.GroundSpeed;
	Pawn.GroundSpeed = 600;
	Pawn.Acceleration = vect(0,0,0);
    
	Focus = none;
	Alert_PendingFocus = none;
	SetFocalPoint( vect(0,0,0) );

	TimeStartOfBeingRidden = WorldInfo.TimeSeconds;

	SetActiveBoidMovementByClass( class'BoidRule_BullRam', FALSE );

	GotoState( 'DoRidingMe' );
}

function Popped()
{
	super.Popped();

	SetActiveBoidMovementByClass( class'BoidRule_BullRam_BeingRidden', FALSE );
    SetActiveBoidMovementByClass( class'BoidRule_BullRam', TRUE );
    Pawn.GroundSpeed = SavedGroundSpeed;
	`log( "BullRam now in charge once again!!!" );

}


function Resumed( name OldCommandName )
{
    super.Resumed( OldCommandName );
}


State DoRidingMe
{
	simulated function Texture2D GetDebugIcon() { return Texture2D'UI_HUD.AI.T_UI_Debug_Icons_CombatMelee'; }

	simulated function BeginState( Name PreviousStateName )
	{
		Super.BeginState( PreviousStateName );
		class'BoidRule_BullRam_BeingRidden'.static.AddRule( Outer, FALSE );

		SetActiveBoidMovementByClass( class'BoidRule_BullRam_BeingRidden', TRUE );
	}

	simulated function ChooseLocationToRunToo()
	{
        local EDirection MoveDir;
		local Vector ForwardOffset;
		local vector TargetLoc;
		local float DistFromTarget;

		local NanoPlayerInput NPI;

		MoveDir = DIR_None;
		// the idea for this is is to choose some point in front of us to the left or right and then move to it
		// makes it like the bull is "bucking"

		ForwardOffset = (Normal(Vector(MyBull.RidingPawn.Rotation)) * 512.0f); // if this is "too short" then the movement speed will get us to the point and then controller will freak out and randomly rotate?!?!?! :-(   There is some wankerish focus point or something being set when it should not be and then badness happens
		// wit this long distance it semi sucks for responsiveness but that is ok for prototyping
		DistFromTarget = 64.0f;


		NPI = NanoPlayerInput(NanoPC(MyBull.RidingPawn.Controller).PlayerInput);

		// if pushing forward then don't modify the left right
		if( NPI.RawJoyUp > 0.2 )
		{
			//`log( "FORWARD" @ (Normal(Vector(MyBull.RidingPawn.Rotation))) );
            TargetLoc = (MyBull.Location + ForwardOffset);
		}
		else if( NPI.RawJoyRight > 0.2 )
		{
			//`log( "RIGHT" );
			MoveDir = DIR_Right;
		}
		else if( NPI.RawJoyRight < -0.2 )
		{
			//`log( "LEFT" );
			MoveDir = DIR_Left;
		}
		else
		{
			//`log( "RANDOM" );
			MoveDir = FRand() > 0.5 ? DIR_Left : DIR_Right;
		}

		if( MoveDir == DIR_Right )
		{
			//`log( "Move RIGHT" );
			TargetLoc = (MyBull.Location + ForwardOffset) + ( Normal(vect(0,1,0) >> MyBull.Rotation) * DistFromTarget );
		}
		else if( MoveDir == DIR_Left )
		{
			//`log( "Move LEFT" );
            TargetLoc = (MyBull.Location  + ForwardOffset) + ( Normal(vect(0,-1,0) >> MyBull.Rotation) * DistFromTarget );
		}

		DrawDebugLine( MyBull.Location, TargetLoc, 255, 0, 0, TRUE );

		MoveToLocation( TargetLoc, 2.0f, TRUE );
	}


	simulated function Tick( float DeltaTime )
	{
		super.Tick( DeltaTime );

		//`log( "tick attack" );


	}
	
Begin:

    do
	{
		ChooseLocationToRunToo();
		Sleep(0.10f);

	} until( ( `TimeSince(TimeStartOfBeingRidden) > MyBull.TimeBeforeKickRiderOff ) || (MyBull.RidingPawn == none) );


	PopCommand( self ); // this is popping ourself (the charge command) and gives control back to the AIController)
}
