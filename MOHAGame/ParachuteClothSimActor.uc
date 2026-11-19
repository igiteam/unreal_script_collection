class ParachuteClothSimActor extends Actor
    placeable
    hidecategories(Navigation);

var export editinline Parachute TheParachute;

simulated function Timer()
{
    Destroy();
    //return;    
}

defaultproperties
{
    // Reference: Parachute'Default__ParachuteClothSimActor.TestParachute0'
    begin object name=TestParachute0 class=Class'Parachute'
    end object
    TheParachute=TestParachute0
    Components[0]=TestParachute0
    CollisionType=0
}