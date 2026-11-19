class combat_DoReloadAnim extends CoreTask within animscripts_combat;

// parameter
var name iReloadAnim;
var bool iStopWhenCanShoot;

// output

// local
var float lAnimRate;
var name lFlagName;

state main
{
Begin:
	endon('abort_reload');
	if (iStopWhenCanShoot)
		abortReloadWhenCanShoot(true);
	
	lAnimRate = 1;
	/*if (!self usingSidearm() && !self usingShotgun() && isdefined(self.enemy) && self canSee(self.enemy) && distanceSquared(self.enemy.origin, self.origin) < 1024*1024)
	{
		dist = distance(self.enemy.origin, self.origin);
		urgency = 1 - ((dist - 512.0) / 512.0);
		if (urgency > 1)
			urgency = 1;
		lAnimRate = 1 + urgency * 1;
	}*/
	
	lFlagName = name("reload_" $ animscripts_combat_utility.getUniqueFlagNameIndex());
	
	setflaggedanimknoballrestart(lFlagName, iReloadAnim, 'root', 1, 0.2, lAnimRate);
	notifyOnStartAim('abort_reload', lFlagName, true);
	endon('start_aim');
	animscripts_shared.DoNoteTracks(lFlagName);
	
	finishedReload = true;
}
