class TurokNodeGroup extends TurokRoute
    native
    hidecategories(Navigation,Movement,Collision);

var(Fencing) array mFences;

defaultproperties
{
    mbForceAddNavPoints=true
    // Reference: SpriteComponent'Default__TurokNodeGroup.Sprite'
    begin object name=Sprite
        Sprite=Texture2D'TurokEditorResources.TurokRouteGroup'
    end object
    Components[0]=Sprite
    Components[1]=Sprite
    // Reference: TurokRouteRenderingComponent'Default__TurokNodeGroup.TurokRouteRenderer'
    begin object name=TurokRouteRenderer
    end object
    Components[2]=TurokRouteRenderer
}