class R6SoundReplicationInfoAbstract extends Actor
    abstract
    native
    notplaceable
    hidecategories(lighting);

simulated event AssignSound(class<Weapon> WeaponClass)
{
    return;
}

defaultproperties
{
    bHidden=true
    bSkipActorPropertyReplication=true
    RemoteRole=2
    TickGroup=1
    NetUpdateFrequency=5.0000000
}