class AdvProjectile_IceBolt extends AdvProjectile_Bolt
    hidecategories(Navigation);

defaultproperties
{
    // Reference: StaticMeshComponent'Default__AdvProjectile_IceBolt.StaticMesh'
    begin object name=StaticMesh
        StaticMesh=StaticMesh'adv_en_arctic_environment_04.Meshes.sm_en_arctic_IcePillar_01_08'
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__AdvProjectile_IceBolt.MyLightEnvironment'
    end object
    Mesh=StaticMesh
    bCanPinToPawns=false
    ExplosionArchetype=EvilExplosion'adv_ps_CustomAction.Archetypes.ar_IceBolt'
    // Reference: CylinderComponent'Default__AdvProjectile_IceBolt.CollisionCylinder'
    begin object name=CollisionCylinder
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=CollisionCylinder
    Components[1]=StaticMesh
    // Reference: DynamicLightEnvironmentComponent'Default__AdvProjectile_IceBolt.MyLightEnvironment'
    begin object name=MyLightEnvironment class=Class'Engine.DynamicLightEnvironmentComponent'
    end object
    Components[2]=MyLightEnvironment
    CollisionComponent=StaticMesh
}