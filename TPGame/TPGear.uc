class TPGear extends Actor
	native;



struct native GearInfoType
{
    var() SkeletalMesh     SkeletalMeshName;
    var() StaticMesh	   StaticMeshName;
    var() PhysicsAsset     PhysicsAssetName;
    var() name             SocketName;
    var() class<Inventory> Inv;
    var() bool             DetachUponDeath;

    structdefaultproperties
    {
        DetachUponDeath=true;
    }
};

var Inventory				Inv;
var SkeletalMeshComponent	Skel;
var StaticMeshComponent		StatMesh;
var bool					Detachable;
var name					SockName;

function AttachTo(Pawn P, GearInfoType GearInfo)
{
    local TPWeapon Weapon;


    Detachable = GearInfo.DetachUponDeath;
    SockName   = GearInfo.SocketName;

    // If an Inventory item is specified, it takes precedence over the skeletal mesh/phyics asset
    if (GearInfo.Inv != None)
    {
        if (ClassIsChildOf (GearInfo.Inv, class'TPWeapon'))
        {
            Weapon = TPWeapon(Spawn(GearInfo.Inv));
            Weapon.AmmoCount      = 0;
            Weapon.AmmoInMagazine = 1;
            Inv = Weapon;
        }
        else
        {
            Inv = Spawn(GearInfo.Inv);
        }

        P.Mesh.AttachComponentToSocket(Inv.DroppedPickupMesh, GearInfo.SocketName);

		Inv.DroppedPickupMesh.SetShadowParent(P.Mesh);
		Inv.DroppedPickupMesh.SetLightEnvironment(P.Mesh.LightEnvironment);
    }
    else if(GearInfo.SkeletalMeshName != None )
    {
		//Instance a skeletal mesh gear piece
        Skel = new class'SkeletalMeshComponent';

        Skel.SetSkeletalMesh(GearInfo.SkeletalMeshName);
        Skel.SetPhysicsAsset(GearInfo.PhysicsAssetName);

        AttachComponent(Skel);
        P.Mesh.AttachComponentToSocket(Skel, GearInfo.SocketName);

		Skel.SetShadowParent(P.Mesh);
		Skel.SetLightEnvironment(P.Mesh.LightEnvironment);
    }
    else if(GearInfo.StaticMeshName != None )
    {
		//Instance a static mesh gear piece
		StatMesh = new class'StaticMeshComponent';
		
		StatMesh.SetStaticMesh(GearInfo.StaticMeshName);
		P.Mesh.AttachComponentToSocket(StatMesh, GearInfo.SocketName);

		StatMesh.SetShadowParent(P.Mesh);
		StatMesh.SetLightEnvironment(P.Mesh.LightEnvironment);
    }
}

function DetachNow(Pawn P, optional float NewLifeSpan = 20)
{
    local vector  SocketLoc;
    local rotator SocketRot;    

    if (Detachable)
    {
        if (Inv != None)
        {
            P.Mesh.GetSocketWorldLocationAndRotation(SockName, SocketLoc, SocketRot);
            P.Mesh.DetachComponent(Inv.DroppedPickupMesh);
            Inv.DropFrom(SocketLoc,P.Velocity);
        }
        else if (Skel != None && Skel.PhysicsAsset != None)
        {
            P.Mesh.DetachComponent(Skel);
            P.Mesh.GetSocketWorldLocationAndRotation(SockName, SocketLoc, SocketRot);            

            SetLocation(SocketLoc);
            AttachComponent (Skel);

            CollisionComponent = Skel;
            
            Skel.SetRBCollidesWithChannel(RBCC_Default, true);
            SetPhysics(PHYS_RigidBody);
            Skel.SetBlockRigidBody(true);
            Skel.SetPhysicsWeight(1.0f);
            Skel.SetHasPhysicsAssetInstance(true);
            Skel.WakeRigidBody();
        }
    }

    SetTimer(NewLifeSpan,,'DestroyMe');
}

function Hide(bool bHide)
{
	if( Skel != None )
		Skel.SetHidden(bHide);
	
	if( StatMesh != None )
		StatMesh.SetHidden(bHide);
}

function DestroyMe ( )
{
    Destroy();
}

function MeshComponent GetComponent()
{
	if( Skel != None )
		return Skel;
		
	if( StatMesh != None )
		return StatMesh;
}


