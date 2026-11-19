class SkyWaterVolume extends PhysicsVolume;

struct WaterEffectType
{
    var ParticleSystem Effect;
    var class<Actor> ActorType;
    var bool bKillsActor;

    structdefaultproperties
    {
        Effect=none
        ActorType=none
        bKillsActor=false
    }
};

var array<WaterEffectType> WaterEffects;

simulated function bool StopsProjectile(Projectile P)
{
    return true;
    //return ReturnValue;    
}

simulated event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
    local SkyEmitter Emit;
    local int EffectIndex;

    EffectIndex = GetEffectInfo(Other.Class);
    // End:0x30
    if(EffectIndex == -1)
    {
        return;
    }
    Emit = Spawn(Class'SkyEmitter', self,, HitLocation, Rotator(HitNormal));
    // End:0x87
    if(Emit != none)
    {
        Emit.SetTemplate(WaterEffects[EffectIndex].Effect);
    }
    // End:0x128
    if(WaterEffects[EffectIndex].bKillsActor)
    {
        // End:0xF4
        if(Pawn(Other) != none)
        {
            Pawn(Other).Health = 0;
            Pawn(Other).Died(none, none, Owner.Location);            
        }
        else
        {
            // End:0x11B
            if(SkyProjectile(Other) != none)
            {
                SkyProjectile(Other).bSuppressExplosionFX = true;
            }
            Other.Destroy();
        }
    }
    //return;    
}

simulated function bool DestroysClass(class<Actor> ActorClass)
{
    local int Index;

    Index = GetEffectInfo(ActorClass);
    // End:0x26
    if(Index == -1)
    {
        return false;
    }
    return WaterEffects[Index].bKillsActor;
    //return ReturnValue;    
}

simulated function int GetEffectInfo(class<Actor> ActorClass)
{
    local int I, bestindex;

    bestindex = -1;
    I = 0;
    J0x12:

    // End:0xA7 [Loop If]
    if(I < WaterEffects.Length)
    {
        // End:0x9D
        if(ClassIsChildOf(ActorClass, WaterEffects[I].ActorType))
        {
            // End:0x60
            if(bestindex == -1)
            {
                bestindex = I;
                // [Explicit Continue]
                goto J0x9D;
            }
            // End:0x9D
            if(ClassIsChildOf(WaterEffects[I].ActorType, WaterEffects[bestindex].ActorType))
            {
                bestindex = I;
            }
        }
        J0x9D:

        ++I;
        // [Loop Continue]
        goto J0x12;
    }
    return bestindex;
    //return ReturnValue;    
}
