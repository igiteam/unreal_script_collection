class SeqAct_StopZipLine extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var() Actor.EPhysics newPhysics;
var Actor Instigator;

event Activated()
{
    local EvilPlayer_interface EPI;
    local EvilPawn P;
    local EvilWeap_MeleeHands Hands;

    EPI = EvilPlayer_interface(Instigator);
    // End:0x263
    if(NotEqual_InterfaceInterface(EPI, EvilPlayer_interface(none)))
    {
        P = EPI.GetPlayerPawn();
        P.SetPhysics(newPhysics);
        P.SetCollision(true, true);
        P.bCollideWorld = true;
        EvilPlayerController(P.Controller).bFiringOnZipLine = false;
        Hands = EvilWeap_MeleeHands(P.InvManager.FindInventoryType(P.HandsClass));
        Hands.UsesOffhand = Class'EvilWeap_MeleeHands'.default.UsesOffhand;
        P.SetCurrentWeaponLeftClass(P.SavedWeaponLeft, true);
        P.SetCurrentWeaponClass(P.SavedWeapon, true);
        P.SavedWeapon = none;
        P.SavedWeapon = none;
    }
    //return;    
}

defaultproperties
{
    newPhysics=EPhysics.PHYS_Falling
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Instigator",LinkVar="None",PropertyName="Instigator",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="Stop Zip Line"
}