class EvilAnimBlendByMoveMode extends UDKAnimBlendBase
    native(Anim)
    hidecategories(Object,Object,Object,Object);

var protected int LastFootDown;
var protected float LastFootDownTime;
var EvilPawn MyEvilPawn;
var Vector SlowDownStart;
var bool bMasterMoveBlendNode;

event OnInit()
{
    local EvilTypesNative.EMoveMode mm;
    local string S;
    local name N;
    local int I;
    local bool bWarnedNames, bCanRemoveExcess;

    super(AnimNode).OnInit();
    // End:0x26
    if(bPlayActiveChild == false)
    {
        bPlayActiveChild = true;
    }
    MyEvilPawn = EvilPawn(SkelComponent.Owner);
    // End:0x3B4
    filtereditoronly
    {
        mm = 0;
        J0x66:

        // End:0x26E [Loop If]
        if(int(mm) < int(6))
        {
            S = string(mm);
            S = Right(S, Len(S) - 4);
            N = name(S);
            // End:0x123
            if(int(mm) >= Children.Length)
            {
                Children.Add(1);                
                Children[int(mm)].Name = N;                
            }
            else
            {
                // End:0x168
                if(Children.Length == 1)
                {
                    Children[int(mm)].Name = N;                    
                }
                else
                {
                    // End:0x24E
                    if(Children[int(mm)].Name != N)
                    {
                        bWarnedNames = true;
                        // End:0x24E
                        if(InStr(string(Children[int(mm)].Name), "(!", true) < 0)
                        {
                            Children[int(mm)].Name = name(((S @ "(!") $ string(Children[int(mm)].Name)) $ ")");
                        }
                    }
                }
            }
            mm = byte(int(mm) + int(1));
            // [Loop Continue]
            goto J0x66;
        }
        bCanRemoveExcess = true;
        I = int(mm);
        J0x28F:

        // End:0x38C [Loop If]
        if(I < Children.Length)
        {
            // End:0x339
            if(InStr(string(Children[int(mm)].Name), "!", true) < 0)
            {
                Children[int(mm)].Name = name("!" $ string(Children[int(mm)].Name));
            }
            bCanRemoveExcess = bCanRemoveExcess && Children[int(mm)].Anim == none;
            ++I;
            // [Loop Continue]
            goto J0x28F;
        }
        // End:0x3B4
        if(bCanRemoveExcess)
        {
            Children.Remove(6, Children.Length - 6);            
        }
    }
    // End:0x3C5
    if(Children.Length != 6)
    {
    }
    //return;    
}

simulated event TickAnim(float DeltaSeconds)
{
    local int DesiredChildIndex, LastChildIndex;
    local bool bCustomBlendTime;
    local EvilTypesNative.EMoveMode mm;

    // End:0x11
    if(MyEvilPawn == none)
    {
        return;
    }
    bCustomBlendTime = MyEvilPawn.CustomMoveModeBlendTime >= 0.0000000;
    LastChildIndex = ActiveChildIndex;
    DesiredChildIndex = int(MyEvilPawn.CurrentMoveMode);
    // End:0x2B3
    if(DesiredChildIndex != ActiveChildIndex)
    {
        // End:0x195
        if((Children.Length > DesiredChildIndex) && Children[DesiredChildIndex].Anim != none)
        {
            // End:0x149
            if(ChildBlendTimes.Length > DesiredChildIndex)
            {
                SetActiveChild(DesiredChildIndex, ((bCustomBlendTime) ? MyEvilPawn.CustomMoveModeBlendTime : ChildBlendTimes[DesiredChildIndex]));                
            }
            else
            {
                SetActiveChild(DesiredChildIndex, ((bCustomBlendTime) ? MyEvilPawn.CustomMoveModeBlendTime : BlendTime));
            }            
        }
        else
        {
            SetActiveChild(1, ((bCustomBlendTime) ? MyEvilPawn.CustomMoveModeBlendTime : BlendTime));
            mm = byte(ActiveChildIndex);
            mm = byte(DesiredChildIndex);
        }
        // End:0x2B3
        if(bMasterMoveBlendNode)
        {
            // End:0x2B3
            if((ActiveChildIndex == 1) || ActiveChildIndex == 2)
            {
                // End:0x2A9
                if((LastChildIndex == 0) && (MyEvilPawn.TurnInPlaceNode == none) || !MyEvilPawn.TurnInPlaceNode.bPlayingTurnTransition)
                {
                    OnFootstep(0);
                }
                SynchronizeWalkCycle();
            }
        }
    }
    // End:0x2F3
    if(bMasterMoveBlendNode && bCustomBlendTime)
    {
        MyEvilPawn.CustomMoveModeBlendTime = -1.0000000;
    }
    //return;    
}

simulated function OnFootstep(int FootDown)
{
    LastFootDown = FootDown;
    LastFootDownTime = MyEvilPawn.WorldInfo.TimeSeconds;
    //return;    
}

protected simulated function FindEarliestFootstep(AnimSequence Seq, int Foot, out float Earliest)
{
    local int I;

    I = 0;
    J0x0B:

    // End:0x197 [Loop If]
    if(I < Seq.Notifies.Length)
    {
        // End:0xFB
        if(!Seq.Notifies[I].Notify.IsA('AnimNotify_Footstep') || AnimNotify_Footstep(Seq.Notifies[I].Notify).FootDown != Foot)
        {            
        }
        else
        {
            // End:0x189
            if(Seq.Notifies[I].Time < Earliest)
            {
                Earliest = Seq.Notifies[I].Time;
            }
        }
        ++I;
        // [Loop Continue]
        goto J0x0B;
    }
    //return;    
}

