class animscripts_move extends Object within HodAI
	dependson(general_human);

var float walk_noncombatanim_rate;
var float walk_noncombatanim2_rate;
var float walk_combatanim_rate;
var float walk_combatanim2_rate;
var float run_combatanim_rate;
var float run_noncombatanim_rate;
var float crouchrun_combatanim_rate;

function main(optional bool newThread = false)
{
	local move_main task;
	task = new(self) class'move_main';
	run(task, newThread);
}

//MoveMainLoop()
//{
//}

function bool MayShootWhileMoving()
{
	local name weapclass;

	if (weapon == 'none')
		return false;
	
	weapclass = weaponClass(weapon);
	if ( weapclass != 'rifle' && weapclass != 'smg' && weapclass != 'spread' && weapclass != 'mg' )
		return false;
	
	if (animscripts_combat_utility.IsSniper())
		return false;
	
	if (dontShootWhileMoving)
	{
		return false;
	}

	return true;
}

function ShootWhileMoving(optional bool newThread = false)
{
	run (new(self) class'move_ShootWhileMoving', newThread);
}

//combatBreaker()
//{
//	self endon("killanimscript");
//	while (isalive(self.enemy) && isdefined(self.node) && self canSee(self.enemy))
//	{
//		if (seekingCoverInMyFov())
//			break;
//		wait (0.25);
//	}
//	self thread moveAgain();
//}
//
//moveAgain()
//{
//	self notify("killanimscript");
//	animscripts\move::main();
//}
//
//seekingCoverInMyFov()
//{
//	// Run back to cover if you're not in your goalradius
//	if (distance(self.origin, self.node.origin) > self.goalradius)
//		return true;
//	if (distance(self.origin, self.node.origin) < 80)
//		return true;
////	print3d(self.node.origin, "node for " + self getentnum(), (1,1,0));
//	enemyAngles = vectorToAngles(self.origin - self.enemy.origin);
//	enemyForward = anglesToForward(enemyAngles);
//	nodeAngles = vectorToAngles(self.origin - self.node.origin);
//	nodeForward = anglesToForward(nodeAngles);
//	return (vectorDot(enemyForward, nodeforward) > 0.1);
//}
//
//RunBreaker()
//{
//	self endon("killanimscript");
//	for (;;)
//	{
//		if (isalive(self.enemy) && isdefined(self.node) && self canSee(self.enemy))
//		{
//			if (!seekingCoverInMyFov())
//				break;
//		}
//		wait (0.25);
//	}
//	self thread moveAgain();
//}
//
///#
//drawLookaheadDir()
//{
//	self endon("killanimscript");
//	for (;;)
//	{
//		line(self.origin + (0,0,20), (self.origin + vectorscale(self.lookaheaddir,64)) + (0,0,20));	
//		wait(0.05);
//	}
//}
//#/
