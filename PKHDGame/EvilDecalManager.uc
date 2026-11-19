class EvilDecalManager extends DecalManager
    config(Game)
    hidecategories(Navigation);

function bool CanSpawnDecals()
{
    return super.CanSpawnDecals();
    //return ReturnValue;    
}

defaultproperties
{
    // Reference: DecalComponent'Default__EvilDecalManager.BaseDecal'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'BaseDecal'
    // Archetype: DecalComponent'Engine.Default__DecalManager.BaseDecal'
    begin object name="BaseDecal"
        ReplacementPrimitive=none
    end object
    DecalTemplate=BaseDecal
    DecalDepthBias=-0.0001200
}