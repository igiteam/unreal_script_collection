class SeqAct_RestoreWeapons extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var EvilPawn PawnInstigator;

event Activated()
{
    local SeqVar_Object ObjVar;
    local AdvWeap_Base WeaponLeft;

    // End:0x301
    foreach LinkedVariables(Class'Engine.SeqVar_Object', ObjVar, "Instigator")
    {
        PawnInstigator = EvilPawn(ObjVar.GetObjectValue());
        // End:0x300
        if(PawnInstigator != none)
        {
            WeaponLeft = AdvWeap_Base(PawnInstigator.FindInventoryType(PawnInstigator.SavedWeaponLeft));
            // End:0x1D7
            if((WeaponLeft != none) && AdvPlayerController(PawnInstigator.Controller).isInventory(WeaponLeft))
            {
                PawnInstigator.SetBlockingInventoryClass(PawnInstigator.SavedWeaponLeft, true);
                // End:0x1D7
                if(PawnInstigator.SavedWeapon == none)
                {
                    PawnInstigator.SetCurrentWeaponLeftClass(PawnInstigator.SavedWeaponLeft, false);
                    PawnInstigator.SavedWeaponLeft = none;
                }
            }
            // End:0x25C
            if(PawnInstigator.SavedWeapon != none)
            {
                PawnInstigator.SetCurrentWeaponClass(PawnInstigator.SavedWeapon, false);
                PawnInstigator.SavedWeapon = none;                
            }
            else
            {
                // End:0x2C0
                if(PawnInstigator.HandsClass != none)
                {
                    PawnInstigator.SavedWeapon = PawnInstigator.HandsClass;                    
                }
            }
            PawnInstigator.SavedWeaponLeft = none;
            PawnInstigator.SavedWeapon = none;
        }        
    }    
    //return;    
}

defaultproperties
{
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Instigator",LinkVar="None",PropertyName="Instigator",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="Restore Weapons"
}