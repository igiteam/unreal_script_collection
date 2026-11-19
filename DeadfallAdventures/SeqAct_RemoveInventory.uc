class SeqAct_RemoveInventory extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var() array< class<EvilWeap_Base> > WeapClasses;

event Activated()
{
    local SeqVar_Object ObjVar;
    local EvilPawn P;
    local EvilWeap_Base Weap, WeapLeft;
    local int Idx;

    // End:0x647
    if(InputLinks[0].bHasImpulse)
    {
        // End:0x63B
        foreach LinkedVariables(Class'Engine.SeqVar_Object', ObjVar, "Players")
        {
            // End:0xCB
            if(EvilPlayerController(ObjVar.GetObjectValue()) != none)
            {
                P = EvilPawn(EvilPlayerController(ObjVar.GetObjectValue()).Pawn);                
            }
            else
            {
                P = EvilPawn(ObjVar.GetObjectValue());
            }
            // End:0x63A
            if(P != none)
            {
                Idx = 0;
                J0x117:

                // End:0x63A [Loop If]
                if(Idx < WeapClasses.Length)
                {
                    Weap = EvilWeap_Base(P.FindInventoryType(WeapClasses[Idx]));
                    // End:0x62C
                    if(Weap != none)
                    {
                        // End:0x1EB
                        if(P.ThrowWeapon == Weap)
                        {
                            P.ThrowWeapon = none;
                            Weap.Destroy();                            
                        }
                        else
                        {
                            // End:0x353
                            if(Weap.OffHandDoesNotFire)
                            {
                                P.SetBlockingInventoryClass(none, true);
                                // End:0x2F5
                                if(P.WeaponLeft == Weap)
                                {
                                    P.SetCurrentWeaponLeftClass(P.SavedWeaponLeft, true);
                                    EvilInventoryManager(P.InvManager).ChangedWeaponLeft();
                                    P.SavedWeaponLeft = none;
                                }
                                Weap.Destroy();
                                // End:0x350
                                if(P.Weapon == none)
                                {
                                    P.EquipHandsWeapon();
                                }                                
                            }
                            else
                            {
                                // End:0x3C8
                                if(!Weap.BothHandWeapon)
                                {
                                    WeapLeft = EvilWeap_Base(P.FindInventoryType(Weap.default.OffHandWeaponClass));
                                }
                                // End:0x5ED
                                if(Weap == P.Weapon)
                                {
                                    P.SetSprint(false);
                                    P.Weapon = none;
                                    // End:0x491
                                    if((WeapLeft != none) && P.WeaponLeft == WeapLeft)
                                    {
                                        P.WeaponLeft = none;
                                    }
                                    // End:0x4D4
                                    if(Weap.BothHandWeapon)
                                    {
                                        P.SetBlockingInventoryClass(none, true);
                                    }
                                    Weap.Destroy();
                                    // End:0x513
                                    if(WeapLeft != none)
                                    {
                                        WeapLeft.Destroy();
                                    }
                                    // End:0x559
                                    if(P.Weapon == none)
                                    {
                                        P.EquipHandsWeapon();                                        
                                    }
                                    else
                                    {
                                        Weap = EvilWeap_Base(EvilInventoryManager(P.InvManager).GetBestWeapon(false, false, true));
                                        P.SetCurrentWeaponClass(Weap.Class);
                                    }                                    
                                }
                                else
                                {
                                    Weap.Destroy();
                                    // End:0x62C
                                    if(WeapLeft != none)
                                    {
                                        WeapLeft.Destroy();
                                    }
                                }
                            }
                        }
                    }
                    Idx++;
                    // [Loop Continue]
                    goto J0x117;
                }
            }            
        }        
        ActivateOutputLink(0);
    }
    //return;    
}

defaultproperties
{
    bAutoActivateOutputLinks=false
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Players",LinkVar="None",PropertyName="Players",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="Remove Inventory"
}