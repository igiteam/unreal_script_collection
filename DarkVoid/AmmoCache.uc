class AmmoCache extends SkyBonusPickupFactory;

event OnPickupBonus(SkyPlayerControllerBase C)
{
    // End:0x4B
    if((C != none) && SkyPawn(C.Pawn) != none)
    {
        SkyPawn(C.Pawn).OnFillAmmo(none);
    }
    //return;    
}

auto state Pickup
{
    function bool ValidTouch(Pawn Other)
    {
        local SkyPawn SP;

        SP = SkyPawn(Other);
        // End:0x74
        if((SP != none) && SP.ShouldFillAmmo())
        {
            Class'SkyHUD'.static.OpenPickupTutorial('AmmoCache', SkyPlayerController(SP.Controller));
            return super.ValidTouch(Other);            
        }
        else
        {
            return false;
        }
        //return ReturnValue;        
    }
    stop;    
}
