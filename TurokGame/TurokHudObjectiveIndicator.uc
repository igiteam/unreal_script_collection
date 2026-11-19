class TurokHudObjectiveIndicator extends TurokHudElement
    transient
    native;

var private @NULL mGoalOwner;
var string mGoalName;
var private float mAnimationPeriod;
var private @NULL mObjectiveMaterialInstanceConstant;
var private @NULL mObjectiveMaterialInstance;
var private @NULL IndicatorColour;
var private float mIndicatorAlpha;
var private float mCurrentTime;
var private float mIndicatorShowTime;
var private float mIndicatorFadeTime;
var private float mIndicatorMaxAlpha;

// Export UTurokHudObjectiveIndicator::execShowIndicator(FFrame&, void* const)
native function ShowIndicator();

// Export UTurokHudObjectiveIndicator::execDrawNative(FFrame&, void* const)
native function DrawNative();

// Export UTurokHudObjectiveIndicator::execDrawIndicatorAtAngle(FFrame&, void* const)
native function DrawIndicatorAtAngle(const float kAngle);

// Export UTurokHudObjectiveIndicator::execSquelch(FFrame&, void* const)
native function Squelch();

event NoSeriouslyInitThisTime(@NULL HUD)
{
    Init(HUD);
    //return;    
}

event Init(@NULL HUD)
{
    super.Init(HUD);
    // End:0x3A
    if(mObjectiveMaterialInstanceConstant == none)
    {
        mObjectiveMaterialInstanceConstant = new Class'Engine.MaterialInstanceConstant';
        mObjectiveMaterialInstanceConstant.SetParent(mObjectiveMaterialInstance);
    }
    //return;    
}

event SetObjective(@NULL Goal, string goal_name)
{
    mGoalOwner = Goal;
    mGoalName = goal_name;
    //return;    
}

event bool CanDraw()
{
    return mGoalOwner != none;
    //return ReturnValue;    
}

event string GetGoalName()
{
    return mGoalName;
    //return ReturnValue;    
}

function Draw()
{
    DrawNative();
    //return;    
}

defaultproperties
{
    mObjectiveMaterialInstance=Material'TurokHud.Reticles.Objective.ObjectiveMaterialInstance'
    IndicatorColour=(R=1.0000000,G=1.0000000,B=0.0000000,A=1.0000000)
    mIndicatorShowTime=5.0000000
    mIndicatorFadeTime=5.0000000
    mIndicatorMaxAlpha=0.7500000
}