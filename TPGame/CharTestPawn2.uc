class CharTestPawn2 extends WehrmachtPawn
	placeable
	config(Game);

var SkeletalMesh BagMesh;
var PhysicsAsset BagPhysics; 

var SkeletalMesh ShovelMesh;
var PhysicsAsset ShovelPhysics; 


function DetachHat()
{
    // Don't detach any hat
}

function InitGear()
{
	local SkeletalMeshComponent skel;
	
	skel = new class'SkeletalMeshComponent';
	skel.SetSkeletalMesh(BagMesh);
	skel.SetPhysicsAsset(BagPhysics);
	AttachComponent(skel);
	Mesh.AttachComponentToSocket(skel, 'backbag');
	skel.SetShadowParent(Mesh);
	skel.SetLightEnvironment(Mesh.LightEnvironment);



	skel = new class'SkeletalMeshComponent';
	skel.SetSkeletalMesh(ShovelMesh);
	skel.SetPhysicsAsset(ShovelPhysics);
	AttachComponent(skel);
	Mesh.AttachComponentToSocket(skel, 'Shovel');
	skel.SetShadowParent(Mesh);
	skel.SetLightEnvironment(Mesh.LightEnvironment);
	    
}



