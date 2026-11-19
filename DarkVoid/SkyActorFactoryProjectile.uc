class SkyActorFactoryProjectile extends ActorFactory
    native
    config(Editor)
    editinlinenew
    collapsecategories;

var() class<Projectile> ProjectileClass;
var() Rotator Direction;

event OnSpawn(Projectile Spawned)
{
    // End:0x26
    if(Spawned != none)
    {
        Spawned.Init(Vector(Direction));
    }
    //return;    
}
