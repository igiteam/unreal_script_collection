class TurokAmmoPoolNapalmGrenade extends TurokAmmoPool;

simulated function AdjustMP()
{
    mAmmoMaximum = 2;
    super.AdjustMP();
    //return;    
}

defaultproperties
{
    mAmmoMaximum=12
}