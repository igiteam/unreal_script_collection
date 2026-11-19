class SPDAction_Latent extends SPDAction
    abstract
    native
    editinlinenew
    collapsecategories;

// Export USPDAction_Latent::execPushDataNative(FFrame&, void* const)
native function PushDataNative(SPDProcessManager Manager);

// Export USPDAction_Latent::execPopDataNative(FFrame&, void* const)
native function PopDataNative(SPDProcessManager Manager);

event PushData(SPDProcessManager Manager)
{
    PushDataNative(Manager);
    //return;    
}

event PopData(SPDProcessManager Manager)
{
    PopDataNative(Manager);
    //return;    
}

event SPDProcessManager.SPDActionState Enter(float ElapsedTime, Actor Actor, SPDProcessManager Manager, SPDDamage DamageInfo)
{
    return 1;
    //return ReturnValue;    
}

event Exit(Actor Actor, SPDProcessManager Manager, SPDDamage DamageInfo)
{
    //return;    
}

event Abort(Actor Actor, SPDProcessManager Manager, SPDDamage DamageInfo)
{
    //return;    
}

event SPDProcessManager.SPDActionState Run(float ElapsedTime, Actor Actor, SPDProcessManager Manager, SPDDamage DamageInfo)
{
    return 1;
    //return ReturnValue;    
}
