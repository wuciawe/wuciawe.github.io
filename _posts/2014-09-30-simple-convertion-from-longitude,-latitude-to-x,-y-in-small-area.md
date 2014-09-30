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

-   \\( x = r lng cos(lat_0) \\)
-   \\( y = r lat \\)

Note that: the `lng`s and the `lat`s are both in radian, and the \\( lat_0 \\) is the average value of `lat`s, and `r` 
denotes the radius of the Earth, which is about 6371km..

Applying this simple map projection with the gps data of Shanghai, it proves to be a good approximation. For example, 
computing the distance between (121.05E, 30.73N) and (121.05E, 31.447N) by using this method gives the result 79.7km, while 
querying that from the [website](http://www.daftlogic.com/projects-google-maps-distance-calculator.htm){:target="_blank"} 
gives 80.5km. That means the loss of the distance along the latitude across the whole Shanghai is almost 1%, which is 
good enough for approximation.