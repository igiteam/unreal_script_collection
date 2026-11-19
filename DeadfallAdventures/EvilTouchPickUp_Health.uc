class EvilTouchPickUp_Health extends EvilTouchPickUp_Base
    notplaceable
    hidecategories(Navigation);

var(Pickup) float HealthToAdd;

function Pickup(EvilPawn P)
{
    local EvilPlayer_interface EPI;

    EPI = EvilPlayer_interface(P);
    // End:0x3E
    if(EqualEqual_InterfaceInterface(EPI, EvilPlayer_interface(none)))
    {
        return;
    }
    // End:0xAF
    if(EPI.GetPlayerPawn().Health >= EPI.GetPlayerPawn().HealthMax)
    {
        return;
    }
    EPI.GetPlayerPawn().GiveHealth(int(HealthToAdd), EPI.GetPlayerPawn().HealthMax);
    super.Pickup(P);
    //return;    
}

defaultproperties
{
    HealthToAdd=30.0000000
    // Reference: CylinderComponent'Default__EvilTouchPickUp_Health.CollisionCylinder'
    begin object name=CollisionCylinder
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    // Reference: StaticMeshComponent'Default__EvilTouchPickUp_Health.PickupMeshComp'
    begin object name=PickupMeshComp
        ReplacementPrimitive=none
    end object
    PickupMesh=PickupMeshComp
    // Reference: EvilCaptionComponent'Default__EvilTouchPickUp_Health.CaptionComp'
    begin object name=CaptionComp
    end object
    CaptionComponent=CaptionComp
    // Reference: DynamicLightEnvironmentComponent'Default__EvilTouchPickUp_Health.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    Components[0]=CollisionCylinder
    Components[1]=PickupMeshComp
    Components[2]=MyLightEnvironment
    Components[3]=CaptionComp
    CollisionType=ECollisionType.COLLIDE_CustomDefault
    CollisionComponent=CollisionCylinder
}