class SeqAct_LoadEquipment extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

event Activated()
{
    local SeqVar_Object ObjVar;
    local EvilPawn P;
    local EvilWeap_Base Weapon, WeaponLeft;
    local class<EvilWeap_Base> WeaponClass;
    local int Idx, ammoToRestore;
    local AdvInventoryManager AdvInv;

    // End:0x6E9
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
        // End:0x6E8
        if(P != none)
        {
            AdvInv = AdvInventoryManager(P.InvManager);
            // End:0x12D
            if(AdvInv == none)
            {                
                return;
            }
            P.SetSprint(false);
            // End:0x1AA
            foreach AdvInv.InventoryActors(Class'EvilGame.EvilWeap_Base', Weapon)
            {
                AdvInv.RemoveFromInventory(Weapon);                
            }            
            P.SetBlockingInventoryClass(none, true);
            // End:0x675
            if(AdvInv.InventoryElements.Length > 0)
            {
                Idx = 0;
                J0x1FC:

                // End:0x675 [Loop If]
                if(Idx < AdvInv.InventoryElements.Length)
                {
                    WeaponClass = class<EvilWeap_Base>(DynamicLoadObject(AdvInv.InventoryElements[Idx].Inventory, Class'Core.Class'));
                    Weapon = EvilWeap_Base(P.CreateInventory(WeaponClass, true));
                    // End:0x362
                    if(!Weapon.BothHandWeapon && Weapon.OffHandWeaponClass != none)
                    {
                        WeaponLeft = EvilWeap_Base(P.FindInventoryType(Weapon.OffHandWeaponClass, true));
                    }
                    ammoToRestore = AdvInv.InventoryElements[Idx].AmmoCount;
                    // End:0x587
                    if(WeaponLeft != none)
                    {
                        Weapon.Unloaded();
                        WeaponLeft.Unloaded();
                        Weapon.MagazineAmmoCount = ((ammoToRestore > (Weapon.MagazineMaxAmmoCount * 2)) ? Weapon.MagazineMaxAmmoCount : ammoToRestore / 2);
                        WeaponLeft.MagazineAmmoCount = ((ammoToRestore > (Weapon.MagazineMaxAmmoCount * 2)) ? WeaponLeft.MagazineMaxAmmoCount : ammoToRestore / 2);
                        AdvInv.AddAmmoToWeapon(0, ammoToRestore / 2, Weapon.Class);
                        AdvInv.AddAmmoToWeapon(0, ammoToRestore / 2, WeaponLeft.Class);                        
                    }
                    else
                    {
                        Weapon.Unloaded();
                        Weapon.MagazineAmmoCount = ((ammoToRestore > Weapon.MagazineMaxAmmoCount) ? Weapon.MagazineMaxAmmoCount : ammoToRestore);
                        AdvInv.AddAmmoToWeapon(0, ammoToRestore, WeaponClass);
                    }
                    // End:0x667
                    if(WeaponLeft != none)
                    {
                        WeaponLeft = none;
                    }
                    Idx++;
                    // [Loop Continue]
                    goto J0x1FC;
                }
            }
            Weapon = EvilWeap_Base(AdvInv.GetBestWeapon(false, false, true));
            P.SetCurrentWeaponClass(Weapon.Class);
        }        
    }    
    OutputLinks[0].bHasImpulse = true;
    //return;    
}

defaultproperties
{
    bAutoActivateOutputLinks=false
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Players",LinkVar="None",PropertyName="Players",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="Load Equipment"
}