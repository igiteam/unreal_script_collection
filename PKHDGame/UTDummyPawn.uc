class UTDummyPawn extends UTPawn
    config(Game)
    hidecategories(Navigation);

var UTSeqAct_DummyWeaponFire FireAction;

simulated function PostBeginPlay()
{
    super(Pawn).PostBeginPlay();
    EvilInventoryManager(InvManager).bInfiniteAmmo = true;
    //return;    
}

simulated function WeaponFired(Weapon InWeapon, bool bViaReplication, optional Vector HitLocation)
{
    LastRenderTime = WorldInfo.TimeSeconds;
    super.WeaponFired(InWeapon, bViaReplication, HitLocation);
    FireAction.NotifyDummyFire();
    //return;    
}

simulated function SetPawnAmbientSound(SoundCue NewAmbientSound)
{
    // End:0x37
    if(!FireAction.bSuppressSounds)
    {
        super.SetPawnAmbientSound(NewAmbientSound);
    }
    //return;    
}

simulated function SetWeaponAmbientSound(SoundCue NewAmbientSound)
{
    // End:0x37
    if(!FireAction.bSuppressSounds)
    {
        super.SetWeaponAmbientSound(NewAmbientSound);
    }
    //return;    
}

simulated function Rotator GetAdjustedAimFor(Weapon InWeapon, Vector projStart)
{
    local Rotator BaseRotation;

    // End:0x71
    if(FireAction.Target != none)
    {
        BaseRotation = Rotator(FireAction.Target.Location - projStart);        
    }
    else
    {
        BaseRotation = Rotation;
    }
    return BaseRotation + (FireAction.MaxSpread * (1.0000000 - (2.0000000 * FRand())));
    //return ReturnValue;    
}

simulated function WeaponAttachmentChanged()
{
    // End:0x22E
    if((CurrentWeaponAttachment == none) || CurrentWeaponAttachment.Class != CurrentWeaponAttachmentClass)
    {
        // End:0x8C
        if(CurrentWeaponAttachment != none)
        {
            CurrentWeaponAttachment.DetachFrom(Mesh);
            CurrentWeaponAttachment.Destroy();
        }
        // End:0xE1
        if(CurrentWeaponAttachmentClass != none)
        {
            CurrentWeaponAttachment = Spawn(CurrentWeaponAttachmentClass, self);
            CurrentWeaponAttachment.Instigator = self;            
        }
        else
        {
            CurrentWeaponAttachment = none;
        }
        // End:0x22E
        if(CurrentWeaponAttachment != none)
        {
            CurrentWeaponAttachment.bSuppressSounds = FireAction.bSuppressSounds;
            CurrentWeaponAttachment.AttachTo(self);
            CurrentWeaponAttachment.SetHidden(false);
            CurrentWeaponAttachment.Mesh.SetRotation(rot(0, -16384, 0));
            CurrentWeaponAttachment.AttachComponent(CurrentWeaponAttachment.Mesh);
            CurrentWeaponAttachment.Mesh.SetHidden(true);
        }
    }
    //return;    
}

simulated function Vector GetWeaponStartTraceLocation(optional Weapon CurrentWeapon)
{
    return GetPawnViewLocation();
    //return ReturnValue;    
}

simulated function Vector GetPawnViewLocation()
{
    // End:0x6D
    if((CurrentWeaponAttachment != none) && CurrentWeaponAttachment.MuzzleFlashPSC != none)
    {
        return CurrentWeaponAttachment.MuzzleFlashPSC.GetPosition();        
    }
    else
    {
        return super.GetPawnViewLocation();
    }
    //return ReturnValue;    
}

simulated event Tick(float DeltaTime)
{
    // End:0x128
    if(((CurrentWeaponAttachment != none) && FireAction.Origin != none) && FireAction.Target != none)
    {
        CurrentWeaponAttachment.SetLocation(FireAction.Origin.Location);
        CurrentWeaponAttachment.SetRotation(Rotator(FireAction.Target.Location - FireAction.Origin.Location));
    }
    //return;    
}

defaultproperties
{
    // Reference: DynamicLightEnvironmentComponent'Default__UTDummyPawn.MyLightEnvironment'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'MyLightEnvironment'
    // Archetype: DynamicLightEnvironmentComponent'Default__UTPawn.MyLightEnvironment'
    begin object name="MyLightEnvironment"
    end object
    LightEnvironment=MyLightEnvironment
    // Reference: ForceFeedbackWaveform'Default__UTDummyPawn.ForceFeedbackWaveformFall'
    // Archetype: ForceFeedbackWaveform'Default__UTPawn.ForceFeedbackWaveformFall'
    begin object name="ForceFeedbackWaveformFall"
    end object
    FallingDamageWaveForm=ForceFeedbackWaveformFall
    // Reference: UTAmbientSoundComponent'Default__UTDummyPawn.AmbientSoundComponent'
    // Archetype: UTAmbientSoundComponent'Default__UTPawn.AmbientSoundComponent'
    begin object name="AmbientSoundComponent"
    end object
    PawnAmbientSound=AmbientSoundComponent
    // Reference: UTAmbientSoundComponent'Default__UTDummyPawn.AmbientSoundComponent2'
    // Archetype: UTAmbientSoundComponent'Default__UTPawn.AmbientSoundComponent2'
    begin object name="AmbientSoundComponent2"
    end object
    WeaponAmbientSound=AmbientSoundComponent2
    // Reference: SkeletalMeshComponent'Default__UTDummyPawn.OverlayMeshComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'OverlayMeshComponent0'
    // Archetype: SkeletalMeshComponent'Default__UTPawn.OverlayMeshComponent0'
    begin object name="OverlayMeshComponent0"
        ReplacementPrimitive=none
    end object
    OverlayMesh=OverlayMeshComponent0
    // Refer[0]ence: UDKSkeletalMeshComponent'Default__UTDummyPawn.FirstPersonArms'
    // Archetype: UDKSkeletalMeshComponent'Default__UTPawn.FirstPersonArms'
    begin object name="FirstPersonArms"
        // Reference: AnimNodeSequence'Default__UTDummyPawn.FirstPersonArms.MeshSequenceA'
        // Archetype: AnimNodeSequence'Default__UTPawn.MeshSequenceA'
        begin object name="MeshSequenceA"
        end object
        Animations=MeshSequenceA
        ReplacementPrimitive=none
    end object
    ArmsMesh=FirstPersonArms
    // Reference: UDKSkeletalMeshComponent'Default__UTDummyPawn.FirstPersonArms2'
    // Archetype: UDKSkeletalMeshComponent'Default__UTPawn.FirstPersonArms2'
    begin object name="FirstPersonArms2"
        // Reference: AnimNodeSequence'Default__UTDummyPawn.FirstPersonArms2.MeshSequenceB'
        // Archetype: AnimNodeSequence'Default__UTPawn.MeshSequenceB'
        begin object name="MeshSequenceB"
        end object
        Animations=MeshSequenceB
        ReplacementPrimitive=none
    end object
    ArmsMesh=FirstPersonArms2
    Mesh=none
    // Reference: CylinderComponent'Default__UTDummyPawn.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    // Archetype: CylinderComponent'Default__UTPawn.CollisionCylinder'
    begin object name="CollisionCylinder"
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    Components=none
    RemoteRole=ENetRole.ROLE_None
    bGameRelevant=true
    bCollideActors=false
    CollisionComponent=none
}