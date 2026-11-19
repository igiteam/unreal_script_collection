class UTKillZVolume extends PhysicsVolume
    hidecategories(Navigation,Object,Movement,Display);

var() class<DamageType> KillZDamageType;

event ActorEnteredVolume(Actor Other)
{
    // End:0x37
    if(!Other.bStatic)
    {
        KillActor(Other);
    }
    //return;    
}

event PawnEnteredVolume(Pawn Other)
{
    KillActor(Other);
    //return;    
}

simulated event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
    // End:0x37
    if(!Other.bStatic)
    {
        KillActor(Other);
    }
    //return;    
}

simulated event KillActor(Actor Other)
{
    // End:0x24
    if(!Other.bScriptInitialized)
    {
    }
    Other.FellOutOfWorld(KillZDamageType);
    // End:0x91
    if(EvilPawn(Other) != none)
    {
        EvilPawn(Other).bStopDeathCamera = true;        
    }
    else
    {
        // End:0xD3
        if(EvilVehicle_Base(Other) != none)
        {
            EvilVehicle_Base(Other).bStopDeathCamera = true;
        }
    }
    //return;    
}

defaultproperties
{
    KillZDamageType=Class'Engine.KillZDamageType'
    // Reference: BrushComponent'Default__UTKillZVolume.BrushComponent0'
    begin object name=BrushComponent0
        ReplacementPrimitive=none
    end object
    BrushComponent=BrushComponent0
    Components[0]=BrushComponent0
    CollisionComponent=BrushComponent0
}