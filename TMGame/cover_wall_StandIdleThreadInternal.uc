class cover_wall_StandIdleThreadInternal extends CoreTask within animscripts_cover_wall;

// parameter

// output

// local
var int i;
var name lFlagName;
var name lIdleAnim;

state main
{
Begin:
	endon('killanimscript');
	endon('end_stand_idle_thread');
	
	i = 0;
	while (true)
	{
		lFlagName = name("idle" $ i);
		lIdleAnim = animscripts_utility.animArrayPickRandom('exposed_idle');
		
		setFlaggedAnimKnobLimitedRestart(lFlagName, lIdleAnim, 1, 0.2);
		
		waittillmatch(lFlagName, 'end');
		
		i ++;
	}
}
