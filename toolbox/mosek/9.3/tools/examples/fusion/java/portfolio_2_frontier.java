/*
  File : portfolio_2_frontier.java

  Copyright : Copyright (c) MOSEK ApS, Denmark. All rights reserved.

  Purpose :   Implements a basic portfolio optimization model.
              Computes points on the efficient frontier.
*/
package com.mosek.fusion.examples;

import mosek.fusion.*;
import java.io.FileReader;
import java.io.BufferedReader;
import java.util.ArrayList;

public class portfolio_2_frontier {
  public static double sum(double[] x) {
    double r = 0.0;
    for (int i = 0; i < x.length; ++i) r += x[i];
    return r;
  }

  public static double dot(double[] x, double[] y) {
    double r = 0.0;
    for (int i = 0; i < x.length; ++i) r += x[i] * y[i];
    return r;
  }


  /*
    Purpose:
        Computes several portfolios on the optimal portfolios by

            for alpha in alphas:
                maximize   expected return - alpha * variance
                subject to the constraints

    Input:
        n: Number of assets
        mu: An n dimmensional vector of expected returns
        GT: A matrix with n columns so (GT')*GT  = covariance matrix
        x0: Initial holdings
        w: Initial cash holding
        alphas: List of the alphas

    Output:
        The efficient frontier as list of tuples (alpha, expected return, variance)
   */
  public static void EfficientFrontier
  ( int      n,
    double[] mu,
    double[][] GT,
    double[] x0,
    double   w,
    double[] alphas,

    double[]    frontier_mux,
    double[]    frontier_s)
  throws mosek.fusion.SolutionError {

    Model M = new Model("Efficient frontier");
    try {
      //M.setLogHandler(new java.io.PrintWriter(System.out));

      // Defines the variables (holdings). Shortselling is not allowed.
      Variable x = M.variable("x", n, Domain.greaterThan(0.0)); // Portfolio variables
      Variable s = M.variable("s", 1, Domain.unbounded());      // Variance variable

      M.constraint("budget", Expr.sum(x), Domain.equalsTo(w + sum(x0)));

      // Computes the risk
      M.constraint("variance", Expr.vstack(s, 0.5, Expr.mul(GT, x)), Domain.inRotatedQCone());

      //  Define objective as a weighted combination of return and variance
      Parameter alpha = M.parameter();
      M.objective("obj", ObjectiveSense.Maximize, Expr.sub(Expr.dot(mu, x) , Expr.mul(alpha, s)));

      // Solve the problem for many values of parameter alpha
      for (int i = 0; i < alphas.length; ++i) {
        alpha.setValue(alphas[i]);

        M.solve();

        frontier_mux[i] = dot(mu, x.level());
        frontier_s[i]   = s.level()[0];
      }
    } finally {
      M.dispose();
    }
  }

  /*
    The example. Reads in data and solves the portfolio models.
   */
  public static void main(String[] argv)
  throws java.io.IOException,
         java.io.FileNotFoundException,
         mosek.fusion.SolutionError {

    int        n      = 3;
    double     w      = 1.0;
    double[]   mu     = {0.1073, 0.0737, 0.0627};
    double[]   x0     = {0.0, 0.0, 0.0};
    double[][] GT     = {
      { 0.166673333200005, 0.0232190712557243 ,  0.0012599496030238 },
      { 0.0              , 0.102863378954911  , -0.00222873156550421},
      { 0.0              , 0.0                ,  0.0338148677744977 }
    };


    // Some predefined alphas are chosen
    double[] alphas = { 0.0, 0.01, 0.1, 0.25, 0.30, 0.35, 0.4, 0.45, 0.5, 0.75, 1.0, 1.5, 2.0, 3.0, 10.0 };
    int      niter = alphas.length;
    double[] frontier_mux = new double[niter];
    double[] frontier_s   = new double[niter];

    EfficientFrontier(n, mu, GT, x0, w, alphas, frontier_mux, frontier_s);
    System.out.println("\n-----------------------------------------------------------------------------------");
    System.out.println("Efficient frontier") ;
    System.out.println("-----------------------------------------------------------------------------------\n");
    System.out.format("%-12s  %-12s  %-12s\n", "alpha", "return", "variance") ;
    for (int i = 0; i < frontier_mux.length; ++i)
      System.out.format("\t%-12.4f  %-12.4e  %-12.4e\n", alphas[i], frontier_mux[i], frontier_s[i]);

  }
}