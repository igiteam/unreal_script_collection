class HodAI_DoMove extends CoreTask within HodAI;

// parameter
var HodState_Move iState;

// output

// local

state main
{
Begin:
	notify ('hod state change');
	endon ('hod state change');

	if (hod_state == none || hod_state.IsPendingKill() || !hod_state.isA('State_Move'))
	{
		hod_state = new(outer) class'State_Move';
		run (hod_state, true);
	}

	if (!hod_state.IsPendingKill())
		waittill ('state move end');

	//iState.Finish();
}
