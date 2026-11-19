class cover_behavior_lookfast extends BoolTask within animscripts_cover_behavior;

// parameter
var CBCFastLook iFastlook;
var CBCLook iLook;

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
	// look fast if possible
	if (iFastlook != none)
	{
		//prof_begin("callOptionalBehaviorCallback");
		endIdleAtFrameEnd(true);

		iFastlook.Execute();

		if (!lBoolReturn)
			notify('dont_end_idle');
	}

	if (lBoolReturn)
		_return (true);

	if (iLook == none)
		_return (false);

	//prof_begin("callOptionalBehaviorCallback");
	endIdleAtFrameEnd(true);

	iLook.Execute(0);

	if (!lBoolReturn)
		notify('dont_end_idle');

	_return (lBoolReturn);
}
