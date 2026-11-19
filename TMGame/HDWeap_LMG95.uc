//-----------------------------------------------------------
//
//-----------------------------------------------------------
class HDWeap_LMG95 extends HDWeap_LMG;

var SkelControlSingleBone	AimControl;

simulated function PostEquipped()
{
    local SkeletalMeshComponent SkelCpnt;
    SkelCpnt = SkeletalMeshComponent(Mesh);
    if ( SkelCpnt != none )
      AimControl = SkelControlSingleBone( SkelCpnt.FindSkelControl('AimControl') );
}


simulated function ChangeZoomFunction( bool bUp )
{
	if ( ZoomState != ZST_Zoomed ) return;
	AimControl.SetSkelControlActive(bUp);
}

simulated event Tick( float deltaTime )
{
    Super.Tick(deltaTime);
    if ( AimControl == none )
        PostEquipped();
}

simulated state WeaponEquipping
{
	simulated function WeaponEquipped()
	{
       PostEquipped();
       Super.WeaponEquipped();
	}
}


// HD End
