class combat_turn extends CoreTask within animscripts_combat;

// parameter
var name iDirection;
var float iAmount;

// output

// local
var bool lKnowWhereToShoot;
var float lRate;
var float lTransTime;
var bool lMustFaceEnemy;
var float lUrgency;
var float lAngle;
var name lAnimName;
var name lTurnAnim;

state main
{
Begin:
	lKnowWhereToShoot = vec_isdefined(shootPos);
	lRate = 1;
	lTransTime = 0.2;
	lMustFaceEnemy = (obj_isdefined(enemy) && canSee(enemy) && distanceSquared(enemy.origin, origin) < 512*512*FInchSq);
	if (a.scriptStartTime + 500 > gettime())
	{
		lTransTime = 0.25; // if it's the first thing we're doing, always blend slowly
		if (lMustFaceEnemy)
			faceEnemyImmediately(true);
	}
	else
	{
		if (lMustFaceEnemy)
		{
			lUrgency = 1.0 - (distance(enemy.origin, origin) / (512*FInch));
			lRate = 1 + lUrgency * 1;
			
			// (ensure lTransTime <= 0.2 / lRate)
			if (lRate > 2)
				lTransTime = 0.05;
			else if (lRate > 1.3)
				lTransTime = 0.1;
			else
				lTransTime = 0.15;
		}
	}

	lAngle = 0;
	if (iAmount > 157.5)
		lAngle = 180;
	else if (iAmount > 112.5)
		lAngle = 135;
	else if (iAmount > 67.5)
		lAngle = 90;
	else
		lAngle = 45;

	lAnimName = name("turn_" $ iDirection $ "_" $ int(lAngle));
	lTurnAnim = animscripts_utility.AnimArray(lAnimName);
	
	if (node_isdefined(node) && node.type == 'Guard' && distanceSquared(origin, node.origin) < 16*16*FInchSq)
		animmode('angle deltas');
	else if (isDeltaAllowed(lTurnAnim))
		animMode('zonly_physics');
	else
		animmode('angle deltas');
	
	setAnimKnobAll('exposed_aiming', 'body', 1, lTransTime);

	isturning = true;
	
	_TurningAimingOn(lTransTime);
	
	setAnimLimited('turn', 1, lTransTime);
	
	setFlaggedAnimKnobLimitedRestart('turn', lTurnAnim, 1, 0, lRate);
	notify('turning');
	
	if (lKnowWhereToShoot)
		shootWhileTurning(true);
	
	doTurnNotetracks();
	
	setanimlimited('turn', 0, 0.2);
	
	_TurningAimingOff(0.2);
	
	clearanim('turn', 0.2);
	setanimknob('exposed_aiming', 1, 0.2, 1);


	// if we didn't actually turn, code prevented us from doing so.
	// give up and turntable.
	if (turnLastResort)
	{
		turnLastResort = false;
		faceEnemyImmediately(true);
	}
	
	if (!animscripts_utility.usingShotgun())
		clearAnim('add_fire', 0.2);
	
	animMode ('zonly_physics');
	
	notify('done turning');
	isturning = false;
}
