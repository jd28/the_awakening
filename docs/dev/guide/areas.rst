Areas
=====

The following document discusses area design...

Creating an Area
----------------

* Areas should all be named with some prefix.  E,g: "Such and Such Castle: Courtyard", "Such and Such Castle: Gardens", etc.  So that a contiguous run is easy to find in the toolset.
* Area resrefs should be of the form: ``<builder prefix>_<area identifier>_<XXX>``, where ``<XXX>`` is 001, 002, 003, etc.  Example: ``pl_faunfor_001``.

Designing an Area
-----------------

The server has a particular design philosophy.  If you are interested in creating areas please try to adhere to it.

The following are general guidelines, there are always places where it might make sense to break them.

* Don't make areas that are overly seamless.  Connecting areas don't need their borders to align or mountains to match, etc.
* Don't make very large areas that take a significant amount of time to load.  Make sure that the area you have designed has a flow and that during normal play doesn't leave more than 50% of the map unexplored.
* Don't overuse placeables is combat areas.
* Whenever you create area transitions, make sure they aren't hidden or hard to hightlight with a mouse.  **Always** make sure that the destination waypoint is not on an the return area transition.
* In boss areas, make some transition one-way so that once the fight is complete players won't be able to 'camp'.
* Don't overdo keys, levers, secret transitions, puzzles, etc.
* Try to keep the duration of most runs to about 45 minutes.
* Use the custom encounter system as described in the Encounter section of the Developer Guide.
* The number of creature appearances in NWN is rather limited, even with all the amazing custom content created by the community.  Don't use a god-like enemey appearance types in lower level areas.

Doors
-----

* Doors should **never** be placed on the palette.  If you want to do so for your convenience while building make sure to delete them out later.
* The server has door scripts.  Please do not add new ones to provide basic functionality like automatically closing, bashing, etc.

Placeables
----------

* Placeables should not be on the palette or exported.  The only placeables that should be on the palette are ones that are spawned by script or dynamically.  In that case you should *always* add an integer variable to the placeable ``EXPORT = 1``

* There are a number of scripts the server already that covers most of the basic uses of placeables.  Please see what is available below before adding any new ones.