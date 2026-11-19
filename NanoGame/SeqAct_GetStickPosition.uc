/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 * Outputs the position of the analog sticks for a specified player
 */
class SeqAct_GetStickPosition extends SequenceAction;

/** If true, values will be grabbed from the right stick instead of the left */
var() bool  bUseRightStick;

/** Angle of the stick, assuming that 0 is straight up */
var float   StickAngle;
/** Magnitude of the stick press, ranging from 0.f to 1.f */
var float   StickMagnitude;
/** Raw up value for the stick, ranging from -1.f to 1.f */
var float   StickRawUp;
/** Raw right value for the stick, ranging from -1.f to 1.f */
var float   StickRawRight;
	
event Activated()
{
	local PlayerController PC;
	local PlayerInput Input;

	PC = PlayerController(Targets[0]);

	if( PC != None )
	{
		Input = PC.PlayerInput;

		if( Input != None )
		{
			// Grab the raw values from the stick
			StickRawUp = bUseRightStick ? -Input.RawJoyLookUp : Input.RawJoyUp;
			StickRawRight = bUseRightStick ? Input.RawJoyLookRight : Input.RawJoyRight;

			// Calculate the normalized angle for the stick, with 0 being straight up
			if( StickRawUp == 0.f )
			{
				// Handle the divide by 0 cases
				if( StickRawRight == 0.f )
				{
					// No input, default to 0
					StickAngle = 0.f;
				}
				else
				{
					StickAngle = (StickRawRight > 0.f) ? 90.f : 270.f;
				}
			}
			else
			{
				StickAngle = RadToDeg * Atan(StickRawRight / StickRawUp );

				// Normalize the angle to be in [0, 360)
				if( StickRawUp < 0.f )
				{
					StickAngle += 180.f;
				}
				else if( StickAngle < 0.f )
				{
					StickAngle += 360.f;
				}
			}

			// Calculate the total magnitude of the stick displacement
			StickMagnitude = sqrt( square(StickRawUp) + square(StickRawRight) );

			PopulateLinkedVariableValues();
		}
	}
}

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 0;
}

defaultproperties
{
	bCallHandler=FALSE

	ObjName="Get Stick Position"
	ObjCategory="Nano"
	VariableLinks(1)=(ExpectedType=class'SeqVar_Float',LinkDesc="Angle",bWriteable=true,PropertyName=StickAngle)
	VariableLinks(2)=(ExpectedType=class'SeqVar_Float',LinkDesc="Mag.",bWriteable=true,PropertyName=StickMagnitude)
	VariableLinks(3)=(ExpectedType=class'SeqVar_Float',LinkDesc="Raw Up",bWriteable=true,PropertyName=StickRawUp)
	VariableLinks(4)=(ExpectedType=class'SeqVar_Float',LinkDesc="Raw Right",bWriteable=true,PropertyName=StickRawUp)
}
