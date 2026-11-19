class MOHAAnimPlayByLevel extends MOHAAnimPlayByBase
    native
    hidecategories(Object,Object,Object,Object,AnimNodeBlendList);

var int currentChild;

event int GetChildIndexToPlay()
{
    local int I;

    currentChild = 0;
    // End:0xCE
    if(((SkelComponent != none) && SkelComponent.Owner != none) && MOHAPlayerPawn(SkelComponent.Owner) != none)
    {
        I = 0;
        J0x4A:

        // End:0xCE [Loop If]
        if(I < Children.Length)
        {
            // End:0xC4
            if((Children[I].Anim != none) && Children[I].Anim.NodeName == MOHAPlayerPawn(SkelComponent.Owner).ITPLevelName)
            {
                currentChild = I;
                // [Explicit Break]
                goto J0xCE;
            }
            ++I;
            // [Loop Continue]
            goto J0x4A;
        }
    }
    J0xCE:

    return currentChild;
    //return ReturnValue;    
}

function float GetCurrentAnimPosition()
{
    local AnimNodeSequence animNodeSeq;
    local float retval, animlength;

    // End:0xDE
    if((Children[currentChild].Anim != none) && AnimNodeSequence(Children[currentChild].Anim) != none)
    {
        animNodeSeq = AnimNodeSequence(Children[currentChild].Anim);
        // End:0xAA
        if(animNodeSeq.AnimSeq != none)
        {
            animlength = animNodeSeq.AnimSeq.SequenceLength / animNodeSeq.AnimSeq.RateScale;            
        }
        else
        {
            animlength = 0.0000000;
        }
        retval = animNodeSeq.GetNormalizedPosition() * animlength;
        return retval;        
    }
    else
    {
        return 0.0000000;
    }
    //return ReturnValue;    
}

function float GetCurrentAnimLength()
{
    local AnimNodeSequence animNodeSeq;
    local float retval;

    retval = 0.0000000;
    // End:0xB2
    if((Children[currentChild].Anim != none) && AnimNodeSequence(Children[currentChild].Anim) != none)
    {
        animNodeSeq = AnimNodeSequence(Children[currentChild].Anim);
        // End:0xB2
        if(animNodeSeq.AnimSeq != none)
        {
            retval = animNodeSeq.AnimSeq.SequenceLength / animNodeSeq.AnimSeq.RateScale;
        }
    }
    return retval;
    //return ReturnValue;    
}

defaultproperties
{
    Children=/* Array type was not detected. */
}