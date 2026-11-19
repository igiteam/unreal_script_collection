class HodNode extends HodEntity
	native(TG);


var Actor data;
var name approachtype;
var vector offset;
var Ternary crouchingIsOK;
var bool script_onlyidle;

var bool allow_stand;
var bool allow_crouch;
var bool allow_prone;

function set(Actor node)
{
	local HodPathNode lPathNode;
	local CoverSlotMarker lCoverSlot;
	local array<ECoverAction> Actions;

	allow_stand = true;
	allow_crouch = true;
	allow_prone = false;

	data = node;
	crouchingIsOK = TernaryUndefined;
	if (IsValid())
	{
		angles.pitch = node.rotation.pitch / 182.04;
		angles.yaw = AngleClamp360(node.rotation.yaw / 182.04);
		angles.roll = node.rotation.roll / 182.04;
		origin = node.GetOrigin() + vect(0, 0, 1);
		type = 'Path';
	}

	lPathNode = HodPathNode(data);
	if (lPathNode != none)
	{
		type = lPathNode.hodNodeType;
	}

	lCoverSlot = CoverSlotMarker(node);
	if (lCoverSlot != none)
	{
		switch (lCoverSlot.OwningSlot.Link.Slots[lCoverSlot.OwningSlot.SlotIdx].CoverType)
		{
		case CT_MidLevel:
			type = 'Cover Crouch';
			lCoverSlot.OwningSlot.Link.GetSlotActions(lCoverSlot.OwningSlot.SlotIdx, Actions);
			if (Actions.Find(CA_PeekLeft) != -1)
			{
				type = 'Cover Left';
				allow_stand = false;
			}
			else if (Actions.Find(CA_PeekRight) != -1)
			{
				type = 'Cover Right';
				allow_stand = false;
			}
			else if (CoverCanStand())
				type = 'Cover Stand';
			//origin.z -= 1;
			break;

		case CT_Standing:
			lCoverSlot.OwningSlot.Link.GetSlotActions(lCoverSlot.OwningSlot.SlotIdx, Actions);
			if (Actions.Find(CA_PeekLeft) != -1)
				type = 'Cover Left';
			else if (Actions.Find(CA_PeekRight) != -1)
				type = 'Cover Right';
			else
				type = 'Path';
			break;

		default:
			type = 'Path';
		}

	}

	if (type == 'Path')
		allow_prone = true;

	offset = invalid_vector;
}

native function bool CoverCanStand();

function bool IsValid()
{
	return data != none;
}

function bool DoesNodeAllowStance(name stance)
{
	// need fix
	//assert (false);
	switch (stance)
	{
	case 'stand':
		return allow_stand;

	case 'crouch':
		return allow_crouch;

	case 'prone':
		return allow_prone;
	//case 'Cover Left':
	//case 'Cover Right':
	//	if (stance == 'stand')
	//		return allow_stand;
	//	return allow_crouch;

	default:
		return true;
	}
	return true;
}

function bool IsNodeDontStand()
{
	return !allow_stand;
	//return false;
}

function bool IsNodeDontCrouch()
{
	return !allow_crouch;
	//return true;
}

function bool IsNodeDontProne()
{
	return !allow_prone;
	//return true;
}
