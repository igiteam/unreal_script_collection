class SeqAct_MultiplayerTrap extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

event Activated()
{
    local SeqVar_Object ObjVar1, ObjVar2;
    local AdvPlayerControllerMP InstigatorPC;
    local AdvTrapDamageVolume DVolume;
    local AdvProjectileSpawner Spawner;
    local AdvGameMP_Base Game;

    Game = AdvGameMP_Base(Class'Engine.WorldInfo'.static.GetWorldInfo().Game);
    // End:0x7F
    if((Game != none) && Game.bTraps == false)
    {
        return;
    }
    // End:0x2CF
    foreach LinkedVariables(Class'Engine.SeqVar_Object', ObjVar1, "Instigator")
    {
        // End:0x10D
        if(AdvPlayerControllerMP(ObjVar1.GetObjectValue()) != none)
        {
            InstigatorPC = AdvPlayerControllerMP(ObjVar1.GetObjectValue());            
        }
        else
        {
            // End:0x18B
            if(AdvPawn(ObjVar1.GetObjectValue()) != none)
            {
                InstigatorPC = AdvPlayerControllerMP(AdvPawn(ObjVar1.GetObjectValue()).Controller);
            }
        }
        // End:0x2CD
        foreach LinkedVariables(Class'Engine.SeqVar_Object', ObjVar2, "Damage volume")
        {
            // End:0x244
            if(AdvTrapDamageVolume(ObjVar2.GetObjectValue()) != none)
            {
                DVolume = AdvTrapDamageVolume(ObjVar2.GetObjectValue());
                DVolume.DamageInstigator = InstigatorPC;
                // End:0x2CC
                continue;
            }
            // End:0x2CC
            if(AdvProjectileSpawner(ObjVar2.GetObjectValue()) != none)
            {
                Spawner = AdvProjectileSpawner(ObjVar2.GetObjectValue());
                Spawner.DamageInstigator = InstigatorPC;
            }            
        }                
    }    
    OutputLinks[0].bHasImpulse = true;
    //return;    
}

defaultproperties
{
    bAutoActivateOutputLinks=false
    InputLinks[0]=(LinkDesc="Activated",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Instigator",LinkVar="None",PropertyName="Player",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    VariableLinks[1]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Damage volume",LinkVar="None",PropertyName="DamageVolume",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="Multiplayer Trap"
}