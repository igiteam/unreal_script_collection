class EvilActorComponent extends ActorComponent
    native;

var() bool bPostRenderDisabled;
var bool bTickScript;

simulated function RegisterWithHUD()
{
    local PlayerController PC;

    // End:0xB9
    foreach Class'Engine.WorldInfo'.static.GetWorldInfo().AllControllers(Class'Engine.PlayerController', PC)
    {
        // End:0xB8
        if(EvilGFxHudWrapper(PC.myHUD) != none)
        {
            EvilGFxHudWrapper(PC.myHUD).AddPostRenderedComponent(self);
            // End:0xB8
            continue;
        }        
    }    
    //return;    
}

simulated function DeregisterWithHUD()
{
    local PlayerController PC;

    // End:0xB6
    foreach Class'Engine.WorldInfo'.static.GetWorldInfo().AllControllers(Class'Engine.PlayerController', PC)
    {
        // End:0xB5
        if(EvilGFxHudWrapper(PC.myHUD) != none)
        {
            EvilGFxHudWrapper(PC.myHUD).RemovePostRenderedComponent(self);
        }        
    }    
    //return;    
}

simulated event PostRenderFor(PlayerController PC, Canvas Canvas)
{
    //return;    
}

simulated event Tick(float DeltaTime)
{
    //return;    
}
