package
{
    import couk.psyked.box2d.Box2DWorld;
    import couk.psyked.box2d.utils.Box2DUtils;
    import couk.psyked.box2d.utils.Box2DWorldOptions;

    import flash.display.Sprite;
    import flash.events.Event;

    [SWF( width="500",height="280",frameRate="30",backgroundColor="0x000000",pageTitle="Box2D Experiments" )]
    public class LibraryShapeExample extends Sprite
    {
        public function LibraryShapeExample()
        {
            addEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
        }

        private function onAddedToStage( e:Event ):void
        {
            removeEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
            addEventListener( Event.REMOVED_FROM_STAGE, onRemovedFromStage );
            //
            var options:Box2DWorldOptions = new Box2DWorldOptions( 500, 280, 30, 9.8 );
            options.setWorldEdges( true, true, true, true );
            var world:Box2DWorld = Box2DUtils.createBoxedWorld( options );
            world.debugDraw = true;
            world.mouseInteractExclusions = new Array();
            world.mouseInteraction = true;
            //world.animateOnEnterFrame = true;
            world.framerateIndependantAnimation = true;
            addChild( world );

            world.createPolyFromLibraryShape( 200, 100, "sampleShape", "vectorassets.swf", Math.random() * 360 );
            world.createPolyFromLibraryShape( 400, 100, "shapeY", "vectorassets.swf", Math.random() * 360 );
            world.createPolyFromLibraryShape( 100, 100, "shapeY", "vectorassets.swf", Math.random() * 360 );
        }

        private function onRemovedFromStage( e:Event ):void
        {
            addEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
            removeEventListener( Event.REMOVED_FROM_STAGE, onRemovedFromStage );
        }
    }
}
