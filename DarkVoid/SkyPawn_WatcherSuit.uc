class SkyPawn_WatcherSuit extends SkyNPC
    native
    config(Pawn);

var deprecated float PercentChanceToDropAuxWeapon;
var(Stun) float StunHealthPct;
var(Stun) const name StunWalkReaction;
var(Stun) const name StunHoverReaction;
var(Stun) const name StunThrustReaction;
var transient array<float> StunHealthHistory;
var transient float StunTimeAccumulator;
var(Sounds) editconst export editinline AudioComponent HoverLoopSound;
var transient bool bShouldPlayHoverLoop;
var(WatcherSuitDamage) float DamageScaleNPC;

// Export USkyPawn_WatcherSuit::execCheckForStun(FFrame&, void* const)
native function CheckForStun(float StartHealth, float EndHealth);

// Export USkyPawn_WatcherSuit::execTakeDamage(FFrame&, void* const)
native function TakeDamage(int Damage, Controller EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser);

function StopHoverLoopSound()
{
    bShouldPlayHoverLoop = false;
    // End:0x38
    if((HoverLoopSound != none) && HoverLoopSound.bWasPlaying)
    {
        HoverLoopSound.Stop();
    }
    //return;    
}

function bool Died(Controller Killer, class<DamageType> DamageType, Vector HitLocation)
{
    StopHoverLoopSound();
    return super.Died(Killer, DamageType, HitLocation);
    //return ReturnValue;    
}

event bool SkyDied(Controller Killer, class<DamageType> DamageType, Vector HitLocation)
{
    StopHoverLoopSound();
    return super(SkyPawn).SkyDied(Killer, DamageType, HitLocation);
    //return ReturnValue;    
}

event Bump(Actor Other, PrimitiveComponent OtherComp, Vector HitNormal)
{
    HandlePlayerBump(Other);
    super(Actor).Bump(Other, OtherComp, HitNormal);
    //return;    
}

event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
    HandlePlayerBump(Other);
    super(Actor).Touch(Other, OtherComp, HitLocation, HitNormal);
    //return;    
}

function HandlePlayerBump(Actor Other)
{
    local SkyPawn_MaxValenti PlayerOther;

    PlayerOther = SkyPawn_MaxValenti(Other);
    // End:0x79
    if((!IsInteracting() && Health > 0) && PlayerOther != none)
    {
        TryAnInteraction();
        // End:0x79
        if(!IsInteracting())
        {
            bCanBeBaseForPawns = false;
            ClearTimer('RestorePawnBaseFlag');
            SetTimer(1.5000000, false, 'RestorePawnBaseFlag');
        }
    }
    //return;    
}

function RestorePawnBaseFlag()
{
    bCanBeBaseForPawns = true;
    //return;    
}
