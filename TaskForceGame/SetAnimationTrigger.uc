class SetAnimationTrigger extends Trigger;

var() name Animation;
var() float AnimRate;
var() bool	bLoopAnim;

function Touch( actor Other )
{
	local Actor A;
	local name CurrentAnimation;
	local float CurrentFrame;
	local float CurrentRate;

	Super.Touch(Other);

	if ( (Event == '') || (Event == 'None') )
		return;

	ForEach DynamicActors( class 'Actor', A, Event )
	{
		A.GetAnimParams(0,CurrentAnimation,CurrentFrame,CurrentRate);
		if( Animation == 'None' )
		{
			Animation = CurrentAnimation;
			CurrentFrame = 0.0;
		}

		if(AnimRate == 0.0)
		{
			AnimRate = CurrentRate;
		}

		if(bLoopAnim)
		{
			A.LoopAnim(Animation,AnimRate,CurrentFrame);
		}
		else
		{
			A.PlayAnim(Animation,AnimRate,CurrentFrame);
		}
	}
}

function Trigger( actor Other, pawn EventInstigator )
{
	Super.Trigger(Other,EventInstigator);
	Touch(Other);
}


// Decompiled with UE Explorer.
defaultproperties
{
    AnimRate=1.0000000
    bLoopAnim=true
}