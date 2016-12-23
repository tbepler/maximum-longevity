
data{
    int <lower=0> N; //number of data points
    real <lower=0> age_at_death_real[N]; //ages at death
    int <lower=0> age_at_death_int[N];
}

parameters{
    //beta dist params
    real<lower=max(age_at_death_real)> max_lifespan;
    real<lower=0> alpha;
    real<lower=0> beta;
    
    //poisson dist params
    real<lower=0> lambda;
}

transformed parameters{
    real<lower=0> age_transformed[N];
    for (i in 1:N){
        age_transformed[i] = age_at_death_real[i]/max_lifespan;
    }
}

model{
        
    vector[2] log_ps;
    
    //priors on parameters
    max_lifespan ~ exponential(1./15.); // give the prior a mean of 15 (125 because relative to 110)
    alpha ~ lognormal(0, 10);
    beta ~ lognormal(0, 10);
    
    lambda ~ lognormal(0, 10);
    
    // model of age at death
    
    // both models should fit the data
    age_transformed ~ beta(alpha, beta);
    target += -N*log(max_lifespan); // range transform
    age_at_death_int ~ poisson(lambda);
    
}

generated quantities{
    // under a uniform prior, the mixing parameter is given by the log likelihood ratio
    real lp_beta;
    real lp_poisson;
    real mix;
    lp_beta = beta_lpdf(age_transformed | alpha, beta) - N*log(max_lifespan);
    lp_poisson = poisson_lpmf(age_at_death_int | lambda);
    
    mix = lp_beta - lp_poisson;
}