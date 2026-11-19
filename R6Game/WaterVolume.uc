class WaterVolume extends PhysicsVolume
    notplaceable
    hidecategories(lighting,Object,Movement,Display);

var() /*0x04000000-0x00000000*/ SoundCue EntrySound;
var() /*0x04000000-0x00000000*/ SoundCue ExitSound;
var() class<Actor> EntryActor;
var() class<Actor> ExitActor;
var() class<Actor> PawnEntryActor;

function PlayEntrySplash(Actor other)
{
    local float SplashSize;
    local Actor splash;

    SplashSize = FClamp((0.0000300 * other.Mass) * (float(250) - (0.5000000 * FMax(-600.0000000, other.Velocity.Z))), 0.1000000, 1.0000000);
    // End:0x95
    if(EntrySound != none)
    {
        other.PlaySound(EntrySound, 4);
        // End:0x95
        if(other.Instigator != none)
        {
            MakeNoise(SplashSize);
        }
    }
    // End:0xD3
    if(EntryActor != none)
    {
        splash = __NFUN_278__(EntryActor);
        // End:0xD3
        if(splash != none)
        {
            splash.SetDrawScale(SplashSize);
        }
    }
    return;
}

function PlayExitSplash(Actor other)
{
    local float SplashSize;
    local Actor splash;

    SplashSize = FClamp(0.0030000 * other.Mass, 0.1000000, 1.0000000);
    other.PlaySound(ExitSound, 4);
    // End:0x80
    if(ExitActor != none)
    {
        splash = __NFUN_278__(ExitActor);
        // End:0x80
        if(splash != none)
        {
            splash.SetDrawScale(SplashSize);
        }
    }
    return;
}

defaultproperties
{
    FluidFriction=2.4000000
    bWaterVolume=true
    LocationName="under water"
}