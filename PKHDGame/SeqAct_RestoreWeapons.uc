class SeqAct_RestoreWeapons extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var EvilPawn PawnInstigator;

event Activated()
{
    local SeqVar_Object ObjVar;

    // End:0x173
    foreach LinkedVariables(Class'Engine.SeqVar_Object', ObjVar, "Instigator")
    {
        PawnInstigator = EvilPawn(ObjVar.GetObjectValue());
        // End:0x172
        if(PawnInstigator != none)
        {
            PawnInstigator.SetCurrentWeaponLeftClass(PawnInstigator.SavedWeaponLeft, true);
            // End:0x132
            if((PawnInstigator.SavedWeapon != none) || PawnInstigator.SavedWeaponLeft != none)
            {
                PawnInstigator.SetCurrentWeaponClass(PawnInstigator.SavedWeapon, true);
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