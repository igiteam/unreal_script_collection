class TurokAmmoPoolChaingun extends TurokAmmoPool;

simulated function AdjustMP()
{
    mAmmoMaximum = 750;
    super.AdjustMP();
    //return;    
}

defaultproperties
{
    mAmmoMaximum=1000
}