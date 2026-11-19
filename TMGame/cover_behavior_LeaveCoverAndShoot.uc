class cover_behavior_LeaveCoverAndShoot extends BoolTask within animscripts_cover_behavior;

// parameter
var CBCLeaveCoverAndShoot iCallback;
var name iInitialGoal;

// output

// local
var bool lBoolReturn;

function OnReturn(CoreTask task)
{
	if (task.isa('BoolTask'))
		lBoolReturn = true;
}

state main
{
Begin:
	animscripts_shoot_behavior.decideWhatAndHowToShoot(iInitialGoal, true);
	
	if (!fixedNode)
		breakOutOfShootingIfWantToMoveUp(true);

	if (iCallback != none)
	{
		//prof_begin('callOptionalBehaviorCallback');
		endIdleAtFrameEnd(true);

		iCallback.Execute();

		if (!lBoolReturn)
			notify('dont_end_idle');
	}
	
	notify('stop_deciding_how_to_shoot');

	_return (lBoolReturn);
}
