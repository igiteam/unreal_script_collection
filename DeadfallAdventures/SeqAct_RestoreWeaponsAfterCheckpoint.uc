class SeqAct_RestoreWeaponsAfterCheckpoint extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var() bool bForceWeaponList;
var bool bWeaponRestored;
var() array< class<EvilWeap_Base> > ForceWeaponList;

event Activated()
{
    local SeqVar_Object ObjVar;
    local EvilPawn P;
    local EvilWeap_Base Weapon, WeaponLeft;
    local class<EvilWeap_Base> WeaponClass;
    local int Idx;
    local array<string> weaponsToRestore;
    local array<int> ammoToRestore;
    local AdvEngine Engine;
    local bool bForceWeaponListFromUrl;

    // End:0x9CF
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
        Engine = AdvEngine(Class'AdvEngine'.static.GetEngine());
        bForceWeaponListFromUrl = ADVGame(Class'Engine.WorldInfo'.static.GetWorldInfo().Game).bRestoreDefaultWeapons;
        // End:0x9CE
        if(P != none)
        {
            // End:0x247
            foreach P.InvManager.InventoryActors(Class'EvilGame.EvilWeap_Base', Weapon)
            {
                // End:0x209
                if(ClassIsChildOf(Weapon.Class, P.HandsClass))
                {
                    continue;                    
                }
                P.InvManager.RemoveFromInventory(Weapon);                
            }            
            // End:0x285
            if(bForceWeaponList || bForceWeaponListFromUrl)
            {
                bWeaponRestored = RestoreFromDefaultList(P);                
            }
            else
            {
                // End:0x8E7
                if((Engine != none) && Engine.CurrentCheckpoint != none)
                {
                    P.SetSprint(false);
                    weaponsToRestore = Engine.CurrentCheckpoint.HeaderData.Inventory;
                    ammoToRestore = Engine.CurrentCheckpoint.HeaderData.InventoryAmmo;
                    // End:0x3BD
                    if(weaponsToRestore.Length < 2)
                    {
                        WeaponClass = class<EvilWeap_Base>(DynamicLoadObject(weaponsToRestore[0], Class'Core.Class'));
                    }
                    // End:0x413
                    if((WeaponClass != none) && !WeaponClass.default.bSelectable)
                    {
                        bWeaponRestored = RestoreFromDefaultList(P);                        
                    }
                    else
                    {
                        Idx = 0;
                        J0x41E:

                        // End:0x8C9 [Loop If]
                        if(Idx < weaponsToRestore.Length)
                        {
                            WeaponClass = class<EvilWeap_Base>(DynamicLoadObject(weaponsToRestore[Idx], Class'Core.Class'));
                            Weapon = EvilWeap_Base(P.CreateInventory(WeaponClass, true));
                            // End:0x547
                            if(!Weapon.BothHandWeapon && Weapon.OffHandWeaponClass != none)
                            {
                                WeaponLeft = EvilWeap_Base(P.FindInventoryType(Weapon.OffHandWeaponClass, true));
                            }
                            // End:0x79F
                            if(WeaponLeft != none)
                            {
                                Weapon.Unloaded();
                                WeaponLeft.Unloaded();
                                Weapon.MagazineAmmoCount = ((ammoToRestore[Idx] > (Weapon.MagazineMaxAmmoCount * 2)) ? Weapon.MagazineMaxAmmoCount : ammoToRestore[Idx] / 2);
                                WeaponLeft.MagazineAmmoCount = ((ammoToRestore[Idx] > (Weapon.MagazineMaxAmmoCount * 2)) ? WeaponLeft.MagazineMaxAmmoCount : ammoToRestore[Idx] / 2);
                                EvilInventoryManager(P.InvManager).AddAmmoToWeapon(0, ammoToRestore[Idx] / 2, Weapon.Class);
                                EvilInventoryManager(P.InvManager).AddAmmoToWeapon(0, ammoToRestore[Idx] / 2, WeaponLeft.Class);                                
                            }
                            else
                            {
                                Weapon.Unloaded();
                                Weapon.MagazineAmmoCount = ((ammoToRestore[Idx] > Weapon.MagazineMaxAmmoCount) ? Weapon.MagazineMaxAmmoCount : ammoToRestore[Idx]);
                                EvilInventoryManager(P.InvManager).AddAmmoToWeapon(0, ammoToRestore[Idx], WeaponClass);
                            }
                            // End:0x8BB
                            if(WeaponLeft != none)
                            {
                                WeaponLeft = none;
                            }
                            ++Idx;
                            // [Loop Continue]
                            goto J0x41E;
                        }
                        bWeaponRestored = ((Weapon != none) ? true : false);
                    }
                }
            }
            // End:0x909
            if(!bWeaponRestored)
            {
                RestoreFromDefaultList(P);
            }
            Weapon = EvilWeap_Base(EvilInventoryManager(P.InvManager).GetBestWeapon(false, false, true));
            // End:0x9AC
            if(Weapon != none)
            {
                P.SetCurrentWeaponClass(Weapon.Class);                
            }
            else
            {
                P.EquipHandsWeapon();
            }
            // End:0x9CE
            continue;
        }        
    }    
    OutputLinks[0].bHasImpulse = true;
    //return;    
}

function bool RestoreFromDefaultList(EvilPawn P)
{
    local int Idx;
    local class<EvilWeap_Base> WeaponClass;
    local AdvPlayerController PC;

    PC = AdvPlayerController(P.Controller);
    // End:0x1AB
    if(ForceWeaponList.Length > 0)
    {
        Idx = 0;
        J0x4C:

        // End:0x1AB [Loop If]
        if(Idx < ForceWeaponList.Length)
        {
            WeaponClass = ForceWeaponList[Idx];
            // End:0x19D
            if(WeaponClass != none)
            {
                // End:0x145
                if(PC.HasPreorder() && PC.GetPreorderWeaponSelectedFromProfile())
                {
                    // End:0x136
                    if(ClassIsChildOf(WeaponClass, Class'AdvWeap_Webley_Base'))
                    {
                        WeaponClass = class<EvilWeap_Base>(FindObject("AdvGameContent.AdvWeap_Remington", Class'Core.Class'));
                    }
                    // End:0x145
                    if(WeaponClass == none)
                    {
                    }
                }
                // End:0x19D
                if(P.FindInventoryType(WeaponClass) == none)
                {
                    P.CreateInventory(WeaponClass);
                }
            }
            Idx++;
            // [Loop Continue]
            goto J0x4C;
        }
    }
    return true;
    //return ReturnValue;    
}

defaultproperties
{
    bAutoActivateOutputLinks=false
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Players",LinkVar="None",PropertyName="Players",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="Restore Weapons After Checkpoint"
}