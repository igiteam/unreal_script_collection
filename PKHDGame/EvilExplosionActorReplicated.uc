class EvilExplosionActorReplicated extends EvilExplosionActor
    notplaceable
    hidecategories(Navigation);

var private repnotify transient EvilExplosion ExploTemplateRef;
var private repnotify transient class<EvilProjectile_Base> ProjExploToEmulate;

replication
{
    // Pos:0x000
    if(bNetDirty)
        ExploTemplateRef, ProjExploToEmulate;
}

simulated event ReplicatedEvent(name VarName)
{
    // End:0x2D
    if(VarName == 'ExploTemplateRef')
    {
        Explode(ExploTemplateRef);        
    }
    else
    {
        // End:0x5A
        if(VarName == 'ProjExploToEmulate')
        {
            EmulateProjectileExplosion(ProjExploToEmulate);            
        }
        else
        {
            super(Actor).ReplicatedEvent(VarName);
        }
    }
    //return;    
}

simulated event Explode(EvilExplosion NewExplosionTemplate)
{
    // End:0x27
    if(int(Role) == int(ROLE_Authority))
    {
        ExploTemplateRef = NewExplosionTemplate;
    }
    super.Explode(NewExplosionTemplate);
    LifeSpan = FMax(LifeSpan, 1.0000000);
    //return;    
}

simulated event EmulateProjectileExplosion(class<EvilProjectile_Base> ProjToEmulate)
{
    local EvilExplosion ExploTemplate;

    ExploTemplate = new (self) ProjToEmulate.default.ExplosionTemplate.Class (ProjToEmulate.default.ExplosionTemplate);
    PrepareDefaultExplosionTemplate(ExploTemplate);
    Explode(ExploTemplate);
    ExploTemplateRef = none;
    // End:0xB8
    if(int(Role) == int(ROLE_Authority))
    {
        ProjExploToEmulate = ProjToEmulate;
    }
    //return;    
}

static simulated function PrepareDefaultExplosionTemplate(EvilExplosion ExploTemplate, optional bool bIsMulti)
{
    ExploTemplate.Damage = 75.0000000;
    ExploTemplate.DamageRadius = 100.0000000;
    ExploTemplate.DamageFalloffExponent = 2.0000000;
    ExploTemplate.KnockDownRadius = 100.0000000;
    ExploTemplate.CringeRadius = 100.0000000;
    //return;    
}

defaultproperties
{
    // Reference: RB_RadialImpulseComponent'Default__EvilExplosionActorReplicated.ImpulseComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'ImpulseComponent0'
    // Archetype: RB_RadialImpulseComponent'Default__EvilExplosionActor.ImpulseComponent0'
    begin object name="ImpulseComponent0"
        ReplacementPrimitive=none
    end object
    RadialImpulseComponent=ImpulseComponent0
    Components[0]=ImpulseComponent0
    RemoteRole=ENetRole.ROLE_SimulatedProxy
    bNetTemporary=true
    bAlwaysRelevant=true
    bNetInitialRotation=true
}