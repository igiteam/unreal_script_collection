class TurokAmmoPoolRailGrenade extends TurokAmmoPool;

simulated function AdjustMP()
{
    mAmmoMaximum = 6;
    super.AdjustMP();
    //return;    
}

defaultproperties
{
    mAmmoMaximum=12
}