class HodAI_DoArrival extends CoreTask within HodAI;

// parameter
var HodState_Arrival iState;
var name lStatus;

state main
{
Begin:
	lStatus = 'Failure';
	if (iState != none && !iState.IsPendingKill())
	{
		notify ('hod state change');
		endon ('hod state change');

		if (hod_state == none || hod_state.IsPendingKill() || !hod_state.isA('State_Arrival'))
		{
			hod_state = new(outer) class'State_Arrival';
			run (hod_state, true);
		}

		if (!hod_state.IsPendingKill())
		{
			waittill ('state arrival end');
			lStatus = 'Success';
		}
	}

	if (iState != none && !iState.IsPendingKill())
		iState.Finish(lStatus);
}