protected simulated function SynchronizeWalkCycle()
{
    local array<AnimNodeSequence> SeqArr;
    local AnimNodeSequence Seq;
    local float Earliest, SeqLen;

    Earliest = 3.4000000 * (10.0000000 ** 38.0000000);
    GetChildrenAtIndex(SeqArr);
    // End:0xE5
    if(SeqArr.Length > 0)
    {
        // End:0xE1
        foreach SeqArr(Seq)
        {
            // End:0xA6
            if((Seq.AnimSeq == none) || !Seq.bRelevant)
            {
                continue;                
            }
            else
            {
                FindEarliestFootstep(Seq.AnimSeq, LastFootDown, Earliest);                
            }
        }                
    }
    else
    {
        return;
    }
    // End:0x28D
    if((Earliest < (3.4000000 * (10.0000000 ** 38.0000000))) && Seq != none)
    {
        Earliest += (MyEvilPawn.WorldInfo.TimeSeconds - LastFootDownTime);
        SeqLen = Seq.GetAnimPlaybackLength() / Seq.Rate;
        // End:0x1F0
        if(Earliest > SeqLen)
        {
            J0x1C2:

            // End:0x1F0 [Loop If]
            if(Earliest > SeqLen)
            {
                Earliest -= SeqLen;
                // [Loop Continue]
                goto J0x1C2;
            }
        }
        // End:0x28C
        foreach SeqArr(Seq)
        {
            Seq.StopAnim();
            Seq.PlayAnim(Seq.bLooping, Seq.Rate, Earliest);            
        }        
    }
    //return;    
}

simulated function AnimNodeSequence GetActiveChild()
{
    return AnimNodeSequence(Children[ActiveChildIndex].Anim);
    //return ReturnValue;    
}

simulated function GetChildrenAtIndex(out array<AnimNodeSequence> Nodes, optional int Index = -1)
{
    local AnimNode N;
    local AnimNodeSequence C;
    local int I;

    // End:0x2B
    if(Index < 0)
    {
        Index = ActiveChildIndex;
    }
    N = Children[Index].Anim;
    // End:0x6C
    if(N == none)
    {
        return;
    }
    // End:0xB1
    if(N.IsA('AnimNodeSequence'))
    {
        Nodes.AddItem(AnimNodeSequence(N));                
    }
    else
    {
        // End:0x129
        if(N.IsA('AnimNodeAdditiveBlending'))
        {
            Nodes.AddItem(AnimNodeSequence(AnimNodeAdditiveBlending(N).Children[0].Anim));                        
        }
        else
        {
            // End:0x2B6
            if(Children[ActiveChildIndex].Anim.IsA('AnimNodeBlendDirectional'))
            {
                Nodes.AddItem(AnimNodeSequence(AnimNodeBlendDirectional(N).Children[0].Anim));                
                Nodes.AddItem(AnimNodeSequence(AnimNodeBlendDirectional(N).Children[1].Anim));                
                Nodes.AddItem(AnimNodeSequence(AnimNodeBlendDirectional(N).Children[2].Anim));                
                Nodes.AddItem(AnimNodeSequence(AnimNodeBlendDirectional(N).Children[3].Anim));                                
            }
            else
            {
                // End:0x3C1
                if(Children[ActiveChildIndex].Anim.IsA('AnimNodeBlendBase'))
                {
                    I = 0;
                    J0x301:

                    // End:0x3C1 [Loop If]
                    if(I < AnimNodeBlendBase(N).Children.Length)
                    {
                        C = AnimNodeSequence(AnimNodeBlendBase(N).Children[I].Anim);
                        // End:0x3B3
                        if(C != none)
                        {
                            Nodes.AddItem(C);                            
                        }
                        ++I;
                        // [Loop Continue]
                        goto J0x301;
                    }
                }
            }
        }
    }
    //return;    
}

simulated function SetActiveChildRootExtract(bool bTranslate, bool bRotateActor)
{
    local array<AnimNodeSequence> SeqArr;
    local AnimNodeSequence Seq;

    GetChildrenAtIndex(SeqArr);
    // End:0x1C8
    foreach SeqArr(Seq)
    {
        // End:0xE6
        if(bTranslate)
        {
            // End:0xE3
            if(((int(Seq.RootBoneOption[0]) == int(1)) || int(Seq.RootBoneOption[1]) == int(1)) || int(Seq.RootBoneOption[2]) == int(1))
            {
                Seq.SetRootBoneAxisOption(2, 2, 2);
            }            
        }
        else
        {
            // End:0x191
            if(((int(Seq.RootBoneOption[0]) == int(2)) || int(Seq.RootBoneOption[1]) == int(2)) || int(Seq.RootBoneOption[2]) == int(2))
            {
                Seq.SetRootBoneAxisOption(1, 1, 1);
            }
        }
        Seq.SetRootBoneRotationOption(0, 0, ((bRotateActor) ? 2 : 0));        
    }    
    //return;    
}

defaultproperties
{
    bTickAnimInScript=true
    bFixNumChildren=true
    bCallScriptEventOnInit=true
    NodeName="MoveModeBlend"
}