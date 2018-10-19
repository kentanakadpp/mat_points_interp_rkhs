<H1> Matlab programs for generating point clouds for interpolation in reproducing kernel Hilbert spaces </H1>

These are Matlab programs for generating point clouds for interpolation in reproducing kernel Hilbert spaces. These programs are used to yield the results of the numerical experiments in the article

"Generation of point clouds by convex optimization for interpolation in reproducing kernel Hilbert spaces" (arXiv:).

As written below, the programs with the prefix "SOCP_" are based on the second-order cone programming problems, which are proposed in the above article. Those with the profix "P_greedy_" are programs that yield points by the P-greedy algorithm. We used them for comparing the P-greedy algorithm with the proposed methods in the article. 

In the "SOCP_" programs, MOSEK optimization toolbox for MATLAB 8.1.0.56 is used. It is provided by <a href="https://www.mosek.com/">MOSEK ApS</a>. The function <b>mosekopt()</b> is used to solve the SCOP problems. 

Below are the descriptions of the program files.

<ul>
  <li> One-shot generator of point clouds by second-order cone programming (Algorithm 1).
    <ul>
      <li> SOCP_RKHS_sample_1D.m &hellip; for the 1-dimensional kernels: Brownian and Gaussian kernels on intervals. </li>
      <li> SOCP_RKHS_sample_2D_Gauss.m &hellip; for the 2-dimensional Gaussian kernels on the square, triangle, and circle. </li>
      <li> SOCP_RKHS_sample_2D_sphere.m &hellip; for the 2-dimensional spherical inverse multiquadratic kernel. </li>
    </ul>
    Below are subroutines used in these programs.
    <ul>
      <ul>
        <li> func_make_prob_Dopt_by_SOCP.m &hellip; Subroutine for making instances of the SOCP problem.</li>
        <li> func_Brown_eigen.m &hellip; Subroutine that outputs the eigenpairs of the Brownian kernel. </li>
        <li> func_Gauss_eigen.m &hellip; Subroutine that outputs the eigenpairs of the Gaussian kernel. </li>
        <li> func_SpherHarm2D.m &hellip; Subroutine that outputs the spherical harmonics. It includes the following subroutines.
        <ul>
          <li> subfunc_coeff.m </li>
          <li> subfunc_assLegendre.m </li>
        </ul>
        </li>
      </ul>
    </ul>
  </li>
  <li> Sequential generator of point clouds by second-order cone programming (Algorithm 2).
    <ul>
      <li> SOCP_RKHS_sample_1D_seq.m </li>
      <li> SOCP_RKHS_sample_2D_Gauss_seq.m </li>
      <li> SOCP_RKHS_sample_2D_sphere_seq.m </li>
    </ul>
    Below is a subroutine used in these programs. The above "func_" programs except "func_..._SOCP.m" are also used. 
    <ul>
      <ul>
        <li> func_make_prob_Dopt_by_SOCP_wfix.m &hellip; Subroutine for making instances of the SOCP problem with some weights fixed to 1.</li>
      </ul>
    </ul>
  </li>

</ul>
