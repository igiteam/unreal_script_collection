class TurokAmmoPoolArrow extends TurokAmmoPool;

simulated function AdjustMP()
{
    mAmmoMaximum = 25;
    super.AdjustMP();
    //return;    
}

defaultproperties
{
    mAmmoMaximum=50
}