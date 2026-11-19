class SeqAct_SaveEquipment extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

event Activated()
{
    local SeqVar_Object ObjVar;
    local EvilPawn P;
    local AdvInventoryManager AdvInv;
    local AdvPlayerController PC;
    local array<string> inventoryItems;
    local array<int> InventoryAmmo;

    // End:0x1E0
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
        // End:0x1DF
        if(P != none)
        {
            PC = AdvPlayerController(P.Controller);
            AdvInv = AdvInventoryManager(P.InvManager);
            // End:0x15E
            if(AdvInv == none)
            {                
                return;
            }
            PC.GetPawnInventoryElements(inventoryItems);
            PC.GetPawnInventoryElementsAmmo(InventoryAmmo);
            AdvInv.SaveInventoryElements(inventoryItems, InventoryAmmo);
        }        
    }    
    OutputLinks[0].bHasImpulse = true;
    //return;    
}

defaultproperties
{
    bAutoActivateOutputLinks=false
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Players",LinkVar="None",PropertyName="Players",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="Save Equipment"
}