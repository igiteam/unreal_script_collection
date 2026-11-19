class SeqAct_HideMapNotes extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var() bool HideMapInsteadOfNotes;

event Activated()
{
    local SeqVar_Object ObjVar;
    local EvilPawn P;
    local EvilPlayerController PC;

    // End:0x1DE
    foreach LinkedVariables(Class'Engine.SeqVar_Object', ObjVar, "Players")
    {
        P = EvilPawn(ObjVar.GetObjectValue());
        // End:0x1DD
        if(P != none)
        {
            PC = EvilPlayerController(P.Controller);
            // End:0x1DD
            if(PC != none)
            {
                // End:0x1DD
                if((P.EvilInvManager != none) && (!HideMapInsteadOfNotes && ClassIsChildOf(P.EvilInvManager.BlockingClassLeft, Class'AdvInventoryItem_Notepad')) || HideMapInsteadOfNotes && ClassIsChildOf(P.EvilInvManager.BlockingClassLeft, Class'AdvInventoryItem_Map'))
                {
                    // End:0x1B9
                    if(PC.CanHideGameplayObject())
                    {
                        PC.HideGameplayObject();
                        // End:0x1DD
                        continue;
                    }
                    PC.RetryHideGameplayObject(2.0000000);
                }
            }
        }        
    }    
    //return;    
}

defaultproperties
{
    HideMapInsteadOfNotes=true
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Players",LinkVar="None",PropertyName="Players",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="Hide Map Notes"
}