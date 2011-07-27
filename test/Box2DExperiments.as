package
{
    import com.adobe.viewsource.ViewSource;

    import couk.psyked.box2d.Box2DWorld;
    import couk.psyked.box2d.utils.Box2DUtils;
    import couk.psyked.box2d.utils.Box2DWorldOptions;

    import flash.display.Sprite;
    import flash.events.Event;

    [SWF( width="500",height="280",frameRate="60",backgroundColor="0x000000",pageTitle="Box2D Experiments" )]
    /**
     * This is an example implementation of Box2D utility classes for quickly establishing a Box2D world
	 * with command settings as the default, a complete boxed world, and 30 circle objects (which are a 
	 * native shape in Box2D)
	 *  
     * @author James
     */
    public class Box2DExperiments extends Sprite
    {
        public function Box2DExperiments()
        {
			// always like to start things when added to stage, just in case the lack of
			// a stage object throws horrible runtime errors.
            addEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
        }

        private function onAddedToStage( e:Event ):void
        {
            removeEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
            addEventListener( Event.REMOVED_FROM_STAGE, onRemovedFromStage );
            
			// create the Box2D world options in a single 'easy' class.
            var options:Box2DWorldOptions = new Box2DWorldOptions( 500, 280, 30, 9.8 );
            	options.setWorldEdges( true, true, true, true );
			
			// initiate the Box2D world with the world options
            var world:Box2DWorld = Box2DUtils.createBoxedWorld( options );
	            world.debugDraw = true;
	            world.animateOnEnterFrame = true;
				
            addChild( world );
			
			// create 30 random circles!
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
