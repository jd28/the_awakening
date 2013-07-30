//::///////////////////////////////////////////////
//:: RIDDLER RIDDLES
//::                     c_con_riddler
//:://////////////////////////////////////////////
/*
    this is the database of the riddles.
    also, it sets the riddlers local
    as well as the riddle key number.
    it needs to fetch the answer strings from that
    database/script.

    add your riddles to the end, incrementing the case number.
    change int nMax to = your last case number +1 (ie for 200, use 201)
    keep track of your riddle numbers to use
    in the answer database.

NOTICE:  a riddle cannot be longer than 511 characters.
         yes, 512 is one too many!
*/
//:://////////////////////////////////////////////
//:: Created By: bloodsong
//:://////////////////////////////////////////////



void main()
{
    object oR = OBJECT_SELF;
    int nMax = 202;   //-- enter the last case+1  maximum max=999
    int nRand = Random(nMax);

    string sUsed = GetLocalString(oR, "USEDRIDDLES");
    //-- this will store the last 30 riddles used
    //-- example "##1201#83..."
    //-- place this on a central placeable if you are using multiple
    //-- riddlers in your mod, and want them all not to repeat riddles.
    string sCheck = IntToString(nRand);

    if(nRand < 10)
    {//-- add 2 leading #'s
     sCheck = "##"+sCheck;
    }
    else if (nRand < 100)
    {//-- add 1 leading #
     sCheck = "#"+sCheck;
    }

    int i = 1;
     while(FindSubString(sUsed, sCheck)!=-1)
     {//--if our number is used, we need to find a new number
       nRand = Random(nMax);
       sCheck = IntToString(nRand);
        if(nRand < 10)
        {//-- add 2 leading #'s
         sCheck = "##"+sCheck;
        }
        else if (nRand < 100)
        {//-- add 1 leading #
         sCheck = "#"+sCheck;
        }
       i++;
        if(i > 66){ break;  } //-- not going to try this more than 65 times
     }


     if(GetStringLength(sUsed) == 90)
     {//-- first chop off leading 3 digits
       sUsed = GetStringRight(sUsed, 87);
     }
     sUsed = sUsed+sCheck;
     SetLocalString(oR, "USEDRIDDLES", sUsed);


    SetLocalInt(oR, "RIDDLE", nRand);
    ExecuteScript("riddler_a", oR); //-- load the answer(s) from database

//-- fetch riddle from this database case

    switch (nRand)
    {
     //-- Riddles 0-200 from the NetBook Riddles online
case   0:  { SetLocalString(oR, "RIDDLE",  "You eat something you neither plant nor plow.    It is the son of water, but if water touches it, it dies.");  break; }
case   1:  { SetLocalString(oR, "RIDDLE",  "A serpent swam in a silver urn.    A golden bird did in its mouth abide    The serpent drank the water, this in turn    Killed the serpent. Then the gold bird died.");  break; }
case   2:  { SetLocalString(oR, "RIDDLE",  "Teacher, open thy book.");  break; }
case   3:  { SetLocalString(oR, "RIDDLE",  "My tines are long.      My tines are short.      My tines end ere      My first report.");  break; }
case   4:  { SetLocalString(oR, "RIDDLE",  "Turn us on our backs      And open up our stomachs      You will be the wisest of men      Though at start a lummox.");  break; }
case   5:  { SetLocalString(oR, "RIDDLE",  "The hungry dog howls      For crust of bread.      His cry goes unheard      It's far overhead.");  break; }
case   6:  { SetLocalString(oR, "RIDDLE",  "Bury deep,      Pile on stones,      Yet I will      Dig up the bones.");  break; }
case   7:  { SetLocalString(oR, "RIDDLE",  "A cloth poorly dyed      And an early morning sky      How are they the same?");  break; }
case   8:  { SetLocalString(oR, "RIDDLE",  "It occurs once in every minute      Twice in every moment      And yet never in one hundred thousand years.");  break; }
case   9:  { SetLocalString(oR, "RIDDLE",  "Never ahead, ever behind,      Yet flying swiftly past;      For a child I last forever,      For adults I'm gone too fast.");  break; }
case   10:  { SetLocalString(oR, "RIDDLE",  "Two horses, swiftest travelling,      Harnessed in a pair, and      Grazing ever in places      Distant from them.");  break; }
case   11:  { SetLocalString(oR, "RIDDLE",  "It can be said:      To be gold is to be good;      To be stone is to be nothing;      To be glass is to be fragile;      To be cold is to be cruel.      Unmetaphored, what am I?");  break; }
case   12:  { SetLocalString(oR, "RIDDLE",  "Round she is, yet flat as a board      Altar of the Lupine Lords.      Jewel on black velvet, pearl in the sea            Unchanged but e'erchanging, eternally.");  break; }
case   13:  { SetLocalString(oR, "RIDDLE",  "Twice four and twenty blackbirds      sitting in the rain      I shot and killed a quarter of them      How many do remain?");  break; }
case   14:  { SetLocalString(oR, "RIDDLE",  "It has a golden head      It has a golden tail      but it hasn't got a body.");  break; }
case   15:  { SetLocalString(oR, "RIDDLE",  "A leathery snake,      With a stinging bite,      I'll stay coiled up,      Unless I must fight.");  break; }
case   16:  { SetLocalString(oR, "RIDDLE",  "Many-maned scud-thumper,      Maker of worn wood,      Shrub-ruster,      Sky-mocker,      Rave!      Portly pusher,      Wind-slave.");  break; }
case   17:  { SetLocalString(oR, "RIDDLE",  "My love, when I gaze on thy beautiful face,      Careering along, yet always in place,      The thought has often come into my mind      If I ever shall see thy glorious behind.");  break; }
case   18:  { SetLocalString(oR, "RIDDLE",  "What has roots as nobody sees,      Is taller than trees,      Up, up it goes,      And yet never grows?");  break; }
case   19:  { SetLocalString(oR, "RIDDLE",  "Thirty white horses on a red hill,      First they champ,      Then they stamp,      Then they stand still.");  break; }
case   20:  { SetLocalString(oR, "RIDDLE",  "Voiceless it cries,      Wingless it flutters,      Toothless bites,      Mouthless mutters.");  break; }
case   21:  { SetLocalString(oR, "RIDDLE",  "An eye in a blue face      Saw an eye in a green face.      'That eye is like to this eye'      Said the first eye,      'But in low place,      Not in high place.'");  break; }
case   22:  { SetLocalString(oR, "RIDDLE",  "It cannot be seen, cannot be felt,      Cannot be heard, cannot be smelt.      It lies behind stars and under hills,      And empty holes it fills.      It comes first and follows after,      Ends life, kills laughter.");  break; }
case   23:  { SetLocalString(oR, "RIDDLE",  "A box without hinges, key, or lid,      Yet golden treasure inside is hid.");  break; }
case   24:  { SetLocalString(oR, "RIDDLE",  "Alive without breath,      As cold as death;      Never thirsty, ever drinking,      All in mail never clinking.");  break; }
case   25:  { SetLocalString(oR, "RIDDLE",  "This thing all things devours:      Birds, beast,trees, flowers;      Gnaws iron, bites steel;      Grinds hard stones to meal;      Slays king, ruins town,      And beats high mountain down.");  break; }
case   26:  { SetLocalString(oR, "RIDDLE",  "You feel it, but never see it and never will.");  break; }
case   27:  { SetLocalString(oR, "RIDDLE",  "You must keep it after giving it.");  break; }
case   28:  { SetLocalString(oR, "RIDDLE",  "As light as a feather, but you can't hold it for ten minutes.");  break; }
case   29:  { SetLocalString(oR, "RIDDLE",  "Has a mouth but does not speak, has a bed but never sleeps.");  break; }
case   30:  { SetLocalString(oR, "RIDDLE",  "Runs smoother than any rhyme, loves to fall but cannot climb!");  break; }
case   31:  { SetLocalString(oR, "RIDDLE",  "You break it even if you name it!");  break; }
case   32:  { SetLocalString(oR, "RIDDLE",  "It passes before the sun and makes no shadow.");  break; }
case   33:  { SetLocalString(oR, "RIDDLE",  "You feed it, it lives; you give it something to drink, it dies.");  break; }
case   34:  { SetLocalString(oR, "RIDDLE",  "A red drum which sounds      Without being touched,      And grows silent,      When it is touched.");  break; }
case   35:  { SetLocalString(oR, "RIDDLE",  "A harvest sown and reaped on the same day      In an unplowed field,      Which increases without growing,      Remains whole though it is eaten      Within and without,      Is useless and yet      The staple of nations.");  break; }
case   36:  { SetLocalString(oR, "RIDDLE",  "If you break me      I do not stop working,      If you touch me      I may be snared,      If you lose me      Nothing will matter.");  break; }
case   37:  { SetLocalString(oR, "RIDDLE",  "All about, but cannot be seen,      Can be captured, cannot be held      No throat, but can be heard.");  break; }
case   38:  { SetLocalString(oR, "RIDDLE",  "I go around in circles,      But always straight ahead      Never complain,      No matter where I am led.");  break; }
case   39:  { SetLocalString(oR, "RIDDLE",  "Lighter than what      I am made of,      More of me is hidden      Than is seen.");  break; }
case   40:  { SetLocalString(oR, "RIDDLE",  "If a man carried my burden,      He would break his back.      I am not rich,      But leave silver in my track.");  break; }
case   41:  { SetLocalString(oR, "RIDDLE",  "My life can be measured in hours,      I serve by being devoured.      Thin, I am quick      Fat, I am slow      Wind is my foe.");  break; }
case   42:  { SetLocalString(oR, "RIDDLE",  "Weight in my belly,      Trees on my back,      Nails in my ribs,      Feet I do lack.");  break; }
case   43:  { SetLocalString(oR, "RIDDLE",  "You can see nothing else      When you look in my face      I will look you in the eye      And I will never lie.");  break; }
case   44:  { SetLocalString(oR, "RIDDLE",  "I am always hungry,     I must always be fed,     The finger I lick     Will soon turn red.");  break; }
case   45:  { SetLocalString(oR, "RIDDLE",  "Three lives have I.      Gentle enough to soothe the skin,      Light enough to caress the sky      Hard enough to crack rocks   What am I?.");  break; }
case   46:  { SetLocalString(oR, "RIDDLE",  "Glittering points      That downward thrust,      Sparkling spears      That never rust.");  break; }
case   47:  { SetLocalString(oR, "RIDDLE",  "Each morning I appear      To lie at your feet,      All day I follow      No matter how fast you run,      Yet I nearly perish      In the midday sun.");  break; }
case   48:  { SetLocalString(oR, "RIDDLE",  "Keys without locks      Yet I unlock the soul.");  break; }
case   49:  { SetLocalString(oR, "RIDDLE",  "Something wholly unreal, yet seems real to I        Think my friend, tell me where does it lie?");  break; }
case   50:  { SetLocalString(oR, "RIDDLE",  "I am so simple,      That I can only point      Yet I guide men      All over the world.");  break; }
case   51:  { SetLocalString(oR, "RIDDLE",  "A beggar's brother went out to sea and drowned.      But the man who drowned had no brother.      What was the relationship between the man who drowned and the beggar?");  break; }
case   52:  { SetLocalString(oR, "RIDDLE",  "For our ambrosia we were blessed,      by the gods, with a sting of death.      Though our might, to some is jest,      we have quelled the dragon's breath.      Who are we?");  break; }
case   53:  { SetLocalString(oR, "RIDDLE",  "One thin, one bold,      one sick, one cold.      The earth we span,      to prey upon man.      Who are we?");  break; }
case   54:  { SetLocalString(oR, "RIDDLE",  "One where none should be,      or maybe where two should be,      seeking out purity,      in the king's trees.      What am I?");  break; }
case   55:  { SetLocalString(oR, "RIDDLE",  "He who makes it does not keep it.      He who takes it does not know it.      He who knows it does not want it.      He who gathers it must destroy it.      What is it?");  break; }
case   56:  { SetLocalString(oR, "RIDDLE",  "One tooth to bite,      he's the forests foe.      One tooth to fight,      as all barbarians know.      What is it?");  break; }
case   57:  { SetLocalString(oR, "RIDDLE",  "This creature, part man and part tree,      hates the termite as much as the flea.      His tracks do not match,      and his limbs may detach,      but he's not a strange creature to see.      What is it?");  break; }
case   58:  { SetLocalString(oR, "RIDDLE",  "The part of the bird      that is not in the sky,      which can swim in the ocean      and always stay dry.      What is it?");  break; }
case   59:  { SetLocalString(oR, "RIDDLE",  "Dead and bound,      what once was free.      What made no sound,      now sings with glee.      What is it?");  break; }
case   60:  { SetLocalString(oR, "RIDDLE",  "The root tops the trunk      on this backward thing,      that grows in the winter      and dies in the spring.      What is it?");  break; }
case   61:  { SetLocalString(oR, "RIDDLE",  "Touching one, yet holding two,      it is a one link chain      binding those who keep words true,      'til death rent it in twain.      What is it?");  break; }
case   62:  { SetLocalString(oR, "RIDDLE",  "The man who made it didn't need it.    The man who bought it didn't use it.    The man who used it didn't want it.");  break; }
case   63:  { SetLocalString(oR, "RIDDLE",  "The wise and knowledgeable man is sure of it.    Even the fool knows it.    The rich man wants it.    The greatest of heroes fears it.    Yet the lowliest of cowards would die for it.");  break; }
case   64:  { SetLocalString(oR, "RIDDLE",  "I am and yet can not;  am an Idea, yet can rot;  am two but none;   am on land but on sea.   Name me.");  break; }
case   65:  { SetLocalString(oR, "RIDDLE",  "All in white.   Fossil, fresh snow, a loan, the sky.   Just what am I?");  break; }
case   66:  { SetLocalString(oR, "RIDDLE",  "It is my lot to be used by women.   I harm none except my slayer.  Rooted, I stand high in a bed;  I am hairy beneath.   Then a brazen peasant's daughter seizes me,   peels back my skin and claims my head.   The woman who catches me fast will feel our meeting.   Her eye will be wet.");  break; }
case   67:  { SetLocalString(oR, "RIDDLE",  "As I was going to St Ives;   I met a man with seven wives;  every wife had seven sacks;   Every sack had seven cats;   Every cat had seven kittens.   Kittens, Cats, Sacks, and Wives;  How many were there going to St. Ives?");  break; }
case   68:  { SetLocalString(oR, "RIDDLE",  "Dawn's away;   The day's turned grey;   And I must travel far away.   But I'll be back;   And then we'll track;   The light of yet another day.");  break; }
case   69:  { SetLocalString(oR, "RIDDLE",  "Deep, dark, underground;   That is the place where I'll be found.   Yet brought into the light of day,   I sprinkle sunlight every-which-way.   Though dulled with oil, it will be found,   I am remarkably well and thoroughly sound.   Cut me quick, and it will be seen   That I instantly have a marvelous sheen.");  break; }
case   70:  { SetLocalString(oR, "RIDDLE",  "Long legs, crooked thighs;   Little head and no eyes.");  break; }
case   71:  { SetLocalString(oR, "RIDDLE",  "What has six eyes, six arms, six legs, three heads, and a very short life?");  break; }
case   72:  { SetLocalString(oR, "RIDDLE",  "What is it that speaks without any words?   And can be loudly and distinctly heard?   Will drive away friend and foe alike,   And is enough to make a stolid man's face alight?");  break; }
case   73:  { SetLocalString(oR, "RIDDLE",  "What must be in the oven, yet cannot be baked?   Grows in the heat, yet shuns the light of day?   What sinks in water, but rises with air?   Looks like skin, but is fine as hair?");  break; }
case   74:  { SetLocalString(oR, "RIDDLE",  "Little Johnny Walker;   My, but he was a talker!   Yet nary a word die he say.   When I took him out,   Then they would all point and shout!   And ask that I put him away.");  break; }
case   75:  { SetLocalString(oR, "RIDDLE",  "One Leg sat in Two Legs' lap.   Upon Three Legs they did abide.   Four legs came and snatched One Leg,   and ran away to hide.   Who are they?");  break; }
case   76:  { SetLocalString(oR, "RIDDLE",  "They are many and one,   They wave and they drum,   Used to cover a stare,   They go with you everywhere.");  break; }
case   77:  { SetLocalString(oR, "RIDDLE",  "Stomp, stomp.   Chomp, chomp.   Romp, romp.   Standing still,   all in gear.");  break; }
case   78:  { SetLocalString(oR, "RIDDLE",  "Sweet tooth,   Ah, shoot!   All gone.   We all long   for another piece of it.");  break; }
case   79:  { SetLocalString(oR, "RIDDLE",  "It comes in on little cat's feet,   Is neither sour nor sweet;   Hovers in the air,   And then is not there.");  break; }
case   80:  { SetLocalString(oR, "RIDDLE",  "A laugh,   A cry,   A moan,   A sigh.");  break; }
case   81:  { SetLocalString(oR, "RIDDLE",  "What is it you have to answer?   But to answer, you have to ask?   And to ask you have to speak?   And to speak, you have to know   The answer.");  break; }
case   82:  { SetLocalString(oR, "RIDDLE",  "I can hit you in the eye;   Yet twinkle in the sky;   Expanding when I die.   What do you think I am?");  break; }
case   83:  { SetLocalString(oR, "RIDDLE",  "Squishes, squashes;   Wishes I washes;   Can get it in my hair;   Makes me not look too fair.");  break; }
case   84:  { SetLocalString(oR, "RIDDLE",  "White on black;   And black on white.   Helps you to know things,   By using your sight.");  break; }
case   85:  { SetLocalString(oR, "RIDDLE",  "Up a hill,   Down a hill,   over them I may roam.   But after all my walking,   There's no place like my own.");  break; }
case   86:  { SetLocalString(oR, "RIDDLE",  "This thing is a most amazing thing.   For it can be both as sharp as a knife,   Or as flat as a floor.   And yet, for all that it can be,   It's as natural as a bee.");  break; }
case   87:  { SetLocalString(oR, "RIDDLE",  "Deep, deep, do they go.   Spreading out as they grow.   Never needing any air.   Sometimes they are as fine as hair.");  break; }
case   88:  { SetLocalString(oR, "RIDDLE",  "Oh lord, I am not worthy!   I bend my limbs to the ground.  I cry, yet without a sound.   Let me drink of waters deep.   And in silence, I will weep.");  break; }
case   89:  { SetLocalString(oR, "RIDDLE",  "Shifting, shifting, drifting deep.  Beow me great and mighty cities sleep.   Swirling, scurlling, all around.   I'm only where no water will be found.");  break; }
case   90:  { SetLocalString(oR, "RIDDLE",  "I bubble and laugh,   and spit in your face.   I'm not lady,   and I don't wear lace.");  break; }
case   91:  { SetLocalString(oR, "RIDDLE",  "What has wings, but cannot fly?   Is enclosed, but can outside also lie?   Can open itself up, or close itself away?   Is the place of kings and queens,   and doggerel of every means?   What is it upon which I stand,   which can lead us to different lands?");  break; }
case   92:  { SetLocalString(oR, "RIDDLE",  "Do not begrude this,   for it is the fate of every man.   Yet it is feared,   and shunned in many lands.   Causes problems, and sometimes gaps,   Can hobble the strongest, and make memory lapse.   What is this danger we all face   if we are a part of a mortal race?");  break; }
case   93:  { SetLocalString(oR, "RIDDLE",  "His eyes were raging,   That scraggly beast.   His lips were bursting,   With rows of angry teeth.   Upon his back, a razor was found,   And in his thoughts, my death abound.   It was a fearsome battle we fought;   My life or his; one would be bought.   And when we were through, and death chilled the air,   We cut out his heart, and ate it with flair.   Who was he?");  break; }
case   94:  { SetLocalString(oR, "RIDDLE",  "I travelled inwards,   to the heart where no one else roamed.   Where only the birds and animals found a home.   Where the pixies flew with an audible air,   And tangled twigs and leaves within my hair.   Ah, I love this place, this paradise;   Where everything is so beautiful,   So still, and so nice.   Whither did I go?");  break; }
case   95:  { SetLocalString(oR, "RIDDLE",  "Of these things, I have two.   One for me, and one for you.   And when you ask about the price,   I simply smile and nod twice.");  break; }
case   96:  { SetLocalString(oR, "RIDDLE",  "I am a strange creature,   Hovering in the air;   Moving from here to there,   With a brilliant flare.   Some say I sing,   But others say I have no voice.   So I just hum, as a matter of choice.  What am I?");  break; }
case   97:  { SetLocalString(oR, "RIDDLE",  "Sleeping during he day, I hide away.   Watchful through the night, I open at dawn's light.   But only for the briefest time, do I shine.   And then I hide away, and sleep through the day.");  break; }
case   98:  { SetLocalString(oR, "RIDDLE",  "Looks like water, but it's heat.  Sits on sand, lies on concrete.   People have been known   To follow it everywhere.   But it gets them no place,   All they can do is stare.");  break; }
case   99:  { SetLocalString(oR, "RIDDLE",  "A part of heaven,   Though it touches earth.   Some say it's valuable,   Others, no worth.");  break; }
case   100:  { SetLocalString(oR, "RIDDLE",  "I stand, and look across the sea;   with its waves, crests, troughs and valleys.   I stride, across this water, my horse following after.   And while it laps against his withers, and brushes against my thighs;   I fill the emptiness with laughter, and he, with his sighs.   Whither do we go?   Or do we go at all?   Or are we simply out here wading,   To the next port of call?   Where the sea ends,   Where the loam lies firm beneath my feet,   I can mount my steed again,   And continue til next we meet.");  break; }
case   101:  { SetLocalString(oR, "RIDDLE",  "It roars its challenge, and I respond.   It takes my abuse and goes beyond.   Filled with liquid, in my hurried haste;  I weild my staff in this turgid race.   But once I have vanquished the mighty foe,   I float like a thistle, ever so slow.   What is it?");  break; }
case   102:  { SetLocalString(oR, "RIDDLE",  "I was born blind,   And could not see,   Until it was quarter of three.   I could not smile   Til half past six,   And all of my arms and legs   Were made out of sticks.");  break; }
case   103:  { SetLocalString(oR, "RIDDLE",  "Ah! My breath doth shake,   My limbs are thin; my belly aches.   Whiteness doth crown my head,   And the tracks I leave are unstead where I tread.   I look out through rheumy eyes,   And seem to say my last goodbyes.   The darkness doth draw me near;   I lean towards it, the better to hear.");  break; }
case   104:  { SetLocalString(oR, "RIDDLE",  "Tis not/Tis is.   Tis good/Tis bad.  Tis left/Tis right.   Tis day/Tis night.  What are they?");  break; }
case   105:  { SetLocalString(oR, "RIDDLE",  "Hick-a-more, hack-a-more,   Fell upon the King's door.   All the King's horses,   And all the King's men,   Couldn't get Hick-a-more, Hack-a-more   Off the King's door.   What is he?");  break; }
case   106:  { SetLocalString(oR, "RIDDLE",  "It is a tolling of the night;   When all is still;   And the wind whispers near the mill.   He was struck twelve times!   And his voice rang out,   but then was stilled.");  break; }
case   107:  { SetLocalString(oR, "RIDDLE",  "It was asked of me what I could be made,   And so people were fed from me.   It was asked of me what I could be made,   And so houses were built.   It was asked of me what I could be made,   And so things were written.   It was asked of me what I could be made,   And so I fertilized the ground.   But when asked more of what I could be made,   There was nothing to be found.");  break; }
case   108:  { SetLocalString(oR, "RIDDLE",  "With this you can do wonderous things.   Look at things close, or far away;   You can see things big,   Or you can see things small.  Or maybe you don't see things at all.   I come in many colours and hues,   Sometimes green and sometimes blue.   And when I'm red, it's not from shame,   But from something with a different name.");  break; }
case   109:  { SetLocalString(oR, "RIDDLE",  "Oh how I love my dancing feet!   They stay together, oh so neat.   And when I want to walk a line,   They all stay together and do double-time.   I count them up, ten times or more,   And race on off, across the floor.   What am I?");  break; }
case   110:  { SetLocalString(oR, "RIDDLE",  "They were made for a fairy queen's feet.   To cover them up and keep them neat.   A flower of various sizes and hues,   Their name is the opposite of a grown man's shoes.   What are they?");  break; }
case   111:  { SetLocalString(oR, "RIDDLE",  "Part pickle, part crazy;  You can't call this flower lazy.   It perks its head up with a snout,   And if it had a voice, I'm sure it'd shout.   What is it?");  break; }
case   112:  { SetLocalString(oR, "RIDDLE",  "Bound by age, comfort and zest,   The inquiring hand could not rest.   But given to her heart's desire,   She gave to us our worst quagmire.   And so now we wallow in our grief,  And seeking to close the box, we weep.   While famine, plague and other woes   Beset ourselves and our foes.  Whence comes this tragedy?");  break; }
case   113:  { SetLocalString(oR, "RIDDLE",  "Nestled among a thorny embrace,   What should I see, but a small, plump face?   With cheeks rosy red, and a neck way too long,   He'll be ripe for the plucking before too long.   What is he?");  break; }
case   114:  { SetLocalString(oR, "RIDDLE",  "A muttered rumble was heard from the pen,   And I, in my walking, stopped to look in.  What was this I saw?  A massive beast, hooved and jawed.   With spikes upon his mighty brow.   I watched as he struck the turf and prowled.   And yet for all of his magnificence,   He couldn't get out of that wooden fence.");  break; }
case   115:  { SetLocalString(oR, "RIDDLE",  "Twas the night of the day   in which I must relay   that in which I took part in.   For the sun was out   and without so much as a shout,   he quietly went in.   Twas ever so queer,   I thought he would leer,   but never a word did I get in.   For without another word   (at least, that's what I heard)   He was back to the place he'd been in.");  break; }
case   116:  { SetLocalString(oR, "RIDDLE",  "Twas the giantess who told me what to do.   Twas she who opened the doors and closed the windows.  Not I.   Twas her who decided the chair did well on the lawn,   And the table should be in the basement.   I have done naught to deserve punishment,   For I did not place the dog on the lamp,   Nor the cat in the chimney.   Twas the giantess.   What is she?");  break; }
case   117:  { SetLocalString(oR, "RIDDLE",  "A great and blazing day above, while I in my darkness abide.   The lazy lady looks o'er her kingdom with heated golden eye.   As light abates, I must go forth, drawing my shadow cloak about me.  It doth not matter, for in the end, we would perform our pagan dance, of words softly spoken, or boldly sprayed upon the wall.  In the dark - a cry, to live or die; by fate or chance the dice do fall.");  break; }
case   118:  { SetLocalString(oR, "RIDDLE",  "From sun up to sun down I stare out across the sea.    From sun down to sun up I stare out across the sea.    But while with sun up I can only blink in the brightness.    With the sun down I can blink out the brightness.   What am I?");  break; }
case   119:  { SetLocalString(oR, "RIDDLE",  "A lot of bark,   But no one notices.   A lot to bite,   And everyone cares.   I'm not a dog,   If anyone notices.   And there's a lot to me,   But I don't have hair.    I stand up straight,   If you've noticed me.   I've got lots of limbs,    If anyone cares.   I can give you shade,   If you've noticed it.   And I do even more,   I give you air.");  break; }
case   120:  { SetLocalString(oR, "RIDDLE",  "Twas in December or June,   When my lady did swoon.   When her hair did fall off,   And her glasses were lost.   When she did scream,   In a manner most obscene.   While pointing at me.   And saying 'Eeee! Eeee!'   I must say it was all a bit much,   Since no one did I touch.   But it was quite apparent,   That something was errant.   So I decided to come back another day,   When, mayhap, she was away.");  break; }
case   121:  { SetLocalString(oR, "RIDDLE",  "This thing is many things.   It is joyful, it is quiet, it is bubbling, it is roaring;   It can jump and it can sit.   It can whisper, and it can drip.   It can be both shallow and deep.  What is it of which I speak?");  break; }
case   122:  { SetLocalString(oR, "RIDDLE",  "I drift,   As slowly as a lazy river.   I dance,  Upon as little as a puff of air.   I tumble,   Better than the greatest acrobat.   Swirling, twirling, to the ground;  Where I lie, til I get my second wind.   So I can begin again.   What am I?");  break; }
case   123:  { SetLocalString(oR, "RIDDLE",  "Red Breasted.   Only one in a field of many.   Born in an egg.   Inspired to sing.   Now gather the letters and tell me what I mean.");  break; }
case   124:  { SetLocalString(oR, "RIDDLE",  "I have four of these, with matching extremeties.   They can do many things, and hardly ever bring me pain.   Unless I stick them with a pin, or burn them sometimes when….   What is it that I can wiggle at will?   And use in other means still?");  break; }
case   125:  { SetLocalString(oR, "RIDDLE",  "I am a box,   Full of that which is most rare.   But it isn't a flute, and it isn't some hair.   Though soft be my bed, I am hard as a rock.   And though dull in the darkness, I glisten once unlocked.   What am I, this box so strange?   To hold such a treasure,   Which is not plain?");  break; }
case   126:  { SetLocalString(oR, "RIDDLE",  "I dreamed I saw a fairy's dance,    Upon the midnight sky.    Where lights, like lantern's grew,    Without a whim, or a why.    Amid their joy,    Amid their dance,    I came running into their midst.    But with nar'ry a sound,    They drew away,    And fell into the mist.   Oh, I saw them again,   But only from very far.   Dancing in the air at night,   Like tiny lanterns, or tiny stars.");  break; }
case   127:  { SetLocalString(oR, "RIDDLE",  "When I looked upon the flames of his passion,    And the coolness of her touch,    I knew tragedy could only come from their union.    And indeed, when they came together,    Darkness reigned upon the land.    And although they were soon separated,    Learning as they did that they were not for each other,   Still, their passing regards for each other,   Left it's impression upon all who had witnessed it.   And would be talked about for ages still to come.");  break; }
case   128:  { SetLocalString(oR, "RIDDLE",  "Oh woe is me!  Woe is me!    To have lost that which I can never buy back!    To be unable to recall that which has transpired!    Let my breath be returned!    Let time recoil!    Let this not be so!    Oh woe is me!  Woe is me!   What have I done?");  break; }
case   129:  { SetLocalString(oR, "RIDDLE",  "What has a coat?    Hugs you not in sympathy?    Whose smile you'd rather not see?    Whose stance is a terrible thing to see?    Who is it that brave men run away from?    Whose fingers are clawed?    Whose sleep lasts for months?    And who's company we shun?");  break; }
case   130:  { SetLocalString(oR, "RIDDLE",  "You can tumble in it,    Roll in it,    Burn it,    Animals eat it,    Used to cover floors,    Still used beyond stall doors.    Freshens whatever it is placed on,    Absorbs whatever is poured into it.    What is it?");  break; }
case   131:  { SetLocalString(oR, "RIDDLE",  "Within passion's fruit they will be found,    And more of them in the pomegranate's crown.    Rowed they are within an apple's core,    Yet other fruits have them more.    And though the nectarine has but one,    Still, this is all just in fun.    Playing hide and seek - a children's game.   Finding out each player is just the same.");  break; }
case   132:  { SetLocalString(oR, "RIDDLE",  "We are little airy creatures,    All of different voice and features;    One of us in glass is set,    One of us you'll find in jet,    T'other you may see in tin,    And the fourth a box within;    If the fifth you should pursue,    It can never fly from you.");  break; }
case   133:  { SetLocalString(oR, "RIDDLE",  "I'm a strange contradiction; I'm new, and I'm old,    I'm often in tatters, and oft decked with gold.    Though I never could read, yet lettered I'm found;    Though blind, I enlighten; though loose, I am bound,   In form too I differ - I'm thick and I'm thin,   I've no flesh and bones, yet I'm covered with skin;   I'm Elven, I'm Human, I'm Gnomish, and such;   Some love me too fondly, some slight me too much;   I often die soon, though I sometimes live ages,   And no monarch alive has so many pages.");  break; }
case   134:  { SetLocalString(oR, "RIDDLE",  "As I went through the garden gap,    Who should I meet but Dick Red-cap!    A stick in his hand, a stone in his throat,    If you'll tell me this riddle, I'll give you a groat.");  break; }
case   135:  { SetLocalString(oR, "RIDDLE",  "Arthur O'Bower has broken his band,   He comes roaring up the land;   The King of Luskan, with all his power,   Cannot turn Arthur of the Bower.   Who is he?");  break; }
case   136:  { SetLocalString(oR, "RIDDLE",  "Little Nancy Etticote,   In a white petticoat,   With a red nose;   The longer she stands,   The shorter she grows.   What is she?");  break; }
case   137:  { SetLocalString(oR, "RIDDLE",  "I have a little sister, they call her Peep, Peep;    She wades the waters deep, deep, deep;    She climbs the mountains high, high, high;    Poor little creature she has but one eye.   Who is she?");  break; }
case   138:  { SetLocalString(oR, "RIDDLE",  "I saw a company a marching,    A-marching across the sea.   And looking upon them, I asked myself    'What could they be?'   For there was a horse,   And there was a cow,   And there were men marching,   With houses and trees. But how?   I saw a company marching,   A-marching over the sea.   Now I ask you,   What could they be?");  break; }
case   139:  { SetLocalString(oR, "RIDDLE",  "I'm up.   I'm down.   I'm all around.   Yet never can I be found.   What am I?");  break; }
case   140:  { SetLocalString(oR, "RIDDLE",  "I can be moved.   I can be rolled.   But nothing will I hold.   I'm red and I'm blue.   And I can be other colors too.   Having no head, though similar in shape,   I have no eyes - yet move all over the place.   What am I?");  break; }
case   141:  { SetLocalString(oR, "RIDDLE",  "I can be eaten,   I can be grown,   And sometimes you'll find me,   As part of your home.   Though able to bend,   And sticky when broke,   I'm stouter than maple,   But weaker than oak.   What am I?");  break; }
case   142:  { SetLocalString(oR, "RIDDLE",  "Upon me you can tread,   Though softly under cover.   And I will take you places,   That you have yet to discover.   I'm high, and I'm low,   Though flat in the middle.   And though a joy to the children,   Adults think of me little.   What am I?");  break; }
case   143:  { SetLocalString(oR, "RIDDLE",  "What is it which builds things up?   Lays mountains low?    Dries up lakes,   And makes things grow?   Cares not a whim about your passing?   And is like few other things,   Because it is everlasting?");  break; }
case   144:  { SetLocalString(oR, "RIDDLE",  "It sat upon a willow tree,   And sang softly unto me.   Easing my pain and sorrow with its song,   I wished to fly, but tarried long.   And in my suffering,   The willow was like a cool clear spring.   What was it that helped me so?   To spend my time in woe.");  break; }
case   145:  { SetLocalString(oR, "RIDDLE",  "I awoke with start.   Hearing its voice in the dark.   And shook more so from within,   Than that which came upon the wind.   Then, with a flare and a flash.   I hid my head and awaited the crash.   What is it that shook my body so?   And made me hide way down low?");  break; }
case   146:  { SetLocalString(oR, "RIDDLE",  "Quickly, quickly up they run.   Then down again here they come.   Moving up, then down, then up again,   Take notes, and start again.   Combining both sharps and flats.   Does anyone know what they are at?");  break; }
case   147:  { SetLocalString(oR, "RIDDLE",  "A man not a man saw and did not see a bird not a bird sitting on a stick not a stick and hit it with a stone not a stone.  What were they?");  break; }
case   148:  { SetLocalString(oR, "RIDDLE",  "They can be harbored, but few hold water,   You can nurse them, but only by holding them against someone else,   You can carry them, but not with your arms,   You can bury them, but not in the earth.");  break; }
case   149:  { SetLocalString(oR, "RIDDLE",  "Deep as a bowl, round as a cup,   Yet all the world's oceans can't fill it up.   What is it?");  break; }
case   150:  { SetLocalString(oR, "RIDDLE",  "Though desert men once called me God,   To-day men call me mad,   For I wag my tail when I am angry,   And growl when I am glad.   What am I?");  break; }
case   151:  { SetLocalString(oR, "RIDDLE",  "I heard of an invading, vanquishing army   sweeping across the land, liquid-quick;   conquering everything, quelling resistance.   With it came darkness, dimming the light.   Humans hid in their houses, while outside   spears pierced, shattering stone walls.   Uncountable soldiers smashed into the ground,   but each elicited life as he died;   when the army had vanished, advancing northward,   the land was green and growing, refreshed.");  break; }
case   152:  { SetLocalString(oR, "RIDDLE",  "Never ahead, ever behind,    Yet flying swiftly past,    For a child, I last forever,   For adults, I'm gone too fast.");  break; }
case   153:  { SetLocalString(oR, "RIDDLE",  "Tall she is, and round as a cup,    Yet all the king's horses    Can't draw her up.   What is she?");  break; }
case   154:  { SetLocalString(oR, "RIDDLE",  "There more of it there is,    The less you see.   What is it?");  break; }
case   155:  { SetLocalString(oR, "RIDDLE",  "What is not enough for one,    Just right for two,    Too much for three?");  break; }
case   156:  { SetLocalString(oR, "RIDDLE",  "What gets wetter the more it dries?");  break; }
case   157:  { SetLocalString(oR, "RIDDLE",  "H I J K L M N O    What word does this represent?");  break; }
case   158:  { SetLocalString(oR, "RIDDLE",  "A long snake   With a stinging bite,   I stay coiled up   Unless I must fight.   What am I?");  break; }
case   159:  { SetLocalString(oR, "RIDDLE",  "Man of old, it is told  Would search until he tired,   Not for gold, ne'er be sold,  But what sought he was fire.   Man today, thou mayst say,  Has quite another aim,   In places deep, he did seek,  To find me for his gain!   What am I?");  break; }
case   160:  { SetLocalString(oR, "RIDDLE",  "A warrior amongst the flowers,   She bears a thrusting sword.   Able and ready to use,   To guard her golden hoard.   What is she?");  break; }
case   161:  { SetLocalString(oR, "RIDDLE",  "Tom gave his brother John a box,   About it there were many locks,   The box was not with key supplied,   But caused two lids to open wide.   What was it?");  break; }
case   162:  { SetLocalString(oR, "RIDDLE",  "The Load-bearer, the Warrior,   The Frightened One, the Brave,   The Fleet-of-foot, the Ironshod   The Faithful One, the Slave.   Who am I?");  break; }
case   163:  { SetLocalString(oR, "RIDDLE",  "Walks in the wind   Runs in the rain   Makes dry oceans in the sun   Counts time, stops clocks   Swallows kingdoms, gnaws rocks.   What is it?");  break; }
case   164:  { SetLocalString(oR, "RIDDLE",  "The rolling hills, the heart that beats forever,   The land that never changes, never stills   Ploughed by travellers far from home, not planted,   White in anger, green in peace, and always blue.   What is it?");  break; }
case   165:  { SetLocalString(oR, "RIDDLE",  "Pull with all your might, only a whistle you'll gain   but almost out of sight, someone may shrink in pain.");  break; }
case   166:  { SetLocalString(oR, "RIDDLE",  "Listen closely, I'm hard to understand   I am as elusive as is a handful of sand.   Even if you perceive me, you know me not   before you can tell me, what I have forgot?");  break; }
case   167:  { SetLocalString(oR, "RIDDLE",  "As I went over 'cross bridge   I met my sister Jenny   I broke her neck and drank her blood   And left here standing empty.   Tell me who was my sister?");  break; }
case   168:  { SetLocalString(oR, "RIDDLE",  "What goes through the door without pinching itself?   What sits on the stove without burning itself?   What sits on the table and is not ashamed?");  break; }
case   169:  { SetLocalString(oR, "RIDDLE",  "What work is it that,   the faster you work,   the longer it is before your work is done,   And the slower you work   the sooner your work is finished?");  break; }
case   170:  { SetLocalString(oR, "RIDDLE",  "Whilst I was engaged in sitting   I spied the dead carrying the living   What did I see?");  break; }
case   171:  { SetLocalString(oR, "RIDDLE",  "I know a word of letters three,   Add two and fewer there will be.   What is it?");  break; }
case   172:  { SetLocalString(oR, "RIDDLE",  "I give you a group of three.   One is sitting down, and never will get up.   The second eats as much as is given him,   yet is always hungry.   The third goes away and never returns.   What are they?");  break; }
case   173:  { SetLocalString(oR, "RIDDLE",  "Whoever makes it, tells it not.   Whoever takes it, knows it not.   Whoever knows it, wants it not.   Of what do I speak?");  break; }
case   174:  { SetLocalString(oR, "RIDDLE",  "You seized me, and yet I fled   You see me flee and cannot hold me tight   You press me in your hand, then your fist is empty.   What am I?");  break; }
case   175:  { SetLocalString(oR, "RIDDLE",  "What has four legs in the morning,   Two legs in the afternoon,   And three legs in the evening?");  break; }
case   176:  { SetLocalString(oR, "RIDDLE",  "What is deaf, dumb, and blind;   and always tells the truth?");  break; }
case   177:  { SetLocalString(oR, "RIDDLE",  "What is always in front of you, but cannot be seen?");  break; }
case   178:  { SetLocalString(oR, "RIDDLE",  "What does man love more than life,   hate more than death or mortal strife;   That which contented men desire,   the poor have, the rich require;   The miser spends, the spendthrift saves,   and all men carry to their graves?");  break; }
case   179:  { SetLocalString(oR, "RIDDLE",  "A life longer than any man, it dies each year to be reborn.  What is it?");  break; }
case   180:  { SetLocalString(oR, "RIDDLE",  "In the eyes it causes blindness,   in the nose just a sneeze;   Yet some suck this down,   and act as if pleased.   What is it?");  break; }
case   181:  { SetLocalString(oR, "RIDDLE",  "It stands alone, with no bone or solid form.   Adamant, it prospers never wrong,   though hurt it may.   Twistable, malleable, might it be,   but always straight as an arrow.   What is it?");  break; }
case   182:  { SetLocalString(oR, "RIDDLE",  "What sphinxes employ, players enjoy.   What are they?");  break; }
case   183:  { SetLocalString(oR, "RIDDLE",  "A man of a hundred stood out in the cold,   Exchanged his gay headdress, of colors most bold,   For one of pure ivory, just now a day old.   But though freshly dressed, the old man stood alone -   It was his misfortune to live on a wold.   Who is he?");  break; }
case   184:  { SetLocalString(oR, "RIDDLE",  "There's someone that I'm always near,   Yet in the dark I disappear.   To this one only I am loyal,   Though in his wake I'm doomed to toil.   He feels me not (we always touch);   If I were lost, he'd not lose much.   And now I come to my surprise,   For you are he, but what am I?");  break; }
case   185:  { SetLocalString(oR, "RIDDLE",  "I'm often held, yet rarely touched;   I'm always wet, yet never rust;   I'm sometimes wagged and sometimes bit;   To use me well, you must have wit.  What am I?");  break; }
case   186:  { SetLocalString(oR, "RIDDLE",  "What is the only tool that sharper grows   Whenever used in any row?");  break; }
case   187:  { SetLocalString(oR, "RIDDLE",  "In the window, she sat weeping.   And with each tear, her life went seeping.   What was she?");  break; }
case   188:  { SetLocalString(oR, "RIDDLE",  "I'm nothing moer than holes tied to holes;   I'm strong as good steel, though not stiff as a pole.   What am I?");  break; }
case   189:  { SetLocalString(oR, "RIDDLE",  "I've little strength, but mighty powers;     I guard small hovels and great towers.     But if perchance my master leaves,    He must ensure he safeguards me.   What am I?");  break; }
case   190:  { SetLocalString(oR, "RIDDLE",  "The floor's on top, the roof's beneath,     And from this place I rarely leave.     Yet with the passing of each day,     A new horizon greets my gaze.");  break; }
case   191:  { SetLocalString(oR, "RIDDLE",  "What is delivered by breath, and scares heroes to death?");  break; }
case   192:  { SetLocalString(oR, "RIDDLE",  "In daytime I lie pooled about,     At night I cloak like a mist.     I creep inside shut boxes and     Inside your tightened fist.     You see me best when you can't see,     For I do not exist.   What am I?");  break; }
case   193:  { SetLocalString(oR, "RIDDLE",  "Devils and rogues know nothing else, save starlight.   What is it?");  break; }
case   194:  { SetLocalString(oR, "RIDDLE",  "Both king and horse have this, of course,   But you'll want neither of them, perforce.  What are they?");  break; }
case   195:  { SetLocalString(oR, "RIDDLE",  "Above all things   have I been placed   thus have I   a man disgraced.   I describe   sunlight or lock   but after all   I'm just a rock.    What am I?");  break; }
case   196:  { SetLocalString(oR, "RIDDLE",  "I cost no money to use.   Or conscious effort to take part of.  And as far as you can see, there is nothing to me.   But without me, you are dead.   What am I?");  break; }
case   197:  { SetLocalString(oR, "RIDDLE",  "Sturdy, strong stable, still   Some live in me some live on   And some find me to live upon.   I rarely leave my native land.   until my death I always stand.   Sturdy Strong Stable Still   Often shaken, but not at will.   High and low I may be found   both above and under ground.");  break; }
case   198:  { SetLocalString(oR, "RIDDLE",  "At the sound of me I can make women weep.   At the sound of me men may clap or stamp their feet.   What am I?");  break; }
case   199:  { SetLocalString(oR, "RIDDLE",  "I am wounded and weary, battered and scarred.  I have faced the finest of foes without flinching.  Yet no cleric can heal me, nor would they care.  I have no bandages, no salves, no healing draughts.  Yet fast do I stand for another day's fighting, and yet another night without rest.");  break; }
case   200:  { SetLocalString(oR, "RIDDLE",  "I war with the wind, with the waves I wrestle;   I must battle with both when the bottom I seek,   My strange habitation by surges o'er-roofed.   I am strong in strife, while I still remain;   As soon as I stir, they are stronger than I.   They wrench  and they wrest, till I run from my foes;   What was put in my keeping they carry away.   If my back be not broken, I baffle them still;   The rocks are my helpers, when hard I am pressed;   Grimly I grip them.  Guess what I'm called.");  break; }
//----------------------------------------------------------------------
    //---add your riddles here
case   201:  { SetLocalString(oR, "RIDDLE",  "Woe to me, for I was torn from the earth;   Beaten and burned, and beaten again;   And trod upon by long-faced beasts.   What am I?");  break; } //-- riddle by irondrake

     SpeakString("Error, Riddle #"+IntToString(nRand)+" not found.");
    }



}
