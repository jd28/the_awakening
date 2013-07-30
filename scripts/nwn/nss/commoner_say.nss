//::///////////////////////////////////////////////
//::
//:: FileName:  commoner_say
//:: Descript:  Makes NPC say something random from
//::            thier converstaion file when they
//::            percieve a PC and when clicked.
//:: requires:  062_npc_say_spawn
//:://////////////////////////////////////////////
/*
Description:
This script is used to make random greetings (or any text you
want) appear over the head of a NPC when they perceive a player
and when they are clicked on.

It is called from within a converstation file you create. You
can use it with 10 lines, 4 lines, or whatever, just change
the constant "N" at the top of the script, and call this script
in the text appears field of each line.

You can also include a dialogue as detailed below

The How-To is at the bottom
*/
//:://////////////////////////////////////////////
//:: Created By: Ranoulf
//:: Created On: 22 Aug. 02
//::
//:: Changed on: 28 Aug. 02
//:://////////////////////////////////////////////

int StartingConditional()  {

    int N = 50;
            //  match this to the number random sayings. If
            //  the NPC has 5 random greetings and a dialogue,
            //  set this to 5 (don't count the dialogue node)

    int iHasDialogue = FALSE;
            //  Change this to True if you want the NPC to also
            //  engage in a normal dialogue, or FALSE if you just
            //  want a radom saying when you click on him

    //  let's track our nodes so we know when we're at the end
    int iNodeNumber = GetLocalInt(OBJECT_SELF,"FS_FLAG_CONVERSATION_NODE");

    //  if the local  doesn't exist yet, our if we have
    //  already been in a conversation, set our selves back to 1
    //  and RESET our Node Number variable.
    if (! iNodeNumber || iNodeNumber > N) {
        SetLocalInt(OBJECT_SELF,"FS_FLAG_CONVERSATION_NODE",1);
        iNodeNumber = 1;
    }

    //  If someone is clicking on us and we have a dialogue, we
    //  need to skip to the end of the conversation file.
    int iSkipOnClick;
    if(iHasDialogue && GetIsObjectValid(GetPCSpeaker()) )
        iSkipOnClick = TRUE;
    else
        iSkipOnClick = FALSE;

    // Now let's see if we should "Talk" by returning true
    if( (! iSkipOnClick)
         //  if we're not skipping to the end
         &&
         //  and our roll came up or this is the last random node
        (Random(N) == N-1  ||  iNodeNumber >= N)
       ) {
         // reset our node counter
       SetLocalInt(OBJECT_SELF,"FS_FLAG_CONVERSATION_NODE",1);
         // and return true, which makes the NPC speak this node
       return TRUE;
    }  // end if

    // Since we didn't talk, lets advance our node counter by one
    else {
        SetLocalInt(OBJECT_SELF,"FS_FLAG_CONVERSATION_NODE",iNodeNumber+1);
        return FALSE;
    }
}   // end function

/*
How-To:

Create the conversation file for the NPCs:

 In the toolset, go over to conversations at the left, right
 click, and select new. In this new conversation, add a bunch of
 nodes right at the top. These are what the NPC will randomly say.
 Don't put any PC responses for them.

 In the "Text Appears When" box of each node, call this script
 (062_farmer_say).

 Save the conversation file as generic_farmer (or some such).

To add a dialogue:

 If you want the NPC to also have a normal dilogue, start it
 after the last random node. DO NOT call this script in that
 node or the NPC will say the entire dialogue.

 In this script, change the iHasDialogue constant at the top
 to TRUE.

Enable the NPCs:

 To get your NPC to talk, you need to change two things.

 1) Use the generic_farmer file as their converstaion.

 2) In their Scripts section set the On Spawn field to
    062_farmer_spawn.

 Now all your farmers have something to say when they see a player!


Other things you should think about:

Other Sets of NPCs:
 You might have farmers, hunters, ranchers and so on. You will
 want to create different conversation files for these groups.
 Unless all your conversation files are the same node length,
 you'll need to save farmer_say as "hunter_say" (for example)
 with a different N (node number). You can still use
 famer_spawn with the new file, our you can create rename it
 NPC_GenTalk_spwn file and use it on all of them.

Perception:
 This script works like clockwork, as long as the NPC isn't moving.
 As soon as you have them walking waypoints,  they only 'see' you
 about 1/3 of the time you think they should. Maybe its supposed to
 be this way?

 BTW - the OnPercieve event doesn't always work like you think it
 should. If you start the game anywhere near the NPC, you have to
 leave their perception (like go behind a building) and come back
 to get it to fire.

The walk waypoint bug:
 If you do have them walking around, don't forget about the walk
 waypoints bug that makes NPCs stand still if you interrupt them
 with a conversation. To fix this, go to the "root" node, look in
 the the "current file" area, (it's onthe far middle-right ) and
 in the "end conversation script" boxes put "nw_d2_walkways" for
 both the "normal" and "aboted" boxes.
*/
