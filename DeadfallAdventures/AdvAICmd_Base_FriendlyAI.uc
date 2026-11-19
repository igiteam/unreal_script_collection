class AdvAICmd_Base_FriendlyAI extends EvilAICmd_Base_Combat within AdvAI_AllyAnimal;

function bool HasMasterInDistance(float MasterDistance)
{
    return VSizeSq(Outer.Master.MyEvilPawn.Location - Outer.MyEvilPawn.Location) < (MasterDistance * MasterDistance);
    //return ReturnValue;    
}

function Pushed()
{
    super.Pushed();
    Outer.MyEvilPawn.IdleAnimIndex = 0;
    GotoState('InCombat');
    //return;    
}

state InCombat
{Begin:

    // End:0x1DC
    if(Outer.HasValidEnemy())
    {
        // End:0x1C5
        if((((HasMasterInDistance(Outer.MasterDistance_FollowInCombat)) || Outer.IsFiring()) || Outer.IsAiming()) || Outer.ClearFireLineToEnemy(,, true))
        {
            // End:0x15B
            if(Outer.MyAdvPawn.bCanStrafe)
            {
                Outer.DoStrafeByDirections(Outer.OnRateStrafeByFlankEnemy, Outer.ShotTarget);                
            }
            else
            {
                Outer.SetMoveGoal(Outer.ShotTarget, Outer.EnemyDistance_Melee * 0.8000000);
            }            
        }
        else
        {
            PushState('FollowMaster');
        }        
    }
    else
    {
        PushState('FollowMaster');
        Outer.Sleep(2.0000000);
    }
    Outer.Sleep(0.5000000);
    goto 'Begin';
    stop;                
}

state FollowMaster
{Begin:

    // End:0x61
    if(Outer.ActualNavPoint != none)
    {
        Outer.PrevNavPoint = Outer.ActualNavPoint;
    }
    Outer.ActualNavPoint = Outer.GetNextNavPoint();
    // End:0x268
    if((Outer.ActualNavPoint != none) && !Outer.HasValidEnemy())
    {
        // End:0x265
        if((Outer.PrevNavPoint != Outer.ActualNavPoint) && Outer.ActualNavPoint != none)
        {
            Outer.SetSpecialMoveGoal(Outer.ActualNavPoint, Outer.MyEvilPawn.GetCollisionRadius() * float(2));
            Outer.SetFocalPoint(Normal(Vector(Outer.ActualNavPoint.Rotation)) * float(100));
            Outer.ExecuteNavActions(Outer.ActualNavPoint);
        }        
    }
    else
    {
        // End:0x47E
        if(((Outer.PrevNavPoint == none) || Outer.PrevNavPoint.NextNavPoint == none) && (VSizeSq(Outer.Master.MyEvilPawn.Location - Outer.MyEvilPawn.Location) > (Outer.MasterDistance_Follow * Outer.MasterDistance_Follow)) || !Outer.ClearSightToActor(Outer.Master.MyEvilPawn))
        {
            Outer.SetMoveGoal(Outer.Master.MyEvilPawn, Outer.MasterDistance_Follow, true);
            Outer.Focus = none;
        }
    }
    Outer.Sleep(0.1000000);
    PopState();
    stop;        
}
