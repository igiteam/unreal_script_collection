class SeqAct_EquipWeapon extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var() bool GiveIfDoesntHave;
var() bool InLeftHand;
var() bool ForceEquip;
var() bool StopSprint;
var() class<EvilWeap_Base> WeaponClass;

event Activated()
{
    local SeqVar_Object ObjVar, WeapVar;
    local EvilWeap_Base Weap, currentWeap;
    local array<EvilWeap_Base> WeapList;
    local EvilInventoryManager Inv;
    local EvilPawn P;
    local EvilPlayerController PC;

    // End:0x654
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
        // End:0x653
        if(P != none)
        {
            P.SetSprint(!StopSprint);
            // End:0x267
            foreach LinkedVariables(Class'Engine.SeqVar_Object', WeapVar, "Weapon")
            {
                Weap = EvilWeap_Base(WeapVar.GetObjectValue());
                // End:0x266
                if(Weap != none)
                {
                    // End:0x1FA
                    if(!InLeftHand || Weap.BothHandWeapon)
                    {
                        P.SetCurrentWeaponClass(Weap.Class, ForceEquip);                        
                    }
                    else
                    {
                        P.SetCurrentWeaponLeftClass(Weap.OffHandWeaponClass, ForceEquip);
                    }
                    OutputLinks[0].bHasImpulse = true;
                    break;                    
                    return;
                }                
            }            
            PC = EvilPlayerController(P.Controller);
            // End:0x35F
            if(((WeaponClass != none) && PC.HasPreorder()) && PC.GetPreorderWeaponSelectedFromProfile())
            {
                // End:0x350
                if(ClassIsChildOf(WeaponClass, Class'AdvWeap_Webley_Base'))
                {
                    WeaponClass = class<EvilWeap_Base>(FindObject("AdvGameContent.AdvWeap_Remington", Class'Core.Class'));
                }
                // End:0x35F
                if(WeaponClass == none)
                {
                }
            }
            // End:0x3C6
            if(GiveIfDoesntHave && P.FindInventoryType(WeaponClass) == none)
            {
                P.CreateInventory(WeaponClass, true);
            }
            // End:0x60C
            if(!InLeftHand)
            {
                // End:0x5D7
                if(WeaponClass.default.DefaultInfiniteWeapon)
                {
                    Inv = EvilInventoryManager(P.InvManager);
                    Inv.GetWeaponList(WeapList, true, int(WeaponClass.default.InventoryGroup));
                    // End:0x4FF
                    if(WeapList.Length > 2)
                    {
                        // End:0x4FB
                        foreach WeapList(currentWeap)
                        {
                            // End:0x4C3
                            if(currentWeap.DefaultInfiniteWeapon)
                            {
                                continue;
                                goto J0x4FB;                                
                            }
                            else
                            {
                                // End:0x4FA
                                if(!currentWeap.UsesOffhand)
                                {
                                    Weap = currentWeap;
                                }
                            }                            
                        }
                        J0x4FB:
                                                
                    }
                    else
                    {
                        Weap = Inv.HasWeaponWithInventoryGroup(int(WeaponClass.default.InventoryGroup));
                    }
                    // End:0x5D7
                    if(!Weap.DefaultInfiniteWeapon)
                    {
                        P.bIgnoreSwitchWeapon = true;
                        P.TossInventory(Weap);
                        P.bIgnoreSwitchWeapon = false;
                    }
                }
                P.SetCurrentWeaponClass(WeaponClass, ForceEquip);
                // End:0x653
                continue;
            }
            P.SetCurrentWeaponLeftClass(WeaponClass.default.OffHandWeaponClass, ForceEquip);
        }        
    }    
    OutputLinks[0].bHasImpulse = true;
    //return;    
}

defaultproperties
{
    GiveIfDoesntHave=true
    StopSprint=true
    bAutoActivateOutputLinks=false
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Players",LinkVar="None",PropertyName="Players",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    VariableLinks[1]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Weapon",LinkVar="None",PropertyName="Weapon",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="Equip Weapon"
}