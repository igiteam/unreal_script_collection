class combat_main extends CoreTask within animscripts_combat;

state main
{
Begin:
	endon('killanimscript');
	
	//[[ self.exception[ 'exposed' ] ]]();
	
	animscripts_utility.initialize('combat');
	a.arrivalType = '';
	
	setup();
	
	//prof_end('combat_init');
	
	exposedCombatMainLoop();
	
	notify('stop_deciding_how_to_shoot');
}
