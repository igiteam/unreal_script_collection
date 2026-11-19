class StateNegotiation_Jump extends CoreTask within State_Negotiation;

// local
var name lAnim;
var Angle lAngle;
state main
{
Begin:
	lAngle = angles;
	lAngle.yaw = VectorToAngles(iPath.End.Actor.Location - Pawn.Location).yaw;
	teleport(, lAngle);
	OrientMode('face angle', angles.yaw);
	AnimMode('zonly_physics');
	pawn.SetPhysics(PHYS_Flying);
	pawn.SetCollisionType(COLLIDE_TouchAllButWeapons);
	//pawn.SetCollisionSize(1.0f, 1.0f);
	//pawn.SetCollision(TRUE, FALSE);
	clearanim('body', 0.2);

	lAnim = SetCustomAnim(misc_modern, 'npc_jump');
	setFlaggedAnimRestart('negotiation_jump', lAnim);
	waittillmatch('negotiation_jump', name("gravity on"));
	setFlaggedAnimLimited('negotiation_jump', lAnim, 1.0, 0.0, 0.0);
	pawn.SetPhysics(PHYS_Falling);
	pawn.SetCollisionSize(1, pawn.default.CylinderComponent.CollisionHeight);
	while (pawn.Physics == PHYS_Falling)
		wait (0);
	setFlaggedAnimLimited('negotiation_jump', lAnim, 1.0, 0.0, 1.0);
	animscripts_shared.DoNoteTracks('negotiation_jump');
	//pawn.SetCollision(TRUE, TRUE);
	pawn.SetCollisionType(COLLIDE_BlockAllButWeapons);
	pawn.SetCollisionSize(pawn.default.CylinderComponent.CollisionRadius, pawn.default.CylinderComponent.CollisionHeight);
	pawn.SetPhysics(PHYS_Walking);

	a.pose = 'stand';
	a.movement = 'run';
}
