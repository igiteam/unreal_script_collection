class SeqAct_ChangeMapNote extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var() AdvMapNotes.EMapNote MapNoteID;
var() bool bShowGameplayIndicator;

event Activated()
{
    local AdvInventoryItem_Notepad Notepad;
    local SeqVar_Object ObjVar;
    local EvilPawn P;

    // End:0x16A
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
        // End:0x169
        if(P != none)
        {
            Notepad = AdvInventoryItem_Notepad(P.FindInventoryType(Class'AdvInventoryItem_Notepad'));
            // End:0x169
            if(Notepad != none)
            {
                Notepad.SetCurrentMapNote(MapNoteID, !bShowGameplayIndicator);
            }
        }        
    }    
    //return;    
}

defaultproperties
{
    bShowGameplayIndicator=true
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Players",LinkVar="None",PropertyName="Players",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="Change Note"
}