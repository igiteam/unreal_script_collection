class R6InteractiveDoorSliding extends R6InteractiveDoor
    native
    config(Game)
    placeable
    hidecategories(lighting);

enum ESlideOpeningDirection
{
    SLIDE_DIR_Left,                 // 0
    SLIDE_DIR_Right,                // 1
    SLIDE_DIR_MAX                   // 2
};

var(R6Door) R6InteractiveDoorSliding.ESlideOpeningDirection m_eOpeningDirection;
var(R6Door) float m_fStartOpening;
var(R6Door) float m_fTurnSomeIncrement;
var float m_fCurrentOpening;

// Export UR6InteractiveDoorSliding::execUpdateOpening(FFrame&, void* const)
native final function UpdateOpening(float fOpening);

function ResetOriginalData()
{
    ResetOriginalData();
    UpdateOpening(m_fStartOpening);
    return;
}

simulated function PostBeginPlay()
{
    PostBeginPlay();
    // End:0x2A
    if(m_fStartOpening != float(0))
    {
        bCollideWorld = false;
        UpdateOpening(m_fStartOpening);        
    }
    else
    {
        // End:0x45
        if(m_pVolume != none)
        {
            m_pVolume.EnableCollide(false);
        }
    }
    return;
}

event SlideSomeBy(Actor pTurner, int iOpen)
{
    return;
}
