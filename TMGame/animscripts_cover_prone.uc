class animscripts_cover_prone extends Object within HodAI
	dependson(general_human);

// TODO:
// - figure out why aiming range is incorrect (aiming arc seems a bit off)

function main(optional bool newThread = false)
{
	run (new(self) class'cover_prone_main', newThread);
}

function IdleThread(optional bool newThread = false)
{
	run (new(self) class'cover_prone_IdleThread', newThread);
}

function UpdateProneWrapper(float time, optional bool newThread = false)
{
	local cover_prone_UpdateProneWrapper task;
	task = new(self) class'cover_prone_UpdateProneWrapper';
	task.time = time;
	run (task, newThread);
}

function ProneCombatMainLoop(optional bool newThread = false)
{
	run (new(self) class'cover_prone_ProneCombatMainLoop', newThread);
}




function ProneReload(float threshold)
{
	animscripts_combat_utility.Reload(threshold, animscripts_utility.animArray('reload'));
}


function setup_cover_prone()
{
	rightAimLimit = 45;
	leftAimLimit = -45;
	upAimLimit = 45; 
	downAimLimit = -45;

	ResetAnimArray();
	SetAnimArray('straight_level', 'prone_aim');

	SetAnimArray('single', 'prone_fire_single');
	SetAnimArray('fire', 'prone_fire_auto');

	SetAnimArray('semi2', 'prone_fire_semi2');
	SetAnimArray('semi3', 'prone_fire_semi3');
	SetAnimArray('semi4', 'prone_fire_semi4');
	SetAnimArray('semi5', 'prone_fire_semi5');

	SetAnimArray('burst2', 'prone_fire_burst2'); // (will be limited to 2 shots)
	SetAnimArray('burst3', 'prone_fire_burst3');
	SetAnimArray('burst4', 'prone_fire_burst4');
	SetAnimArray('burst5', 'prone_fire_burst5');
	SetAnimArray('burst6', 'prone_fire_burst6');

	SetAnimArray('reload', 'prone_reload');

	SetAnimArray('look', 'prone_look_v1');
	//SetAnimArray('look', 'prone_twitch_lookfast');
	//SetAnimArray('look', 'prone_twitch_lookup');

	SetAnimArray('grenade_safe', 'prone_grenade_v1');
	SetAnimArray('grenade_exposed', 'prone_grenade_v1');

	SetAnimArray('prone_idle', 'prone_idle');

	//SetAnimArray('hide_to_look', 'coverstand_look_moveup');
	//SetAnimArray('look_idle', 'coverstand_look_idle');
	//SetAnimArray('look_to_hide', 'coverstand_look_movedown');
	//SetAnimArray('look_to_hide_fast', 'coverstand_look_movedown_fast');

	SetAnimArray('stand_2_prone', 'stand_2_prone_nodelta');
	SetAnimArray('crouch_2_prone', 'crouch_2_prone');
	SetAnimArray('prone_2_stand', 'prone_2_stand_nodelta');
	SetAnimArray('prone_2_crouch', 'prone_2_crouch');
	SetAnimArray('stand_2_prone_firing', 'stand_2_prone_firing');
	SetAnimArray('crouch_2_prone_firing', 'crouch_2_prone_firing');
	SetAnimArray('prone_2_stand_firing', 'prone_2_stand_firing');
	SetAnimArray('prone_2_crouch_firing', 'prone_2_crouch_firing');
}


//tryThrowingGrenade(throwAt, safe)
//{
//	theanim = undefined;
//	if (isdefined(safe) && safe)
//		theanim = animArrayPickRandom('grenade_safe');
//	else
//		theanim = animArrayPickRandom('grenade_exposed');
//	
//	self animMode ('zonly_physics'); // Unlatch the feet
//	self.keepClaimedNodeInGoal = true;
//	
//	armOffset = (32,20,64); // needs fixing!
//	threwGrenade = TryGrenade(throwAt, theanim);
//	
//	self.keepClaimedNodeInGoal = false;
//	return threwGrenade;
//}


function bool ConsiderThrowGrenade()
{
//	if (isdefined(anim.throwGrenadeAtPlayerASAP) && isAlive(level.player))
//	{
//		if (tryThrowingGrenade(level.player, 200))
//			return true;
//	}
//	
//	if (isdefined(self.enemy))
//		return tryThrowingGrenade(self.enemy, 850);
	
	return false;
}

function bool ShouldFireWhileChangingPose()
{
	if (node != none && distanceSquared(origin, node.origin) < 16*16*FInchSq)
		return false; // we're on a node and can't use an animation with a delta
	if (enemy != none && canSee(enemy) && !grenade && animscripts_shared.getAimYawToShootEntOrPos() < 20*FInch)
		return animscripts_move.MayShootWhileMoving();
	return false;
}

function TransitionTo(name iNewPose, optional bool newThread = false)
{
	local cover_prone_TransitionTo task;

	if (iNewPose == a.pose)
		return;

	task = new(self) class'cover_prone_TransitionTo';
	task.iNewPose = iNewPose;
	run (task, newThread);
}

//finishNoteTracks(animname)
//{
//	self endon('killanimscript');
//	animscripts\shared::DoNoteTracks(animname);
//}


function SetupAim(float iTransTime)
{
	setAnimKnobAll('prone_aim', 'body', 1, iTransTime);
	setAnimLimited('prone_aim_2', 1, iTransTime);
	setAnimLimited('prone_aim_4', 1, iTransTime);
	setAnimLimited('prone_aim_6', 1, iTransTime);
	setAnimLimited('prone_aim_8', 1, iTransTime);
}


function ProneTo(name newPose, optional float rate = 1, optional bool newThread = false)
{
	local cover_prone_ProneTo task;
	task = new(self) class'cover_prone_ProneTo';
	task.newPose = newPose;
	task.rate = rate;
	run (task, newThread);
}
