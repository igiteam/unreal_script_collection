class MOHAOBBMovePoint extends MOHAMovePoint
    placeable
    hidecategories(Navigation);

var int Count;

event Tick(float DeltaTime)
{
    SetRelativeLocation(Class'MOHAUtilities'.static.GetClosetPointOnRootBodyBoxElem0(Base));
    //return;    
}

defaultproperties
{
    // Reference: SpriteComponent'Default__MOHAOBBMovePoint.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
    bHardAttach=true
    CollisionType=0
}