class PKAICmd_Base_Reaper extends EvilAICmd_Base_Combat within PKAI_Boss_Reaper;

var Vector MoveLocation;
var float PawnDistToEnemy;
var float PawnDistToTarget;
var int StrafeCounter;
var name DisplayState;
var PKPawn_Boss_Reaper_Base MyReaperPawn;
var int CurrentNodeIndex;

function bool IsStillWalking()
{
    return Outer.FindCommandOfClass(Class'EvilGame.EvilAICmd_MoveToGoal') != none;
    //return ReturnValue;    
}

function Pushed()
{
    super.Pushed();
    MyReaperPawn = PKPawn_Boss_Reaper_Base(Outer.Pawn);
    Outer.SetTimer(GetTransitionCheckTime(), false, 'CheckTimedCombatTransition');
    Outer.AutoAcquireEnemy();
    GotoState('BaseState');
    //return;    
}

state BaseState
{Begin:

    DisplayState = 'BaseState';
    // End:0x7D
    if(!Outer.HasValidEnemy())
    {
        Outer.Sleep(0.1000000);
        Outer.AutoAcquireEnemy();
        goto 'Begin';
    }
    // End:0x11B
    if(MyReaperPawn.Target == none)
    {
        MyReaperPawn.Target = Outer.Enemy;
        Outer.Focus = Outer.Enemy;
    }
    // End:0x183
    if(MyReaperPawn.bVulnurable)
    {
        Outer.AbortMoving();
        Outer.Sleep(0.1000000);
        goto 'Begin';
    }
    MyReaperPawn.CheckMonstersList();
    // End:0x245
    if((((MyReaperPawn.PissedOff == 0) && MyReaperPawn.StrafeDirection == 'None') && RandRange(0.0000000, 100.0000000) < float(50)) || MyReaperPawn.bRoaming)
    {
        GotoState('WalkAway');
    }
    // End:0x372
    if(!MyReaperPawn.bRoaming && Outer.NavigationHandle.ActorReachable(Outer.Enemy))
    {
        // End:0x32A
        if(RandRange(0.0000000, 1.0000000) < (0.1000000 + (0.3000000 * float(StrafeCounter))))
        {
            Outer.AbortMoving();
            StrafeCounter = 0;
            GotoState('Strike');
        }
        // End:0x372
        if(StrafeCounter < 3)
        {
            Outer.AbortMoving();
            StrafeCounter++;
            GotoState('Strafe');
        }
    }
    // End:0x3EC
    if(!IsStillWalking() && !MyReaperPawn.bRoaming)
    {
        Outer.SetMoveGoal(Outer.Enemy, 1536.0000000, true, true);
    }
    Outer.Sleep(0.1000000);
    goto 'Begin';
    stop;                    
}

state WalkAway
{Begin:

    DisplayState = 'WalkAway';
    MyReaperPawn.StrafeDirection = 'None';
    MyReaperPawn.bRoaming = true;
    Outer.Sleep(RandRange(1.0000000, 2.0000000));
    MyReaperPawn.bRoaming = false;
    // End:0xF2
    if(RandRange(0.0000000, 1.0000000) < 0.5000000)
    {
        MyReaperPawn.StrafeDirection = 'Right';        
    }
    else
    {
        MyReaperPawn.StrafeDirection = 'Left';
    }
    GotoState('BaseState');
    stop;                
}

state Strike
{Begin:

    DisplayState = 'Strike';
    MyReaperPawn.bReadyToStrike = true;
    // End:0xCE
    if((MyReaperPawn.LastThrowTime + 3.0000000) > Outer.WorldInfo.TimeSeconds)
    {
        MyReaperPawn.Target = Outer.Enemy;
    }
    // End:0x1B6
    if(RandRange(0.0000000, 100.0000000) < float(20))
    {
        MyReaperPawn.StrafeDirection = 'None';
        MyReaperPawn.PissedOff++;
        MyReaperPawn.GroundSpeed = MyReaperPawn.default.GroundSpeed * float(2);
        Outer.Sleep(5.0000000);
        MyReaperPawn.PissedOff--;        
    }
    else
    {
        Outer.Sleep(5.0000000);
    }
    MyReaperPawn.StrafeDirection = 'None';
    MyReaperPawn.bReadyToStrike = false;
    GotoState('BaseState');
    stop;        
}

state Strafe
{Begin:

    DisplayState = 'Strafe';
    // End:0xD0
    if((MyReaperPawn.StrafeDirection == 'None') || RandRange(0.0000000, 1.0000000) < 0.1000000)
    {
        // End:0xA8
        if(RandRange(0.0000000, 1.0000000) < 0.5000000)
        {
            MyReaperPawn.StrafeDirection = 'Right';            
        }
        else
        {
            MyReaperPawn.StrafeDirection = 'Left';
        }
    }
    Outer.Sleep(RandRange(0.2500000, 1.0000000));
    GotoState('BaseState');
    stop;        
}
