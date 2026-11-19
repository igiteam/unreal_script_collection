class SeqAct_SetWeaponPlacements extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var() bool bLeftHand;
var EvilPlayer_interface PawnInstigator;

event Activated()
{
    local SeqVar_Object ObjVar;

    // End:0x14C
    foreach LinkedVariables(Class'Engine.SeqVar_Object', ObjVar, "Instigator")
    {
        PawnInstigator = EvilPlayer_interface(ObjVar.GetObjectValue());
        // End:0x14B
        if(NotEqual_InterfaceInterface(PawnInstigator, EvilPlayer_interface(none)))
        {
            // End:0xEC
            if(bLeftHand)
            {
                EvilWeap_Base(PawnInstigator.GetWeaponLeft()).bDisableSetPosition = InputLinks[1].bHasImpulse;
                // End:0x14B
                continue;
            }
            EvilWeap_Base(PawnInstigator.GetWeapon()).bDisableSetPosition = InputLinks[1].bHasImpulse;
        }        
    }    
    //return;    
}

defaultproperties
{
    InputLinks[0]=(LinkDesc="Enable",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    InputLinks[1]=(LinkDesc="Disable",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Instigator",LinkVar="None",PropertyName="Instigator",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="Set Weapon Placements"
}