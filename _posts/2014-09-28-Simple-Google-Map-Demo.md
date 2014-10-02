---
layout: post
category: [demo]
tags: [google map, gps]
infotext: 'A very simple demo to plot trajectories with google map'
---
{% include JB/setup %}


These days I have some work on gps trajectories. I'd like to view those gps data on the map, so as to check whether some 
assumptions can make sense. After a little bit of searching, I find this work on github: essoduke/jQuery-tinyMap. Based 
on his work, I make a very simple demo which can plot several trajectories on Google Map.

<!-- more -->

[This demo](https://github.com/wuciawe/GoogleMapDemo) is very easy to use. Just open the index.html, you will get:

[Full Page](http://wuciawe.github.io/GoogleMapDemo/){:target="_blank"}

{::nomarkdown}
    <iframe src="http://wuciawe.github.io/GoogleMapDemo/" width=100% height=1100px>
        <p>
            Your browser does not support iframes.
        </p>
    </iframe>
{:/nomarkdown}


## Usage

### Input Format

The input format is as:

    textarea = trajectory[;|\n]trajectory[;|\n]trajectory ...
    trajectory = location|location|location ...
    location = longitude,latitude

Every input may contain several trajectories seperated by `'` or `\n`.
Every trajectory contains a serials of locations, which is separated by `|`.
Every location is composed with longitude and latitude in the form of `longitude,latitude`.

### Buttons

The Points Button is to plot every gps point in the trajectories on the map. After plotting, the map will be centered to 
the geometry center of those points.

The Routes Button is to plot every trajectory with a blue line on the map. After plotting the amp will be centered to the 
last plotted trajectory's geometry center.

The ClearAll Button will clean up all those plotted layers.