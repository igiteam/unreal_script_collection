class HodAI_DoPain extends CoreTask within HodAI;

// parameter
var HodState_Pain iState;

// local
var State_Pain lState;
var name lStatus;

state main
{
Begin:
	lStatus = 'Failure';
	if (iState != none && !iState.IsPendingKill())
	{
		notify ('hod state change');
		endon ('hod state change');

		lState = new(outer) class'State_Pain';
		lState.note = name("state pain end " $ GetUniqueID());
		hod_state = lState;
		run (hod_state, true);

		if (!hod_state.IsPendingKill())
		{
			waittill (lState.note);
			lStatus = 'Success';
		}
	}

	if (iState != none && !iState.IsPendingKill())
		iState.Finish(lStatus);
}
