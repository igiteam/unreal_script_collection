class combat_utility_PutGunBackInHandOnKillAnimScript extends CoreTask within animscripts_combat_utility;

state main
{
Begin:
	endon ('weapon_switch_done');
	endon ('death');
	
	waittill('killanimscript');
	animscripts_shared.placeWeaponOn(primaryweapon, 'right');
}
