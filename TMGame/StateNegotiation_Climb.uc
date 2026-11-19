class StateNegotiation_Climb extends CoreTask within State_Negotiation;

// local
var float lEndZ;
var float lClimbSpeed;
var name lAnim;
var float lDelayTime;
var Angle lAngle;

state main
{
Begin:
	lAngle = angles;
	lAngle.yaw = VectorToAngles(iPath.End.Actor.Location - Pawn.Location).yaw;
	teleport(, lAngle);
	OrientMode('face angle', angles.yaw);
	AnimMode('zonly_physics');
	//pawn.SetPhysics(PHYS_Flying);
	//pawn.SetCollisionSize(1.0f, 1.0f);
	//pawn.SetCollision(FALSE, FALSE);
	pawn.SetCollisionType(COLLIDE_TouchAllButWeapons);
	clearanim('body', 0.2);
	setFlaggedAnimRestart('negotiation_climb_start', SetCustomAnim(misc_modern, 'npc_climb_start'));
	waittillmatch('negotiation_climb_start', name("start climb"));
	pawn.SetPhysics(PHYS_Flying);
	pawn.SetCollisionSize(1.0f, pawn.default.CylinderComponent.CollisionHeight);
	animscripts_shared.DoNoteTracks('negotiation_climb_start');
	
	pawn.SetPhysics(PHYS_Flying);
	lEndZ = GetMoveDelta(SetCustomAnim(animscripts_init.trans_anim, 'npc_climb_end'), 0, 1).Z;
	lAnim = SetCustomAnim(animscripts_init.trans_anim, 'npc_climb_loop', 1.5);
	lClimbSpeed = GetMoveDelta(lAnim, 0, 1).Z / GetAnimLength(lAnim);

	lDelayTime = (iPath.End.Actor.GetOrigin().Z - origin.Z - lEndZ) / lClimbSpeed;
	SetFlaggedAnimKnobRestart('negotiation_climb_loop', SetCustomAnim(misc_modern, 'npc_climb_loop', 1.5, true));
	wait(lDelayTime);

	SetFlaggedAnimKnobRestart('negotiation_climb_end', SetCustomAnim(misc_modern, 'npc_climb_end'));
	waittillmatch('negotiation_climb_end', name("end climb"));
	pawn.SetCollisionType(COLLIDE_BlockAllButWeapons);
	//pawn.SetCollision(TRUE, TRUE);
	pawn.SetCollisionSize(pawn.default.CylinderComponent.CollisionRadius, pawn.default.CylinderComponent.CollisionHeight);
	pawn.SetPhysics(PHYS_Walking);
	animscripts_shared.DoNoteTracks('negotiation_climb_end');

	a.pose = 'crouch';
	a.movement = 'stop';
}
