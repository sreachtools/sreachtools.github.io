---
layout: page
title: "Dependencies & Installation"
---

<a name="posttop"></a>

- [Dependencies](#dependencies)
- [Installation](#installation)

### Dependencies

You can skip installing the dependencies marked **optional**. This will disable
some of the features of SReachTools or hamper performance.  We will denote
MATLAB's command prompt by `>>`, while the system command prompt by `$ `.
1. MATLAB (>2017a)
    1. Toolboxes
        1. MATLAB's Statistics and Machine Learning Toolbox
        1. (**Optional**) MATLAB's Global Optimization Toolbox --- required for
           `genzps-open` options in `SReachPoint` and `SReachSet`
        1. (**Optional**) MATLAB's Optimization Toolbox --- recommended
           installation for MATLAB's Global Optimization Toolbox
1. **MPT3** ([https://www.mpt3.org/](https://www.mpt3.org/)) --- for polytopic
   computational geometry
    1. Copy the MATLAB script [install_mpt3.m](https://www.mpt3.org/Main/Installation?action=download&upname=install_mpt3.m)
       provided by MPT3 from the browser to your local computer.
    1. Run in MATLAB's command prompt after changing
       directory to the folder containing `install_mpt3.m`
       ```
       >> install_mpt3
       ```
       This script will automatically download MPT3 and its dependencies.
    1. Add `cd <PATH-TO-TBXMANAGER>;tbxmanager restorepath`
       to your MATLAB `startup` script for the MPT3
       installation to persist across MATLAB runs.
1. **CVX** ([http://cvxr.com/cvx/](http://cvxr.com/cvx/)) --- for parsing convex
   and mixed-integer programs. Use the **Standard bundles, including Gurobi
   and/or MOSEK**,  even if you do not plan to use Gurobi or MOSEK. CVX does not
   require any additional licenses to work with GUROBI or MOSEK in an academic
   setting.
   1. Download the zip file from
      [http://cvxr.com/cvx/download/](http://cvxr.com/cvx/download/).
   1. Extract the `cvx` folder.
   1. Change the current working directory of MATLAB to the `cvx` folder.
   1. Run in MATLAB's command prompt
      ```
      >> cvx_setup
      ```
   1. Add `cd <PATH-TO-CVX>;cvx_setup` to your MATLAB
      `startup` script for the CVX installation to persist
      across MATLAB runs.
   1. Other notes:
      - Detailed installation instructions are given in
        [http://cvxr.com/cvx/download/](http://cvxr.com/cvx/download/).
      - SDPT3 (the default backend solver of CVX) performs reasonably well with
        CVX, when compared to MOSEK, and significantly poorly when compared to
        GUROBI in the tested examples and CVX v2.1 version. See Step 5 for
        instructions in installing external solvers for SReachTools.
1. (**Optional**) [GeoCalcLib](https://github.com/worc4021/GeoCalcLib) --- a
   MATLAB interface to Avis's [LRS vertex-facet enumeration
   library](http://cgm.cs.mcgill.ca/~avis/C/lrs.html), an alternative to MPT's
   preferred approach for vertex-facet enumeration,
   [CDD](https://www.inf.ethz.ch/personal/fukudak/cdd_home/index.html).  See
   [https://github.com/sreachtools/GeoCalcLib](https://github.com/sreachtools/GeoCalcLib)
   for a fork of [GeoCalcLib](https://github.com/worc4021/GeoCalcLib) with
   detailed installation instructions.

   > :warning: GeoCalcLib currently works only in Unix and MAC OS.  SReachTools
   > will gracefully switch back to CDD, if GeoCalcLib is installed incorrectly.
1. (**Optional**) External solvers --- **GUROBI** and/or **MOSEK**.
    1. Do you need to install external solvers?
        - Mixed-integer programming enabled by GUROBI or MOSEK is required for
          particle-based approaches in `SReachPoint`, namely "voronoi-open" and
          "particle-open".
        - External solvers are typically more numerically robust and
          computationally faster than free solvers like SDPT3 that come with
          CVX.
    1. **GUROBI**: MPT3 + GUROBI provides robust polyhedral computation. CVX +
       GUROBI is a faster combination in contrast to SDPT3 and MOSEK.  

       > :warning: CVX v2.2 does not play well with GUROBI v9.0.2, while v2.1
       > worked with GUROBI v7.5.2. 
       
       See
       [http://ask.cvxr.com/t/cvx-with-gurobi-error-warning/7072](http://ask.cvxr.com/t/cvx-with-gurobi-error-warning/7072)
       for more details. 

       > :warning: Until this issue is resolved, SReachTools can not use
       > GUROBI to perform particle-based approaches in SReachPoint.

       1. GUROBI offers free academic license, which can be requested at
          [http://www.gurobi.com/registration/download-reg](http://www.gurobi.com/registration/download-reg).  
       1. Run the following command to generate the license file
          ```
          $ grbgetkey OUTPUT_OF_GUROBI_LICENSE_REQUEST
          ```
       1. **MPT3 + GUROBI**: 
           1. Add `GRB_LICENSE_FILE` environment variable that has the location
              of the `gurobi.lic` file for MPT3 to detect GUROBI. 
           1. To update MPT3 with GUROBI, run in MATLAB's command prompt 
              ```
              >> mpt_init
              ```
       1. **CVX + GUROBI**: Follow instructions in
          [http://cvxr.com/cvx/doc/gurobi.html](http://cvxr.com/cvx/doc/gurobi.html)
          to obtain GUROBI license.

          To enable GUROBI bundled with CVX, run the following command in
          MATLAB command prompt
          ```
          >> cvx_setup
          ```
    1. **MOSEK** is an alternative to GUROBI as a backend solver for CVX. In
       empirical tests, however the performance of SDPT3 and MOSEK have been
       comparable.  Unfortunately, MPT3 does not support MOSEK. See
       [https://www.mpt3.org/Main/FAQ](https://www.mpt3.org/Main/FAQ).  
       1. **MOSEK** offers free academic license, which can be requested at
          [https://www.mosek.com/license/request/](https://www.mosek.com/license/request/).
       1. Save the license file obtained via email in your home folder in a
          folder named `mosek`. See
          [https://docs.mosek.com/9.2/licensing/quickstart.html](https://docs.mosek.com/9.2/licensing/quickstart.html)
          for more details.
       1. **CVX + MOSEK**: To enable MOSEK bundled with CVX, run the following
          command in MATLAB command prompt
          ```
          >> cvx_setup
          ```
       1. See [http://web.cvxr.com/cvx/doc/mosek.html](http://web.cvxr.com/cvx/doc/mosek.html) for more details.

### Installation

1. Install the necessary dependencies listed above
1. Clone the SReachTools repository (or download the latest zip file from
   [Releases](https://github.com/sreachtools/SReachTools/releases))
   ```
   $ git clone https://github.com/sreachtools/SReachTools
   ```
1. Change the MATLAB current working directory to where SReachTools was
   downloaded. 

   > :warning: Please do not add the folder to the MATLAB path manually.
1. Run `>> srtinit` in MATLAB command prompt to add the toolbox to the paths and
   ensure all must-have dependencies are properly installed.
   - You can add `cd <PATH-TO-SREACHTOOLS>;srtinit` to your MATLAB's `startup.m`
     to automatically have this done in future.
   - (**Optional**) Additional steps:
       - Run `srtinit -t` to run all the unit tests.
       - Run `srtinit -v` to visualize the steps the changes to the path and
         check for recommended dependencies.  
       - Run `srtinit -x` to remove functions of SReachTools from MATLAB's path
         after use.  

[Go to top](#posttop)
