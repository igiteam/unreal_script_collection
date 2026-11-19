class StateNegotiation_Over extends CoreTask within State_Negotiation;

var float lHighZ;
var float lZ;
var StateNegotiation_Over_Teleport teleporter;
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
	pawn.SetCollisionSize(1.0f, pawn.default.CylinderComponent.CollisionHeight);
	//pawn.SetCollision(FALSE, FALSE);
	pawn.SetCollisionType(COLLIDE_TouchAllButWeapons);
	clearanim('body', 0.2);
	setFlaggedAnimRestart('negotiation_over', SetCustomAnim(misc_modern, 'npc_cross'));
	waittillmatch('negotiation_over', name("cross start"));

	lHighZ = 45;
	lZ = iPath.Agent.Location.Z - origin.Z;
	teleporter = new(self) class'StateNegotiation_Over_Teleport';
	teleporter.iDelta = vect(0, 0, 1) * (lZ - lHighZ);
	teleporter.iTime = 0.25;
	run (teleporter, true);
	pawn.SetCollisionSize(1.0f, 1.0);

	waittillmatch('negotiation_over', name("gravity on"));
	pawn.SetPhysics(PHYS_Falling);
	pawn.SetCollisionSize(1, pawn.default.CylinderComponent.CollisionHeight);

	animscripts_shared.DoNoteTracks('negotiation_over');
	//pawn.SetCollision(TRUE, TRUE);
	pawn.SetCollisionType(COLLIDE_BlockAllButWeapons);
	pawn.SetCollisionSize(pawn.default.CylinderComponent.CollisionRadius, pawn.default.CylinderComponent.CollisionHeight);
	pawn.SetPhysics(PHYS_Walking);

	a.pose = 'stand';
	a.movement = 'run';
}
