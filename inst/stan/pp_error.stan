#include /include/license.stan

data {
  int<lower=1> S;                           // number of strata
  array[S] int<lower=0> n;                  // stratum sample size
  array[S] int<lower=0> k;                  // stratum misstatements
  real<lower=0> alpha;                      // prior parameter alpha
  real<lower=0> beta;                       // prior parameter beta
  int beta_prior;                           // beta prior {0 = no, 1 = yes}
  int gamma_prior;                          // gamma prior {0 = no, 1 = yes}
  int normal_prior;                         // normal prior {0 = no, 1 = yes}
  int uniform_prior;                        // uniform prior {0 = no, 1 = yes}
  int cauchy_prior;                         // Cauchy prior {0 = no, 1 = yes}
  int t_prior;                              // Student-t prior {0 = no, 1 = yes}
  int chisq_prior;                          // Chi-squared prior {0 = no, 1 = yes} 
  int exponential_prior;                    // exponential prior {0 = no, 1 = yes}
  int use_likelihood;                       // apply likelihood {0 = no, 1 = yes}
  int binomial_likelihood;                  // binomial likelihood {0 = no, 1 = yes}
  int poisson_likelihood;                   // Poisson likelihood {0 = no, 1 = yes}
}
parameters {
  real<lower=0, upper=1> phi;               // population probability of misstatement
  real<lower=1> nu;                         // population concentration
  vector<lower=0, upper=1>[S] theta_s;      // stratum probability of misstatement
}
model {
  if (beta_prior) {
    phi ~ beta(alpha, beta);                // hyperprior
  } else if (gamma_prior) {
    phi ~ gamma(alpha, beta);               // hyperprior
  } else if (normal_prior) {
    phi ~ normal(alpha, beta);              // hyperprior
  } else if (uniform_prior) {
    phi ~ uniform(alpha, beta);             // hyperprior
  } else if (cauchy_prior) {
    phi ~ cauchy(alpha, beta);              // hyperprior
  } else if (t_prior) {
    phi ~ student_t(alpha, 0, 1);           // hyperprior
  } else if (chisq_prior) {
    phi ~ chi_square(alpha);                // hyperprior
  } else if (exponential_prior) {
    phi ~ exponential(alpha);               // hyperprior
  }
  nu ~ pareto(1, 1.5);                      // hyperprior
  theta_s ~ beta(phi * nu, (1 - phi) * nu); // prior
  if (use_likelihood) {
    if (binomial_likelihood) {
      k ~ binomial(n, theta_s);             // likelihood
    } else if (poisson_likelihood) {
      for (i in 1:S) {
        k[i] ~ poisson(n[i] * theta_s[i]);  // likelihood
      }
    }
  }
}
