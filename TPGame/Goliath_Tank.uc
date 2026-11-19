class Goliath_Tank extends TPBaseTank
				placeable;

var protected MaterialInstanceConstant InteriorLeftWheelMaterialInstance, InteriorRightWheelMaterialInstance;
var int LWheelSkinID, RWheelSkinID;
var name InteriorWheels;
var float LeftWheelSpeed, RightWheelSpeed;
var GoliathWeaknessCylinder WeaknessCylinder;

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

		if (WeaknessCylinder == none)
		{
			WeaknessCylinder = Spawn(class'GoliathWeaknessCylinder',self);
			WeaknessCylinder.CollisionComponent.SetTraceBlocking(true, true);
			WeaknessCylinder.SetBase(self,, Mesh, 'JO_VehicleBody');
			//Mesh.AttachComponent(WeaknessCylinder,'JO_VehicleBody', vect(-110,0,0));
		}
	}
}

simulated event Destroyed()
{
	if (WeaknessCylinder != None)
		WeaknessCylinder.Destroy();
}

simulated event TakeDamage( int Damage, Controller instigatedBy, Vector hitlocation, Vector momentum,
					class<DamageType> damageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
}

//called by the goliath weakness cylinder
simulated event ReallyTakeDamage( int Damage, Controller instigatedBy, Vector hitlocation, Vector momentum,
					class<DamageType> damageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	super.TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
}

simulated function Tick(float dt)
{
	local float Left, Right;
	super.Tick(dt);

	if (InteriorLeftWheelMaterialInstance != none)
	{
		Left = SVehicleSimTank(SimObj).LeftTrackVel * Wheels[0].WheelRadius;
		LeftWheelSpeed += dt * (Left * 0.0085);
		InteriorLeftWheelMaterialInstance.SetScalarParameterValue(InteriorWheels,LeftWheelSpeed);
	}
	if (InteriorRightWheelMaterialInstance != none)
	{
		Right = SVehicleSimTank(SimObj).RightTrackVel * Wheels[0].WheelRadius;
		RightWheelSpeed += dt * (Right * 0.0085);
		InteriorRightWheelMaterialInstance.SetScalarParameterValue(InteriorWheels,RightWheelSpeed);
	}
}

