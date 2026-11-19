class R6GeoLedge extends R6Geo
    native
    hidecategories(lighting,Object,Movement,Display,Actor,Advanced,Collision,R6SoundPropagation,R6Sound,Heat,Brush,Volume,PhysicsVolume,Attachment,NavMeshGeneration);

var float m_fHeight;
var Vector m_vDir;
var bool m_bIsNarrow;

simulated function bool BlocksView()
{
    return true;
    return;
}

simulated function bool DisableCameraMoveWhileUsing()
{
    return false;
    return;
}

simulated event bool GetInteractDesc(out R6EngineEnums.ER6InteractDesc eDesc, optional PlayerController PC)
{
    eDesc = 19;
    return true;
    return;
}

simulated event bool GetBusyInteractDesc(out R6EngineEnums.ER6InteractDesc eDesc, PlayerController PC)
{
    // End:0x1E
    if(PC.Pawn.IsInTakeCover())
    {
        return false;
    }
    eDesc = 19;
    return true;
    return;
}
