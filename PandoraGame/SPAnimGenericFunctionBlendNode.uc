class SPAnimGenericFunctionBlendNode extends SPAnimBaseNode
    native;

/** Enums Variable Declaration the name of the function to call during the tick */
var() name functionName;
/** This is the amount of time in seconds that it will take to reach the desired target weights for all children.If your target weights are constantly changing and this time is greater than 0, it may never reach the target weight.In that case, it will have a "rubberband" effect, always chasing the target but never reaching it, until either the transition timebecomes small enough or the target weights stay constant for long enough. */
var() float TransitionTime;
/** These generic modifiers are exposed to the editor so that you may modify various aspects of the animation by accessing these variables in your callback function.  Using these variables is totally optional and will depend on your needs for the logic in your callback function */
var() float Modifier1;
var() float Modifier2;
var() float Modifier3;

event GenericFunctionBlendProto(SPAnimGenericFunctionBlendNode Node)
{
    //return;    
}

event SetRateModifier(int Index, float Rate)
{
    local AnimNodeSequence Sequence;

    // End:0x68
    if((Index >= 0) && Index < Children.Length)
    {
        Sequence = AnimNodeSequence(Children[Index].Anim);
        // End:0x68
        if(Sequence != none)
        {
            Sequence.AnimSeq.RateScale = Rate;
        }
    }
    //return;    
}
