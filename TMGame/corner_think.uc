class corner_think extends CoreTask within animscripts_corner;

// parameter
var name iDirection;

// output

// local
var cover_behavior_callback behaviorCallbacks;

state main
{
Begin:
	endon ('killanimscript');
	
//	self.animArrayFuncs['exposed']['stand'] = animscripts\corner::set_standing_animarray_aiming;
//	self.animArrayFuncs['exposed']['crouch'] = animscripts\corner::set_crouching_animarray_aiming;
	
	coverNode.Set(node.data);
	cornerDirection = iDirection;
	a.cornerMode = 'unknown';
	
	a.standIdleThread = false;

	//// need fix
	//a.pose = 'stand';
	
	if (a.pose == 'crouch')
	{
		set_anim_array('crouch');
	}
	else if (a.pose == 'stand')
	{
		set_anim_array('stand');
	}
	else
	{
		assert(a.pose == 'prone');
		animscripts_utility.ExitProneWrapper(1);
		a.pose = 'crouch';
		set_anim_array('crouch');
	}
	
	isshooting = false;
	tracking = false;
	
	cornerAiming = false;
	
	animscripts_shared.setAnimAimWeight(0);
	
	haveGoneToCover = false;
		
//	behaviorCallbacks = spawnstruct();
	behaviorCallbacks.mainLoopStart			= corner_CBCmainLoopStart;
	behaviorCallbacks.reload				= corner_CBCReload;
	behaviorCallbacks.leaveCoverAndShoot	= corner_CBCleaveCoverAndShoot;
	behaviorCallbacks.look					= corner_CBClook;
	behaviorCallbacks.fastlook				= corner_CBCfastlook;
	behaviorCallbacks.idle					= corner_CBCidle;
	behaviorCallbacks.grenade				= corner_CBCgrenade;
	behaviorCallbacks.grenadehidden			= corner_CBCgrenadehidden;
	behaviorCallbacks.blindfire				= corner_CBCblindfire;
	
	animscripts_cover_behavior.main(behaviorCallbacks);
}
