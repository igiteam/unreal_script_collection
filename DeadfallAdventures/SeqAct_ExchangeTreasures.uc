class SeqAct_ExchangeTreasures extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

event Activated()
{
    local SeqVar_Object ObjVar;
    local AdvPlayerPawnMP PPawn;

    // End:0x151
    foreach LinkedVariables(Class'Engine.SeqVar_Object', ObjVar, "Player")
    {
        // End:0x87
        if(AdvPlayerPawnMP(ObjVar.GetObjectValue()) != none)
        {
            PPawn = AdvPlayerPawnMP(ObjVar.GetObjectValue());
        }
        // End:0x150
        if((PPawn.PlayerReplicationInfo != none) && AdvPRI(PPawn.PlayerReplicationInfo) != none)
        {
            // End:0x150
            if(AdvPRI(PPawn.PlayerReplicationInfo).BlessingManager.ExchangeTreasures())
            {
                OutputLinks[0].bHasImpulse = true;
            }
        }        
    }    
    //return;    
}

defaultproperties
{
    bAutoActivateOutputLinks=false
    OutputLinks[0]=(Links=none,LinkDesc="Exchange succeeded",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0,PIEActivationTime=0.0000000,bIsActivated=false)
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Player",LinkVar="None",PropertyName="Player",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="Exchange Multiplayer Treasures"
}