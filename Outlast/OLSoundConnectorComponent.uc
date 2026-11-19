class OLSoundConnectorComponent extends ActorComponent
	native;

var() bool bEnabled;
var() bool bSpherical;
var() float SphereRadius;
var() float BoxWidth;

var() bool bAllowSourceVirtualization;

var transient array<OLSoundEnvironmentVolume> ConnectedVolumes;

cpptext
{
	void ConnectVolumes(const FVector& location, const TArray<class AOLSoundEnvironmentVolume*>& Volumes);

#if WITH_EDITOR
	void CheckConnectorForErrors();
#endif

	FVector GetCenterLocation();
	FVector GetClosestPoint(const FVector& target);
}

defaultproperties
{
	bEnabled=true
	bSpherical=true
	SphereRadius=100.0
	BoxWidth=200.0	
	bAllowSourceVirtualization=true
}
