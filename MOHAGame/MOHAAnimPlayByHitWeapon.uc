class MOHAAnimPlayByHitWeapon extends MOHAAnimPlayByBase
    hidecategories(Object,Object,Object,Object,AnimNodeBlendList);

var() array< class<MOHADamageType> > Weapons;

event int GetChildIndexToPlay()
{
    local int Index, I, Length;
    local class<DamageType> dtype;

    Index = 0;
    // End:0x2E
    if((none == SkelComponent) || none == SkelComponent.Owner)
    {
        return Index;
    }
    // End:0x6C
    if(none != MOHAAIPawn(SkelComponent.Owner))
    {
        dtype = MOHAAIPawn(SkelComponent.Owner).LastHitDamageType;        
    }
    else
    {
        // End:0xAA
        if(none != MOHAMultiplayerPawn(SkelComponent.Owner))
        {
            dtype = MOHAMultiplayerPawn(SkelComponent.Owner).LastHitDamageType;            
        }
        else
        {
            dtype = none;
        }
    }
    // End:0x14B
    if(dtype != none)
    {
        Length = ((Weapons.Length > (Children.Length - 1)) ? Children.Length - 1 : Weapons.Length);
        I = 0;
        J0xEE:

        // End:0x14B [Loop If]
        if(I < Length)
        {
            // End:0x141
            if((Children[I + 1].Anim != none) && ClassIsChildOf(dtype, Weapons[I]))
            {
                Index = I + 1;
            }
            ++I;
            // [Loop Continue]
            goto J0xEE;
        }
    }
    return Index;
    //return ReturnValue;    
}

defaultproperties
{
    Children=/* Array type was not detected. */
}