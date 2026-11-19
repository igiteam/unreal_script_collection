class R6NavMeshNote extends Note
    native
    placeable
    hidecategories(lighting,Actor,Advanced,Collision,Display,Events,Fire,Movement,Object,Actor,Advanced,Collision,Display,Events,Fire,Movement,Object)
    autoexpandcategories(Note);

enum eERROR_NM_TYPE
{
    eERROR_NM_ADJTRIANGLE,          // 0
    eERROR_NM_INVALIDCONNECTION,    // 1
    eERROR_NM_MAX                   // 2
};

var R6NavMeshNote.eERROR_NM_TYPE m_eErrorType;

defaultproperties
{
    bHidden=false
}