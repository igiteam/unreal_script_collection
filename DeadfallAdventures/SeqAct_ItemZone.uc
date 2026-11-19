class SeqAct_ItemZone extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var() class<AdvInventoryItem_Base> ItemClass;

event Activated()
{
    local SeqVar_Object ObjVar;
    local EvilPawn P;

    // End:0x2BC
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
        // End:0xEE
        if(P == none)
        {
            continue;            
        }
        // End:0x165
        if(InputLinks[0].bHasImpulse)
        {
            P.SetBlockingInventoryClass(ItemClass, true);
            P.SetCurrentWeaponLeftClass(ItemClass, true);
            // End:0x2BB
            continue;
        }
        P.SetBlockingInventoryClass(none, true);
        // End:0x29A
        if(((EvilWeap_Base(P.Weapon) != none) && !EvilWeap_Base(P.Weapon).BothHandWeapon) && EvilWeap_Base(P.Weapon).OffHandWeaponClass != none)
        {
            P.SetCurrentWeaponLeftClass(EvilWeap_Base(P.Weapon).OffHandWeaponClass);
            // End:0x2BB
            continue;
        }
        P.SetCurrentWeaponLeftClass(none, true);        
    }    
    OutputLinks[0].bHasImpulse = true;
    //return;    
}

defaultproperties
{
    bAutoActivateOutputLinks=false
    InputLinks[0]=(LinkDesc="Enable",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    InputLinks[1]=(LinkDesc="Disable",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Players",LinkVar="None",PropertyName="Players",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="Equip Item Zone"
}