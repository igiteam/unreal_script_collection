class R6InteractLocationsConfig extends R6Config
    native
    hidecategories(Object);

var(Climb) float m_fClimbWallOffset;
var(Climb) float m_fClimbSideMargins;
var(Climb) float m_fClimbMinHeight;
var(Climb) float m_fClimbMaxHeight;
var(Rappel) Vector m_vAttachTopRappel;
var(Rappel) Vector m_vAttachBottomRappel;
var(Rappel) Vector m_vAttachWindowRappel;
var(Rappel) Vector m_vRappelRopeDrop;
var(Rappel) float m_fDettachTopRappel;
var(Rappel) float m_fDettachBottomRappel;
var(Rappel) float m_fInteractRappelRopeRadius;
var(Rappel) float m_fInteractRappelRopeOffset;
var(FastRope) Vector m_vAttachFastRope;
var(FastRope) Vector m_vAttachFastRopeChopper;
var(FastRope) float m_fDettachFastRope;
var(Door) Vector m_vBreachingDoor;
var(Door) Vector m_vSnakeCamDoor;
var(Ladder) Vector m_vAttachClimbUpLadder;
var(Ladder) Vector m_vAttachClimbDownLadder;
var(Ladder) float m_fDettachSlideDownLadder;
var(Ladder) float m_fMinHeightSlideLadder;
var(Ladder) /*0x20000000-0x00000000*/ int m_iRotationRangeInteractLadder;
var(Ladder) float m_fInteractHeightOffsetLadder;
var(Window) Vector m_vClimbWindow;
var(Window) float m_fClimbWindowMargin;
var(BlockingVol) float m_fOffsetOpenPullFar;
var(BlockingVol) float m_fExtraSizeOpenPullFar;
var(BlockingVol) float m_fOffsetTcPeek;
var(BlockingVol) float m_fOffsetTcPeekExposedHor;
var(BlockingVol) float m_fOffsetTcPeekExposedVer;
var(BlockingVol) float m_fExtraSizeTcPeekExposed;
var(Replenish) float m_fReplenishOffset;
var(Replenish) /*0x20000000-0x00000000*/ int m_iRotationRangeInteractReplenish;
var(Refit) float m_fRefitOffset;
var(Refit) /*0x20000000-0x00000000*/ int m_iRotationRangeInteractRefit;
var(Turret) /*0x20000000-0x00000000*/ int m_iRotationRangeInteractTurret;
var(Geo) /*0x20000000-0x00000000*/ int m_iRotationRangeInteractGeo;
var(Distances) float m_fWindowHeight;
var(Distances) float m_fRailingHeight;
var(Incapacitation) float m_fReviveRadius;
var(DepotStation) /*0x20000000-0x00000000*/ int m_iRotationRangeInteractDepotStation;

defaultproperties
{
    m_fClimbWallOffset=42.0000000
    m_fClimbSideMargins=50.0000000
    m_fClimbMinHeight=112.0000000
    m_fClimbMaxHeight=144.0000000
    m_vAttachTopRappel=(X=-73.0000000,Y=5.0000000,Z=0.0000000)
    m_vAttachBottomRappel=(X=45.0000000,Y=-2.5000000,Z=0.0000000)
    m_vAttachWindowRappel=(X=-95.0000000,Y=10.0000000,Z=0.0000000)
    m_vRappelRopeDrop=(X=16.0000000,Y=0.0000000,Z=0.0000000)
    m_fDettachTopRappel=170.0000000
    m_fDettachBottomRappel=105.0000000
    m_fInteractRappelRopeRadius=30.0000000
    m_fInteractRappelRopeOffset=10.0000000
    m_vAttachFastRope=(X=-73.0000000,Y=0.0000000,Z=0.0000000)
    m_vAttachFastRopeChopper=(X=-80.0000000,Y=0.0000000,Z=0.0000000)
    m_fDettachFastRope=240.0000000
    m_vBreachingDoor=(X=0.0000000,Y=30.0000000,Z=0.0000000)
    m_vSnakeCamDoor=(X=0.0000000,Y=25.0000000,Z=0.0000000)
    m_vAttachClimbUpLadder=(X=62.0000000,Y=2.0000000,Z=0.0000000)
    m_vAttachClimbDownLadder=(X=100.0000000,Y=3.0000000,Z=0.0000000)
    m_fDettachSlideDownLadder=90.0000000
    m_fMinHeightSlideLadder=180.0000000
    m_iRotationRangeInteractLadder=16384
    m_fInteractHeightOffsetLadder=100.0000000
    m_vClimbWindow=(X=0.0000000,Y=60.0000000,Z=0.0000000)
    m_fClimbWindowMargin=57.0000000
    m_fOffsetOpenPullFar=50.0000000
    m_fExtraSizeOpenPullFar=20.0000000
    m_fOffsetTcPeek=50.0000000
    m_fOffsetTcPeekExposedHor=50.0000000
    m_fOffsetTcPeekExposedVer=50.0000000
    m_fExtraSizeTcPeekExposed=80.0000000
    m_fReplenishOffset=-100.0000000
    m_iRotationRangeInteractReplenish=32768
    m_fRefitOffset=-100.0000000
    m_iRotationRangeInteractRefit=32768
    m_iRotationRangeInteractTurret=32768
    m_iRotationRangeInteractGeo=29491
    m_fWindowHeight=112.0000000
    m_fRailingHeight=96.0000000
    m_fReviveRadius=100.0000000
    m_iRotationRangeInteractDepotStation=13654
}