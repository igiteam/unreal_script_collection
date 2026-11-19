class cover_prone_main extends CoreTask within animscripts_cover_prone;

state main
{
Begin:
	trackScriptState('Cover Prone Main', "code");
	endon('killanimscript');
    animscripts_utility.initialize('cover_prone');

//	// TODO: run cover crouch or exposed crouch
//	if (weaponClass(weapon) == 'rocketlauncher')
//	{
//		animscripts_combat.main();
//		_return();
//	}
	
//	if (isDefined(a.arrivalType) && a.arrivalType == 'prone_saw')
//	{
//		assert(isDefined(self.node.turretInfo));
//		self animscripts\cover_wall::useSelfPlacedTurret('saw_bipod_prone', 'weapon_saw_MG_Setup');
//	}
//	else if (isDefined(self.node.turret))
//	{
//		self animscripts\cover_wall::useStationaryTurret();
//	}

	// if we're too close to our enemy, stand up
	// (285 happens to be the same distance at which we leave cover and go into exposed if our enemy approaches)
	if (obj_isDefined(enemy) && lengthSquared(origin - enemy.origin) < squared(512*FInch))
	{
		animscripts_combat.main(true);
		_return();
	}

	setup_cover_prone();

	coverNode.Set(node.data);   
	OrientMode('face angle', coverNode.angles.yaw);	

	setProneAnimNodes(-45, 45, 'prone_legs_down', 'exposed_modern', 'prone_legs_up');
	if (a.pose != 'prone')
		transitionTo('prone');
	else
		animscripts_utility.EnterProneWrapper(0);
	
	idleThread(true);
		
	setAnimKnobAll('prone_aim', 'body', 1, 0.1, 1);

	// face the direction of our covernode
	OrientMode('face angle', coverNode.angles.yaw);	
	animmode('zonly_physics');
	
	proneCombatMainLoop();
	
	notify('stop_deciding_how_to_shoot');
	
}
