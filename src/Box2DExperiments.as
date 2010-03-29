package
{
    import com.adobe.viewsource.ViewSource;

    import couk.psyked.box2d.Box2DWorld;
    import couk.psyked.box2d.utils.Box2DUtils;
    import couk.psyked.box2d.utils.Box2DWorldOptions;

    import flash.display.Sprite;
    import flash.events.Event;

    [SWF( width="500",height="280",frameRate="60",backgroundColor="0x000000",pageTitle="Box2D Experiments" )]
    public class Box2DExperiments extends Sprite
    {
        public function Box2DExperiments()
        {
            ViewSource.addMenuItem( this, "srcview/index.html" );
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
            world.animateOnEnterFrame = true;
            addChild( world );
            //world.createCircle( 200, 200, 20 );
            for ( var i:int = 0; i < 30; i++ )
            {
                world.createCircle( 500 * Math.random(), 280 * Math.random(), 50 * Math.random());
            }
        }

        private function onRemovedFromStage( e:Event ):void
        {
            addEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
            removeEventListener( Event.REMOVED_FROM_STAGE, onRemovedFromStage );
        }
    }
}
