class RumbleDescription extends Object
	editinlinenew
	native;

var float InnerAttenuateRadius;
var float OuterAttenuateRadius;

//the motor speeds go from 0-1
//NOTE: This function needs to be able to be called multiple times per Tick, as each viewport and controller will call it
event bool GetRumbleValues(PlayerController Controller, float TimeIntoEffect, vector attenuatePos, out float LeftMotor, out float RightMotor)
{
	LeftMotor = 0;
	RightMotor = 0;
	return false;
}

//should return a float describing the importance of keeping this effect around
//Used to bump effects out of the list in favor of more important ones
//Priority 1 effects will not be removed
event float GetPriority()
{
	return 0;
}


// Decompiled with UE Explorer.
defaultproperties
{
    InnerAttenuateRadius=-1.0000000
    OuterAttenuateRadius=-1.0000000
}