---
layout: post
title:  "Release of v1.3"
date:   2020-05-10 00:00:00 -0600
categories: jekyll update
author: "Abraham P. Vinod"
---

A new version of SReachTools is out! Check out
[https://github.com/sreachtools/SReachTools/releases/tag/v1.3](https://github.com/sreachtools/SReachTools/releases/tag/v1.3).

- `SReachSetCcO` has a new option --- maximum volume ellipsoid 
    - Reorient the direction vectors by fitting a maximum volume ellipsoid
      inside the safe set 
    - The center of the ellipsoid as the point from which vectors will be drawn
- SReachSetCcO can now handle non-2D set of direction vectors
- Abandoned GUROBI as the preferred CVX backend solver due to issues of the
  current CVX build (CVXv2.2, 1148) with GUROBI
- Included instructions for MOSEK installation
- SReachSet provides the maximum probability of safety if no `set_of_dir_vecs`
  is provided
- Updated SReachTools.pdf to peer-reviewed copy
