class ACTION_StopBlendedAnimation extends ScriptedAction;

var(Action)	EAnimationChannels AnimationChannel;
var(Action) float	BlendOutTime;

function bool InitActionFor ( ScriptedController C )
{
	if ( ZombieBipedPawn ( C.Pawn ) != None )
	{
		// blend out and stop the animations
		ZombieBipedPawn ( C.Pawn ).BlendOutAnims ( AnimationChannel, AnimationChannel, BlendOutTime );
		ZombieBipedPawn ( C.Pawn ).AnimStopLooping ( AnimationChannel );
	}

	return false;	
}


// Decompiled with UE Explorer.
defaultproperties
{
    AnimationChannel=24
    BlendOutTime=0.2500000
    ActionString="stop blended animation"
    bValidForTrigger=false
}