---
layout: post
category: [transform]
tags: [gps]
infotext: 'equirectangular projection for small area, very simple convertion from the longitude and latitude into x-y coordinates'
---

Given the GPS data with longitude and latitude, it is very common to determine the distance for location information of these 
data.In order to do that, you need first transform those gps data into x-y plane. It is always not so simple to achieve 
that, there are many materials about [map projection](http://en.wikipedia.org/wiki/List_of_map_projections){:target="_blank"} and 
[UTM](http://en.wikipedia.org/wiki/Universal_Transverse_Mercator_coordinate_system){:target="_blank"}.
 
<!-- more -->

<script type="text/javascript" src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"></script>

When the area is small, you can use a very simple [equirectangular projection](http://en.wikipedia.org/wiki/Equirectangular_projection) to
approximate the projection. If you use the horizontal axis `x` to map longitude, and the vertical axis `y` to map latitude, 
then you can use the following formula to approximate the projection:

-   $$x = r/lamda cos(/phi_0)$$
-   $$y = r/phi$$

Note that 