---
layout: post
title:  "Release of v1.2"
date:   2019-04-18 00:00:00 -0600
categories: jekyll update
author: "Abraham P. Vinod"
---

A new version of SReachTools is out! Check out
[https://github.com/sreachtools/SReachTools/releases/tag/v1.2](https://github.com/sreachtools/SReachTools/releases/tag/v1.2).

- SReachPoint has a new method `chance-affine-uni`
    - This method is an adaptation of Vitus and Tomlin's CDC 2011 paper.
    - It performs affine controller synthesis using uniform risk allocation (via bisection) and chance constraint optimization. 
    - We have rerun all examples and have added tests
- Documentation has been moved to a separate repository [https://github.com/sreachtools/sreachtools-website](https://github.com/sreachtools/sreachtools-website).
- Minor bug fixes on output control and covariance sanitization.
- In addition, this version is now participated in repeatability
    - HSCC 2019
    - ARCH 2019
    - [CodeOcean capsules](https://codeocean.com/explore/capsules/?query=sreachtools)
