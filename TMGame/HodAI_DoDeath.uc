class HodAI_DoDeath extends CoreTask within HodAI;

// parameter
var HodState_Death iState;

state main
{
Begin:
	notify ('hod state change');
	endon ('hod state change');

	hod_state = new(outer) class'State_Death';
	run (hod_state, true);

	if (!hod_state.IsPendingKill())
		waittill ('state death end');

	iState.Finish();
}
