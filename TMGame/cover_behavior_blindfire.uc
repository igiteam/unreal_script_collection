class cover_behavior_blindfire extends BoolTask within animscripts_cover_behavior;

// parameter
var CBCBlindFire iCallback;

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
	if (!animscripts_utility.canBlindFire())
		_return (false);

	if (iCallback == none)
		_return (false);

	//prof_begin("callOptionalBehaviorCallback");
	endIdleAtFrameEnd(true);

	iCallback.Execute();

	if (!lBoolReturn)
		notify('dont_end_idle');

	//prof_end("callOptionalBehaviorCallback");

	_return (lBoolReturn);
}
