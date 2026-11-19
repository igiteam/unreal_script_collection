class corner_StandIdleThreadInternal extends CoreTask within animscripts_corner;

// local
var name lAnimArrayArg;
var int i;
var name lFlagName;
var name lIdleAnim;

state main
{
Begin:
	endon('killanimscript');
	endon('end_stand_idle_thread');
	
	lAnimArrayArg = 'exposed_idle';
	if (a.cornerMode == 'lean')
		lAnimArrayArg = 'lean_idle';
	
	assert(animscripts_utility.animArrayAnyExist(lAnimArrayArg));
	i = 0;
	while (true)
	{
		lFlagName = name("idle" $ i);
		lIdleAnim = animscripts_utility.animArrayPickRandom(lAnimArrayArg);
		
		setFlaggedAnimKnobLimitedRestart(lFlagName, lIdleAnim, 1, 0.2);
		
		waittillmatch(lFlagName, 'end');
		++ i;
	}
}
