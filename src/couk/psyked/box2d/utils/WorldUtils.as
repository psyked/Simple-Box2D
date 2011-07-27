package couk.psyked.box2d.utils
{
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2DebugDraw;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	
	import flash.display.Sprite;

	public class WorldUtils
	{
		public static function addDebugDraw(world:b2World):Sprite
		{
			var dbgDraw:b2DebugDraw = new b2DebugDraw();
			var dbgSprite:Sprite = new Sprite();
			dbgDraw.SetSprite(dbgSprite);
			dbgDraw.SetDrawScale(30);
			dbgDraw.SetFillAlpha(0.3);
			dbgDraw.SetLineThickness(1);
			dbgDraw.SetFlags(b2DebugDraw.e_shapeBit | b2DebugDraw.e_jointBit);
			world.SetDebugDraw(dbgDraw);
			return dbgSprite;
		}

		public static function createBoxedWorld(_world:b2World, _scale:int, _width:int, _height:int, _top:Boolean = true, _left:Boolean = true, _bottom:Boolean = true, _right:Boolean = true):void
		{
			var fixtureDef:b2FixtureDef = new b2FixtureDef();
			fixtureDef.friction = 1;
			fixtureDef.density = 1;
			// Create border of boxes
			var boxDef:b2PolygonShape = new b2PolygonShape();
			var bodyDef:b2BodyDef = new b2BodyDef();
			var body:b2Body;

			if (_left)
			{
				// Left
				bodyDef.position.Set(-100 / _scale, _height / _scale / 2);
				boxDef.SetAsBox(100 / _scale, (_height + 40) / _scale / 2);
				fixtureDef.shape = boxDef;

				body = _world.CreateBody(bodyDef);
				body.CreateFixture(fixtureDef);
					//wallB.SetMassFromShapes();
			}
			if (_right)
			{
				// Right
				bodyDef.position.Set((_width + 99) / _scale, _height / _scale / 2);
				fixtureDef.shape = boxDef;
				body = _world.CreateBody(bodyDef);
				body.CreateFixture(fixtureDef);
					//wallB.SetMassFromShapes();
			}
			if (_top)
			{
				// Top
				bodyDef.position.Set(_width / _scale / 2, -100 / _scale);
				boxDef.SetAsBox((_width + 40) / _scale / 2, 100 / _scale);
				fixtureDef.shape = boxDef;
				body = _world.CreateBody(bodyDef);
				body.CreateFixture(fixtureDef);
					//wallB.SetMassFromShapes();
			}
			if (_bottom)
			{
				// Bottom
				bodyDef.position.Set(_width / _scale / 2, (_height + 99) / _scale);
				fixtureDef.shape = boxDef;
				body = _world.CreateBody(bodyDef);
				body.CreateFixture(fixtureDef);
					//wallB.SetMassFromShapes();
			}
		}
	}
}
