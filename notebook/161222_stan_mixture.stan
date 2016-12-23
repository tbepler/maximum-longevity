
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
    
    //mixture params
    real<lower=0,upper=1> mix;
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
    
    mix ~ beta(1, 1); //use a totally uninformative prior on the mixing parameter
    
    // model of age at death
    // increment directly to ensure constants are preserved
    
    // both models should fit the data
    age_transformed ~ beta(alpha, beta);
    age_at_death_int ~ poisson(lambda);

    // infer the mixing parameter for model comparison
    log_ps[1] = log(mix) + beta_lpdf(age_transformed | alpha, beta);
    log_ps[2] = log(1-mix) + poisson_lpmf(age_at_death_int | lambda);
    
    increment_log_prob(log_sum_exp(log_ps));
    
}