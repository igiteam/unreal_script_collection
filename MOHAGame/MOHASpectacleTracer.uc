class MOHASpectacleTracer extends Emitter
    hidecategories(Navigation);

struct native FireTiming
{
    var() float MinIdleTime;
    var() float MaxIdleTime;
    var() float MinFireTime;
    var() float MaxFireTime;

    structdefaultproperties
    {
        MinIdleTime=0.0000000
        MaxIdleTime=0.0000000
        MinFireTime=0.0000000
        MaxFireTime=0.0000000
    }
};

var(Tuning_Tracer) ParticleSystem TracerTemplate;
var(Tuning_Tracer) FireTiming TracerFireTiming;

simulated event PostBeginPlay()
{
    super.PostBeginPlay();
    SetTemplate(TracerTemplate);
    ParticleSystemComponent.DeactivateSystem();
    //return;    
}

event StartFiring()
{
    GotoState('Firing');
    //return;    
}

event StopFiring()
{
    GotoState('Idle');
    //return;    
}

auto state Idle
{
    function BeginState(name PreviousStateName)
    {
        SetTimer(RandRange(TracerFireTiming.MinIdleTime, TracerFireTiming.MaxIdleTime), false, 'StartFiring');
        //return;        
    }

    function EndState(name NextStateName)
    {
        ClearTimer('StartFiring');
        //return;        
    }
    stop;    
}

state Firing
{
    function BeginState(name PreviousStateName)
    {
        SetTimer(RandRange(TracerFireTiming.MinFireTime, TracerFireTiming.MaxFireTime), false, 'StopFiring');
        ParticleSystemComponent.ActivateSystem();
        //return;        
    }

    function EndState(name NextStateName)
    {
        ClearTimer('StopFiring');
        ParticleSystemComponent.DeactivateSystem();
        //return;        
    }
    stop;    
}

defaultproperties
{
    TracerTemplate=ParticleSystem'HUS_VFX_TracerLS.tracer'
    TracerFireTiming=(MinIdleTime=7.0000000,MaxIdleTime=10.0000000,MinFireTime=1.0000000,MaxFireTime=3.0000000)
    // Reference: ParticleSystemComponent'Default__MOHASpectacleTracer.ParticleSystemComponent0'
    begin object name=ParticleSystemComponent0
    end object
    ParticleSystemComponent=ParticleSystemComponent0
    // Reference: SpriteComponent'Default__MOHASpectacleTracer.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
    Components[1]=ParticleSystemComponent0
    // Reference: ArrowComponent'Default__MOHASpectacleTracer.ArrowComponent0'
    begin object name=ArrowComponent0
    end object
    Components[2]=ArrowComponent0
}