class EvilTouchPickUp_AmmoBase extends EvilTouchPickUp_Base
    notplaceable
    hidecategories(Navigation);

var(Pickup) class<EvilWeap_Base> WeaponClass;
var(Pickup) array<int> AmmoAmount;

simulated function PostBeginPlay()
{
    local string ClassName;

    super.PostBeginPlay();
    // End:0xC9
    if(CaptionComponent.CaptionText == "")
    {
        ClassName = string(WeaponClass.Name);
        // End:0x8E
        if(Right(ClassName, 5) != "_Base")
        {
            ClassName = ClassName $ "_Base";
        }
        CaptionComponent.SetCaptionLoc("AmmoPickupString", ClassName);
    }
    //return;    
}

function Pickup(EvilPawn P)
{
    local int I;

    // End:0x4E
    if(!EvilInventoryManager(P.InvManager).NeedsAmmo(WeaponClass))
    {
        return;
    }
    I = 0;
    J0x59:

    // End:0xE3 [Loop If]
    if(I < AmmoAmount.Length)
    {
        EvilInventoryManager(P.InvManager).AddAmmoToWeapon(byte(I), AmmoAmount[I], WeaponClass);
        I++;
        // [Loop Continue]
        goto J0x59;
    }
    super.Pickup(P);
    //return;    
}

defaultproperties
{
    AmmoAmount[0]=0
    AmmoAmount[1]=0
    AmmoAmount[2]=0
    // Reference: CylinderComponent'Default__EvilTouchPickUp_AmmoBase.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    // Archetype: CylinderComponent'Default__EvilTouchPickUp_Base.CollisionCylinder'
    begin object name="CollisionCylinder"
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    // Reference: StaticMeshComponent'Default__EvilTouchPickUp_AmmoBase.PickupMeshComp'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'PickupMeshComp'
    // Archetype: StaticMeshComponent'Default__EvilTouchPickUp_Base.PickupMeshComp'
    begin object name="PickupMeshComp"
        ReplacementPrimitive=none
    end object
    PickupMesh=PickupMeshComp
    // Reference: EvilCaptionComponent'Default__EvilTouchPickUp_AmmoBase.CaptionComp'
    // Archetype: EvilCaptionComponent'Default__EvilTouchPickUp_Base.CaptionComp'
    begin object name="CaptionComp"
    end object
    CaptionComponent=CaptionComp
    // Reference: DynamicLightEnvironmentComponent'Default__EvilTouchPickUp_AmmoBase.MyLightEnvironment'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'MyLightEnvironment'
    // Archetype: DynamicLightEnvironmentComponent'Default__EvilTouchPickUp_Base.MyLightEnvironment'
    begin object name="MyLightEnvironment"
    end object
    LightEnvironment=MyLightEnvironment
    Components[0]=CollisionCylinder
    Components[1]=PickupMeshComp
    Components[2]=MyLightEnvironment
    Components[3]=CaptionComp
    CollisionComponent=CollisionCylinder
}