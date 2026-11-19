class combat_ShootUntilNeedToTurn extends CoreTask within animscripts_combat;

state main
{
Begin:
	watchForNeedToTurnOrTimeout(true);
	endon('need_to_turn');
	
	keepTryingToMelee(true);
	
	animscripts_combat_utility.shootUntilShootBehaviorChange();
	
	notify('stop_watching_for_need_to_turn');
	notify('stop_trying_to_melee');
}
