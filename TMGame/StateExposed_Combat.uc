class StateExposed_Combat extends CoreTask within HodAI;

state main
{
Begin:
	endon ('killanimscript');

	while (true)
	{
		if (enemy == none)
			run (new(self) class'StateExposed_Combat_DeferredGotoExposed', true);

		waittill ('enemy');
	}
}
