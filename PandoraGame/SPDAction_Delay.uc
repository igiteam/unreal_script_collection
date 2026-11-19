class SPDAction_Delay extends SPDAction_Latent
    editinlinenew
    collapsecategories;

/** VARIABLE DECLARATIONS */
var(SPDAction) float DelayInSeconds;
var float Counter;

event PushData(SPDProcessManager Manager)
{
    Manager.PushFloat(Counter);
    //return;    
}

event PopData(SPDProcessManager Manager)
{
    Counter = Manager.PopFloat();
    //return;    
}

event SPDProcessManager.SPDActionState Enter(float ElapsedTime, Actor Actor, SPDProcessManager Manager, SPDDamage DamageInfo)
{
    // End:0x10
    if(DelayInSeconds <= float(0))
    {
        return 1;
    }
    Counter = DelayInSeconds;
    return 0;
    //return ReturnValue;    
}

event SPDProcessManager.SPDActionState Run(float ElapsedTime, Actor Actor, SPDProcessManager Manager, SPDDamage DamageInfo)
{
    Counter -= ElapsedTime;
    // End:0x21
    if(Counter > 0.0000000)
    {
        return 0;        
    }
    else
    {
        return 1;
    }
    //return ReturnValue;    
}

event Exit(Actor Actor, SPDProcessManager Manager, SPDDamage DamageInfo)
{
    //return;    
}

defaultproperties
{
    Action="Action Delay - Stop next action from executing for given time"
}