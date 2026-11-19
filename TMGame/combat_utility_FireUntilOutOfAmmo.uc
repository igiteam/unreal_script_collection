class combat_utility_FireUntilOutOfAmmo extends CoreTask within animscripts_combat_utility;

// parameter
var name iFireAnim;
var bool iStopOnAnimationEnd;
var int iMaxshots;

// output

// local
var name lAnimName;
var float lRate;

state main
{
Begin:
	lAnimName = name("fireAnim_" $ getUniqueFlagNameIndex());
	
	//prof_begin('FireUntilOutOfAmmo');

	// reset our accuracy as we aim
	maps__gameskill.resetMissTime();
	
	// first, wait until we're aimed right
	while (!aimedAtShootEntOrPos())
		wait (0.05);
		
	//prof_begin('FireUntilOutOfAmmo');		
	
	
	setAnim('add_fire', 1, 0.1, 1);
	
	lRate = randomfloatrange(0.3, 3.0);
	if (shootStyle == 'full' || shootStyle == 'burst')
		lRate = animscripts_weaponList.autoShootAnimRate();
	//else if (obj_isdefined(shootEnt) && isdefined(shootEnt.magic_bullet_shield))
	//	lRate = 0.25;
	
	setFlaggedAnimKnobRestart(lAnimName, iFireAnim, 1, 0.2, lRate);
	
	// Update the sight accuracy against the player.  Should be called before the volley starts.
	updatePlayerSightAccuracy();

	//prof_end('FireUntilOutOfAmmo');

	FireUntilOutOfAmmoInternal(lAnimName, iFireAnim, iStopOnAnimationEnd, iMaxshots);
	
	clearAnim('add_fire', 0.2);
}
