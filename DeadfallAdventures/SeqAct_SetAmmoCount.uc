class SeqAct_SetAmmoCount extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var() class<EvilWeap_Base> WeapClass;
var() array<int> AmmoCount;
var() bool AddAmmo;

event Activated()
{
    local SeqVar_Object ObjVar;
    local EvilPawn P;
    local EvilWeap_Base Weap, WeapLeft;
    local int I;

    // End:0x300
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
        // End:0x2FF
        if(P != none)
        {
            Weap = EvilWeap_Base(P.FindInventoryType(WeapClass, true));
            // End:0x2FF
            if(Weap != none)
            {
                WeapLeft = EvilWeap_Base(P.FindInventoryType(WeapClass.default.OffHandWeaponClass, true));
                // End:0x1E2
                if(!AddAmmo)
                {
                    Weap.Unloaded();
                    // End:0x1E2
                    if(WeapLeft != none)
                    {
                        WeapLeft.Unloaded();
                    }
                }
                I = 0;
                J0x1ED:

                // End:0x2FF [Loop If]
                if(I < AmmoCount.Length)
                {
                    EvilInventoryManager(P.InvManager).AddAmmoToWeapon(byte(I), AmmoCount[I], WeapClass);
                    // End:0x2F1
                    if(WeapLeft != none)
                    {
                        EvilInventoryManager(P.InvManager).AddAmmoToWeapon(byte(I), AmmoCount[I], WeapLeft.Class);
                    }
                    I++;
                    // [Loop Continue]
                    goto J0x1ED;
                }
            }
        }        
    }    
    ActivateOutputLink(0);
    //return;    
}

defaultproperties
{
    AmmoCount[0]=0
    AmmoCount[1]=0
    bAutoActivateOutputLinks=false
    VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Players",LinkVar="None",PropertyName="Players",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    ObjName="Set Ammo Count"
}