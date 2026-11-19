class combat_utility_FireUntilOutOfAmmoInternal extends CoreTask within animscripts_combat_utility;

// parameter
var name iAnimName;
var name iFireAnim;
var bool iStopOnAnimationEnd;
var int iMaxshots;

// output

// local
var int lNumShots;
var bool lHasFireNotetrack;
var bool lUsingRocketLauncher;

function OnEndon(name note)
{
	if (outer.outer.pawn.isa('TGPawn_PLABase'))
		;
}

state main
{
Begin:
	endon('enemy'); // stop shooting if our enemy changes, because we have to reset our accuracy and stuff
	// stop shooting if the player becomes invulnerable, so we will call resetAccuracyAndPause again
	if (isPlayer(enemy) && (shootStyle == 'full' || shootStyle == 'semi'))
		level.endon('player_becoming_invulnerable');
	
	if (iStopOnAnimationEnd)
	{
		NotifyOnAnimEnd(iAnimName, 'fireAnimEnd', true);
		endon('fireAnimEnd');
	}
	
	lNumShots = 0;
	
	lHasFireNotetrack = animHasNoteTrack(iFireAnim, 'fire');
	
	lUsingRocketLauncher = weaponClass(weapon) == 'rocketlauncher';
	
	while (true)
	{
		if (lHasFireNotetrack)
			waittillmatch(iAnimName, 'fire');
		
		//prof_begin('FireUntilOutOfAmmoInternal');
		if (lNumShots == iMaxshots) // note: iMaxshots == -1 if no limit
			break;
		
		if (bulletsInClip == 0)
		{
			if (!cheatAmmoIfNecessary())
				break;
		}
		
		if (aimedAtShootEntOrPos())
		{
			shootAtShootEntOrPos();

//			assertex(self.bulletsInClip >= 0, self.bulletsInClip);
			if (isPlayer(enemy) && flag('player_is_invulnerable'))
			{
				if (randomint(3) == 0)
					bulletsInClip--;
			}
			else
			{
				bulletsInClip--;
			}
			
			if (lUsingRocketLauncher)
			{
//				self.a.rockets--;
//				if (self.weapon == 'rpg')
//				{
//					self hidepart('tag_rocket');
//					self.a.rocketVisible = false;
//				}
			}
		}
		lNumShots++;
		
//		self thread shotgunPumpSound(iAnimName);
		
		if (fastBurst && lNumShots == iMaxshots)
			break;
		
		//prof_end('FireUntilOutOfAmmoInternal');
	
		if (!lHasFireNotetrack)
			waittillmatch(iAnimName, 'end');
	}
	
	if (iStopOnAnimationEnd)
		notify('fireAnimEnd'); // stops NotifyOnAnimEnd()
}
