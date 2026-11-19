class TPVehicleNode extends TPPathNode;
	
var (VehicleNode) float Speed;					// Speed the vehicle should be at when touching node
var (VehicleNode) name Event;					// Event to wait for

event Touch(Actor Other, PrimitiveComponent OtherComponent, vector HitLocation, vector HitNormal)
{
	super.Touch(Other, OtherComponent, HitLocation, HitNormal);

	if ( Other.IsA('SVehicle') )
	{
		SVehicle(Other).Throttle = Speed;
	}
}

