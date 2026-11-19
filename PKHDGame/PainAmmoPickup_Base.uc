class PainAmmoPickup_Base extends PainItemBaseStaticMesh
    abstract
    notplaceable
    hidecategories(Navigation);

var() int AmmoToAdd;
var int WeaponFireMode;
var class<EvilWeap_Base> WeaponClass;

function PostBeginPlay()
{
    // End:0x4B
    if(PainGRI(WorldInfo.GRI).IsMultiplayerGame())
    {
        MaxPickCount = 0;
    }
    // End:0xB2
    if(PainGRI(WorldInfo.GRI).IsCoopMultiplayerGame())
    {
        MaxPickCount = 2;
        LastPickerClearDelay = 0.0000000;
        bHidePickupFromLastPicker = true;
    }
    super(PainItemBase).PostBeginPlay();
    //return;    
}

function AddAmmo(PKPlayerPawn P, PainPRI PRI)
{
    // End:0xDF
    if(PainGRI(WorldInfo.GRI).IsMultiplayerGame())
    {
        PKInventoryManager(P.InvManager).AddAmmoToWeapon(byte(WeaponFireMode), int(float(AmmoToAdd) * PKGame(WorldInfo.Game).AmmoFoundFactor), WeaponClass);        
    }
    else
    {
        PKInventoryManager(P.InvManager).AddAmmoToWeapon(byte(WeaponFireMode), int((float(AmmoToAdd) * PKGame(WorldInfo.Game).AmmoFoundFactor) * PRI.Difficulty.default.AmmoDifficultyModifier), WeaponClass);
    }
    //return;    
}

simulated function HideFromLastPicker()
{
    local editinline ParticleSystemComponent Comp;

    // End:0xBA
    if(LastPRIPicker.IsLocalPlayerPRI())
    {
        SetOwner(Controller(LastPRIPicker.Owner).Pawn);
        PickupMesh.SetOwnerNoSee(true);
        // End:0xB9
        foreach BindParticlesPSC(Comp)
        {
            Comp.SetOwnerNoSee(true);            
        }        
    }
    //return;    
}

function bool CanPickUp(PKPlayerPawn P, PainPRI PRI)
{
    // End:0x69
    if(!PKInventoryManager(P.InvManager).NeedsAmmo(WeaponClass, WeaponFireMode))
    {
        SetTimer(0.5000000, false, 'ReCheckTouchingPlayers_T');
        return false;
    }
    // End:0x93
    if((LastPRIPicker != none) && LastPRIPicker == PRI)
    {
        return false;
    }
    return super(PainItemBase).CanPickUp(P, PRI);
    //return ReturnValue;    
}

function ReCheckTouchingPlayers_T()
{
    local PKPlayerPawn P;
    local bool bIsSomeoneTouchingWhoCantPickup;

    bIsSomeoneTouchingWhoCantPickup = false;
    // End:0xBB
    foreach TouchingActors(Class'PKPlayerPawn', P)
    {
        // End:0x72
        if(!CanPickUp(P, PainPRI(P.PlayerReplicationInfo)))
        {
            bIsSomeoneTouchingWhoCantPickup = true;
            // End:0xBA
            continue;
        }
        Touch(P, none, Location, Normal(Location - P.Location));        
    }    
    // End:0xDC
    if(bIsSomeoneTouchingWhoCantPickup)
    {
        SetTimer(0.5000000, false, 'ReCheckTouchingPlayers_T');
    }
    //return;    
}

function Pickup(PKPlayerPawn P, PainPRI PRI)
{
    super(PainItemBase).Pickup(P, PRI);
    // End:0x7C
    if(bHidePickupFromLastPicker)
    {
        LastPRIPicker = PRI;
        bForceNetUpdate = true;
        HideFromLastPicker();
        // End:0x7C
        if(LastPickerClearDelay > 0.0000000)
        {
            SetTimer(LastPickerClearDelay, false, 'ClearLastPRIPicker');
        }
    }
    PRI.ScoreAmmoTaken();
    AddAmmo(P, PRI);
    //return;    
}

function ClearLastPRIPicker()
{
    LastPRIPicker = none;
    //return;    
}

defaultproperties
{
    // Reference: StaticMeshComponent'Default__PainAmmoPickup_Base.PickupMeshComp'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'PickupMeshComp'
    // Archetype: StaticMeshComponent'Default__PainItemBaseStaticMesh.PickupMeshComp'
    begin object name="PickupMeshComp"
        ReplacementPrimitive=none
    end object
    PickupMesh=PickupMeshComp
    // Reference: CylinderComponent'Default__PainAmmoPickup_Base.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    // Archetype: CylinderComponent'Default__PainItemBaseStaticMesh.CollisionCylinder'
    begin object name="CollisionCylinder"
        CollisionRadius=30.0000000
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    // Reference: DynamicLightEnvironmentComponent'Default__PainAmmoPickup_Base.MyLightEnvironment'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'MyLightEnvironment'
    // Archetype: DynamicLightEnvironmentComponent'Default__PainItemBaseStaticMesh.MyLightEnvironment'
    begin object name="MyLightEnvironment"
    end object
    LightEnvironment=MyLightEnvironment
    LastPickerClearDelay=20.0000000
    Components[0]=CollisionCylinder
    Components[1]=MyLightEnvironment
    Components[2]=PickupMeshComp
    CollisionComponent=CollisionCylinder
}