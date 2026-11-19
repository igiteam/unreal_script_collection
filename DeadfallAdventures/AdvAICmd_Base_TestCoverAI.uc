class AdvAICmd_Base_TestCoverAI extends AdvAICmd_Base_CoverAI within AdvAIController_Cover;

var Vector StrafePoint;

function PlayMySound()
{
    //return;    
}

function Pushed()
{
    super.Pushed();
    Outer.SetAttackBehavior(Outer.Enemy);
    Outer.SetTimer(GetTransitionCheckTime(), false, 'CheckTimedCombatTransition');
    Outer.bAllowCombatTransitions = false;
    Outer.ReactionManager.SuppressAllReactions();
    GotoState('InCombat');
    //return;    
}

state InCombat
{Begin:

    Outer.FlushPersistentDebugLines();
    StrafePoint = Outer.GetStrafePointByDirection(5, 100.0000000,, Outer.Enemy);
    Outer.DrawDebugLine(Outer.MyEvilPawn.Location, StrafePoint, 255, 255, 255, true);
    Outer.Sleep(0.1000000);
    goto 'Begin';
    stop;                    
}
