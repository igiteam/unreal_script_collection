class NaziAPCMG extends NaziAPCMG_Persistent
	placeable;

var SkeletalMeshComponent APCdrvFwheel1;
var SkeletalMeshComponent APCdrvFwheel2;
var SkeletalMeshComponent APCdrvRwheel1;
var SkeletalMeshComponent APCdrvRwheel2;
var SkeletalMeshComponent APCpassFwheel1;
var SkeletalMeshComponent APCpassFwheel2;
var SkeletalMeshComponent APCpassRwheel1;
var SkeletalMeshComponent APCpassRwheel2;

simulated function PostBeginPlay()
{    
    super.PostBeginPlay();
	
	// Attach wheels
    mesh.AttachComponentToSocket(APCdrvFwheel1,'drvFwheel1');
	mesh.AttachComponentToSocket(APCdrvFwheel2,'drvFwheel2');
	mesh.AttachComponentToSocket(APCpassFwheel1,'passFwheel1');
	mesh.AttachComponentToSocket(APCpassFwheel2,'passFwheel2');
    mesh.AttachComponentToSocket(APCdrvRwheel1,'drvRwheel1');
	mesh.AttachComponentToSocket(APCdrvRwheel2,'drvRwheel2');
    mesh.AttachComponentToSocket(APCpassRwheel1,'passRwheel1');
	mesh.AttachComponentToSocket(APCpassRwheel2,'passRwheel2');
}

