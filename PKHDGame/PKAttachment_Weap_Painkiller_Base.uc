class PKAttachment_Weap_Painkiller_Base extends PainAttachment_Weap_Base
    abstract
    hidecategories(Navigation);

var export editinline UTParticleSystemComponent BeamEffectComp;
var() ParticleSystem BeamEffect;
var() name BeamEffectEndPointName;
var PKProjectile_PainkillerBlades_Base Blades;
var bool bSearchForBlades;
var float ReaquireTimer;
var transient float LastPainkillerEffectTime;

simulated function PlayImpactEffects(Vector HitLocation, optional bool bIsLeft = false)
{
    // End:0xAE
    if(int(Instigator.FiringMode) == int(0))
    {
        // End:0xA9
        if((WorldInfo.TimeSeconds - LastPainkillerEffectTime) > 0.0900000)
        {
            super(EvilAttachment_Weap_Base).PlayImpactEffects(HitLocation, bIsLeft);
            LastPainkillerEffectTime = WorldInfo.TimeSeconds;            
        }
        else
        {
            return;
        }        
    }
    else
    {
        super(EvilAttachment_Weap_Base).PlayImpactEffects(HitLocation, bIsLeft);
    }
    //return;    
}

simulated function ThirdPersonFireEffects(Vector HitLocation)
{
    super(EvilAttachment_Weap_Base).ThirdPersonFireEffects(HitLocation);
    // End:0x1BD
    if(int(Instigator.FiringMode) == int(1))
    {
        bSearchForBlades = true;
        // End:0x1BA
        if(EffectIsRelevant(Instigator.Location, false, MaxFireEffectDistance, MaxFireEffectDistance * 0.7500000))
        {
            // End:0x17A
            if(BeamEffectComp == none)
            {
                BeamEffectComp = new (Outer) Class'EvilGame.UTParticleSystemComponent';
                BeamEffectComp.SetTemplate(BeamEffect);
                BeamEffectComp.SetHidden(true);
                BeamEffectComp.SetTickGroup(3);
                BeamEffectComp.bUpdateComponentInTick = true;
                Mesh.AttachComponentToSocket(BeamEffectComp, MuzzleFlashSocket);                
            }
            else
            {
                BeamEffectComp.ActivateSystem();
                BeamEffectComp.SetHidden(true);
            }
        }        
    }
    else
    {
        // End:0x213
        if(int(Instigator.FiringMode) == int(0))
        {
            Mesh.PlayAnim('WeaponFire',, true, false);
        }
    }
    //return;    
}

simulated event StopThirdPersonFireEffects()
{
    super(EvilAttachment_Weap_Base).StopThirdPersonFireEffects();
    // End:0x38
    if(BeamEffectComp != none)
    {
        BeamEffectComp.DeactivateSystem();
    }
    bSearchForBlades = false;
    Blades = none;
    Mesh.PlayAnim('WeaponIdle',,, false);
    //return;    
}

simulated function SetBeamEmitterHidden(bool bHide)
{
    // End:0x38
    if(BeamEffectComp != none)
    {
        BeamEffectComp.SetHidden(bHide);
    }
    //return;    
}

simulated function Tick(float DeltaTime)
{
    local Vector StartTrace, EndTrace, AimDir;
    local bool bFound, bAimTest;
    local float Distance, AimRange;

    // End:0x95
    if(bSearchForBlades)
    {
        bFound = false;
        // End:0x7A
        foreach DynamicActors(Class'PKProjectile_PainkillerBlades_Base', Blades)
        {
            // End:0x79
            if(Blades.Instigator == Instigator)
            {
                bFound = true;
                bSearchForBlades = false;
                // End:0x7A
                break;
            }            
        }        
        // End:0x95
        if(!bFound)
        {
            Blades = none;
        }
    }
    // End:0x2BE
    if(Blades != none)
    {
        StartTrace = Instigator.GetWeaponStartTraceLocation();
        AimDir = Vector(Instigator.GetBaseAimRotation());
        EndTrace = Blades.Location;
        Distance = VSize(EndTrace - StartTrace);
        AimRange = FClamp(1.5000000 * (Distance / float(600)), 0.7500000, 0.9830000);
        bAimTest = (AimDir Dot Normal(EndTrace - StartTrace)) > (((PKPlayerPawn(Instigator) != none) && PainPRI(Instigator.PlayerReplicationInfo).bHasWeaponModifier) ? 0.5000000 : AimRange);
        // End:0x28E
        if(bAimTest && FastTrace(EndTrace, StartTrace))
        {
            SetBeamEmitterHidden(false);
            // End:0x27C
            if(BeamEffectComp != none)
            {
                BeamEffectComp.SetVectorParameter(BeamEffectEndPointName, EndTrace);
            }
            ReaquireTimer = 0.2000000;            
        }
        else
        {
            ReaquireTimer -= DeltaTime;
            // End:0x2BE
            if(ReaquireTimer <= float(0))
            {
                SetBeamEmitterHidden(true);
            }
        }
    }
    //return;    
}

defaultproperties
{
    // Reference: SkeletalMeshComponent'Default__PKAttachment_Weap_Painkiller_Base.SkeletalMeshComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'SkeletalMeshComponent0'
    // Archetype: SkeletalMeshComponent'Default__PainAttachment_Weap_Base.SkeletalMeshComponent0'
    begin object name="SkeletalMeshComponent0"
        // Reference: UDKAnimNodeSequence'Default__PKAttachment_Weap_Painkiller_Base.SkeletalMeshComponent0.MeshSequenceA'
        // Archetype: UDKAnimNodeSequence'Default__PainAttachment_Weap_Base.SkeletalMeshComponent0.MeshSequenceA'
        begin object name="MeshSequenceA"
        end object
        Animations=MeshSequenceA
        ReplacementPrimitive=none
    end object
    Mesh=SkeletalMeshComponent0
    WeaponClass=Class'PKWeap_Painkiller_Base'
    EvilWeapAnimType=EEvilWeapAnimType.EEWAT_Minigun
}