class TurokRoute extends Route
    native
    hidecategories(Navigation,Movement,Collision);

var @NULL mCenter;
var float mRadius;
var() @NULL mColour;
var() bool mbHideArea;
var() bool mbForceAddNavPoints;
var() float mPathRadius;
var() array mStreamingAutoLinkNames;

// Export UTurokRoute::execInsideRouteRadius(FFrame&, void* const)
native final function bool InsideRouteRadius(@NULL pos);

// Export UTurokRoute::execInitializeRoute(FFrame&, void* const)
native final function InitializeRoute();

// Export UTurokRoute::execNavigationPoints(FFrame&, void* const)
native final iterator function NavigationPoints(class<Class> BaseClass, out @NULL Point);

event PostBeginPlay()
{
    InitializeRoute();
    //return;    
}

defaultproperties
{
    mPathRadius=48.0000000
    // Reference: SpriteComponent'Default__TurokRoute.Sprite'
    begin object name=Sprite
        Sprite=Texture2D'TurokEditorResources.TurokRoute'
    end object
    Components[0]=Sprite
    Components[1]=Sprite
    // Reference: TurokRouteRenderingComponent'Default__TurokRoute.TurokRouteRenderer'
    begin object name=TurokRouteRenderer class=Class'TurokRouteRenderingComponent'
        AlwaysLoadOnClient=false
        AlwaysLoadOnServer=false
    end object
    Components[2]=TurokRouteRenderer
}