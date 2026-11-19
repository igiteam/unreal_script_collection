class R6PlayerOptionsManager extends R6Config
    native
    hidecategories(Object);

var() array<R6PlayerOptions> m_aExistingProfiles;
var string m_szProfileForPlayer[2];

defaultproperties
{
    m_szThumbnailTexture="KellerEditorMaterials.DontTouch"
    m_szDescription="Player options"
}