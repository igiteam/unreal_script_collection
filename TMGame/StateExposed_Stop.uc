class StateExposed_Stop extends CoreTask within HodAI;

state main
{
Begin:
	endon ('killanimscript');

	while (true)
	{
		if (toggle_combat || (enemy != none))
		{
			goto_state ('exposed');
			break;
		}

		wait (0.05);
	}
}
