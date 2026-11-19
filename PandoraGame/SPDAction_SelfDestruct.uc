class SPDAction_SelfDestruct extends SPDAction
    editinlinenew
    collapsecategories;

event SPDProcessManager.SPDActionState Run(float ElapsedTime, Actor Actor, SPDProcessManager Manager, SPDDamage DamageInfo)
{
    local Pawn Pawn;

    // End:0xCD
    if(DamageInfo.Component == none)
    {
        Pawn = Pawn(Actor);
        // End:0xAB
        if(Pawn != none)
        {
            // End:0xAB
            if(Pawn.GetStateName() != 'Dying')
            {
                // End:0xAB
                if(Pawn.Died(DamageInfo.instigatedBy, DamageInfo.DamageType, DamageInfo.Location) == false)
                {
                    SPPawn(Pawn).NotifyFactoryOfDeath();
                }
            }
        }
        Actor.Destroy();
        Actor.bForceNetUpdate = true;        
    }
    else
    {
        DamageInfo.Component.SetHidden(true);
        Actor.DetachComponent(DamageInfo.Component);
    }
    return 1;
    //return ReturnValue;    
}

defaultproperties
{
    Action="Self Destruct - Removes the destructible from the world."
}