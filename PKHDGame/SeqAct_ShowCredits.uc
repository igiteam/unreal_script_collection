class SeqAct_ShowCredits extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

event Activated()
{
    local SeqVar_Object ObjVar;
    local PKPlayerController PC;

    // End:0x157
    foreach LinkedVariables(Class'Engine.SeqVar_Object', ObjVar, "Players")
    {
        // End:0x8B
        if(PKPlayerController(ObjVar.GetObjectValue()) != none)
        {
            PC = PKPlayerController(ObjVar.GetObjectValue());            
        }
        else
        {
            PC = PKPlayerController(PKPawn(ObjVar.GetObjectValue()).Controller);
        }
        // End:0x156
        if((PC != none) && PainGFxHudWrapper(PC.myHUD) != none)
        {
            PainGFxHudWrapper(PC.myHUD).ShowCredits();
        }        
    }    
    OutputLinks[0].bHasImpulse = true;
    //return;    
}

defaultproperties
{
    bAutoActivateOutputLinks=false
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Players",LinkVar="None",PropertyName="Players",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="Show credits"
}