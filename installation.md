---
layout: page
title: "Dependencies & Installation"
---

<a name="posttop"></a>

- [List of dependencies](#dependencies)
- [Essential dependencies](#essential-dependencies)
- [Optional dependencies](#optional-dependencies)
- [Installation](#installation)

We will denote MATLAB's command prompt by `>>`, while the system command prompt
by `$ `.

### Dependencies

External dependencies of SReachTools are:
1. MATLAB's Statistics and Machine Learning Toolbox
1. MPT3 ([https://www.mpt3.org/](https://www.mpt3.org/))
1. CVX ([http://cvxr.com/cvx/](http://cvxr.com/cvx/))
1. MATLAB's Global Optimization Toolbox (**optional**)
1. MATLAB's Optimization Toolbox (**optional**)
1. GeoCalcLib
   ([https://github.com/sreachtools/GeoCalcLib](https://github.com/sreachtools/GeoCalcLib))
   (**optional**)
1. GUROBI (**optional**)
1. MOSEK (**optional**)

#### Essential dependencies

These dependencies are platform-independent, and have been tested in Windows,
MacOS, and Linux.

1. **MATLAB (>2017a)** with MATLAB's Statistics and Machine Learning Toolbox
1. **MPT3** ([https://www.mpt3.org/](https://www.mpt3.org/)) --- for polytopic
   computational geometry
    1. Copy the MATLAB script [install_mpt3.m](https://www.mpt3.org/Main/Installation?action=download&upname=install_mpt3.m)
       provided by MPT3 from the browser to your local computer.
    1. Download and install MPT3 by running the following command in 
       MATLAB's command prompt (after changing
       directory to the folder containing `install_mpt3.m`)
       ```
       >> install_mpt3
       ```
    1. Add `cd <PATH-TO-TBXMANAGER>;tbxmanager restorepath`
       to your MATLAB `startup` script for the MPT3
       installation to persist across MATLAB runs.
1. **CVX** ([http://cvxr.com/cvx/](http://cvxr.com/cvx/)) --- for parsing convex
   and mixed-integer programs. Use the *Standard bundles, including Gurobi
   and/or MOSEK*,  even if you do not plan to use Gurobi or MOSEK. CVX does not
   require any additional licenses to work with GUROBI or MOSEK in an academic
   setting.
   1. Download the zip file from
      [http://cvxr.com/cvx/download/](http://cvxr.com/cvx/download/), and
      extract it to the `cvx` folder.
   1. Install CVX by running the following command in MATLAB's command prompt 
      (after changing the current working directory to the `cvx` folder)
      ```
      >> cvx_setup
      ```
   1. Add `cd <PATH-TO-CVX>;cvx_setup` to your MATLAB `startup` script for the 
      CVX installation to persist across MATLAB runs.
   1. Other notes:
      - Detailed installation instructions are given in
        [http://cvxr.com/cvx/download/](http://cvxr.com/cvx/download/).
      - SDPT3 (the default backend solver of CVX) performs reasonably well with
        CVX, when compared to MOSEK, and significantly poorly when compared to
        GUROBI in the tested examples and CVX v2.1 version. See Step 5 for
        instructions in installing external solvers for SReachTools.


#### Optional dependencies

These dependencies will allow non-essential features of SReachTools or enable
superior performance.

1. MATLAB's Global Optimization Toolbox and Optimization Toolbox
   - Affects `genzps-open` options in `SReachPoint` and `SReachSet` computation.
1. [GeoCalcLib](https://github.com/worc4021/GeoCalcLib) --- a MATLAB interface
   to Avis's [LRS vertex-facet enumeration
   library](http://cgm.cs.mcgill.ca/~avis/C/lrs.html). In empirical tests, we
   found LRS to be a superior alternative to MPT's preferred approach for
   vertex-facet enumeration,
   [CDD](https://www.inf.ethz.ch/personal/fukudak/cdd_home/index.html).  
   - Affects `lag-over` and `lag-under` options in `SReachSet` computation.
   - See
   [https://github.com/sreachtools/GeoCalcLib](https://github.com/sreachtools/GeoCalcLib)
   for detailed installation instructions.
   - :warning: GeoCalcLib currently works only in Unix and MAC OS. 
1. External solvers --- **GUROBI** and/or **MOSEK**.
    1. Why do we need to install external solvers?
        - Mixed-integer programming enabled by GUROBI or MOSEK is required for
          particle-based approaches in `SReachPoint`.
            - Affects `voronoi-open` and `particle-open` options in
              `SReachPoint` computation.
        - External solvers are typically more numerically robust and
          computationally faster than free solvers like SDPT3 that come with
          CVX.
            - Affects overall computation speed and solution quality.
    1. **GUROBI** ([http://www.gurobi.com/](http://www.gurobi.com/)):  A backend
       solver for CVX that also enables mixed-integer programming associated
       with particle-based approaches, apart from convex programming. MPT3 +
       GUROBI also provides robust polyhedral computation. (:warning: Currently
       facing issues).  
       1. GUROBI offers free academic license, which can be requested at
          [http://www.gurobi.com/registration/download-reg](http://www.gurobi.com/registration/download-reg).  
       1. **MPT3 + GUROBI**: Requires the external installation.
           1. Obtain a copy of GUROBI Optimizer from
              [http://www.gurobi.com/](http://www.gurobi.com/) (Requires signing
              up)
           1. Unzip the installation to desired folder.
           1. Generate the license file by running the following command in the 
              Unix command prompt (after changing the current working directory 
              to the `<PATH-TO-GUROBI-HOME>/gurobi902/<OS>/bin/`)
              ```
              $ grbgetkey OUTPUT_OF_GUROBI_LICENSE_REQUEST
              ```               
           1. Setup GUROBI by running the following command in MATLAB's command 
              prompt (after changing the current working directory to 
              `<PATH-TO-GUROBI-HOME>/gurobi902/<OS>/matlab/`)
              ```
              >> gurobi_setup
              ```
           1. Add `GRB_LICENSE_FILE` environment variable that has the location
              of the `gurobi.lic` file for MPT3 to detect GUROBI. Alternatively,
              add the following command in `startup.m`
              ```
              >> setenv('GRB_LICENSE_FILE','/home/ubuntu/gurobi.lic')
              ```
           1. Update MPT3 with GUROBI by running the following command in MATLAB's 
              command prompt
              ```
              >> mpt_init
              ```
       1. **CVX + GUROBI**: The current build of CVX v2.2 does not play well
            with GUROBI v9.0.2. (:warning: Currently facing issues)
          - Previously, CVX v2.1 worked with GUROBI v7.5.2 successfully. We will
            update these instructions once CVX + GUROBI becomes a viable option
            again. 
          - See the following CVX forum posts for more details:
            1. [http://ask.cvxr.com/t/cvx-with-gurobi-error-warning/7072](http://ask.cvxr.com/t/cvx-with-gurobi-error-warning/7072)
            1. [http://ask.cvxr.com/t/mismangement-of-matlab-path-in-cvxv2-2-and-external-gurobi-v9-0-2/7346/3](http://ask.cvxr.com/t/mismangement-of-matlab-path-in-cvxv2-2-and-external-gurobi-v9-0-2/7346/3)
          - We found CVX + GUROBI to be faster than SDPT3 and MOSEK 
    1. **MOSEK**  ([https://www.mosek.com/](https://www.mosek.com/)): A backend
       solver for CVX that also enables mixed-integer programming associated
       with particle-based approaches, apart from convex programming.
       1. MOSEK offers free academic license, which can be requested at
          [https://www.mosek.com/license/request/](https://www.mosek.com/license/request/).
       1. **CVX + MOSEK**: 
          1. Save the license file obtained via email in your home folder in a
             folder named `mosek`. See
             [https://docs.mosek.com/9.2/licensing/quickstart.html](https://docs.mosek.com/9.2/licensing/quickstart.html)
             for more details.
          1. To enable MOSEK bundled with CVX, run the following command in
             MATLAB command prompt
             ```
             >> cvx_setup
             ```
          1. See
             [http://web.cvxr.com/cvx/doc/mosek.html](http://web.cvxr.com/cvx/doc/mosek.html)
             for more details.
       1. **MPT3 + MOSEK**: Unfortunately, MPT3 does not support MOSEK. See
          [https://www.mpt3.org/Main/FAQ](https://www.mpt3.org/Main/FAQ).
       1. In empirical tests, SDPT3 and MOSEK have demonstrated similar
          performance in computation time and solution quality. We found MOSEK
          to be slower than GUROBI.

### Installation

1. Install the necessary dependencies listed above
1. Clone the SReachTools repository (or download the latest zip file from
   [Releases](https://github.com/sreachtools/SReachTools/releases))
   ```
   $ git clone https://github.com/sreachtools/SReachTools
   ```
   > :warning: Please do not add the folder to the MATLAB path manually.
1. Install SReachTools by running the following command in MATLAB command prompt 
   (after changing the current working directory in MATLAB to `SReachTools` 
   folder)
   ```
   >> srtinit
   ```
   - (**Optional**) Additional steps:
       - Run `srtinit -t` to run all the unit tests.
       - Run `srtinit -v` to visualize the steps the changes to the path and
         check for recommended dependencies.  
       - Run `srtinit -x` to remove functions of SReachTools from MATLAB's path
         after use.  
1. You can add `cd <PATH-TO-SREACHTOOLS>;srtinit` to your MATLAB's `startup.m`
   to automatically have this done in future.

[Go to top](#posttop)
