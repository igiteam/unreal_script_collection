class PKBurningLightActor extends Actor
    notplaceable
    hidecategories(Navigation);

var() float BurningTime;
var() float LightDuration;
var() export editinline EvilDynamicLight_Base BurningLight;

simulated function PostBeginPlay()
{
    SetTimer(BurningTime, false, 'EndBurningLight');
    SetTimer(LightDuration, true, 'ResetBurningLight');
    //return;    
}

simulated function EndBurningLight()
{
    ClearTimer('ResetBurningLight');
    SetTimer(LightDuration, false, 'EndTimer');
    //return;    
}

simulated function ResetBurningLight()
{
    BurningLight.ResetLight();
    //return;    
}

simulated function EndTimer()
{
    Destroy();
    //return;    
}

defaultproperties
{
    BurningTime=4.0000000
    LightDuration=0.8000000
    // Reference: EvilDynamicLight_Base'Default__PKBurningLightActor.LightComponentB'
    begin object name="LightComponentB" class=Class'EvilGame.EvilDynamicLight_Base'
    end object
    BurningLight=LightComponentB
    Components[0]=LightComponentB
    RemoteRole=ENetRole.ROLE_SimulatedProxy
}