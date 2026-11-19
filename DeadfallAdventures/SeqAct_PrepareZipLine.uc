class SeqAct_PrepareZipLine extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var() Actor.EPhysics newPhysics;
var() EvilTypes.EHandOnLine WhichHandHoldLine;
var Actor Instigator;

event Activated()
{
    local EvilPlayer_interface EPI;
    local EvilPawn P;
    local EvilWeap_MeleeHands Hands;

    EPI = EvilPlayer_interface(Instigator);
    // End:0x4B7
    if(NotEqual_InterfaceInterface(EPI, EvilPlayer_interface(none)))
    {
        P = EPI.GetPlayerPawn();
        P.SetPhysics(newPhysics);
        P.ZeroMovementVariables();
        P.SetCollision(false, false);
        P.bCollideWorld = false;
        // End:0x188
        if(P.SavedWeaponLeft == none)
        {
            P.SavedWeaponLeft = ((P.WeaponLeft != none) ? class<EvilWeap_Base>(P.WeaponLeft.Class) : none);
        }
        // End:0x22E
        if(P.SavedWeapon == none)
        {
            P.SavedWeapon = ((P.Weapon != none) ? class<EvilWeap_Base>(P.Weapon.Class) : none);
        }
        Hands = EvilWeap_MeleeHands(P.InvManager.FindInventoryType(P.HandsClass));
        EvilPlayerController(P.Controller).WhichHandHoldLine = WhichHandHoldLine;
        // End:0x350
        if(int(WhichHandHoldLine) == int(0))
        {
            P.SetCurrentWeaponClass(P.HandsClass, true);
            P.SetCurrentWeaponLeftClass(none, true);            
        }
        else
        {
            // End:0x405
            if(int(WhichHandHoldLine) == int(1))
            {
                Hands.UsesOffhand = true;
                EvilPlayerController(P.Controller).bFiringOnZipLine = true;
                P.SetCurrentWeaponLeftClass(P.HandsClass, true);                
            }
            else
            {
                // End:0x4B7
                if(int(WhichHandHoldLine) == int(2))
                {
                    Hands.UsesOffhand = false;
                    EvilPlayerController(P.Controller).bFiringOnZipLine = true;
                    P.SetCurrentWeaponClass(P.HandsClass, true);
                }
            }
        }
    }
    //return;    
}

defaultproperties
{
    newPhysics=EPhysics.PHYS_Flying
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Instigator",LinkVar="None",PropertyName="Instigator",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="Prepare Zip Line"
}