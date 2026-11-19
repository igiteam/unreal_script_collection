class TPAssaultBlimp extends TPAssaultBlimp_Persistent
	placeable;

function NotifyRappel(WehrmachtPawn wehr)
{
    local int i;

    for (i = 0; i < WehrmachtL.Length; i++)
    {
        if (wehr == WehrmachtL[i])
        {
            Mesh.AttachComponentToSocket(RopesL[i],RopeSocketsL[i]);
            RopesL[i].PlayAnim('BlimpRope_Unfurl');
        }
    }

    for (i = 0; i < WehrmachtR.Length; i++)
    {
        if (wehr == WehrmachtR[i])
        {
            Mesh.AttachComponentToSocket(RopesR[i],RopeSocketsR[i]);
            RopesR[i].PlayAnim('BlimpRope_Unfurl');
        }
    }
}

function NotifyDescent(WehrmachtPawn wehr)
{
    local int i;

    for (i = 0; i < WehrmachtL.Length; i++)
    {
        if (wehr == WehrmachtL[i])
        {
            RopesL[i].PlayAnim('BlimpRope_SlideDown');
        }
    }

    for (i = 0; i < WehrmachtR.Length; i++)
    {
        if (wehr == WehrmachtR[i])
        {
            RopesR[i].PlayAnim('BlimpRope_SlideDown');
        }
    }
}

function NotifyLand (WehrmachtPawn wehr)
{
    local int i;

    for (i = 0; i < WehrmachtL.Length; i++)
    {
        if (wehr == WehrmachtL[i])
        {
            WehrmachtL[i] = None;
            RopesL[i].PlayAnim('BlimpRope_Curl');
        }
    }

    for (i = 0; i < WehrmachtR.Length; i++)
    {
        if (wehr == WehrmachtR[i])
        {
            WehrmachtR[i] = None;
            RopesR[i].PlayAnim('BlimpRope_Curl');
        }
    }
}

event OnAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
    local int i;

    if (SeqNode.AnimSeqName == 'BlimpRope_Unfurl')
    {
        for (i = 0; i < RopesL.Length; i++)
        {
            if (RopesL[i].Animations == SeqNode)
            {
                RopesL[i].PlayAnim('BlimpRope_Idle');
                return;
            }
        }

        for (i = 0; i < RopesR.Length; i++)
        {
            if (RopesR[i].Animations == SeqNode)
            {
                RopesR[i].PlayAnim('BlimpRope_Idle');
                return;
            }
        }
    }

    if (SeqNode.AnimSeqName == 'BlimpRope_Curl')
    {
        for (i = 0; i < RopesL.Length; i++)
        {
            if (RopesL[i].Animations == SeqNode)
            {
                Mesh.DetachComponent(RopesL[i]);
                return;
            }
        }

        for (i = 0; i < RopesR.Length; i++)
        {
            if (RopesR[i].Animations == SeqNode)
            {
                Mesh.DetachComponent(RopesR[i]);
                return;
            }
        }
    }
}

