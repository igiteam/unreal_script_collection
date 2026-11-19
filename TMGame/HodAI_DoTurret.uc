class HodAI_DoTurret extends CoreTask within HodAI;

// parameter

// output

// local

state main
{
Begin:
	notify ('hod state change');
	endon ('hod state change');

	if (hod_state == none || hod_state.IsPendingKill() || !hod_state.isA('State_Turret'))
	{
		hod_state = new(outer) class'State_Turret';
		run (hod_state, true);
	}

	if (!hod_state.IsPendingKill())
		waittill ('state turret end');
	//iState.Finish();
}
