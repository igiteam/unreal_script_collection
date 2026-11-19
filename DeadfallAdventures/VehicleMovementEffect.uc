class VehicleMovementEffect extends UDKVehicleMovementEffect
    hidecategories(Navigation);

defaultproperties
{
    // Reference: StaticMeshComponent'Default__VehicleMovementEffect.AerialMesh'
    begin object name=AerialMesh
        ReplacementPrimitive=none
        Translation=(X=0.0000000,Y=0.0000000,Z=-100.0000000)
        Scale3D=(X=80.0000000,Y=60.0000000,Z=60.0000000)
    end object
    AirEffect=AerialMesh
    Components[0]=AerialMesh
}