class combat_ExposedReload extends CoreTask within animscripts_combat;

// parameter
var float iThreshold;

// output

// local
var name lReloadAnim;

state main
{
Begin:
	a.exposedReloading = true;
		
	lReloadAnim = animscripts_utility.animArrayPickRandom('reload');
		
	// if crouching will give us cover while reloading, do it
	if (a.pose == 'stand' && animscripts_utility.animArrayAnyExist('reload_crouchhide') && obj_isdefined(enemy) && canSee(enemy))
	{
		if (!sightTracePassed(origin + vect(0,0,50) * FInch, enemy.getShootAtPos(), false, none))
			lReloadAnim = animscripts_utility.animArrayPickRandom('reload_crouchhide');
	}
		
	keepTryingToMelee(true);

	setanim('reload',1,0.2);
	setanim('exposed_aiming', 0, 0.2);

	finishedReload = false;
	doReloadAnim(lReloadAnim, iThreshold > 0.05); // this will return at the time when we should start aiming
	notify('abort_reload'); // make sure threads that doReloadAnim() started finish

	if (finishedReload)
		animscripts_weaponList.RefillClip();

	setanimrestart('exposed_aiming', 1, 0.2);
	clearanim('reload', 0.2);

	notify('stop_trying_to_melee');

	a.exposedReloading = false;

	maps__gameskill.didSomethingOtherThanShooting();
}
