class combat_utility_DoGrenadeThrow extends CoreTask within animscripts_combat_utility;

// input
var name iThrowAnim;
var float iNextGrenadeTimeToUse;
var bool iSecondGrenadeOfDouble;

// output

// local
var name lModel;
var name lAttachSide;
var name lNoteTrack;

function OnNotify(name inNote, CoreNotify inData)
{
	local CoreAnimNotify data;

	if ('throwanim' == inNote)
	{
		data = CoreAnimNotify(inData);
		if (data != none)
			lNoteTrack = data.data;
		else
			lNoteTrack = '';
	}
}

state main
{
Begin:
	//prof_begin('DoGrenadeThrow');
//	self animscripts\battleChatter_ai::evaluateAttackEvent('grenade');
	notify ('stop_aiming_at_enemy');
	SetFlaggedAnimKnobAllRestart('throwanim', iThrowAnim, 'body', 1, 0.1, 1);

	animscripts_shared.DoNoteTracksForever('throwanim', 'killanimscript', true);

	//prof_begin('DoGrenadeThrow');

	lModel = animscripts_utility.getGrenadeModel();

	lAttachSide = 'none';
	while (true)
	{
		waittill('throwanim');
		//prof_begin('DoGrenadeThrow');
		if (lNoteTrack == 'grenade_left' || lNoteTrack == 'grenade_right')
		{
			lAttachSide = attachGrenadeModel(lModel, 'TAG_INHAND');
			isHoldingGrenade = true;
		}
		if (lNoteTrack == 'grenade_throw' || lNoteTrack == 'grenade throw')
			break;
		assert(lNoteTrack != 'end'); // we shouldn't hit 'end' until after we've hit 'grenade_throw'!
		if (lNoteTrack == 'end') // failsafe
		{
			anim.numGrenadesInProgressTowardsPlayer--;
			notify('dont_reduce_giptp_on_killanimscript');
			//prof_end('DoGrenadeThrow');
			_return ();//false;
		}
	}

	notify('dont_reduce_giptp_on_killanimscript');

//	if (self usingPlayerGrenadeTimer())
//	{
//		// give the grenade some time to get to the player.
//		// if it gets there, we'll reset the timer so we don't throw any more in a while.
//		self thread watchGrenadeTowardsPlayer(iNextGrenadeTimeToUse);
//	}
//
//	self throwGrenade();
//
//
//	if (!self usingPlayerGrenadeTimer())
//	{
//		setGrenadeTimer(self.activeGrenadeTimer, iNextGrenadeTimeToUse);
//	}
//
//	if (iSecondGrenadeOfDouble)
//	{
//		if (anim.numGrenadesInProgressTowardsPlayer > 1 || gettime() - anim.lastGrenadeLandedNearPlayerTime < 2000)
//		{
//			// two grenades in progress toward player. give them time to arrive.
//			anim.grenadeTimers['player_double_grenade'] = gettime() + min(5000, anim.playerDoubleGrenadeTime);
//		}
//	}
//
//	self notify ('stop grenade check');
//
////		assert (lAttachSide != 'none');
//	if (lAttachSide != 'none')
//		self detach(lModel, lAttachSide);
//	else
//	{
//		print ('No grenade hand set: ');
//		println (iThrowAnim);
//		println('animation in console does not specify grenade hand');
//	}
//	self.isHoldingGrenade = undefined;
//
//	self.grenadeawareness = self.oldGrenAwareness;
//	self.oldGrenAwareness = undefined;
//
//	//prof_end('DoGrenadeThrow');
//
//	self waittillmatch('throwanim', 'end');
//	// modern
//
//	// TODO: why is this here? why are we assuming that the calling function wants these particular animnodes turned on?
//	self setanim(%exposed_modern,1,.2);
//	self setanim(%exposed_aiming,1);
//	self clearanim(iThrowAnim,.2);
}
