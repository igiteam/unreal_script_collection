class R6BulletFlyby extends Actor
    native
    notplaceable
    hidecategories(lighting);

var Vector m_vStartPos;
var Vector m_vEndPos;
var Vector m_vCurrentPos;
var Vector m_fDirection;
var float m_fLength;
var float m_fTime;

// Export UR6BulletFlyby::execPlaySoundFlyby(FFrame&, void* const)
native final function PlaySoundFlyby(const out Vector vStart, const out Vector vEnd);

defaultproperties
{
    bHidden=true
    TickGroup=1
}