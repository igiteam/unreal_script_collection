class AdvAI_GermanBrowningSoldier extends AdvAIController_Cover
    config(AI)
    hidecategories(Navigation);

function BeginFireFromOpenWrapper(Actor EventInstigator, EvilAIReactChannel OrigChannel)
{
    FireFromOpen();
    //return;    
}

simulated function OnStartFire()
{
    //return;    
}

function float GetEnemyReachableStrafeModifier(bool bReachable)
{
    // End:0x25
    if(bReachable)
    {
        return super(EvilAIController).GetEnemyReachableStrafeModifier(bReachable);        
    }
    else
    {
        return 0.4000000;
    }
    //return ReturnValue;    
}

defaultproperties
{
    DefaultCommand=Class'AdvAICmd_Base_Shotgun'
    StrafesData=/* Array type was not detected. */
    EnemyDistance_Shoot=1000.0000000
    // Reference: EvilAIReactManager'Default__AdvAI_GermanBrowningSoldier.ReactionManager0'
    begin object name=ReactionManager0
    end object
    ReactionManager=ReactionManager0
    DefaultReactConditions=/* Array type was not detected. */
}