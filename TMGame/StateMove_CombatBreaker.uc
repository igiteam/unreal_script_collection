class StateMove_CombatBreaker extends CoreTask within HodAI;


// parameter

function bool CombatCheck()
{
	local vector lMe2Enemy;
	local vector lEnemyForward;
	local vector lNodeForward;

	lMe2Enemy = enemy.origin - origin;
	lEnemyForward = vectornormalize(lMe2Enemy);

	if ((lMe2Enemy dot lEnemyForward) > lerp(150, 350, vectorDot(lEnemyForward, lookForward) * 0.5 + 0.5) * FInch)
		return false;

	lNodeForward = anglesToForward(vectorToAngles(node.origin - origin));
	return (vectorDot(lEnemyForward, lNodeForward) > 0.1);
}

state main
{
Begin:
	endon ('killanimscript');
	while (node_isdefined(node))
	{
		if (animscripts_utility.isvalidenemy(enemy))
		{
			// If move to goal is not interruptable - skip notification
			if (!MoveToEnemy && (pawn.MyTGAI.bMovingToGoal || pawn.MyTGAI.bMovingToCover) && pawn.MyTGAI.bMoveGoalInterruptable)
			{
				goto_state('exposed');
				break;
			}

			if (CanSee(enemy))
			{
				if (MoveToEnemy)
				{
					goto_state('exposed');
					break;
				}
				else if (CombatCheck())
				{
					push_state('combat_breaker');
					break;
				}
			}
		}
		wait (0.25);
	}
}
