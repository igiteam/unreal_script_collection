class SkyExplosionLightBeamWeapon extends SkyExplosionLight
    editinlinenew
    collapsecategories;

var array<LightValues> RedTeamTimeShift;
var array<LightValues> BlueTeamTimeShift;

function SetTeam(byte NewTeam)
{
    switch(NewTeam)
    {
        // End:0x1B
        case 0:
            TimeShift = RedTeamTimeShift;
            // End:0x3F
            break;
        // End:0x2E
        case 1:
            TimeShift = BlueTeamTimeShift;
            // End:0x3F
            break;
        // End:0xFFFF
        default:
            TimeShift = default.TimeShift;
            // End:0x3F
            break;
            break;
    }
    //return;    
}
