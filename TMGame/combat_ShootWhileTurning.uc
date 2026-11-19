class combat_ShootWhileTurning extends CoreTask within animscripts_combat;

state main
{
Begin:
	endon('killanimscript');
	endon('done turning');
	
	if(animscripts_utility.weaponAnims() == 'rocketlauncher')
		_return();
	
	animscripts_combat_utility.shootUntilShootBehaviorChange();
	
	clearAnim('add_fire', 0.2);
}
