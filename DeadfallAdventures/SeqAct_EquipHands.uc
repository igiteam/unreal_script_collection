class SeqAct_EquipHands extends SeqAct_Latent
    forcescriptorder(true)
    hidecategories(Object);

var AdvPawn PawnInstigator;
var bool bEquipCompleted;
var class<EvilWeap_Base> HandsClass;
var() AdvTypes.EHandsType HandsType;

event Activated()
{
    local SeqVar_Object ObjVar;

    bAborted = false;
    bEquipCompleted = false;
    // End:0x412
    foreach LinkedVariables(Class'Engine.SeqVar_Object', ObjVar, "Instigator")
    {
        PawnInstigator = AdvPawn(ObjVar.GetObjectValue());
        // End:0x3F9
        if((PawnInstigator != none) && NotEqual_InterfaceInterface(EvilPlayer_interface(PawnInstigator), EvilPlayer_interface(none)))
        {
            HandsClass = PawnInstigator.GetHandsClassFor(HandsType);
            // End:0x10B
            if(HandsClass == none)
            {
                bEquipCompleted = true;
                bAborted = true;                
                return;
            }
            // End:0x230
            if((PawnInstigator.Weapon != none) && PawnInstigator.Weapon.Class == HandsClass)
            {
                PawnInstigator.SavedWeaponLeft = ((PawnInstigator.WeaponLeft != none) ? class<EvilWeap_Base>(PawnInstigator.WeaponLeft.Class) : none);
                PawnInstigator.SetCurrentWeaponLeftClass(none, true);
                bAborted = false;
                bEquipCompleted = true;                
                return;
            }
            PawnInstigator.EquipHandsAction = self;
            PawnInstigator.SavedWeaponLeft = ((PawnInstigator.WeaponLeft != none) ? class<EvilWeap_Base>(PawnInstigator.WeaponLeft.Class) : none);
            PawnInstigator.SavedWeapon = ((PawnInstigator.Weapon != none) ? class<EvilWeap_Base>(PawnInstigator.Weapon.Class) : none);
            // End:0x3AC
            if(PawnInstigator.FindInventoryType(HandsClass) == none)
            {
                PawnInstigator.CreateInventory(HandsClass, true);
            }
            PawnInstigator.SetCurrentWeaponClass(HandsClass, true);
            PawnInstigator.SetCurrentWeaponLeftClass(none, true);
            // End:0x411
            continue;
        }
        bEquipCompleted = true;
        bAborted = true;        
    }    
    //return;    
}

function NotifyChangedWeapon(Weapon PrevWeapon, Weapon NewWeapon)
{
    // End:0x49
    if((NewWeapon != none) && NewWeapon.Class == HandsClass)
    {
        bEquipCompleted = true;
    }
    //return;    
}

event bool Update(float DeltaTime)
{
    // End:0x39
    if(bEquipCompleted)
    {
        bAborted = false;
        PawnInstigator.EquipHandsAction = none;
    }
    return !bEquipCompleted;
    //return ReturnValue;    
}

defaultproperties
{
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Instigator",LinkVar="None",PropertyName="Instigator",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="Equip Hands"
}