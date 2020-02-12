---
layout: docs
title: SReachSetGpO.m
---

```
  Compute the stochastic reach set corresponding to the stochastic reachability 
  problem of a target tube using Genz's algorithm and MATLAB's patternsearch
  =============================================================================
 
  SReachSetGpO computes the open-loop controller-based underapproximative
  stochastic reach set to the problem of stochastic reachability of a target
  tube as discussed in
 
  A. Vinod and M. Oishi, "Scalable underapproximative verification of stochastic
  LTI systems using convexity and compactness," In Proc. Hybrid Syst.: Comput. &
  Ctrl., pages 1--10, 2018. HSCC 2018
 
  A. Vinod and M. Oishi, "Stochastic reachability of a target tube: Theory and
  computation," IEEE Transactions in Automatic Control, 2018 (submitted)
  https://arxiv.org/pdf/1810.05217.pdf.
 
  =============================================================================
 
  [polytope, extra_info] = SReachSetGpO(method_str, sys, prob_thresh,...
    safety_tube, options)
  
  Inputs:
  -------
    method_str  - Solution technique to be used. Must be 'genzps-open'
    sys         - System description (LtvSystem/LtiSystem object)
    prob_thresh - Probability threshold at which the set is to be constructed
    safety_tube - Collection of (potentially time-varying) safe sets that
                  define the safe states (Tube object)
    options     - Collection of user-specified options for 'chance-open'
                  (Matlab struct created using SReachSetOptions)
 
  Outputs:
  --------
    polytope   - Underapproximative polytope of dimension sys.state_dim which
                 underapproximates the stochastic reach set
    extra_info - A Matlab struct that comprises of auxillary
                 information from the set computation:
                    1. xmax - Initial state that has the maximum reach
                              probability to stay with the safety tube using an
                              open-loop controller (via the method in use)
                    2. Umax - Optimal open-loop policy ((sys.input_dim) *
                              time_horizon)-dimensional vector 
                              U = [u_0; u_1;...; u_N] (column vector) for xmax
                              (via the method in use)
                    3. xmax_reach_prob 
                            - Maximum attainable reach probability to
                              stay with the safety tube using an open-loop
                              controller
                    4. opt_theta_i 
                            - Vector comprising of scaling factors along each
                              user-specified direction of interest
                    5. opt_input_vec_at_vertices 
                            - Optimal open-loop policy ((sys.input_dim) *
                              time_horizon)-dim.  vector U = [u_0; u_1; ...;
                              u_N] (column vector) for each vertex of the
                              polytope
                    6. opt_reach_prob_i
                            - Maximum attainable reach probability to stay with
                              the safety tube at the vertices of the polytope
                    7. vertices_underapprox_polytope
                            - Vertices of the polytope
                                xmax + opt_theta_i * options.set_of_dir_vecs
                    8. polytope_cc_open
                            - Polytope obtained by running SReachSet with
                              'chance-open'
                    9. extra_info_cco
                            - Extra information obtained by running SReachSet 
                              with 'chance-open'. See SReachSetCcO for more
                              details.
  Notes:
  ------
  * extra_info.xmax_reach_prob is the highest prob_thresh that may be given
    while obtaining a non-trivial underapproximation
  * This function calls SReachSet (chance-open) for the purposes of
    initialization of the nonlinear solver as well as constructing bounds on the
    line search.
  * We compute the set by ray-shooting algorithm that guarantees an
    underapproximation due to the compactness and convexity of the stochastic
    reach set. 
    - Xmax computation is done with a heuristic of centering the initial
      state with respect to the polytope obtained via SReachSet (chance-open),
      followed by a patternsearch-based xmax computation
    - Line search is done via bisection on theta, the scaling along the
      direction vector of interest. 
        - The underapproximative polytope returned by SReachSet (chance-open) is
          utilized to compute a lower bound on theta
        - The upper bound on the theta is obtained by the support vector of
          the target tube at t=0.
    - Internal computation is done using SReachPointGpO to maximize code
      modularity and reuse.
    - The bisection is guided by feasibility of finding an open-loop controller
      at each value of theta that minimizes 
 
          -log(min(Reach_prob, prob_thresh)) (1)
 
      Reach_prob is a log-concave function over the open-loop and thus (1) is a
      convex objective. 
        1. Using options.thresh, an inner min operation is used that is
           convexity-preserving. This is an attempt to ensure that the
           Monte-Carlo simulation-driven optimization does not spend too much 
           time looking for global optimality, when a certificate of exceeding a
           lower bound suffices. 
        2. After the optimization, the optimal value is reevaluated using a
           fresh set of particles for generality.
        3. At each value of theta, feasibility is determined if the optimal
           value of the optimization is above prob_thresh. However, by using a
           sufficiently low desired_accuracy in Genz's algorithm, it can be seen
           that we will not be too off. Moreover, Hoeffding's inequality can be
           utilized to bound the overapproximation.
      The first two adjustments are implemented in SReachPointGpO, the
      point-based stochastic reachability computation using genzps-open
      method. 
  * Xmax computation is done with a heuristic of centering the initial
    state with respect to the polytope obtained via SReachSet
    (chance-open), followed by a patternsearch-based xmax computation
  * In 'genzps-open', desired accuracy is the farthest lower bound on the
    confidence interval acceptable. In order to remain conservative,
    RandomVector/getProbPolyhedron subtracts desired_accuracy from the result to
    yield an underapproximation. For higher desired_accuracy, the result may be
    more conservative but faster. For lower desired_accuracy, the result may
    take more time.
  * If init_safe_set_affine = Polyhedron(), then we interpret it as R^n
  * If set_of_dir_vecs is empty, then the maximum of the optimal safety
    probability is returned via extra_info.
  * See @LtiSystem/getConcatMats for more information about the
      notation used.
 
  =============================================================================
  
  This function is part of the Stochastic Reachability Toolbox.
  License for the use of this function is given in
       https://sreachtools.github.io/license/
 
```
