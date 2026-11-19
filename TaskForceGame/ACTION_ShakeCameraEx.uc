class ACTION_ShakeCameraEx extends ScriptedAction;

var() float		ShakeTime;
var() float		ShakeRate;
var() vector	MaxOffset;
var() bool		MotionBlur;
var() byte		BlurAlpha;

function bool InitActionFor ( ScriptedController C ) 
{
	local SFRMPlayerController PC;

	ForEach C.DynamicActors(class'SFRMPlayerController', PC)
	{		
		if ( PC != None ) 
			PC.SetupShake ( ShakeTime, MaxOffset, ShakeRate, MotionBlur, BlurAlpha );
	}
		
	// finish
	return false;
}

function string GetActionString()
{
	return ActionString;
}


// Decompiled with UE Explorer.
defaultproperties
{
    shaketime=1.0000000
    ShakeRate=0.0300000
    MaxOffset=(X=10.0000000,Y=10.0000000,Z=10.0000000)
    BlurAlpha=64
    ActionString="shake camera EX"
}