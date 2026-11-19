class ACTION_ShakeCamera extends ScriptedAction;

var(Action) enum EShakeType {

	SHAKE_Weak,
	SHAKE_Normal,
	SHAKE_Mean
		
} ShakeType;

var() bool bMotionBlur;
var() byte BlurAlpha;

function bool InitActionFor ( ScriptedController C ) 
{	
	local SFRMPlayerController PC;

	ForEach C.DynamicActors(class'SFRMPlayerController', PC)
	{
		if ( PC != None ) 
		{	
			if ( ShakeType == SHAKE_Weak )
				PC.SetupShake ( 0.125f, vect ( 5, 5, 5 ), 0.01f, bMotionBlur, BlurAlpha );
			else if ( ShakeType == SHAKE_Normal )
				PC.SetupShake ( 0.25f, vect ( 10, 10, 10 ), 0.01f, bMotionBlur, BlurAlpha );
			else if ( ShakeType == SHAKE_Mean )
				PC.SetupShake ( 0.5f, vect ( 15, 15, 15 ), 0.01f, bMotionBlur, BlurAlpha );
		}
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
    BlurAlpha=64
    ActionString="shake camera"
}