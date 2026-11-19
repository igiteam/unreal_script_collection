class SeqAct_ShowUpgradesMenu extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

event Activated()
{
    local SeqVar_Object ObjVar;
    local EvilPawn P;

    // End:0x146
    foreach LinkedVariables(Class'Engine.SeqVar_Object', ObjVar, "Players")
    {
        // End:0xA9
        if(EvilPlayerController(ObjVar.GetObjectValue()) != none)
        {
            P = EvilPawn(EvilPlayerController(ObjVar.GetObjectValue()).Pawn);            
        }
        else
        {
            P = EvilPawn(ObjVar.GetObjectValue());
        }
        // End:0x145
        if(P != none)
        {
            AdvGFxHudWrapper(EvilPlayerController(P.Controller).myHUD).ShowUpgradesMenu();
        }        
    }    
    //return;    
}

defaultproperties
{
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Players",LinkVar="None",PropertyName="Players",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="Show Upgrades Menu"
}