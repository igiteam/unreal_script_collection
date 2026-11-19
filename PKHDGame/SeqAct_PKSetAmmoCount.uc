class SeqAct_PKSetAmmoCount extends SeqAct_SetAmmoCount
    forcescriptorder(true)
    hidecategories(Object);

event Activated()
{
    local SeqVar_Object ObjVar;
    local PKPawn P;
    local PainWeap_Base Weap;
    local int I;

    // End:0x28C
    foreach LinkedVariables(Class'Engine.SeqVar_Object', ObjVar, "Players")
    {
        // End:0xA9
        if(PKPlayerController(ObjVar.GetObjectValue()) != none)
        {
            P = PKPawn(PKPlayerController(ObjVar.GetObjectValue()).Pawn);            
        }
        else
        {
            P = PKPawn(ObjVar.GetObjectValue());
        }
        // End:0x28B
        if(P != none)
        {
            Weap = PainWeap_Base(P.FindInventoryType(WeapClass, true));
            // End:0x28B
            if(Weap != none)
            {
                Weap.Unloaded();
                I = 0;
                J0x15F:

                // End:0x28B [Loop If]
                if(I < AmmoCount.Length)
                {
                    PKInventoryManager(P.InvManager).AddAmmoToWeapon(byte(I), (((PainGRI_SP(Class'Engine.WorldInfo'.static.GetWorldInfo().GRI) != none) && PainGRI_SP(Class'Engine.WorldInfo'.static.GetWorldInfo().GRI).b666AmmoCardEnabled) ? 666 : AmmoCount[I]), WeapClass);
                    I++;
                    // [Loop Continue]
                    goto J0x15F;
                }
            }
        }        
    }    
    OutputLinks[0].bHasImpulse = true;
    //return;    
}

defaultproperties
{
    ObjName="PKSet Ammo Count"
}