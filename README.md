# What is Simple Box2D?
Simple-Box2D is a few ActionScript 3 classes that encapsulate the functionality of the awesome [Box2DFlashAS3](http://box2dflash.sourceforge.net/) library, and puts them into a format which is a little more familiar to traditional ActionScript 3 developers.

# Main library features:
* A really simple wrapper class which makes it quick and easy to establish a new Box2D World environment.
* A simple wrapper for creating new basic shapes.
* **A complex polygon creation tool - which can import simple shapes from a Flash Professional library and convert them to complex physical shapes, automagically.**

### Simple-Box2D makes it easy to go from this:
![From the Flash IDE](http://uploads.psyked.co.uk/2010/01/flashview.jpg)

### To this!
![To the Flash Player](http://uploads.psyked.co.uk/2010/01/box2dview.jpg)

# Similar libraries and feature comparison
Simple-Box2D is built for Box2D version 2.0.1. There are no plans to update the source code to work with the newer, more powerful version 2.1a.

[Quick Box2D](http://actionsnippet.com/?page_id=1391) is another ActionScript 3 library with a similar aim, but is more established, built and maintained by more than one developer, and although it doesn't have the same ability to create complex polygons from Flash Professional library data, is probably a better choice.

# Getting started
Download the source code from GitHub; add it to your ActionScript 3 project, and you're ready to get started.

### Creating a simple Box2D world:

    var options:Box2DWorldOptions = new Box2DWorldOptions( 500, 280, 30, 9.8 );
        options.setWorldEdges( true, true, true, true );
    
    var world:Box2DWorld = Box2DUtils.createBoxedWorld( options );
        world.debugDraw = true;
        world.animateOnEnterFrame = true;
    addChild( world );
    
    for ( var i:int = 0; i < 30; i++ )
    {
        world.createCircle( 500 * Math.random(), 280 * Math.random(), 50 * Math.random());
    }

### Creating a polygon from an array of points:
Shapes in Box2D come in three basic flavours – circle, rectangle and custom polygon. Normally, everything must be convex (no inny bits), have no more than 8 sides, and can’t have holes. With the libraries included in this library, it's a little less restrictive than that.

Using some clever triangulation code from [Splashdust.net](http://www.splashdust.net/2009/10/box2d-mouse-drawing-now-with-ear-clipping/), there’s a simple method for creating any custom shape from an array of Point objects.  With this method you can create a shape with any number of sides, and not worry about whether the shape is concave or convex.  It’ll still break if the edges of your shape interest each other, and doesn’t support holes in the objects you’re creating, but it’s a start.

Here's the code you'll need to create a polygon from an array of points:

    var array:Array = [
                    new Point( 0, 0 ), 
                    new Point( 10, 0 ), 
                    new Point( 10, 10 ), 
                    new Point( 20, 10 ), 
                    new Point( 20, 0 ), 
                    new Point( 30, 0 ), 
                    new Point( 30, 30 ), 
                    new Point( 0, 30 ) 
                   ];
    
    world.createComplexPolygon( 50, 50, array );

### Creating a polygon from a shape in a library:
This is where things get cool.  Creating a shape from a series of points is all well and good, but it’s a laborious process to set up and modify.  You can create a shape in the Flash IDE, add your symbol to your library and import it to Box2D.  Currently this method only supports single shapes on a single layer.

    world.createPolyFromLibraryShape( 300, 100, "sampleShape", "vectorassets.swf" );

### Adding Mouse interaction:

What fun is a simulation if you can’t interact with it? So we now have an easy way to add mouse joints to move things about.  In the next version it’s my plan to add a method for filtering out objects, presumably based on each bodies userData.

    world.mouseInteraction = true;

### Framerate independent animation:

    world.framerateIndependantAnimation = true;

    var options:Box2DWorldOptions = new Box2DWorldOptions( 500, 280, 30, 9.8 );
        options.setWorldEdges( true, true, true, true );
    
    var world:Box2DWorld = Box2DUtils.createBoxedWorld( options );
        world.debugDraw = true;
        world.mouseInteractExclusions = new Array();
        world.mouseInteraction = true;
        world.framerateIndependantAnimation = true;
    addChild( world );

# History
The Simple Box2D classes were initially developed by James Ford ([@psyked_james](http://twitter.com/#!/psyked_james)) of http://www.psyked.co.uk and were initially discussed and posted in four blog posts on that website:

1. [Simplifying Box2DAS3…](http://www.psyked.co.uk/actionscript/simplifying-box2das3.htm)
2. [Simple Box2D – Custom Polygon creation.](http://www.psyked.co.uk/box2d/simple-box2d-custom-polygon-creation.htm)
3. [StarRequests, Simple-Box2D & Flickr – a example mashup.](http://www.psyked.co.uk/actionscript/starrequests-simple-box2d-flickr-mashup-sample.htm)
4. [A more advanced StarRequests, Simple-Box2D & Flickr example.](http://www.psyked.co.uk/box2d/a-more-advanced-starrequests-simple-box2d-flickr-example.htm)
5. [Demo & Source: Simple Box2D, with curved edges!](http://www.psyked.co.uk/box2d/demo-source-simple-box2d-with-curved-edges.htm)
6. [Simple Box2D – Better, cleverer, more optimised.](http://www.psyked.co.uk/box2d/simple-box2d-better-cleverer-more-optimised.htm)

Simple-Box2D has been used to create the levels for the Flash game ["Building Bridges".](http://www.mmtdigital.co.uk/Flash/ChristmasGame2009/Building_Bridges.html)