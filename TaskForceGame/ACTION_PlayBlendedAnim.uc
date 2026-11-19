class ACTION_PlayBlendedAnim extends ScriptedAction;

var(Action) name Animation;
var(Action) float BlendInTime;
var(Action) float BlendOutTime;
var(Action) float AnimRate;
var(Action)	EAnimationChannels AnimationChannel;
var(Action) name BlendBone;
var(Action) float BlendAlpha;
var(Action) bool bLoop;

function string GetActionString ( )
{
	return ActionString@Animation;
}

function bool InitActionFor ( ScriptedController C )
{
	// failure?
	if ( C.pawn == None )
	{
		warn ( "BADNESS MADNESS - Action_PlayBlendedAnim tried to play animation with no pawn." );
		return false;
	}

	// if not base channel.. do a blended anim
	if ( AnimationChannel > CHANNEL_Base )
	{
		C.Pawn.AnimBlendParams ( AnimationChannel, BlendAlpha, BlendInTime, BlendOutTime, BlendBone );
		if ( bLoop )
		{
			C.Pawn.LoopAnim ( Animation, AnimRate, 0.0, AnimationChannel );
		}
		else
		{
			C.Pawn.PlayAnim ( Animation, AnimRate, 0.0, AnimationChannel );
		}
	}
	else
	{
		// just play with tweening
		if ( bLoop )
		{
			C.Pawn.LoopAnim ( Animation, AnimRate, BlendInTime, AnimationChannel );
		}
		else
		{
			C.Pawn.PlayAnim ( Animation, AnimRate, BlendInTime, AnimationChannel );
		}
	}

	return false;	
}


// Decompiled with UE Explorer.
defaultproperties
{
    BlendInTime=0.2500000
    BlendOutTime=0.2500000
    AnimRate=1.0000000
    AnimationChannel=24
    BlendBone="pelvis"
    BlendAlpha=1.0000000
    ActionString="play blended anim"
}