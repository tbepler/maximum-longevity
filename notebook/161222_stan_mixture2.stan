
data{
    int <lower=0> N; //number of data points
    real <lower=0> age_at_death[N]; //ages at death
}

parameters{
    //beta dist params
    real<lower=max(age_at_death)> max_lifespan;
    real<lower=0> alpha[2];
    real<lower=0> beta[2];
}

transformed parameters{
    real<lower=0> age_transformed[N];
    for (i in 1:N){
        age_transformed[i] = age_at_death[i]/max_lifespan;
    }
}

model{
    
    //priors on parameters
    max_lifespan ~ exponential(1./15.); // give the prior a mean of 15 (125 because relative to 110)
    alpha ~ lognormal(0, 10);
    beta ~ lognormal(0, 10);
    
    // model of age at death
    
    // both models should fit the data
    age_transformed ~ beta(alpha[1], beta[1]);
    target += -N*log(max_lifespan);
    age_at_death ~ gamma(alpha[2], beta[2]);
    
}

generated quantities{
    // under a uniform prior, the mixing parameter is given by the log likelihood ratio
    real lp_beta;
    real lp_gamma;
    real mix;
    lp_beta = beta_lpdf(age_transformed | alpha[1], beta[1]) - N*log(max_lifespan);
    lp_gamma = gamma_lpdf(age_at_death | alpha[2], beta[2]);
    
    mix = lp_beta - lp_gamma;
    
}