class UTVehicleShield extends UDKWeaponShield
    abstract
    hidecategories(Navigation);

var SoundCue ActivatedSound;
var SoundCue DeactivatedSound;
var export editinline AudioComponent AmbientComponent;
var export editinline ParticleSystemComponent ShieldEffectComponent;
var float ShieldActivatedTime;
var bool bFullyActive;

function SetActive(bool bNowActive)
{
    // End:0x187
    if(bHidden != !bNowActive)
    {
        SetCollision(bNowActive, false);
        SetHidden(!bNowActive);
        // End:0xE6
        if(ShieldEffectComponent != none)
        {
            ShieldEffectComponent.SetHidden(bHidden);
            // End:0xC6
            if(bHidden)
            {
                ShieldEffectComponent.DeactivateSystem();
                ShieldEffectComponent.KillParticlesForced();                
            }
            else
            {
                ShieldEffectComponent.ActivateSystem();
            }
        }
        // End:0x144
        if(bNowActive)
        {
            PlaySound(ActivatedSound, false);
            AmbientComponent.Play();
            SetTimer(ShieldActivatedTime, false, 'ShieldFullyOnline');            
        }
        else
        {
            PlaySound(DeactivatedSound, false);
            AmbientComponent.Stop();
            bFullyActive = false;
        }
    }
    //return;    
}

simulated function ShieldFullyOnline()
{
    bFullyActive = true;
    //return;    
}

event TakeDamage(int Damage, Controller EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    HitInfo.HitComponent = CollisionComponent;
    Base.TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
    //return;    
}

defaultproperties
{
    ShieldActivatedTime=1.8000000
    bHidden=true
    bHardAttach=true
    bCollideActors=false
}