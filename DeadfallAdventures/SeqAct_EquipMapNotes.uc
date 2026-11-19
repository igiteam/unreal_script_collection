class SeqAct_EquipMapNotes extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var() bool EquipMapInsteadOfNotes;

event Activated()
{
    local SeqVar_Object ObjVar;
    local EvilPawn P;
    local EvilPlayerController PC;

    // End:0x12B
    foreach LinkedVariables(Class'Engine.SeqVar_Object', ObjVar, "Players")
    {
        P = EvilPawn(ObjVar.GetObjectValue());
        // End:0x12A
        if(P != none)
        {
            PC = EvilPlayerController(P.Controller);
            // End:0x12A
            if(PC != none)
            {
                // End:0xE2
                if(EquipMapInsteadOfNotes)
                {
                    P.SetBlockingInventoryClass(Class'AdvInventoryItem_Map', true);                    
                }
                else
                {
                    P.SetBlockingInventoryClass(Class'AdvInventoryItem_Notepad', true);
                }
                PC.ShowGameplayObject();
            }
        }        
    }    
    //return;    
}

defaultproperties
{
    EquipMapInsteadOfNotes=true
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Players",LinkVar="None",PropertyName="Players",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="Equip Map Notes"
}