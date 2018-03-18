# Drawing_Language_Compiler

This project implements an IDE with a compiler from scratch which is able to compile(interpret actually) a simple drawing language. The drawing language is able to describe graphs and its grammar is very easy. For example:
<pre><code>
origin is (200,200);
scale is (80,80/3);
rot is pi/2+0*pi/3;
for t from -pi to pi step pi/50 draw(cos(t),sin(t));
rot is pi/2+2*pi/3;
for t from -pi to pi step pi/50 draw(cos(t),sin(t));
rot is pi/2-2*pi/3;
for t from -pi to pi step pi/50 draw(cos(t),sin(t));
</code></pre>

*origin*, *scale*, *rot*, *for*, *from*, *to*, *step*, *draw* are the key words of this drawing language,which actually describes a function graph.

This project is written by C++ using Qt's GUI libraries. 
As you can see from the screenshot, this projects builds an IDE in which we can write codes using the grammars of the drawing language and then interpret it and draw the finial graphs.

Also, I implemented some other helpful functions:
* The compiler is able to check the errors of the input and indicate them line by line.
* The variables are highlighted in the editor of the IDE.
* The IDE will draw a Grammar tree of the input.

Screenshot:
![alt tag](http://oga6pysjo.bkt.gdipper.com/image/Drawing-Language-Compiler/IDE.jpg)
