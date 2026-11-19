class StateExposed_Combat_DeferredGotoExposed extends CoreTask within StateExposed_Combat;

var float lCurrentTime;
state main
{
Begin:
	notify ('DeferredGotoExposed');
	endon ('DeferredGotoExposed');
	endon ('killanimscript');
	endon ('enemy');

	while (true)
	{
		if (!toggle_combat)
		{
			lCurrentTime = float(GetTime()) / 1000.0;
			if (lCurrentTime - in_combat_time < 10)
				wait (10 - lCurrentTime + in_combat_time);
			else
				break;
		}
		else
			wait (0.05);
	}
	goto_state ('exposed');
}
