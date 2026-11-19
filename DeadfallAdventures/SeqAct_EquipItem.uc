class SeqAct_EquipItem extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var() class<AdvInventoryItem_Base> ItemClass;
var Inventory OldInventory;

event Activated()
{
    local SeqVar_Object ObjVar;
    local EvilPawn P;
    local AdvTypes.EInventoryItem Selection;

    // End:0x49C
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
        // End:0x49B
        if(P != none)
        {
            // End:0x49B
            if(ItemClass != AdvInventoryManager(AdvPlayerPawn(P).InvManager).BlockingClassLeft)
            {
                // End:0x3E1
                if((AdvInventoryManager(AdvPlayerPawn(P).InvManager).PendingWeapon != none) && AdvPlayerPawn(P).Weapon != AdvInventoryManager(AdvPlayerPawn(P).InvManager).PendingWeapon)
                {
                    // End:0x2E6
                    if(AdvWeap_Base(AdvInventoryManager(AdvPlayerPawn(P).InvManager).PendingWeapon).BothHandWeapon && ItemClass == Class'AdvInventoryItem_Torch')
                    {
                        P.SetBlockingInventoryClass(ItemClass, true);
                        AdvPlayerPawn(P).MyTorch.bPendingFlashlightOn = true;                        
                    }
                    else
                    {
                        // End:0x38C
                        if(P.SavedWeaponLeft == none)
                        {
                            P.SavedWeaponLeft = ((P.WeaponLeft != none) ? class<EvilWeap_Base>(P.WeaponLeft.Class) : none);
                        }
                        P.SetBlockingInventoryClass(ItemClass, true);
                        P.SetCurrentWeaponLeftClass(ItemClass, true);
                    }                    
                }
                else
                {
                    switch(ItemClass)
                    {
                        // End:0x40F
                        case Class'AdvInventoryItem_Compass':
                            Selection = 6;
                            // End:0x448
                            break;
                        // End:0x42A
                        case Class'AdvInventoryItem_Notepad':
                            Selection = 2;
                            // End:0x448
                            break;
                        // End:0x445
                        case Class'AdvInventoryItem_Torch':
                            Selection = 1;
                            // End:0x448
                            break;
                        // End:0xFFFF
                        default:
                            break;
                    }
                    Class'AdvGFxUI_InventoryMenu'.static.SelectInventory(Selection, AdvPlayerPawn(P).GetPlayerController());
                }
                // End:0x49B
                continue;
            }
        }        
    }    
    OutputLinks[0].bHasImpulse = true;
    //return;    
}

defaultproperties
{
    bAutoActivateOutputLinks=false
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Players",LinkVar="None",PropertyName="Players",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    VariableLinks[1]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="OldInventory",LinkVar="None",PropertyName="OldInventory",bWriteable=true,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="Equip Item"
}