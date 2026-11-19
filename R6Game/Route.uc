class Route extends Actor
    native
    notplaceable
    hidecategories(lighting);

enum ERouteType
{
    ERT_Linear,                     // 0
    ERT_Loop,                       // 1
    ERT_Circle,                     // 2
    ERT_MAX                         // 3
};

var() Route.ERouteType RouteType;
var() array<NavigationPoint> MoveList;

defaultproperties
{
    // Reference: SpriteComponent'Default__Route.Sprite'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SpriteComponent'Default__Actor.Sprite'
    begin object name="Sprite"
        Sprite=Texture2D'EngineResources.S_Route'
    end object
    Components[0]=Sprite
    // Reference: RouteRenderingComponent'Default__Route.RouteRenderer'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="RouteRenderer" class=Class'RouteRenderingComponent'
        HiddenGame=true
        AlwaysLoadOnClient=false
        AlwaysLoadOnServer=false
    end object
    Components[1]=RouteRenderer
}