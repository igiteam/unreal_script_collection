/**
 * 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAICmd_BullRam_Charge_Player extends NanoAICmd_BullRam_Charge within NanoAI_BullRam;



static function Charge(NanoAI_BullRam AI, optional vector NewMoveLocation, optional Actor NewMoveActor, optional float MaxMoveTime, optional bool NewbFaceFocus = TRUE)
{
	local NanoAICmd_BullRam_Charge_Player Cmd;
	if (AI != None)
	{
		Cmd = new(AI) class'NanoAICmd_BullRam_Charge_Player';
		if (Cmd != None)
		{
			Cmd.MoveLocation = NewMoveLocation;
			AI.PushCommand(Cmd);
		}
	}
}




function Pushed()
{
	super.Pushed();

	Focus = none;
	Alert_PendingFocus = none;
	SetFocalPoint( vect(0,0,0) );
}

function Popped()
{
	super.Popped();

	Focus = none;
	Alert_PendingFocus = none;
	SetFocalPoint( vect(0,0,0) );
}



function Resumed( name OldCommandName )
{
    super.Resumed( OldCommandName );
}


State DoCharge
{
	simulated function Texture2D GetDebugIcon() { return Texture2D'UI_HUD.AI.T_UI_Debug_Icons_CombatRanged'; }

	simulated function BeginState( Name PreviousStateName )
	{
		Super.BeginState( PreviousStateName );
	}

	simulated function ChargeForward()
	{
		//DrawDebugLine( MyBull.Location, MoveLocation, 0, 255, 255, TRUE ); 
		MoveToLocation( MoveLocation, 5.0f, TRUE );
	}

	
Begin:
	DoTelegraph();
	Sleep( 0.250f );
	PSC_TelegraphEffect.DeactivateSystem();
	ChargeForward();
	Sleep( 1.250f );
	PopCommand( self ); // this is popping ourself (the charge command) and gives control back to the AIController)
}




defaultproperties
{
	bAllowNewSameClassInstance=FALSE
	bReplaceActiveSameClassInstance=FALSE
}