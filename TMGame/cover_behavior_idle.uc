class cover_behavior_idle extends BoolTask within animscripts_cover_behavior;

// parameter
var cover_behavior_callback behaviorCallbacks;
var float howLong;

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
	flinching = false;

	if (behaviorCallbacks.flinch != none)
	{
		// flinch if we just started getting shot at very recently
		if (!a.idlingAtCover && gettime() - suppressionStart < 600)
		{
			lBoolReturn = false;
			behaviorCallbacks.flinch.Execute();
			if (lBoolReturn)
				_return (true);
		}
		else
		{
			// if bullets aren't already whizzing by, idle for now but flinch if we get incoming fire
			flinchwhensuppressed(behaviorCallbacks, true);
		}
	}

	if (!a.idlingAtCover)
	{
		assert(obj_isdefined(behaviorCallbacks.idle)); // idle must be available!
		idleThread(behaviorCallbacks.idle, true); // this thread doesn't stop until 'end_idle', which must be notified before we start anything else! use endIdleAtFrameEnd() to do this.
		a.idlingAtCover = true;
	}

	if (howLong >= 0)
		idleWait(howLong);
	else
		idleWaitABit();

	if (flinching)
		waittill('flinch_done');

	notify('stop_waiting_to_flinch');
}
