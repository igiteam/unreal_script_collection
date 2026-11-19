class cover_behavior_CoverReload extends BoolTask within animscripts_cover_behavior;

// parameter
var CBCReload iCallback;
var float iThreshold;

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
	if (bulletsInClip > weaponClipSize(weapon) * iThreshold)
		_return (false);

	if (iCallback == none)
		_return (false);

	isreloading = true;

	//prof_begin('callOptionalBehaviorCallback');
	endIdleAtFrameEnd(true);

	iCallback.Execute();

	if (!lBoolReturn)
		notify('dont_end_idle');

	//prof_end('callOptionalBehaviorCallback');

	isreloading = false;

	_return (lBoolReturn);
}
