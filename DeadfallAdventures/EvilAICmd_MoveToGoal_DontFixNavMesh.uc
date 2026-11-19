class EvilAICmd_MoveToGoal_DontFixNavMesh extends EvilAICmd_MoveToGoal within EvilAIController;

state Unstuck
{Begin:

    Outer.NavMeshPath_SearchExtent_Modifier += vect(-5.0000000, -5.0000000, 0.0000000);
    GotoState('MoveToGoalState', 'CheckMove');
    stop;                    
}

defaultproperties
{
    MaxMovetowardTries=0
    MaxNavPathSearchFails=5
    AlternativeMoveGoalRadius=600.0000000
}