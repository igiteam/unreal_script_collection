class shared_PlayLookAnimation extends CoreTask within animscripts_shared;

// parameter
var name iLookAnim;
var float iLookTime;
var DelegateCanStop iCanStopCallback;

// output

// local
var int i;

state main
{
Begin:
	if (!obj_isdefined(iCanStopCallback))
		iCanStopCallback = CanStop_ReturnTrue;
	
	for (i = 0; i < iLookTime * 10; i++)
	{
		// Break out if you saw somebody lately
		if (isalive(enemy))
		{
			if (animscripts_utility.canSeeEnemy() && iCanStopCallback.Execute())
				_return();
		}
		if (animscripts_utility.isSuppressedWrapper() && iCanStopCallback.Execute())
			_return();
		
		setAnimKnobAll(iLookAnim, 'body', 1, 0.1);
		wait (0.1);
	}
}
