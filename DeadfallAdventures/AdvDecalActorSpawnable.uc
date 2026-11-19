class AdvDecalActorSpawnable extends DecalActorMovable
    hidecategories(Navigation);

defaultproperties
{
    // Reference: DecalComponent'Default__AdvDecalActorSpawnable.NewDecalComponent'
    begin object name=NewDecalComponent
        DecalMaterial=DecalMaterial'adv_lf_flares_01.Materials.m_MirrorLightOnWall'
        bDecalMaterialSetAtRunTime=true
        ReplacementPrimitive=none
    end object
    Decal=NewDecalComponent
    Components[0]=NewDecalComponent
    Components[1]=none
    Components[2]=none
    bNoDelete=false
}