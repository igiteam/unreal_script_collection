class OLBatteriesPickupFactory extends OLPickableObject
	native
	placeable;

var() int NumBatteries;

var() StaticMesh Mesh1;
var() StaticMesh Mesh2;
var() StaticMesh Mesh3;
var() StaticMesh Mesh4;

cpptext
{
	virtual UBOOL CanPickup(AOLHero* hero);
	virtual void Pickup(AOLHero* hero);
	virtual void TryShowInvalidPickupMessage();
	FString GetPickableName();	
	virtual void PostEditChangeProperty(FPropertyChangedEvent& PropertyChangedEvent);
	void Reset();
}

defaultproperties
{	
	Begin Object Name=PickupMeshComp
		StaticMesh=StaticMesh'Interactive_Objects.PickupObjects.CamCorderBattery-01'
	End Object
	PickupMesh=PickupMeshComp	

	Mesh1=StaticMesh'Interactive_Objects.PickupObjects.CamCorderBattery-01'
	Mesh2=StaticMesh'Interactive_Objects.PickupObjects.CamCorderBattery-02'
	Mesh3=StaticMesh'Interactive_Objects.PickupObjects.CamCorderBattery-03'
	Mesh4=StaticMesh'Interactive_Objects.PickupObjects.CamCorderBattery-04'

	NumBatteries=1
}