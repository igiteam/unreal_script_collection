class SkyAnimNotify_FreezeBot extends SkyAnimNotify_Reversible
    config(Engine)
    editinlinenew
    collapsecategories;

enum EFreezeBot
{
    FREEZEBOT_FREEZE,               // 0
    FREEZEBOT_UNFREEZE,             // 1
    FREEZEBOT_DONOTHING,            // 2
    FREEZEBOT_MAX                   // 3
};

var() SkyAnimNotify_FreezeBot.EFreezeBot FreezeBot;
var() SkyAnimNotify_FreezeBot.EFreezeBot FreezeBrain;
var() bool bAllowFrozenFiring;
var() bool bAllowFrozenFacingUpdate;

event Notify(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
    local Pawn P;
    local SkyBot SB;

    P = Pawn(Owner);
    // End:0xF8
    if(P != none)
    {
        SB = SkyBot(P.Controller);
        // End:0xF8
        if(SB != none)
        {
            switch(FreezeBot)
            {
                // End:0x82
                case 0:
                    SB.bAllowFrozenFacingUpdate = bAllowFrozenFacingUpdate;
                    SB.Freeze(true, bAllowFrozenFiring);
                    // End:0xAB
                    break;
                // End:0xA0
                case 1:
                    SB.Freeze(false);
                    // End:0xAB
                    break;
                // End:0xA5
                case 2:
                // End:0xFFFF
                default:
                    // End:0xAB
                    break;
                    break;
            }
            switch(FreezeBrain)
            {
                // End:0xD0
                case 0:
                    SB.BrainFreeze(true);
                    // End:0xF8
                    break;
                // End:0xED
                case 1:
                    SB.BrainFreeze(false);
                    // End:0xF8
                    break;
                // End:0xF2
                case 2:
                // End:0xFFFF
                default:
                    // End:0xF8
                    break;
                    break;
            }
        }
    }
    super(AnimNotify_Scripted).Notify(Owner, AnimSeqInstigator);
    //return;    
}

event Reverse(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
    local Pawn P;
    local SkyBot SB;

    P = Pawn(Owner);
    // End:0xF8
    if(P != none)
    {
        SB = SkyBot(P.Controller);
        // End:0xF8
        if(SB != none)
        {
            switch(FreezeBot)
            {
                // End:0x66
                case 0:
                    SB.Freeze(false);
                    // End:0xAB
                    break;
                // End:0xA0
                case 1:
                    SB.bAllowFrozenFacingUpdate = bAllowFrozenFacingUpdate;
                    SB.Freeze(true, bAllowFrozenFiring);
                    // End:0xAB
                    break;
                // End:0xA5
                case 2:
                // End:0xFFFF
                default:
                    // End:0xAB
                    break;
                    break;
            }
            switch(FreezeBrain)
            {
                // End:0xD0
                case 0:
                    SB.BrainFreeze(false);
                    // End:0xF8
                    break;
                // End:0xED
                case 1:
                    SB.BrainFreeze(true);
                    // End:0xF8
                    break;
                // End:0xF2
                case 2:
                // End:0xFFFF
                default:
                    // End:0xF8
                    break;
                    break;
            }
        }
    }
    super.Reverse(Owner, AnimSeqInstigator);
    //return;    
}
