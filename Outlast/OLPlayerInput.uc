class OLPlayerInput extends UDKPlayerInput within OLPlayerController
	config(Input)
	native;

var config array<KeyBind> GPBindingsA;
var config array<KeyBind> GPBindingsB;
var config array<KeyBind> GPBindingsC;

var config string StrafeCommand;
var config string MoveCommand;
var config string LookXCommand;
var config string LookYCommand;
var config string SouthpawMoveCommand;
var config string SouthpawLookYCommand;

enum GamepadBindingsType
{
	GBT_A,
	GBT_B,
	GBT_C
};

var GamepadBindingsType GamepadConfig;

native function ResetInput();

simulated exec function Duck()
{
	if (bToggleCrouch)
	{
		ToggleDuck();
		return;
	}

	if (IsMoveInputIgnored())
	{
		return;
	}

	bDuck = 1;
}

simulated exec function UnDuck()
{
	if (bToggleCrouch)
	{
		return;
	}

	bDuck = 0;
}

simulated exec function ToggleDuck()
{
	if (bDuck == 1)
	{
		bDuck = 0;
	}
	else if (!IsMoveInputIgnored())
	{
		bDuck = 1;
	}
}

simulated exec function StartLeanLeft()
{
	if (IsMoveInputIgnored())
	{
		return;
	}

	bLeanInputLeft = 1;
}

simulated exec function StartLeanRight()
{
	if (IsMoveInputIgnored())
	{
		return;
	}

	bLeanInputRight = 1;
}

simulated exec function StopLeanLeft()
{
	bLeanInputLeft = 0;
}

simulated exec function StopLeanRight()
{
	bLeanInputRight = 0;
}

function PreProcessInput( float DeltaTime )
{
	Super.PreProcessInput(DeltaTime);
	RawJoyLookRight	= aMouseX;
	RawJoyLookUp	= aMouseY;
}

// Removes all key bindings for a specific command
event UnBindNoSave(string Command)
{
	local int BindIndex;

	while (true)
	{
		BindIndex = Bindings.Find('Command', Command);
		if (BindIndex != -1)
		{
			Bindings.Remove(BindIndex, 1);
		}
		else
		{
			break;
		}
	}
}

native function bool IsKeyPressed(Name Key);

cpptext
{
	virtual UBOOL InputTouch(INT ControllerId, UINT Handle, ETouchType Type, FVector2D TouchLocation, DOUBLE DeviceTimestamp, UINT TouchpadIndex=0);
	virtual UBOOL InputKey(INT ControllerId, FName Key, enum EInputEvent Event, FLOAT AmountDepressed = 1.f, UBOOL bGamepad = FALSE );
}

defaultproperties
{
	bEnableFOVScaling=true
}
