///////////////////////////////////////////////////////////////////////////////
// TasedGoal.uc - TasedGoal class
// this goal that causes an AI to react to being Tased

class TasedGoal extends StunnedGoal;
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////

// note that the priority for the taser needs to be higher than any other stunned goal.






// Decompiled with UE Explorer.
defaultproperties
{
    bShouldRunFromStunningDevice=false
    Priority=97
    goalName="Tased"
}