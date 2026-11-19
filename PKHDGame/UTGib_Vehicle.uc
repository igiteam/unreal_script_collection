class UTGib_Vehicle extends EvilGib
    abstract
    config(Game)
    notplaceable
    hidecategories(Navigation);

var float TimeBeforeGibExplosionEffect;
var ParticleSystem PS_GibExplosionEffect;
var ParticleSystem PS_GibTrailEffect;
var SoundCue LoopedSound;
var name BurnName;
var float BurnDuration;
var MaterialInstanceTimeVarying MITV;
var class<EvilVehicle_Base> OwningClass;

simulated event PostBeginPlay()
{
    super(Actor).PostBeginPlay();
    CreateAudioComponent(LoopedSound, true, true);
    //return;    
}

simulated function ActivateGibExplosionEffect()
{
    local int TeamNum;
    local editinline ParticleSystemComponent PSC_Trail;

    // End:0x2B
    if(int(WorldInfo.NetMode) == int(NM_DedicatedServer))
    {
        return;
    }
    // End:0x65
    if(Instigator != none)
    {
        TeamNum = int(Instigator.GetTeamNum());
    }
    // End:0x7F
    if(TeamNum > 1)
    {
        TeamNum = 0;
    }
    // End:0xF5
    if(OwningClass.default.BurnOutMaterial[TeamNum] != none)
    {
        GibMeshComp.SetMaterial(0, OwningClass.default.BurnOutMaterial[TeamNum]);
    }
    // End:0x1E3
    if((WorldInfo.TimeSeconds - GibMeshComp.LastRenderTime) < 1.0000000)
    {
        WorldInfo.MyEmitterPool.SpawnEmitter(PS_GibExplosionEffect, Location, Rotation);
        PSC_Trail = new (self) Class'Engine.ParticleSystemComponent';
        PSC_Trail.SetTemplate(PS_GibTrailEffect);
        AttachComponent(PSC_Trail);
    }
    // End:0x29C
    if((WorldInfo.TimeSeconds - GibMeshComp.LastRenderTime) < 3.0000000)
    {
        MITV = GibMeshComp.CreateAndSetMaterialInstanceTimeVarying(0);
        MITV.SetScalarStartTime('BurnTime', LifeSpan - (BurnDuration - (FRand() * 1.0000000)));
    }
    //return;    
}

defaultproperties
{
    TimeBeforeGibExplosionEffect=0.1000000
    BurnName="BurnTime"
    BurnDuration=3.5000000
    // Reference: DynamicLightEnvironmentComponent'Default__UTGib_Vehicle.GibLightEnvironmentComp'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'GibLightEnvironmentComp'
    // Archetype: DynamicLightEnvironmentComponent'Default__EvilGib.GibLightEnvironmentComp'
    begin object name="GibLightEnvironmentComp"
    end object
    GibLightEnvironment=GibLightEnvironmentComp
    Components[0]=GibLightEnvironmentComp
}