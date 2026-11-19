class SPAnimBlendDirectionalNode extends SPAnimBaseNode
    native;

/** Allows control over how quickly the directional blend should be allowed to change. */
var() float DirDegreesPerSecond;
var float DirAngle;

event EnableFootsteps(AnimNode an, bool Set)
{
    local SPAnimNodeSequence Seq;

    Seq = SPAnimNodeSequence(an);
    // End:0x32
    if(Seq != none)
    {
        Seq.m_EnableFootsteps = Set;
    }
    //return;    
}
