class combat_AbortReloadWhenCanShoot extends CoreTask within animscripts_combat;

state main
{
Begin:
	endon('abort_reload');
	endon('killanimscript');
	while (true)
	{
		if (obj_isdefined(shootEnt) && canSee(shootEnt))
			break;
		wait (0.05);
	}
	notify('abort_reload');
}
