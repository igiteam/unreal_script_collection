class combat_utility_Reload extends CoreTask within animscripts_combat_utility;

// parameter
var float iThresholdFraction;
var name iOptionalAnimation;

// output

// local

state main
{
Begin:
	endon('killanimscript');

	if (!NeedToReload(iThresholdFraction))
		_return();

	//prof_begin('Reload');

	a.Alertness = 'casual';

//	self animscripts\battleChatter_ai::evaluateReloadEvent();
//	self animscripts\battleChatter::playBattleChatter();
	Pawn.PlayChatter(CAT_Reload);

	if (isDefined(iOptionalAnimation))
	{
		if (a.state == 'cover')
			iOptionalAnimation = SetCustomAnim(misc_modern, iOptionalAnimation);
		setFlaggedAnimKnobAll('reloadanim', iOptionalAnimation, 'body', 1, 0.1, 1);
		animscripts_shared.DoNoteTracks('reloadanim');
		animscripts_weaponList.RefillClip();	// This should be in the animation as a notetrack in theory.
		a.needsToRechamber = 0;
	}
	else
	{
		if (a.pose == 'prone')
		{
			setFlaggedAnimKnobAll('reloadanim','reload_prone_rifle', 'body', 1, 0.1, 1);
			UpdateProne('prone_legs_up', 'prone_legs_down', 1, 0.1, 1);
		}
		else
		{
//			println ('Bad anim_pose in combat::Reload');
			//prof_end('Reload');
			wait (2);
			_return();
		}
		animscripts_shared.DoNoteTracks('reloadanim');
		animscripts_weaponList.RefillClip();	// This should be in the animation as a notetrack in most instances.
		a.needsToRechamber = 0;
		//clearanim('upperbody', 0.1);		// Only needed for the upper body running reload.
	}

	//prof_end('Reload');
	_return(true);
}
