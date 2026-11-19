class SPAnimNotify_Footstep extends AnimNotify_Footstep
    native
    config(Game)
    editinlinenew
    collapsecategories;

var SPPhysicalMaterial DefaultMaterial;
var config float MaxAudibleDist;
var config float MaxAudibleDistForNotVisible;

defaultproperties
{
    DefaultMaterial=SPPhysicalMaterial'PAN_Physical_Materials.Default.SP_PhysicalMaterial_Default'
    MaxAudibleDist=2000.0000000
    MaxAudibleDistForNotVisible=200.0000000
}