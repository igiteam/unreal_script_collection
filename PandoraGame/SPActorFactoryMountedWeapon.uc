class SPActorFactoryMountedWeapon extends ActorFactory
    native
    config(Editor)
    editinlinenew
    collapsecategories;

var() class<MountedWeapon> WeaponClass;

defaultproperties
{
    WeaponClass=Class'MountedWeapon'
    bPlaceable=false
}