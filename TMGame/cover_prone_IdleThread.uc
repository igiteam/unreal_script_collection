class cover_prone_IdleThread extends CoreTask within animscripts_cover_prone;

// parameter

// output

// local
var name lIdleAnim;

state main
{
Begin:
	endon('killanimscript');
	endon('kill_idle_thread');

	while (true)
	{
		lIdleAnim = animscripts_utility.animArrayPickRandom('prone_idle');
		setflaggedanimlimited('idle', lIdleAnim);
		waittillmatch('idle', 'end');
		clearanim(lIdleAnim, 0.2);
	}
}
