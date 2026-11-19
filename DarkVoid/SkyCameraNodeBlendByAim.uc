class SkyCameraNodeBlendByAim extends SkyCameraNodeBlendList
    native;

enum ECameraBlendByAim
{
    CamBlendByAim_UpLeft,           // 0
    CamBlendByAim_UpCenter,         // 1
    CamBlendByAim_UpRight,          // 2
    CamBlendByAim_CenterLeft,       // 3
    CamBlendByAim_CenterCenter,     // 4
    CamBlendByAim_CenterRight,      // 5
    CamBlendByAim_DownLeft,         // 6
    CamBlendByAim_DownCenter,       // 7
    CamBlendByAim_DownRight,        // 8
    CamBlendByAim_MAX               // 9
};

var() Vector2D m_vAim;
var() float m_fAccelRate;
var() float m_fDecelRate;
var Vector2D m_vPrevVel;
var Vector2D m_vPrevPos;
var() float m_fMaxSpeed;
var float m_fHighestSpeed;
var float m_fThreshold;
