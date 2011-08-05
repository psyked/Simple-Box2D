package couk.psyked.box2d
{
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Joints.b2DistanceJointDef;
	import Box2D.Dynamics.Joints.b2MouseJoint;
	import Box2D.Dynamics.Joints.b2MouseJointDef;
	import Box2D.Dynamics.Joints.b2RevoluteJointDef;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	
	import couk.psyked.box2d.utils.MouseUtils;
	import couk.psyked.box2d.utils.PointUtils;
	import couk.psyked.box2d.utils.WorldUtils;
	import couk.psyked.box2d.utils.library.ShapeParser;
	import couk.psyked.box2d.utils.shape.PolygonTool;
	import couk.psyked.box2d.vo.WorldOptions;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	
	import wumedia.vector.VectorShapes;

	public class Box2DWorld extends Sprite
	{

		public function Box2DWorld(world:b2World, _options:WorldOptions)
		{
			options = _options;
			_world = world;
			//worldSprite = WorldUtils.addDebugDraw(world);
			//MouseUtils.initialise(_world, options.scale, worldSprite);
			//PointUtils.initialise(_world, options.scale, worldSprite);

			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

		public var fixtureDef:b2FixtureDef = new b2FixtureDef();

		public var mouseInteractExclusions:Array;

		private var _animateOnEnterFrame:Boolean;
		private var _debugDraw:Boolean;
		private var _deferedMouseInteraction:Boolean;

		private var _framerateIndependantAnimation:Boolean;

		private var _mouseInteraction:Boolean;
		private var _world:b2World;
		private var fiaTimer:Timer;

		private var framerate:Number = (1000 / 60);
		private var mouseDefinition:b2MouseJointDef;

		private var mouseJoint:b2MouseJoint;
		private var options:WorldOptions;
		private var worldSprite:Sprite;

		public function get animateOnEnterFrame():Boolean
		{
			return _animateOnEnterFrame;
		}

		public function set animateOnEnterFrame(value:Boolean):void
		{
			if (value)
			{
				if (!_animateOnEnterFrame)
				{
					addEventListener(Event.ENTER_FRAME, updateBox2D);
				}
			}
			else
			{
				if (_animateOnEnterFrame)
				{
					removeEventListener(Event.ENTER_FRAME, updateBox2D);
				}
			}
			_animateOnEnterFrame = value;
		}

		/**
		 *
		 * @param vec
		 * @return
		 */
		public function b2Vec2ToPoint(vec:b2Vec2):Point
		{
			return new Point(vec.x * options.scale, vec.y * options.scale);
		}

		public function createCircle(_x:int, _y:int, _radius:int, _rotation:int = 0):void
		{
			/*var bodyDef:b2BodyDef = new b2BodyDef();
			bodyDef.position.Set(x / options.scale, y / options.scale);
			bodyDef.linearDamping = 0.25;
			bodyDef.angularDamping = 0.25;
			var shapeDef:b2CircleShape = new b2CircleShape();
			shapeDef.radius = radius / options.scale;
			shapeDef.density = 1;
			shapeDef.friction = 5;
			var body:b2Body = _world.CreateBody(bodyDef);
			body.SetAngle((rotation % 360) * (Math.PI / 180));
			body.CreateShape(shapeDef);*/
			//body.SetMassFromShapes();
			var bodyDef:b2BodyDef = new b2BodyDef();
			bodyDef.position.Set(_x / options.scale, _y / options.scale);
			bodyDef.type = b2Body.b2_dynamicBody;
			//bodyDef.massData = new b2MassData();
			//bodyDef.massData.mass = _weight / (options.scale/10);
			//bodyDef.angle = _rotation * ( Math.PI / 180 );
			var circleDef:b2CircleShape = new b2CircleShape(_radius / options.scale);
			//circleDef.radius=ghostSprite.radius / options.scale;
			fixtureDef.shape = circleDef;
			fixtureDef.density = 1; //ghostSprite.density * (_weight / 50); //10.0;
			fixtureDef.friction = 5; //ghostSprite.friction; //5;
			//fixtureDef.restitution = ghostSprite.restitution; //0.2;
			//fixtureDef.filter.maskBits = 1;//ghostSprite.maskBits //1;
			//fixtureDef.filter.categoryBits = 2 //1;
			// So the elves never collide with each other.
			//fixtureDef.filter.groupIndex = -1;
			var body:b2Body = _world.CreateBody(bodyDef);
			body.CreateFixture(fixtureDef);
		}



		/*
		   private function makeComplexBody(p_body:B2Body, p_vertices:Array) : Void
		   {
		   var processedVerts = _polyTool.getTriangulatedPoly(p_vertices);

		   if(processedVerts != null) {
		   var tcount = cast(processedVerts.length / 3, Int);
		   for (i in 0...tcount) {
		   var polyDef:B2PolygonDef;
		   polyDef = new B2PolygonDef();
		   polyDef.friction = 0.5;

		   if(p_static)
		   polyDef.density = 0.0;
		   else
		   polyDef.density = 1.0;

		   polyDef.vertexCount = 3;

		   var index:int = i * 3;
		   polyDef.vertices[0].Set(processedVerts[index].x/30,processedVerts[index].y/30);
		   polyDef.vertices[1].Set(processedVerts[index+1].x/30,processedVerts[index+1].y/30);
		   polyDef.vertices[2].Set(processedVerts[index+2].x/30,processedVerts[index+2].y/30);
		   p_body.CreateShape(polyDef);
		   }
		   p_body.SetMassFromShapes();
		   _bodyCount++;
		   } else {

		   // The polygon is bad somehow. Probably overlapping segments.
		   // So let's recurse with the convex hull of the bad poly.
		   makeComplexBody(p_body, _polyTool.getConvexPoly(p_vertices), p_static);
		   }
		 } */

		/**
		 *
		 * @param x
		 * @param y
		 * @param points
		 * @param rotation
		 */
		public function createComplexPolygon(x:int, y:int, points:Vector.<Point>, rotation:int = 0):b2Body
		{
			if (points.length < 3)
			{
				//throw new Error( "Complex Polygons must have at least 3 points." );
				trace("Complex Polygons must have at least 3 points.");
			}
			//todo: Re-implement this - it's really quite good.
			/* graphics.lineStyle( 1, 0xff0000 );
			   for each ( var point:Point in points )
			   {
			   graphics.lineTo( point.x, point.y );
			 } */

			var bodyDef:b2BodyDef = new b2BodyDef();
			bodyDef.position.Set(x / options.scale, y / options.scale);
			bodyDef.linearDamping = 0.25;
			bodyDef.angularDamping = 0.25;

			var body:b2Body = _world.CreateBody(bodyDef);
			body.SetAngle((rotation % 360) * (Math.PI / 180));

			// If there are more than 8 vertices, its a complex body
			if (points.length > 8)
			{
				trace("Creating a complex body (has more than 8 sides) (has " + points.length + ")");
				makeComplexBody(body, points);
			}
			else
			{
				if (PolygonTool.isPolyConvex(points) && PolygonTool.isPolyClockwise(points))
				{
					trace("Creating a simple body");
					makeSimpleBody(body, points);
				}
				else
				{
					trace("Creating a complex body (convex or non-clockwise)");
					makeComplexBody(body, points);
				}
			}
			/* var processedVerts:Array = PolygonTool.getTriangulatedPoly( points );

			   if ( processedVerts != null )
			   {
			   makeComplexBody( body, processedVerts );
			   }
			   else
			   {
			   makeComplexBody( body, PolygonTool.getConvexPoly( points ));
			 } */
			//body.SetMassFromShapes();
			return body;
		}

		public function createDisanceJoint(body1:b2Body, body2:b2Body, _a1:Point = null, _a2:Point = null):void
		{
			var a1:b2Vec2;
			var a2:b2Vec2;

			if (!_a1)
			{
				a1 = body1.GetWorldCenter();
			}
			else
			{
				a1 = new b2Vec2(_a1.x / options.scale, _a1.y / options.scale);
			}
			if (!_a2)
			{
				a2 = body2.GetWorldCenter();
			}
			else
			{
				a2 = new b2Vec2(_a2.x / options.scale, _a2.y / options.scale);
			}
			var jointDef:b2DistanceJointDef = new b2DistanceJointDef();
			jointDef.Initialize(body1, body2, a1, a2);
			_world.CreateJoint(jointDef);
		}

		/**
		 * Loads the specified library file, and extracts the named library item from it, parsing it into a Box2D object.
		 */
		public function createPolyFromExternalLibraryShape(x:int, y:int, shapeName:String, libraryName:String, rotation:int = 0, levelOfDetail:uint = 5):void
		{

			var loader:URLLoader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.BINARY;
			loader.addEventListener(IOErrorEvent.IO_ERROR, onError);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
			loader.addEventListener(Event.COMPLETE, onLoaded);
			loader.load(new URLRequest(libraryName));

			function onError(e:Event = null):void
			{
				loader.removeEventListener(IOErrorEvent.IO_ERROR, onError);
				loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
				loader.removeEventListener(Event.COMPLETE, onLoaded);

				// supress the errors for now.
			}

			function onLoaded(e:Event = null):void
			{
				loader.removeEventListener(IOErrorEvent.IO_ERROR, onError);
				loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
				loader.removeEventListener(Event.COMPLETE, onLoaded);

				VectorShapes.extractFromLibrary(loader.data, [shapeName]);

				//var points:Array = Box2DShapeParser.getPoints( shapeName, 1, levelOfDetail * options.scale );
				var points:Vector.<Vector.<Point>> = ShapeParser.getPoints(shapeName, 1, levelOfDetail);

				if (points)
				{
					for each (var shapePoints:Vector.<Point> in points)
					{
						if (shapePoints.length > 2)
						{
							createComplexPolygon(x, y, shapePoints, rotation);
						}
						else
						{
							trace("Error getting points from Shape in library.");
						}
					}
				}
				if (e)
				{
					dispatchEvent(e);
				}
			}

		}

		public function createPolyFromLibraryShape(x:int, y:int, shapeName:String, rotation:int = 0, levelOfDetail:uint = 5, displayList:DisplayObject = null):Array
		{
			if (displayList)
			{
				VectorShapes.extractFromLibrary(displayList.root.loaderInfo.bytes, [shapeName]);
			}
			else
			{
				VectorShapes.extractFromLibrary(root.loaderInfo.bytes, [shapeName]);
			}
			//var points:Array = Box2DShapeParser.getPoints( shapeName, 1, levelOfDetail * options.scale );
			var points:Vector.<Vector.<Point>> = ShapeParser.getPoints(shapeName, 1, levelOfDetail);
			var rtn:Array = new Array();
			if (points)
			{
				for each (var shapePoints:Vector.<Point> in points)
				{
					if (shapePoints.length > 2)
					{
						rtn.push(createComplexPolygon(x, y, shapePoints, rotation));
					}
					else
					{
						trace("Error getting points from Shape in library.");
					}
				}
			}
			return rtn;
		}

		public function createRectangle(_x:int, _y:int, _width:int, _height:int, _rotation:int = 0):b2Body
		{
			/*var bodyDef:b2BodyDef = new b2BodyDef();
			bodyDef.position.Set( x / options.scale, y / options.scale );
			bodyDef.linearDamping = 0.25;
			bodyDef.angularDamping = 0.25;
			var shapeDef:b2PolygonDef = new b2PolygonDef();
			shapeDef.SetAsBox( width / options.scale, height / options.scale );
			shapeDef.density = 1;
			shapeDef.friction = 5;
			var body:b2Body = _world.CreateBody( bodyDef );
			body.SetAngle(( rotation % 360 ) * ( Math.PI / 180 ));
			body.CreateShape( shapeDef );
			body.SetMassFromShapes();*/

			var bodyDef:b2BodyDef = new b2BodyDef();
			bodyDef.position.Set((_x + (_width / 2)) / options.scale, (_y + (_height / 2)) / options.scale);
			var boxDef:b2PolygonShape = new b2PolygonShape();
			boxDef.SetAsBox((_width / 2) / options.scale, (_height / 2) / options.scale);

			fixtureDef.shape = boxDef;
			fixtureDef.density = 1; //groundSprite.density //0.0;
			fixtureDef.friction = 5; //groundSprite.friction;
			var body:b2Body = _world.CreateBody(bodyDef);
			body.CreateFixture(fixtureDef);
			
			//body.SetMassFromShapes();
			//body.SetUserData(groundSprite);
			return body;
		}

		public function createRevoluteJoint(body1:b2Body, body2:b2Body, point:Point):void
		{
			var jointDef:b2RevoluteJointDef = new b2RevoluteJointDef();
			jointDef.Initialize(body1, body2, new b2Vec2(point.x / options.scale, point.y / options.scale));
			_world.CreateJoint(jointDef);
		}

		public function get debugDraw():Boolean
		{
			return _debugDraw;
		}

		public function set debugDraw(value:Boolean):void
		{
			if (value)
			{
				if (!contains(worldSprite))
				{
					addChild(worldSprite);
				}
			}
			else
			{
				if (contains(worldSprite))
				{
					removeChild(worldSprite);
				}
			}
			_debugDraw = value;
		}

		/**
		 *
		 * @param fn
		 */
		public function forEachBody(fn:Function):void
		{
			var node:b2Body = _world.GetBodyList();
			while (node)
			{
				var b:b2Body = node;
				node = node.GetNext();

				fn.apply(this, [b]);
			}
		}

		public function get framerateIndependantAnimation():Boolean
		{
			return _framerateIndependantAnimation;
		}

		public function set framerateIndependantAnimation(value:Boolean):void
		{
			if (value)
			{
				if (!_framerateIndependantAnimation)
				{
					fiaTimer = new Timer(framerate);
					fiaTimer.addEventListener(TimerEvent.TIMER, updateBox2D);
					fiaTimer.start();
				}
			}
			else
			{
				if (_framerateIndependantAnimation)
				{
					fiaTimer.removeEventListener(TimerEvent.TIMER, updateBox2D);
					fiaTimer.stop();
					fiaTimer = null;
				}
			}
			_framerateIndependantAnimation = value;
		}

		public function getb2world():b2World
		{
			return _world;
		}

		public function get mouseInteraction():Boolean
		{
			return _mouseInteraction;
		}

		public function set mouseInteraction(value:Boolean):void
		{
			if (stage)
			{
				if (value)
				{
					if (!_mouseInteraction)
					{
						// excludeUserData is an array of userData types to exclude from this behaviour
						stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
						stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
					}
				}
				else
				{
					if (_mouseInteraction)
					{
						// excludeUserData is an array of userData types to exclude from this behaviour
						stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
						stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
					}
				}
				_mouseInteraction = value;
				_deferedMouseInteraction = value;
			}
			else
			{
				_deferedMouseInteraction = value;
			}
		}

		/**
		 *
		 * @param point
		 * @return
		 */
		public function pointTob2Vec2(point:Point):b2Vec2
		{
			return new b2Vec2(point.x / options.scale, point.y / options.scale);
		}

		/**
		 *
		 * @param e
		 */
		public function updateBox2D(e:Event = null):void
		{
			_world.Step((1 / 30), 10, 10);
			if (mouseJoint)
			{
				var mouseXWorldPhys:Number = mouseX / options.scale;
				var mouseYWorldPhys:Number = mouseY / options.scale;
				var p2:b2Vec2 = new b2Vec2(mouseXWorldPhys, mouseYWorldPhys);
				mouseJoint.SetTarget(p2);
			}
		}


		internal function makeComplexBody(body:b2Body, processedVerts:Vector.<Point>):void
		{
			var vertArray:Vector.<Point> = processedVerts.slice(0);
			if (!PolygonTool.isPolyClockwise(vertArray))
			{
				vertArray.reverse();
			}
			var polys:Vector.<Vector.<Point>> = PolygonTool.earClip(vertArray);

			fixtureDef.density = 1;
			fixtureDef.friction = 5;

			//processedVerts.push(processedVerts[0]);

			if (polys != null)
			{
				trace("Have split shape into " + polys.length + " separate shapes");
				for each (var poly:Vector.<Point> in polys)
				{
					trace("Creating new shape");
					trace("New shape will have " + poly.length + " sides");
					var shapeDef:b2PolygonShape = new b2PolygonShape();

					var verts:Array = new Array();
					for (var i:int = 0; i < poly.length; i++)
					{
						verts.push(new b2Vec2(poly[i].x / options.scale, poly[i].y / options.scale));
					}
					shapeDef.SetAsArray(verts, verts.length);
					fixtureDef.shape = shapeDef;
					body.CreateFixture(fixtureDef);
				}
			}
			else
			{
				makeComplexBody(body, PolygonTool.getConvexPoly(processedVerts));
			}
		}

		internal function makeSimpleBody(body:b2Body, _verticies:Vector.<Point>):void
		{
			/*var vertArray:Array = p_vertices.slice(0);
			vertArray.reverse();

			var polyDef:b2PolygonDef;
			polyDef = new b2PolygonDef();
			polyDef.friction = 0.5;

			polyDef.density = 1.0;

			polyDef.vertexCount = p_vertices.length;
			var i:int = 0;
			for each (var vertex:Point in vertArray)
			{
				polyDef.vertices[i].Set(vertex.x / options.scale, vertex.y / options.scale);
				i++;
			}
			p_body.CreateShape(polyDef);*/
			var bodyDef:b2BodyDef = new b2BodyDef();
			//bodyDef.position.Set(_x / options.scale, _y / options.scale);
			var polyDef:b2PolygonShape = new b2PolygonShape();
			//boxDef.SetAsBox(( _width / 2 ) / m_physScale, ( _height / 2 ) / m_physScale );
			/*polyDef.vertexCount=_verticies.length;*/
			var verts:Array = new Array();
			for (var i:int = 0; i < _verticies.length; i++)
			{
				//polyDef.vertices[i].Set(_verticies[i].x / m_physScale, _verticies[i].y / m_physScale);
				var v:b2Vec2 = new b2Vec2();
				v.x = _verticies[i].x / options.scale;
				v.y = _verticies[i].y / options.scale;
				verts.push(v);
			}
			/*fixtureDef.vertices[i].Set(_verticies[0].x / m_physScale, _verticies[0].y / m_physScale);*/
			polyDef.SetAsArray(verts, verts.length);
			/* polyDef.vertices[0].Set(0,-1);
			polyDef.vertices[1].Set(1,1);
			polyDef.vertices[2].Set(-1,1); */
			fixtureDef.shape = polyDef;
			fixtureDef.density = 1.0; //groundSprite.density //0.0;
			fixtureDef.friction = 0.5; //groundSprite.friction;
			//var body:b2Body = world.CreateBody(bodyDef);
			body.CreateFixture(fixtureDef);
			//p_body.SetMassFromShapes();
		}

		internal function onMouseDown(e:Event):void
		{
			//trace( Box2DMouseUtils.getTopBodyAtMouse());
			var body:b2Body = MouseUtils.getTopBodyAtMouse();
			if (body)
			{
				var mouseJointDef:b2MouseJointDef = new b2MouseJointDef();
				mouseJointDef.bodyA = _world.GetGroundBody();
				mouseJointDef.bodyB = body;
				mouseJointDef.target.Set(mouseX / options.scale, mouseY / options.scale);
				mouseJointDef.maxForce = 30000;
				//mouseJointDef.timeStep = ( 1 / 30 );
				mouseJoint = _world.CreateJoint(mouseJointDef) as b2MouseJoint;
			}
		}

		internal function onMouseUp(e:Event):void
		{
			if (mouseJoint)
			{
				_world.DestroyJoint(mouseJoint);
				mouseJoint = null;
			}
		}

		private function onAddedToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			mouseInteraction = _deferedMouseInteraction;
		}
	}
}
