#include /include/license.stan

data {
  int<lower=1> S;
  int<lower=1> n[S];
  int<lower=0> k[S];
  real<lower=0> priorx;
  real<lower=0> priorn;
  int beta_prior;
  int use_likelihood;
}
parameters {
  real<lower=0, upper=1> theta;
  real<lower=0> sigma;
  vector[S] alpha_s;
}
transformed parameters {
  real mu;
  mu = logit(theta);
}
model {
  if (beta_prior) {
    theta ~ beta(1 + priorx, priorn - priorx);
  } else {
    theta ~ gamma(1 + priorx, priorn);
  }
  sigma ~ normal(0, 1);
  alpha_s ~ normal(0, 1);
  if (use_likelihood) {
    k ~ binomial_logit(n, mu + sigma * alpha_s);
  }
}
generated quantities {
  vector<lower=0, upper=1>[S] theta_s;
  for (i in 1:S) {
    theta_s[i] = inv_logit(mu + sigma * alpha_s[i]);
  }
}
