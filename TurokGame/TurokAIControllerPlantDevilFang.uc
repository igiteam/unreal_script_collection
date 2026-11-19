class TurokAIControllerPlantDevilFang extends TurokAIController
    hidecategories(Navigation);

event bool SeeFlare()
{
    Disable('SeeFlare');
    return true;
    //return ReturnValue;    
}

event SeeFlareExploded(@NULL HitActor)
{
    Disable('SeeFlareExploded');
    //return;    
}

event HitByFlare(@NULL Flare)
{
    Disable('HitByFlare');
    //return;    
}

state GoalDormant
{
    function BeginState(name PreviousStateName)
    {
        //return;        
    }

    function EndState(name NextStateName)
    {
        //return;        
    }
Begin:

    stop;                
}

defaultproperties
{
    // Reference: SpriteComponent'Default__TurokAIControllerPlantDevilFang.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
}