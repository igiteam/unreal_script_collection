class SeqAct_EquipWeapon extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var() bool GiveIfDoesntHave;
var() bool InLeftHand;
var() bool ForceEquip;
var() class<EvilWeap_Base> WeaponClass;

event Activated()
{
    local SeqVar_Object ObjVar, WeapVar;
    local EvilWeap_Base Weap;
    local EvilPawn P;

    // End:0x330
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
        // End:0x32F
        if(P != none)
        {
            // End:0x23C
            foreach LinkedVariables(Class'Engine.SeqVar_Object', WeapVar, "Weapon")
            {
                Weap = EvilWeap_Base(WeapVar.GetObjectValue());
                // End:0x23B
                if(Weap != none)
                {
                    // End:0x1CF
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
            // End:0x2A4
            if(GiveIfDoesntHave && P.FindInventoryType(WeaponClass) == none)
            {
                P.CreateInventory(WeaponClass, true);
            }
            // End:0x2E8
            if(!InLeftHand)
            {
                P.SetCurrentWeaponClass(WeaponClass, ForceEquip);
                // End:0x32F
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
    bAutoActivateOutputLinks=false
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Players",LinkVar="None",PropertyName="Players",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    VariableLinks[1]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Weapon",LinkVar="None",PropertyName="Weapon",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="Equip Weapon"
}