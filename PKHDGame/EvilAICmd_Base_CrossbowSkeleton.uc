class EvilAICmd_Base_CrossbowSkeleton extends EvilAICmd_Base_Combat within EvilAIController;

var Actor Obstacle;

function Pushed()
{
    // End:0x72
    if(int(Outer.Pawn.Physics) == int(0))
    {
        Outer.Pawn.SetMovementPhysics();
    }
    // End:0xE7
    if(Outer.HasValidEnemy())
    {
        Outer.SetFocalPoint(Outer.Enemy.Location);
    }
    GotoState('InCombat');
    super.Pushed();
    //return;    
}

state InCombat
{Begin:

    // End:0x63A
    if(Outer.HasValidEnemy())
    {
        // End:0x2F7
        if((Outer.GetEnemyInfo().DistanceToEnemy > Outer.EnemyDistance_Shoot) || !Outer.ClearSightToEnemy())
        {
            Outer.SetMoveGoal(Outer.Enemy, FMax(Outer.MyEvilPawn.GetCollisionRadius(), Outer.EnemyDistance_Shoot - (Outer.Pawn.GetCollisionRadius() * float(4))));
            // End:0x2F4
            if(!Outer.ClearSightToEnemy(Obstacle))
            {
                Outer.ReactionManager.NudgeChannel(Outer, 'TriggerStrafe');
                // End:0x2F4
                if(!Outer.ClearSightToEnemy(Obstacle))
                {
                    Outer.SetMoveGoal(Outer.Enemy, FMax(Outer.MyEvilPawn.GetCollisionRadius(), Outer.GetEnemyInfo().DistanceToEnemy - (Outer.MyEvilPawn.GetCollisionRadius() * float(8))));
                }
            }            
        }
        else
        {
            // End:0x5F1
            if(Outer.ClearSightToEnemy())
            {
                Outer.SetFocalPoint(Outer.Enemy.Location);
                Outer.Sleep(0.1000000);
                // End:0x3DF
                if(FRand() < 0.1000000)
                {
                    Outer.ReactionManager.NudgeChannel(Outer, 'TriggerStrafe');                    
                }
                else
                {
                    // End:0x5EE
                    if(((Outer.GetEnemyInfo().DistanceToEnemy > Outer.EnemyDistance_Melee) && !Outer.MyEvilPawn.bStrafing) && !(int(Outer.MyEvilPawn.PawnAction) == 11) && !Outer.NavigationHandle.ActorReachable(Outer.Enemy))
                    {
                        Outer.SetMoveGoal(Outer.Enemy, FMax(Outer.MyEvilPawn.GetCollisionRadius(), Outer.GetEnemyInfo().DistanceToEnemy - (Outer.MyEvilPawn.GetCollisionRadius() * float(8))));
                    }
                }                
            }
            else
            {
                Outer.ReactionManager.NudgeChannel(Outer, 'TriggerStrafe');
            }
        }        
    }
    else
    {
        Outer.PopCommand(self);
    }
    goto 'Begin';
    stop;                
}
