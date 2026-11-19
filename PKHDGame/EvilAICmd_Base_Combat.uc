class EvilAICmd_Base_Combat extends EvilAICommand within EvilAIController;

var float TransitionCheckTime;
var bool bCanOuterFastSpinUp;

function bool CheckTransition(out class<EvilAICmd_Base_Combat> out_NewCommand, out string out_Reason)
{
    //return ReturnValue;    
}

function float GetTransitionCheckTime()
{
    return TransitionCheckTime;
    //return ReturnValue;    
}

function Pushed()
{
    super.Pushed();
    Outer.SetTimer(GetTransitionCheckTime(), false, 'CheckTimedCombatTransition');
    //return;    
}

function Popped()
{
    super(GameAICommand).Popped();
    Outer.ClearTimer('CheckTimedCombatTransition');
    //return;    
}

state InCombat
{Begin:

    stop;                
}

defaultproperties
{
    TransitionCheckTime=0.5000000
    bCanOuterFastSpinUp=true
}