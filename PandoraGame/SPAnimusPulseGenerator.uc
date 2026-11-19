class SPAnimusPulseGenerator extends SPDamageImpulsePulse
    placeable;

var SoundCue FireSound;
var transient bool bSoundPlayed;
var export editinline ParticleSystemComponent ParticleEffectComponent;

function DoEffect()
{
    // End:0x23
    if(!bSoundPlayed)
    {
        PlaySound(FireSound);
        bSoundPlayed = true;
    }
    //return;    
}

static function Rotator GetPulseFireRotation(Actor firedBy)
{
    local PlayerPawn pPawn;
    local PlayerController Controller;
    local Vector ViewLocation;
    local Rotator ViewRotation;

    pPawn = PlayerPawn(firedBy);
    // End:0x64
    if(pPawn != none)
    {
        Controller = PlayerController(pPawn.Controller);
        // End:0x64
        if(Controller != none)
        {
            Controller.GetPlayerViewPoint(ViewLocation, ViewRotation);
            return ViewRotation;
        }
    }
    return super.GetPulseFireRotation(firedBy);
    //return ReturnValue;    
}

state Finished
{
    function bool ReadyToDie()
    {
        return ParticleEffectComponent.bWasCompleted;
        //return ReturnValue;        
    }
    stop;    
}
