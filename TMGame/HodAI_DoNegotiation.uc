class HodAI_DoNegotiation extends CoreTask within HodAI;

// parameter
var HodState_Negotiation iState;

// local
var State_Negotiation lState;
var name lStatus;

state main
{
Begin:
	lStatus = 'Failure';
	if (iState != none && !iState.IsPendingKill())
	{
		notify ('hod state change');
		endon ('hod state change');

		lState = new(outer) class'State_Negotiation';
		lState.iPath = iState.iPath;
		hod_state = lState;
		run (hod_state, true);

		if (!hod_state.IsPendingKill())
		{
			waittill ('state negotiation end');
			lStatus = 'Success';
		}
	}

	if (iState != none && !iState.IsPendingKill())
		iState.Finish(lStatus);
}
