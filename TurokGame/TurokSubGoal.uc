class TurokSubGoal extends Actor
    native
    placeable
    hidecategories(Navigation);

var(Objective) const @NULL mOwnerGoal;
var(Objective) const int mInitialTeamOwner;

function OnCapture(@NULL Action)
{
    local array objInstigators;
    local @NULL firstInstigator;

    // End:0x0D
    if(mOwnerGoal == none)
    {
        return;
    }
    // End:0x99
    if(Action.InputLinks[0].bHasImpulse)
    {
        Action.GetObjectVars(objInstigators, "Instigator");
        // End:0x69
        if(objInstigators.Length > 0)
        {
            firstInstigator = Actor(objInstigators[0]);
        }
        // End:0x97
        if(mOwnerGoal.SubGoalEvaluateCapture(self, firstInstigator))
        {
            TriggerEventClass(Class'TurokSeqEvent_GoalGained', firstInstigator);
        }
        return;
    }
    // End:0x125
    if(Action.InputLinks[1].bHasImpulse)
    {
        Action.GetObjectVars(objInstigators, "Instigator");
        // End:0xF5
        if(objInstigators.Length > 0)
        {
            firstInstigator = Actor(objInstigators[0]);
        }
        // End:0x123
        if(mOwnerGoal.SubGoalEvaluateRelease(self, firstInstigator))
        {
            TriggerEventClass(Class'TurokSeqEvent_GoalLost', firstInstigator);
        }
        return;
    }
    //return;    
}

defaultproperties
{
    mInitialTeamOwner=255
    bStatic=true
    bHidden=true
    bIgnoreEncroachers=true
    bMovable=false
    // Reference: SpriteComponent'Default__TurokSubGoal.Sprite'
    begin object name=Sprite class=Class'Engine.SpriteComponent'
        Sprite=Texture2D'TurokEditorResources.TurokGoal'
        HiddenGame=true
        AlwaysLoadOnClient=false
        AlwaysLoadOnServer=false
    end object
    Components[0]=Sprite
    SupportedEvents=/* Array type was not detected. */
}