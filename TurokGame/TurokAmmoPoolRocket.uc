class TurokAmmoPoolRocket extends TurokAmmoPool;

simulated function AdjustMP()
{
    mAmmoMaximum = 4;
    super.AdjustMP();
    //return;    
}

defaultproperties
{
    mAmmoMaximum=10
}