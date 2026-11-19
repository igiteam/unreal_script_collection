// HD Begin
class HDWeap_95Rifle	extends HDWeap_AssaultRifle;

var SkelControlSingleBone	AimControl;

simulated function PostEquipped()
{
    local SkeletalMeshComponent SkelCpnt;
    SkelCpnt = SkeletalMeshComponent(Mesh);
    if ( SkelCpnt != none )
      AimControl = SkelControlSingleBone( SkelCpnt.FindSkelControl('AimControl') );
}

// change zoom function
simulated function ChangeZoomFunction( bool bUp )
{
	if ( ZoomState != ZST_Zoomed ) return;
	if ( AimControl != None )
        AimControl.SetSkelControlActive(bUp);
}

simulated event Tick( float deltaTime )
{
    Super.Tick(deltaTime);
}

// HD End
