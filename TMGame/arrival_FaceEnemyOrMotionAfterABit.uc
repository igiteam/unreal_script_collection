class arrival_FaceEnemyOrMotionAfterABit extends CoreTask within animscripts_cover_arrival;

state main
{
Begin:
	endon('killanimscript');
	
	wait(1.0);
	
	// don't want to spin around if we're almost where we're going anyway
	while (pathGoalPos != invalid_vector && distanceSquared(origin, pathGoalPos) < 200*200*FInchSq)
		wait(0.25);
	
	OrientMode('face default');
}
