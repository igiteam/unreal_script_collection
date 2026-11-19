class combat_IdleThread extends CoreTask within animscripts_combat;

// parameter

// output

// local
var name idleAnim;

state main
{
Begin:
	endon('killanimscript');
	endon('kill_idle_thread');

	while (true)
	{
		idleAnim = animscripts_utility.animArrayPickRandom('exposed_idle');
		setflaggedanimlimited('idle', idleAnim);
		waittillmatch('idle', 'end');
		clearanim(idleAnim, 0.2);
	}
}
