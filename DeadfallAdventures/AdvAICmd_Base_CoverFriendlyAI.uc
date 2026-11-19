class AdvAICmd_Base_CoverFriendlyAI extends AdvAICmd_Base_CoverAI within AdvAI_Ally;

function bool HasMasterInDistance(float MasterDistance)
{
    return VSizeSq(Outer.Master.MyEvilPawn.Location - Outer.MyEvilPawn.Location) < (MasterDistance * MasterDistance);
    //return ReturnValue;    
}

function Pushed()
{
    super.Pushed();
    //return;    
}

state InCombat
{Begin:

    // End:0x1E0
    if(!Outer.MyEvilPawn.IsInCover() && !ShouldChangeCover())
    {
        // End:0x185
        if(Outer.HasValidEnemy())
        {
            // End:0x16E
            if((((HasMasterInDistance(Outer.MasterDistance_FollowInCombat)) || Outer.IsFiring()) || Outer.IsAiming()) || Outer.ClearFireLineToEnemy(,, true))
            {
                Outer.DoStrafeByDirections(Outer.OnRateStrafeByFlankEnemy, Outer.ShotTarget);                
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
    }
    else
    {
        // End:0x20F
        if(Outer.HasValidEnemy())
        {
            goto 'CoverCheck';            
        }
        else
        {
            PushState('FollowMaster');
            Outer.Sleep(0.5000000);
        }
    }
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
