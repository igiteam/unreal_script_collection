class shared_TrackLoop extends CoreTask within animscripts_shared;

// parameter
var name aim2;
var name aim4;
var name aim6;
var name aim8;

// output

// local

var float aimBlendTime;

var float prevYawDelta;
var float prevPitchDelta;
var float maxYawDeltaChange;
var float maxPitchDeltaChange;

var float pitchAdd;
var float yawAdd;

var bool doMaxAngleCheck;

var float yawDelta;
var float pitchDelta;
	
var bool firstFrame;

var vector selfShootAtPos;
var vector shoot_pos;

var Angle likelyEnemyDir;

var vector vectorToShootPos;
var Angle anglesToShootPos;

var float yawDeltaChange;
var float pitchDeltaChange;

var float weight;

state main
{
Begin:
	//prof_begin('trackLoopInit');
	aimBlendTime = 0.05;
	
	prevYawDelta = 0;
	prevPitchDelta = 0;
	maxYawDeltaChange = 5; // max change in yaw in 1 frame
	maxPitchDeltaChange = 5;
	
	pitchAdd = 0;
	yawAdd = 0;
	
	if (type == 'dog')
	{
		doMaxAngleCheck = false;
		shootEnt = enemy;
	}
	else
	{
		doMaxAngleCheck = true;
		if (a.script == 'cover_crouch' && isdefined(a.coverMode) && a.coverMode == 'lean')
			pitchAdd = -1 * anim.coverCrouchLeanPitch;
		if ((a.script == 'cover_left' || a.script == 'cover_right') && isdefined(a.cornerMode) && a.cornerMode == 'lean')
			yawAdd = angles.yaw - coverNode.angles.yaw;
	}
	
	yawDelta = 0;
	pitchDelta = 0;
	
	firstFrame = true;
	
//	//prof_end('trackLoopInit');
	
	while (true)
	{
//		//prof_begin('trackLoop');
	
		incrAnimAimWeight();
		
		selfShootAtPos.x = origin.x;
		selfShootAtPos.y = origin.y;
		selfShootAtPos.z = getEye().z;

		shoot_pos = shootPos;
		if (shootEnt != none)
			shoot_pos = shootEnt.GetShootAtPos();

//		if (!isdefined(shoot_pos) && self animscripts\cqb::shouldCQB())
//		{
//			selfForward = anglesToForward(self.angles);
//			if (isdefined(self.cqb_target))
//			{
//				shoot_pos = self.cqb_target getShootAtPos();
//				if (vectorDot(vectorNormalize(shoot_pos - selfShootAtPos), selfForward) < 0.643) // 0.643 = cos50
//					shoot_pos = undefined;
//			}
//			if (!isdefined(shoot_pos) && isdefined(self.cqb_point_of_interest))
//			{
//				shoot_pos = self.cqb_point_of_interest;
//				if (vectorDot(vectorNormalize(shoot_pos - selfShootAtPos), selfForward) < 0.643) // 0.643 = cos50
//					shoot_pos = undefined;
//			}
//		}
		
		if (!vec_isdefined(shoot_pos))
		{
			assert(!obj_isdefined(shootEnt));
			
			if (obj_isdefined(node) && node.type == 'Guard' && distanceSquared(origin, node.origin) < 16 * FInchSq)
			{
				//yawDelta = AngleClamp180(angles.yaw - node.angles.yaw);
				yawDelta = AngleClamp180(node.angles.yaw - angles.yaw);
				pitchDelta = 0;
			}
			else
			{
				if (getAnglesToLikelyEnemyPath(likelyEnemyDir))
				{
					//yawDelta = AngleClamp180(angles.yaw - likelyEnemyDir.yaw);
					yawDelta = AngleClamp180(likelyEnemyDir.yaw - angles.yaw);
					//pitchDelta = AngleClamp180(360 - likelyEnemyDir.pitch);
					pitchDelta = AngleClamp180(likelyEnemyDir.pitch);
				}
				else
				{
					yawDelta = 0;
					pitchDelta = 0;
				}
			}
		}
		else
		{
			vectorToShootPos = shoot_pos - selfShootAtPos;
			anglesToShootPos = vectorToAngles(vectorToShootPos);
			
			pitchDelta = /*360 - */anglesToShootPos.pitch;
			pitchDelta = AngleClamp180(pitchDelta + pitchAdd);
			
			//yawDelta = angles.yaw - anglesToShootPos.yaw;
			yawDelta = anglesToShootPos.yaw - angles.yaw;
			
			yawDelta = AngleClamp180(yawDelta + yawAdd);
		}
		
		if (doMaxAngleCheck && (abs(yawDelta) > 60 || abs(pitchDelta) > 60))
		{
			yawDelta = 0;
			pitchDelta = 0;
		}
		else
		{
			if (yawDelta > rightAimLimit)
				yawDelta = rightAimLimit;
			else if (yawDelta < leftAimLimit)
				yawDelta = leftAimLimit;
			if (pitchDelta > upAimLimit)
				pitchDelta = upAimLimit;
			else if (pitchDelta < downAimLimit)
				pitchDelta = downAimLimit;
		}
		
		if (firstFrame)
		{
			firstFrame = false;
		}
		else
		{
			yawDeltaChange = yawDelta - prevYawDelta;
			if (abs(yawDeltaChange) > maxYawDeltaChange)
				yawDelta = prevYawDelta + maxYawDeltaChange * sign(yawDeltaChange);
			
			pitchDeltaChange = pitchDelta - prevPitchDelta;
			if (abs(pitchDeltaChange) > maxPitchDeltaChange)
				pitchDelta = prevPitchDelta + maxPitchDeltaChange * sign(pitchDeltaChange);
		}
		
		prevYawDelta = yawDelta;
		prevPitchDelta = pitchDelta;
		
		if (yawDelta > 0)
		{
			assert(yawDelta <= rightAimLimit);
			weight = yawDelta / rightAimLimit * a.aimweight;
			setAnimLimited(aim4, 0, aimBlendTime);
			setAnimLimited(aim6, weight, aimBlendTime);
		}
		else if (yawDelta < 0)
		{
			assert(yawDelta >= leftAimLimit);
			weight = yawDelta / leftAimLimit * a.aimweight;
			setAnimLimited(aim6, 0, aimBlendTime);
			setAnimLimited(aim4, weight, aimBlendTime);
		}
		
		if (pitchDelta > 0)
		{
			assert(pitchDelta <= upAimLimit);
			weight = pitchDelta / upAimLimit * a.aimweight;
			setAnimLimited(aim2, 0, aimBlendTime);			
			setAnimLimited(aim8, weight, aimBlendTime);
		}
		else if (pitchDelta < 0)
		{
			assert(pitchDelta >= downAimLimit);
			weight = pitchDelta / downAimLimit * a.aimweight;
			setAnimLimited(aim8, 0, aimBlendTime);
			setAnimLimited(aim2, weight, aimBlendTime);
		}
		
//		//prof_end('trackLoop');
		wait (0.05);
	}
}
