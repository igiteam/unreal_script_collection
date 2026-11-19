class cover_behavior_FlinchWhenSuppressed extends CoreTask within animscripts_cover_behavior;

// parameter
var cover_behavior_callback behaviorCallbacks;

// output

// local
var float lLastSuppressionTime;
var float lTime;

var bool lBoolReturn;

function OnReturn(CoreTask task)
{
	if (task.isa('BoolTask'))
		lBoolReturn = true;
}

state main
{
Begin:
	endon ('killanimscript');
	endon ('stop_waiting_to_flinch');

	lLastSuppressionTime = lastSuppressionTime;

	while (true)
	{
		waittill('suppression');

		lTime = gettime();

		if (lLastSuppressionTime < lTime - 2000)
			break;

		lLastSuppressionTime = lTime;
	}

	flinching = true;

	endIdleAtFrameEnd(true);

	assert(behaviorCallbacks.flinch != none);
	lBoolReturn = false;
	behaviorCallbacks.flinch.Execute();

	if (!lBoolReturn)
		notify('dont_end_idle');

	flinching = false;
	notify('flinch_done');
}
