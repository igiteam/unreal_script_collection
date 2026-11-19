class EvilAmmoPickupFactory extends EvilItemPickupFactory
    abstract
    hidecategories(Navigation,Lighting,LightColor,Force,Display,Collision,PickupFactory)
    classgroup(Pickups,Ammo);

var int AmmoAmount;
var class<EvilWeap_Base> TargetWeapon;

function SpawnCopyFor(Pawn Recipient)
{
    // End:0x7E
    if(EvilInventoryManager(Recipient.InvManager) != none)
    {
        EvilInventoryManager(Recipient.InvManager).AddAmmoToWeapon(0, AmmoAmount, TargetWeapon);
    }
    Recipient.PlaySound(PickupSound);
    Recipient.MakeNoise(0.2000000);
    // End:0x148
    if(PlayerController(Recipient.Controller) != none)
    {
        PlayerController(Recipient.Controller).ReceiveLocalizedMessage(MessageClass,,,, Class);
    }
    //return;    
}

static simulated function UpdateHUD(UTHUD H)
{
    local Weapon CurrentWeapon;

    super(EvilPickupFactory).UpdateHUD(H);
    // End:0x85
    if(H.PawnOwner != none)
    {
        CurrentWeapon = H.PawnOwner.Weapon;
        // End:0x85
        if(CurrentWeapon == none)
        {
            return;
        }
    }
    // End:0xEE
    if(default.TargetWeapon == CurrentWeapon.Class)
    {
        H.LastAmmoPickupTime = H.LastPickupTime;
    }
    //return;    
}

auto state Pickup
{
    function bool ValidTouch(Pawn Other)
    {
        // End:0x1A
        if(!super.ValidTouch(Other))
        {
            return false;
        }
        // End:0x8F
        if(EvilInventoryManager(Other.InvManager) != none)
        {
            return EvilInventoryManager(Other.InvManager).NeedsAmmo(TargetWeapon);
        }
        return true;
        //return ReturnValue;        
    }

    function float DetourWeight(Pawn P, float PathWeight)
    {
        local EvilWeap_Base W;

        W = EvilWeap_Base(P.FindInventoryType(TargetWeapon));
        // End:0x82
        if(W != none)
        {
            return (W.DesireAmmo(true) * MaxDesireability) / PathWeight;
        }
        return 0.0000000;
        //return ReturnValue;        
    }
    stop;    
}

defaultproperties
{
    // Reference: DynamicLightEnvironmentComponent'Default__EvilAmmoPickupFactory.PickupLightEnvironment'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'PickupLightEnvironment'
    // Archetype: DynamicLightEnvironmentComponent'Default__EvilItemPickupFactory.PickupLightEnvironment'
    begin object name="PickupLightEnvironment"
    end object
    LightEnvironment=PickupLightEnvironment
    // Reference: ForceFeedbackWaveform'Default__EvilAmmoPickupFactory.ForceFeedbackWaveformPickUp'
    // Archetype: ForceFeedbackWaveform'Default__EvilItemPickupFactory.ForceFeedbackWaveformPickUp'
    begin object name="ForceFeedbackWaveformPickUp"
    end object
    PickUpWaveForm=ForceFeedbackWaveformPickUp
    // Reference: StaticMeshComponent'Default__EvilAmmoPickupFactory.BaseMeshComp'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'BaseMeshComp'
    // Archetype: StaticMeshComponent'Default__EvilItemPickupFactory.BaseMeshComp'
    begin object name="BaseMeshComp"
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__EvilAmmoPickupFactory.PickupLightEnvironment'
    end object
    BaseMesh=BaseMeshComp
    MaxDesireability=0.2000000
    // Reference: StaticMeshComponent'Default__EvilAmmoPickupFactory.AmmoMeshComp'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'AmmoMeshComp'
    begin object name="AmmoMeshComp" class=Class'Engine.StaticMeshComponent'
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__EvilAmmoPickupFactory.PickupLightEnvironment'
        MaxDrawDistance=4000.0000000
        CachedMaxDrawDistance=4000.0000000
        CastShadow=false
        bForceDirectLightMap=true
        bCastDynamicShadow=false
        CollideActors=false
        BlockActors=false
        BlockZeroExtent=false
        BlockNonZeroExtent=false
        BlockRigidBody=false
        Scale=1.8000000
    end object
    PickupMesh=AmmoMeshComp
    // Reference: CylinderComponent'Default__EvilAmmoPickupFactory.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    // Archetype: CylinderComponent'Default__EvilItemPickupFactory.CollisionCylinder'
    begin object name="CollisionCylinder"
        CollisionHeight=9.6000000
        CollisionRadius=24.0000000
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=CollisionCylinder
    Components[1]=none
    Components[2]=PickupLightEnvironment
    Components[3]=BaseMeshComp
    Components[4]=AmmoMeshComp
    CollisionComponent=CollisionCylinder
}