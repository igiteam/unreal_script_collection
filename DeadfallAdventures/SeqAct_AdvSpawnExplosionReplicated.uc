class SeqAct_AdvSpawnExplosionReplicated extends SeqAct_SpawnExplosionReplicated
    forcescriptorder(true)
    hidecategories(Object);

var Object Instigator;

event Activated()
{
    local AdvPlayerController AdvPC;
    local EvilExplosionActorReplicated ExplosionActor;

    // End:0x182
    if((Locator != none) && ExplosionTemplate != none)
    {
        ExplosionActor = Locator.Spawn(Class'EvilGame.EvilExplosionActorReplicated', Locator,, Locator.Location, Locator.Rotation);
        // End:0xD1
        if(AdvPlayerController(Instigator) != none)
        {
            AdvPC = AdvPlayerController(Instigator);            
        }
        else
        {
            // End:0x123
            if(AdvPawn(Instigator) != none)
            {
                AdvPC = AdvPlayerController(AdvPawn(Instigator).Controller);
            }
        }
        // End:0x15A
        if(AdvPC != none)
        {
            ExplosionActor.SetInstigatorController(AdvPC);
        }
        ExplosionActor.Explode(ExplosionTemplate);
    }
    //return;    
}

defaultproperties
{
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Locator",LinkVar="None",PropertyName="Locator",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    VariableLinks[1]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Instigator",LinkVar="None",PropertyName="Instigator",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="Adv Spawn Explosion Replicated"
}