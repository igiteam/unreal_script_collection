class cover_behavior_LookForEnemy extends BoolTask within animscripts_cover_behavior;

// parameter
var cover_behavior_callback behaviorCallbacks;

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
	if (a.atConcealmentNode && animscripts_utility.canSeeEnemy())
		_return (false);

	if (a.lastEncounterTime + 6000 > gettime())
	{
		lookfast(behaviorCallbacks);
		_return (lBoolReturn);
	}

	// look slow if possible
	if (behaviorCallbacks.look != none)
	{
		//prof_begin('callOptionalBehaviorCallback');
		endIdleAtFrameEnd(true);

		behaviorCallbacks.look.Execute(2 + randomfloat(2));

		if (!lBoolReturn)
			notify('dont_end_idle');
	}
	if (lBoolReturn)
		_return (true);

	if (behaviorCallbacks.fastlook == none)
		_return (false);

	//prof_begin("callOptionalBehaviorCallback");
	endIdleAtFrameEnd(true);

	behaviorCallbacks.fastlook.Execute();

	if (!lBoolReturn)
		notify('dont_end_idle');

	_return (lBoolReturn);
}
