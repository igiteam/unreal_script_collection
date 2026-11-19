class PKWeap_Melee_BagBaby extends EvilWeap_Melee_HumanMelee
    config(Weapon)
    hidecategories(Navigation);

var EvilExplosion ExplosionTemplate;
var EvilExplosion ExplosionArchetype;

simulated function DoMeleeDamage(float DamageScale, optional Actor Target = none, optional Vector HitLocaltion = vect(0.0000000, 0.0000000, 0.0000000))
{
    local EvilExplosionActor ExplosionActor;
    local PKAIController EventInstigator;

    // End:0x1DC
    if(ExplosionArchetype != none)
    {
        ExplosionActor = Spawn(Class'EvilGame.EvilExplosionActor', self,, Instigator.Location, MakeRotator(0, 0, 0));
        ExplosionTemplate = new (self) ExplosionArchetype.Class (ExplosionArchetype);
        ExplosionTemplate.HitNormal = Normal(Vector(Instigator.Rotation));
        ExplosionTemplate.HitActor = Instigator;
        EventInstigator = PKAIController(Instigator.Controller);
        // End:0x1A9
        if((EventInstigator != none) && EventInstigator.bConfused)
        {
            EventInstigator.MyPKPawn.bIsInvulnerable = false;
        }
        ExplosionActor.Explode(ExplosionTemplate);
        ExplosionTemplate = none;
    }
    //return;    
}

defaultproperties
{
    ExplosionArchetype=EvilExplosion'ch_BagBaby.Effects.ar_BagBabyExplo'
    // Reference: ForceFeedbackWaveform'Default__PKWeap_Melee_BagBaby.ForceFeedbackWaveformShooting1'
    // Archetype: ForceFeedbackWaveform'EvilGame.Default__EvilWeap_Melee_HumanMelee.ForceFeedbackWaveformShooting1'
    begin object name="ForceFeedbackWaveformShooting1"
    end object
    WeaponFireWaveForm=ForceFeedbackWaveformShooting1
    // Reference: AudioComponent'Default__PKWeap_Melee_BagBaby.ReloadSound'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'ReloadSound'
    // Archetype: AudioComponent'EvilGame.Default__EvilWeap_Melee_HumanMelee.ReloadSound'
    begin object name="ReloadSound"
    end object
    ReloadSoundComp=ReloadSound
    // Reference: DynamicLightEnvironmentComponent'Default__PKWeap_Melee_BagBaby.MyLightEnvironment'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'MyLightEnvironment'
    // Archetype: DynamicLightEnvironmentComponent'EvilGame.Default__EvilWeap_Melee_HumanMelee.MyLightEnvironment'
    begin object name="MyLightEnvironment"
    end object
    LightEnvironment=MyLightEnvironment
    // Reference: UDKSkeletalMeshComponent'Default__PKWeap_Melee_BagBaby.FirstPersonMesh'
    // Archetype: UDKSkeletalMeshComponent'EvilGame.Default__EvilWeap_Melee_HumanMelee.FirstPersonMesh'
    begin object name="FirstPersonMesh"
        ReplacementPrimitive=none
    end object
    Mesh=FirstPersonMesh
    // Reference: SkeletalMeshComponent'Default__PKWeap_Melee_BagBaby.PickupMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'PickupMesh'
    // Archetype: SkeletalMeshComponent'EvilGame.Default__EvilWeap_Melee_HumanMelee.PickupMesh'
    begin object name="PickupMesh"
        ReplacementPrimitive=none
    end object
    DroppedPickupMesh=PickupMesh
    PickupFactoryMesh=PickupMesh
    Components[0]=MyLightEnvironment
    Components[1]=ReloadSound
}