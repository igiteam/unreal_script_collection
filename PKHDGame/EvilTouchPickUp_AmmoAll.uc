class EvilTouchPickUp_AmmoAll extends EvilTouchPickUp_Base
    notplaceable
    hidecategories(Navigation);

var(Pickup) bool GiveMax;
var(Pickup) array<int> AmmoAmount;

function Pickup(EvilPawn P)
{
    local array<EvilWeap_Base> Weapons;
    local EvilWeap_Base Weap;
    local bool successed;
    local int I;

    EvilInventoryManager(P.InvManager).GetWeaponList(Weapons);
    // End:0x16C
    foreach Weapons(Weap)
    {
        I = 0;
        J0x6B:

        // End:0x16B [Loop If]
        if(I < AmmoAmount.Length)
        {
            // End:0x15D
            if(!Weap.AmmoMaxed(I))
            {
                // End:0x114
                if(GiveMax)
                {
                    Weap.AddAmmoForFireMode(byte(I), Weap.GetMaxAmmoCount(byte(I)));                    
                }
                else
                {
                    Weap.AddAmmoForFireMode(byte(I), AmmoAmount[I]);
                }
                successed = true;
            }
            I++;
            // [Loop Continue]
            goto J0x6B;
        }        
    }    
    // End:0x17E
    if(!successed)
    {
        return;
    }
    super.Pickup(P);
    //return;    
}

defaultproperties
{
    GiveMax=true
    AmmoAmount[0]=0
    AmmoAmount[1]=0
    AmmoAmount[2]=0
    // Reference: CylinderComponent'Default__EvilTouchPickUp_AmmoAll.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    // Archetype: CylinderComponent'Default__EvilTouchPickUp_Base.CollisionCylinder'
    begin object name="CollisionCylinder"
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    // Reference: StaticMeshComponent'Default__EvilTouchPickUp_AmmoAll.PickupMeshComp'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'PickupMeshComp'
    // Archetype: StaticMeshComponent'Default__EvilTouchPickUp_Base.PickupMeshComp'
    begin object name="PickupMeshComp"
        ReplacementPrimitive=none
    end object
    PickupMesh=PickupMeshComp
    // Reference: EvilCaptionComponent'Default__EvilTouchPickUp_AmmoAll.CaptionComp'
    // Archetype: EvilCaptionComponent'Default__EvilTouchPickUp_Base.CaptionComp'
    begin object name="CaptionComp"
    end object
    CaptionComponent=CaptionComp
    // Reference: DynamicLightEnvironmentComponent'Default__EvilTouchPickUp_AmmoAll.MyLightEnvironment'
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