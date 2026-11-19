class SeqAct_ShowBankVaultMessage extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

event Activated()
{
    local SeqVar_Object ObjVar;
    local AdvPlayerPawnMP PPawn;

    // End:0x13F
    foreach LinkedVariables(Class'Engine.SeqVar_Object', ObjVar, "Player")
    {
        // End:0x87
        if(AdvPlayerPawnMP(ObjVar.GetObjectValue()) != none)
        {
            PPawn = AdvPlayerPawnMP(ObjVar.GetObjectValue());
        }
        // End:0x13E
        if((PPawn.Controller != none) && AdvPlayerControllerMP(PPawn.Controller) != none)
        {
            AdvPlayerControllerMP(PPawn.Controller).SetBlessingMessage("Press 'e' to exchange your treasures");
        }        
    }    
    OutputLinks[0].bHasImpulse = true;
    //return;    
}

defaultproperties
{
    bAutoActivateOutputLinks=false
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Player",LinkVar="None",PropertyName="Player",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="Show Bank Vault Message"
}