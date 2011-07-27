package
{
	import couk.psyked.box2d.Box2DWorld;
	import couk.psyked.box2d.utils.Box2DUtils;
	import couk.psyked.box2d.utils.Box2DWorldOptions;
	import couk.psyked.utils.KeyboardManager;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;

	[SWF( width="500", height="280", frameRate="30", backgroundColor="0x000000", pageTitle="Box2D Experiments" )]
	/**
	 * This is an example implementation of creating complex Box2D shapes (convex, multi-sided) using 
	 * a series of points in an array.  It's painstaking to do manually, but hey, you get the complex 
	 * shapes support.
	 *  
	 * @author James
	 */
	public class ComplexPolygonExample extends Sprite
	{
		public function ComplexPolygonExample()
		{
			// always like to start things when added to stage, just in case the lack of
			// a stage object throws horrible runtime errors.
			addEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
		}

		private function onAddedToStage( e:Event ):void
		{
			removeEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
			addEventListener( Event.REMOVED_FROM_STAGE, onRemovedFromStage );

			var options:Box2DWorldOptions = new Box2DWorldOptions( 500, 280, 30, 9.8 );
				options.setWorldEdges( true, true, true, true );
				
			var world:Box2DWorld = Box2DUtils.createBoxedWorld( options );
				world.debugDraw = true;
				world.mouseInteractExclusions = new Array();
				world.mouseInteraction = true;
				//world.animateOnEnterFrame = true;
				world.framerateIndependantAnimation = true;
				
			addChild( world );

			// create a new object, using the more traditional point-to-point shape declaration
			// method that's more like other Box2D class libraries.  This however, lets you use
			// shapes with any number of sides and convex shapes, instead of adhering to the 
			// normal Box2D constraints.
			var array:Array = [ new Point( 0, 0 ),
				new Point( 20, 0 ),
				new Point( 20, 20 ),
				new Point( 40, 20 ),
				new Point( 40, 0 ),
				new Point( 60, 0 ),
				new Point( 60, 40 ),
				new Point( 0, 40 )];

			world.createComplexPolygon( 50, 50, array, Math.random() * 360 );
			world.createComplexPolygon( 150, 150, array, Math.random() * 360 );
			world.createComplexPolygon( 250, 50, array, Math.random() * 360 );
			world.createComplexPolygon( 350, 150, array, Math.random() * 360 );
			world.createComplexPolygon( 450, 50, array, Math.random() * 360 );
			world.createComplexPolygon( 50, 0, array, Math.random() * 360 );
			world.createComplexPolygon( 150, 50, array, Math.random() * 360 );
			world.createComplexPolygon( 250, 0, array, Math.random() * 360 );
			world.createComplexPolygon( 350, 50, array, Math.random() * 360 );
			world.createComplexPolygon( 450, 0, array, Math.random() * 360 );

		}

		private function onRemovedFromStage( e:Event ):void
		{
			addEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
			removeEventListener( Event.REMOVED_FROM_STAGE, onRemovedFromStage );
		}
	}
}
