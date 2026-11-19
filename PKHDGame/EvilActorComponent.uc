class EvilActorComponent extends ActorComponent;

var bool Disabled;

simulated function RegisterWithHUD()
{
    local PlayerController PC;

    // End:0x89
    foreach Class'Engine.WorldInfo'.static.GetWorldInfo().AllControllers(Class'Engine.PlayerController', PC)
    {
        EvilGFxHudWrapper(PC.myHUD).AddPostRenderedComponent(self);        
    }    
    //return;    
}

simulated function DeregisterWithHUD()
{
    local PlayerController PC;

    // End:0x89
    foreach Class'Engine.WorldInfo'.static.GetWorldInfo().AllControllers(Class'Engine.PlayerController', PC)
    {
        EvilGFxHudWrapper(PC.myHUD).RemovePostRenderedComponent(self);        
    }    
    //return;    
}

simulated event PostRenderFor(PlayerController PC, Canvas Canvas)
{
    //return;    
}
