class E50_Tank extends TPBaseTank
				placeable;

var protected MaterialInstanceConstant InteriorLeftWheelMaterialInstance, InteriorRightWheelMaterialInstance;
var int LWheelSkinID, RWheelSkinID;
var name InteriorWheels;
var float LeftWheelSpeed, RightWheelSpeed;

simulated function PostBeginPlay()
{
	local MaterialInterface WheelMaterial;

	Super.PostBeginPlay();

	if (Mesh != None)
	{
		// set up material instance (for overlay effects)
		WheelMaterial = Mesh.GetMaterial(LWheelSkinID);
		if ( WheelMaterial != None )
		{
			InteriorLeftWheelMaterialInstance = new(Outer) class'MaterialInstanceConstant';
			Mesh.SetMaterial(LWheelSkinID, InteriorLeftWheelMaterialInstance);
			InteriorLeftWheelMaterialInstance.SetParent(WheelMaterial);
		}
		WheelMaterial = Mesh.GetMaterial(RWheelSkinID);
		if ( WheelMaterial != None )
		{
			InteriorRightWheelMaterialInstance = new(Outer) class'MaterialInstanceConstant';
			Mesh.SetMaterial(RWheelSkinID, InteriorRightWheelMaterialInstance);
			InteriorRightWheelMaterialInstance.SetParent(WheelMaterial);
		}
	}
}

simulated function Tick(float dt)
{
	local float Left, Right;
	super.Tick(dt);
	Left = SVehicleSimTank(SimObj).LeftTrackVel * Wheels[0].WheelRadius;
	LeftWheelSpeed += dt * (Left * 0.0085);
	InteriorLeftWheelMaterialInstance.SetScalarParameterValue(InteriorWheels,LeftWheelSpeed);

	Right = SVehicleSimTank(SimObj).RightTrackVel * Wheels[0].WheelRadius;
	RightWheelSpeed += dt * (Right * 0.0085);
	InteriorRightWheelMaterialInstance.SetScalarParameterValue(InteriorWheels,RightWheelSpeed);
}

