class cover_behavior_TryThrowingGrenade extends BoolTask within animscripts_cover_behavior;

// parameter
var CBCGrenade iCallback;
var HodEntity iThrowAt;

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
	if (iCallback == none)
		_return (false);
	
	//prof_begin("callOptionalBehaviorCallback");
	endIdleAtFrameEnd(true);

	iCallback.Execute(iThrowAt);
	
	if (!lBoolReturn)
		notify('dont_end_idle');
		
	//prof_end("callOptionalBehaviorCallback");
	
	_return (lBoolReturn);
}
